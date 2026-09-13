# PRD v2 — EPUB Reader + FOSS Auto-Translation

**Status:** Draft v2 (revisi dari PRD v1 — "Nexus Reader")
**Platform:** Android (Flutter)
**Bahasa Utama:** Indonesia (target bahasa terjemahan default)
**Prinsip Non-Negosiasi Baru:** 100% Gratis & 100% FOSS by default

---

## 0. Ringkasan Perubahan dari v1 (Baca Ini Dulu)

| # | Area | v1 (Draft Awal) | v2 (Revisi) | Kenapa |
|---|---|---|---|---|
| 1 | Nama aplikasi | "Nexus Reader" (working title) | **Alinea** (rekomendasi utama) + 3 alternatif | Menghindari tumpang tindih brand dengan RTH Nexus (perusahaanmu), lebih ownable |
| 2 | Provider translation default | `GoogleTranslationProvider`, `MicrosoftTranslationProvider` — keduanya proprietary & berbayar per karakter | `LibreTranslateProvider` (self-hosted, AGPL-3.0, mesin Argos Translate MIT) sebagai default | v1 tidak benar-benar FOSS/gratis — ini kontradiksi langsung dengan requirement kamu |
| 3 | Alasan Translation Gateway | "Sembunyikan API key vendor berbayar" | "Lindungi compute self-hosted dari abuse, tetap bisa ganti/upgrade provider tanpa update APK" | Alasan lama tidak relevan lagi kalau tidak ada vendor berbayar |
| 4 | Local database | Isar / SQLite | **Drift** (SQLite type-safe, actively maintained) | Isar mangkrak — development resmi melambat sejak 2026, maintainer original berhenti, komunitas hanya melanjutkan lewat fork `isar_community` |
| 5 | EPUB rendering | "WebView-based approach" (abstrak) | Package konkret: `flutter_epub_viewer` (epub.js + WebView) + `epubx` (parser) | v1 tidak menyebut package nyata — riskan salah pilih library saat implementasi |
| 6 | Skema database | 3 entity datar (Book, Chapter, TranslationCache), tanpa mapping node-translation yang stabil | 8 entity ternormalisasi + prinsip UUID-ready untuk sync masa depan | Section 16 v1 menyebut "stable node ID" tapi tidak pernah mendefinisikan tabelnya |
| 7 | Proses bisnis | Tersebar di banyak flowchart terpisah | Section terpadu baru: alur end-to-end + model biaya operasional | Kamu minta "proses bisnis" eksplisit |

Detail lengkap ada di masing-masing section di bawah. Section yang **tidak berubah signifikan** dari v1 (persona, non-goals, accessibility, analytics) saya ringkas saja — isi lengkapnya tetap berlaku dari dokumen aslimu.

---

## 1. Product Overview & Penamaan Aplikasi

### 1.1 Konsep Produk (tidak berubah dari v1)

EPUB reader Flutter untuk Android yang menyatukan pengalaman membaca dengan **instant translation** ala browser modern — bukan lagi copy-paste ke Google Translate, tapi terjemahan terjadi di tempat, tanpa keluar dari buku.

> **Read first, translate seamlessly when needed — 100% gratis, 100% dapat diaudit sumbernya.**

### 1.2 Nama Aplikasi — Rekomendasi

"Nexus Reader" sebaiknya diganti. Alasannya: kamu sudah punya brand **RTH Nexus** untuk perusahaan CBT SaaS-mu — memakai "Nexus" lagi untuk app pribadi/FOSS yang beda domain sama sekali berisiko membingungkan pengguna (dikira produk resmi RTH Nexus) dan mendilusi brand-mu sendiri.

| Nama | Makna | Kenapa Cocok | Catatan |
|---|---|---|---|
| **Alinea** ⭐ | Kata serapan Indonesia/Belanda untuk "paragraf" | Paragraf adalah unit terjemahan inti di app ini — nama & fungsi selaras. Pendek, mudah diucap ID/EN, belum ada app EPUB/translate dengan nama ini di riset saya | Cek ketersediaan nama di Play Store & domain sebelum commit |
| Terbaca | "Dapat dibaca" (kata asli Indonesia) | Literal, jelas, menggambarkan hasil akhir: apa pun jadi terbaca | Cukup generik, mungkin sudah dipakai app lain |
| Lentera / LenteraBaca | "Lampu/pelita" — metafora pencerahan lewat pemahaman | Evocative, mudah diingat | Sedikit lebih abstrak dari fungsi literalnya |
| Bacalih | Portmanteau "Baca" + "Alih" (alih bahasa) | Unik, deskriptif | Terdengar sedikit buatan/kurang natural diucapkan |

**Rekomendasi:** pakai **Alinea** sebagai working name mulai sekarang di kode/repo (package name `id.alinea.reader` atau semacamnya), tapi validasi ketersediaan nama sebelum submit ke Play Store.

### 1.3 Positioning (tidak berubah dari v1)

> A reading environment where any EPUB can become readable in Bahasa Indonesia without leaving the book — powered entirely by open-source translation, not a paid API.

Klausa terakhir ("powered entirely by open-source translation") adalah diferensiator baru dibanding kompetitor (Koodo Reader, ReadEra, berbagai "EPUB Translator" generik di Play Store) yang umumnya mengandalkan AI/API berbayar pihak ketiga sebagai backend translate.

---

## 2. Problem Statement, Goals & Non-Goals

### 2.1 Problem Statement — tidak berubah dari v1 (7 poin, lihat dokumen asli section 2). Tetap valid.

### 2.2 Goals — ditambah 1 goal baru

Goals G1–G6 dari v1 (Native EPUB Reading, Seamless Translation, Indonesian-First, Preserve Reading Context, Translation Performance, Extensible Backend) **tetap berlaku dan tidak diubah.**

**Goal baru — G7 (FOSS & Zero Marginal Cost):**
Aplikasi dan mesin translation default-nya harus dapat dijalankan tanpa biaya per-penggunaan (no pay-per-character API), dan komponen intinya harus dapat diaudit/diverifikasi sebagai open source. Provider berbayar/proprietary hanya boleh menjadi opsi tambahan yang eksplisit di-opt-in oleh pengguna, tidak pernah default.

### 2.3 Non-Goals — tidak berubah dari v1 (DRM bypass, cloud sync, social, TTS, dst — tetap non-goal MVP).

### 2.4 Keputusan Strategis Baru: "FOSS" itu Dua Level

Ini poin penting yang v1 tidak bahas dan perlu kamu putuskan secara sadar:

| Level | Artinya | Implikasi |
|---|---|---|
| **A — FOSS untuk mesin translation saja** | Translation engine gratis & open source (LibreTranslate/Argos), tapi app boleh pakai library proprietary lain (mis. Google ML Kit opsional, Firebase Crashlytics, dll) | Lebih fleksibel, distribusi Play Store saja sudah cukup |
| **B — FOSS untuk seluruh aplikasi** | Seluruh source code app dirilis di bawah lisensi OSI (GPL-3.0/MIT), tidak ada dependency proprietary sama sekali (termasuk Google Play Services) | Memungkinkan distribusi via **F-Droid**, tapi mengharuskan ML Kit dihapus dari default build, dan analytics/crash-reporting harus yang self-hosted juga (mis. Sentry self-hosted, bukan Firebase) |

**Rekomendasi:** desain default configuration app supaya **kompatibel dengan Level B** (tanpa ML Kit, tanpa Firebase, self-hosted analytics opsional) — tapi tetap arsitektur provider-agnostic sehingga kalau kamu rilis varian Play-Store-only, kamu bisa toggle ML Kit sebagai enhancement opsional tanpa mengubah struktur inti. Ini memberi kamu kedua opsi distribusi tanpa refactor besar nanti.

---

## 3. Target Users / Personas

Tidak berubah dari v1 — 3 persona (Casual Reader, Language Learner, Technical/Academic Reader) tetap relevan dan tidak perlu direvisi.

---

## 4. Fitur — MVP Scope

### 4.1 Must / Should / Could / Won't Have

| Prioritas | Fitur |
|---|---|
| **Must Have** | Import EPUB · parsing metadata · cover display · navigasi chapter (termasuk nested TOC) · reading progress + resume posisi · text selection · translate teks terpilih (via LibreTranslate self-hosted) · deteksi bahasa otomatis · tampilan original + translated · cache translation lokal · error handling translation · reading settings (font, tema, dst) |
| **Should Have** | Translate per-paragraf · riwayat translation · buku favorit · tema dark/sepia/AMOLED · **bookmarks** (baru) · **highlights dengan warna** (baru, terhubung ke translation unit) · pemilihan provider (LibreTranslate vs ML Kit opsional) |
| **Could Have** | Translate per-chapter · custom translation prompt/style (natural/literal/academic) · glossary/terminology lock · TTS · shared community cache (opt-in) |
| **Won't Have (MVP)** | Cloud sync akun · fitur sosial · DRM bypass · full-book auto-translate background · translation model on-device custom (bukan via provider) |

Perubahan dari v1: **Bookmarks** dan **Highlights** ditambahkan ke Should Have — v1 tidak menyebutnya sama sekali, padahal untuk reader app yang "sempurna jangka panjang," dua fitur ini nyaris wajib, dan skema database section 9 sudah didesain mengakomodasinya sejak awal supaya tidak perlu migrasi besar nanti.

### 4.2 UX Flow Inti — tidak berubah dari v1

Flow "Select Text → Context Toolbar → Translation Panel" (section 7.1 v1) dan tiga mode tampilan (Original+Translation / Translation Only / Original with On-Demand — Mode C sebagai default MVP) **tetap direkomendasikan tanpa perubahan.** Alasannya di v1 (hemat request, aman terhadap layout) masih valid dan malah makin penting sekarang karena translation dijalankan di server self-hosted dengan compute terbatas (lihat section 6.4).

---

## 5. Proses Bisnis End-to-End

Ini section baru yang menyatukan seluruh sistem jadi satu alur operasional, plus model biaya yang berubah total karena keputusan FOSS.

### 5.1 Alur Pengguna → Sistem (End-to-End)

```text
Pengguna membuka app
     ↓
Import EPUB dari device
     ↓
Parser ekstrak metadata + hash file (cek duplikat)
     ↓
Buku masuk Library, reading_status = unread
     ↓
Pengguna membaca chapter (WebView + epub.js)
     ↓
Pengguna select teks yang tidak dipahami
     ↓
App cek translation_cache lokal (SQLite/Drift)
     ├── HIT  → tampilkan instan (< 200ms), tidak ada network call
     └── MISS → kirim ke Translation Gateway
                    ↓
              Gateway cek Redis cache (shared antar pengguna, opsional)
                    ├── HIT  → kembalikan, simpan ke cache lokal
                    └── MISS → forward ke LibreTranslate self-hosted
                                    ↓
                              Argos Translate model inference
                                    ↓
                              Hasil dikembalikan → cache di Redis + lokal
     ↓
Pengguna lanjut membaca (reading_progress ter-update otomatis)
```

### 5.2 Model Biaya Operasional (Perubahan Fundamental dari v1)

Ini yang paling penting untuk dipahami sebagai pemilik produk:

| Komponen | Model Biaya v1 (asumsi provider berbayar) | Model Biaya v2 (FOSS) |
|---|---|---|
| Biaya per-translasi | Variabel, naik linear dengan pemakaian (pay-per-character) | **Rp 0** — model sudah ter-download di server, inference tidak dikenakan biaya per-request |
| Biaya tetap | API key subscription/vendor | Hosting VPS untuk LibreTranslate (fixed, tidak naik sebanding volume translate) |
| Risiko skala | Biaya bisa meledak kalau app viral | Risiko bergeser ke **kapasitas compute** (CPU inference bisa jadi bottleneck di traffic tinggi, bukan biaya) |
| Titik kegagalan bisnis | Kehabisan quota API / billing bermasalah | Server self-hosted down / model belum ter-load untuk bahasa tertentu |

**Implikasi:** karena tidak ada biaya marginal, kamu bisa mengizinkan penggunaan translate se-agresif mungkin dari sisi UX tanpa takut billing shock — tapi kamu **harus** merancang caching sekuat mungkin (section 6.5) supaya server tidak collapse di jam ramai, karena bottleneck-nya sekarang compute, bukan uang.

### 5.3 Tanggung Jawab Operasional (Ops Checklist)

Karena kamu jadi operator server translation-nya sendiri, proses bisnis mencakup tanggung jawab baru yang tidak ada kalau pakai API pihak ketiga:

- [ ] Deploy LibreTranslate via Docker Compose, pilih paket bahasa yang relevan dengan test matrix (EN, JA, ZH, KO, AR, DE/FR/ES ↔ ID)
- [ ] Monitor latency & uptime instance (mis. lewat health check `/health` yang sudah disediakan LibreTranslate)
- [ ] Rencana scale-out: mulai dari 1 instance CPU-only, siapkan jalur ke GPU instance atau replika horizontal di belakang Nginx kalau concurrent user naik
- [ ] Kebijakan retensi cache Redis/DB (LRU + `hit_count` untuk keputusan eviction — lihat section 9)
- [ ] Rencana lisensi: jika kamu **memodifikasi** source LibreTranslate (bukan sekadar deploy stock), kewajiban AGPL-3.0 mengharuskan kamu mempublikasikan source modifikasimu ke pengguna yang berinteraksi dengannya lewat network. Kalau hanya deploy tanpa modifikasi, tidak ada kewajiban tambahan.

---

## 6. Arsitektur Translation — FOSS-First (Koreksi Utama)

### 6.1 Provider Abstraction (diperbarui dari v1 section 10)

```dart
abstract class TranslationProvider {
  String get id;              // 'libretranslate' | 'mlkit_ondevice' | 'byok_deepl' ...
  String get versionTag;      // dipetakan ke provider_version di cache key
  bool get isFoss;            // ditampilkan sebagai badge transparansi di Settings
  bool get requiresNetwork;

  Future<TranslationResult> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    String style = 'natural',   // reserved untuk fitur Translation Style masa depan
  });

  Future<LanguageDetectionResult> detectLanguage(String text);
}
```

Menambahkan `isFoss` dan `requiresNetwork` langsung di level interface (bukan cuma di dokumen) memastikan komitmen FOSS-mu benar-benar tertanam di kode, bukan cuma kebijakan di atas kertas — UI Settings bisa menampilkan badge "Open Source" secara otomatis dari flag ini.

### 6.2 Implementasi Provider — Hierarki Baru

```text
TranslationProvider
├── LibreTranslateProvider     (DEFAULT) — self-hosted, engine Argos Translate (MIT),
│                                gateway AGPL-3.0, $0 biaya marginal, kualitas cukup untuk
│                                percakapan/teknis, lebih lemah untuk teks sastra kompleks
│
├── OnDeviceMLKitProvider      (OPSIONAL, opt-in) — google_mlkit_translation, gratis,
│                                offline setelah model terunduh, kualitas lebih baik,
│                                TAPI proprietary & butuh Google Play Services
│                                (tidak kompatibel F-Droid / de-Googled Android)
│
└── BringYourOwnKeyProvider    (OPSIONAL, power user) — user memasukkan API key sendiri
                                 (DeepL/Google Cloud/Azure), app TIDAK PERNAH membundel
                                 atau membayar ini — murni pass-through
```

Ini mengganti `GoogleTranslationProvider`/`MicrosoftTranslationProvider` v1 sebagai *default bundled option* — keduanya sekarang hanya bisa diakses lewat `BringYourOwnKeyProvider`, sepenuhnya opsional, dan tidak pernah jadi biaya buat kamu sebagai developer.

### 6.3 Kenapa Gateway Tetap Dipertahankan (Alasan Baru)

v1 beralasan gateway diperlukan untuk "API key tidak tertanam di APK." Alasan itu tidak relevan lagi untuk LibreTranslate self-hosted (tidak ada API key vendor mahal untuk disembunyikan). Tapi gateway tetap bernilai karena:

1. **Melindungi alamat server self-hosted-mu** dari exposure langsung di APK (mencegah orang lain membebani servermu tanpa melalui app-mu).
2. **Rate limiting** — krusial justru karena compute-mu terbatas (bukan billing yang terbatas).
3. **Provider routing** tetap berguna untuk fallback: kalau instance LibreTranslate utama down, gateway bisa reroute ke instance cadangan atau turunkan ke ML Kit lokal.
4. **Caching terpusat** (Redis) mengurangi beban inference berulang untuk kalimat populer (mis. buku klasik domain publik yang banyak dibaca banyak pengguna).

### 6.4 Realita Performa Self-Hosted MT (Koreksi Ekspektasi dari v1)

v1 section 31 menargetkan "remote translation response < 3 detik." Untuk LibreTranslate/Argos Translate berjalan CPU-only di VPS kecil, target ini **optimis** — terutama untuk pasangan bahasa yang harus pivot lewat bahasa perantara (mis. Jepang → Indonesia mungkin pivot lewat Inggris, menggandakan waktu inference), dan makin berat saat beberapa request concurrent.

**Rekomendasi realistis:**
- Target MVP: < 3 detik untuk kalimat pendek pada 1 concurrent user; toleransi hingga 6–8 detik dalam kondisi beban tinggi, dengan loading state yang jelas di UI.
- Prioritaskan cache hit rate setinggi mungkin (lihat 6.5) ketimbang memaksa raw inference lebih cepat.
- Kalau performa jadi masalah nyata di produksi, `OnDeviceMLKitProvider` bisa jadi fallback otomatis untuk pengguna yang mengaktifkannya (lebih cepat karena on-device, tanpa round-trip network).

### 6.5 Caching Strategy (diperluas dari v1 section 13)

Cache key formula v1 tetap dipakai: `hash(source_language + target_language + normalized_text + provider_version)`, ditambah dimensi baru `style` untuk mengakomodasi fitur Translation Style masa depan tanpa migrasi ulang.

Layer cache:
```text
Local (Drift/SQLite, per-device)
    ↓ miss
Redis (server, shared antar pengguna — opsional, perlu consent untuk privacy)
    ↓ miss
LibreTranslate inference
    ↓
Simpan ke kedua layer cache, update hit_count
```

Catatan privasi (tidak berubah dari prinsip v1 section 34): cache lokal per-device adalah default; shared cache di Redis/server bersifat opsional dan hanya boleh menyimpan pasangan teks-terjemahan (bukan identitas buku/pengguna) — didesain sebagai lookup anonim berbasis hash konten semata.

---

## 7. Arsitektur EPUB Rendering & Translation Bridge

### 7.1 Package Konkret (mengisi kekosongan v1 yang hanya bilang "WebView-based approach")

| Kebutuhan | Package | Lisensi | Catatan |
|---|---|---|---|
| Parsing EPUB (OPF, manifest, spine, metadata) | `epubx` | MIT-style | Dart-native, tidak bergantung `dart:io`, jalan di semua platform |
| Rendering chapter (HTML/CSS + text selection ala browser) | `flutter_epub_viewer` | BSD-3-Clause | Menggabungkan epub.js (JS engine translation-friendly) + `flutter_inappwebview` — persis Option A yang direkomendasikan v1, sekarang dengan nama package nyata |
| Local database | `drift` + `sqlite3_flutter_libs` | MIT | Lihat section 9 |
| State management | `riverpod` | MIT | Tidak berubah dari v1 |
| Networking | `dio` | MIT | Tidak berubah dari v1 |

### 7.2 Translation Bridge (tidak berubah secara konsep dari v1 section 16, sekarang dipetakan ke package nyata)

```text
User selects text di dalam WebView (epub.js)
       ↓
epub.js emit selection event via JS
       ↓
flutter_inappwebview.addJavaScriptHandler() menangkap event
       ↓
Flutter ambil teks + node_path (stable id, lihat translation_units di section 9)
       ↓
TranslationProvider.translate(...)
       ↓
Hasil dikirim balik via evaluateJavascript()
       ↓
epub.js suntik translation overlay ke DOM tanpa mengubah teks asli
```

`node_path` yang stabil (bukan sekadar index runtime) adalah kunci supaya hasil terjemahan tidak salah tempel setelah re-render atau update app — ini yang tidak pernah didefinisikan sebagai tabel nyata di v1 (lihat `translation_units` di section 9.2).

---

## 8. Struktur Project

### 8.1 Flutter App Structure (diperbarui dari v1 section 22–24)

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│
├── core/
│   ├── network/
│   ├── storage/            # Drift database + SharedPreferences wrapper
│   ├── errors/
│   └── utils/
│       └── hashing.dart    # sha256 untuk file_hash & source_text_hash
│
├── features/
│   ├── library/
│   ├── reader/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── reader_screen.dart
│   │       ├── reader_controller.dart
│   │       └── translation_overlay.dart
│   │
│   ├── translation/
│   │   ├── data/
│   │   │   ├── providers/
│   │   │   │   ├── libretranslate_provider.dart   # default
│   │   │   │   ├── mlkit_provider.dart            # opsional, opt-in
│   │   │   │   └── byok_provider.dart             # power user
│   │   │   ├── translation_api.dart
│   │   │   └── translation_cache_repository.dart
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── epub/                # wrapper epubx + flutter_epub_viewer
│   ├── bookmarks/           # baru
│   ├── highlights/          # baru
│   ├── glossary/            # baru, forward-designed (UI menyusul)
│   └── settings/
│
└── main.dart
```

Perubahan dari v1: `bookmarks/`, `highlights/`, `glossary/` ditambahkan sebagai feature module terpisah — sejalan dengan penambahan tabel database di section 9, supaya arsitektur dan skema data konsisten sejak awal.

### 8.2 Backend Structure (Translation Gateway)

```text
backend/
├── app/
│   ├── main.py                  # FastAPI entrypoint
│   ├── routers/
│   │   ├── translate.py         # POST /v1/translate
│   │   ├── detect.py            # POST /v1/detect-language
│   │   └── providers.py         # GET /v1/providers (transparansi: mana yang FOSS)
│   ├── services/
│   │   ├── libretranslate_client.py
│   │   └── cache_service.py      # Redis
│   ├── core/
│   │   ├── rate_limit.py
│   │   └── config.py
│   └── models/                   # Pydantic schemas
│
├── infra/
│   ├── docker-compose.yml        # gateway + libretranslate + redis + nginx
│   └── nginx.conf
│
└── requirements.txt
```

Stack backend tidak berubah dari rekomendasi v1 (FastAPI, Redis, Nginx, Docker) — cocok juga dengan stack yang biasa kamu pakai. Bedanya hanya *isi* `libretranslate_client.py` menggantikan client Google/Microsoft.

---

## 9. Struktur Database — Skema Lengkap

### 9.1 Prinsip Desain "Tanpa Cela Jangka Panjang"

Sebelum masuk ke tabel, tiga prinsip yang dipegang konsisten di seluruh skema ini (dan yang tidak ada di v1):

1. **Setiap tabel utama punya dua identitas**: `id` integer auto-increment (untuk performa query lokal) **dan** `uuid` text (untuk identitas global yang aman dipakai kalau roadmap V5 — cross-device sync — akhirnya digarap). Ini mencegah migrasi identitas yang menyakitkan nanti.
2. **Soft-delete, bukan hard-delete**, untuk data yang berharga bagi pengguna (`is_archived` di `books`) — supaya "hapus buku" tidak sengaja menghapus riwayat baca/highlight yang mungkin masih dibutuhkan.
3. **Content-addressed cache** (`translation_cache` di-key oleh hash konten, bukan oleh buku/chapter) — supaya kalimat yang sama di buku berbeda bisa saling berbagi cache hit, dan tabel ini bisa lepas total dari App Settings sederhana yang **tidak perlu masuk database** (lihat 9.4).

### 9.2 Skema (DDL)

```sql
-- =========================================================
-- BOOKS
-- =========================================================
CREATE TABLE books (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid                TEXT NOT NULL UNIQUE,
    title               TEXT NOT NULL,
    subtitle            TEXT,
    author              TEXT,
    publisher           TEXT,
    source_language     TEXT,                          -- ISO 639-1, mis. 'en'
    isbn                TEXT,
    epub_version        TEXT,                           -- '2.0' | '3.0'
    file_path           TEXT NOT NULL,
    file_hash           TEXT NOT NULL UNIQUE,            -- sha256 file — cegah import duplikat
    file_size_bytes     INTEGER,
    cover_path          TEXT,
    reading_status      TEXT NOT NULL DEFAULT 'unread',  -- unread | in_progress | finished
    is_favorite         INTEGER NOT NULL DEFAULT 0,
    is_archived         INTEGER NOT NULL DEFAULT 0,      -- soft-delete
    added_at            TEXT NOT NULL,
    updated_at          TEXT NOT NULL,
    last_opened_at      TEXT
);

-- =========================================================
-- CHAPTERS  (mendukung TOC bertingkat — gap nyata di v1)
-- =========================================================
CREATE TABLE chapters (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid                TEXT NOT NULL UNIQUE,
    book_id             INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    parent_chapter_id   INTEGER REFERENCES chapters(id) ON DELETE SET NULL,
    spine_index         INTEGER NOT NULL,
    toc_order           INTEGER,
    href                TEXT NOT NULL,
    title               TEXT,
    word_count          INTEGER,
    UNIQUE (book_id, spine_index)
);

-- =========================================================
-- READING PROGRESS  (dipisah dari books — 1:1 sekarang, siap jadi 1:many kalau perlu histori multi-device nanti)
-- =========================================================
CREATE TABLE reading_progress (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id             INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    chapter_id          INTEGER NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
    cfi                 TEXT,                            -- EPUB CFI atau DOM anchor id
    scroll_pct          REAL DEFAULT 0,
    updated_at          TEXT NOT NULL,
    UNIQUE (book_id)
);

-- =========================================================
-- BOOKMARKS  (baru — tidak ada di v1)
-- =========================================================
CREATE TABLE bookmarks (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid                TEXT NOT NULL UNIQUE,
    book_id             INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    chapter_id          INTEGER NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
    cfi                 TEXT NOT NULL,
    label               TEXT,
    created_at          TEXT NOT NULL
);

-- =========================================================
-- HIGHLIGHTS  (baru — terhubung opsional ke translation_units)
-- =========================================================
CREATE TABLE highlights (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid                TEXT NOT NULL UNIQUE,
    book_id             INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    chapter_id          INTEGER NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
    translation_unit_id INTEGER REFERENCES translation_units(id) ON DELETE SET NULL,
    start_anchor        TEXT NOT NULL,
    end_anchor          TEXT NOT NULL,
    color               TEXT NOT NULL DEFAULT 'yellow',
    note                TEXT,
    created_at          TEXT NOT NULL
);

-- =========================================================
-- TRANSLATION UNITS  (mengisi "stable node ID" yang disebut tapi
-- tidak pernah didefinisikan sebagai tabel di v1 section 16)
-- =========================================================
CREATE TABLE translation_units (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    chapter_id          INTEGER NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
    node_path           TEXT NOT NULL,      -- id struktural stabil, mis. "p[12]" atau hash konten
    sequence_index      INTEGER NOT NULL,
    source_text_hash    TEXT NOT NULL,      -- sha256(teks ternormalisasi) — deteksi drift kalau re-import
    UNIQUE (chapter_id, node_path)
);

-- =========================================================
-- TRANSLATION CACHE  (content-addressed, reusable lintas buku)
-- =========================================================
CREATE TABLE translation_cache (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    source_language     TEXT NOT NULL,
    target_language     TEXT NOT NULL,
    source_text_hash    TEXT NOT NULL,
    translated_text     TEXT NOT NULL,
    provider            TEXT NOT NULL,      -- 'libretranslate' | 'mlkit_ondevice' | ...
    provider_version    TEXT NOT NULL,
    style               TEXT NOT NULL DEFAULT 'natural',  -- reserved: fitur Translation Style
    hit_count           INTEGER NOT NULL DEFAULT 1,
    created_at          TEXT NOT NULL,
    last_used_at        TEXT NOT NULL,      -- basis eviction LRU
    UNIQUE (source_text_hash, source_language, target_language, provider, provider_version, style)
);

-- =========================================================
-- GLOSSARY TERMS  (forward-designed untuk fitur v1 section 45)
-- =========================================================
CREATE TABLE glossary_terms (
    id                     INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id                INTEGER REFERENCES books(id) ON DELETE CASCADE,  -- NULL = istilah global
    source_term            TEXT NOT NULL,
    preferred_translation  TEXT NOT NULL,
    source_language        TEXT NOT NULL,
    target_language        TEXT NOT NULL,
    created_at             TEXT NOT NULL,
    updated_at             TEXT NOT NULL
);

-- book_id nullable perlu 2 unique index terpisah — detail yang mudah terlewat:
CREATE UNIQUE INDEX ux_glossary_scoped
    ON glossary_terms (book_id, source_term, source_language, target_language);
CREATE UNIQUE INDEX ux_glossary_global
    ON glossary_terms (source_term, source_language, target_language)
    WHERE book_id IS NULL;
```

### 9.3 Contoh Pemetaan ke Drift (Dart)

```dart
class Books extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get sourceLanguage => text().nullable()();
  TextColumn get filePath => text()();
  TextColumn get fileHash => text().unique()();
  TextColumn get coverPath => text().nullable()();
  TextColumn get readingStatus =>
      textEnum<ReadingStatus>().withDefault(const Constant('unread'))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
}
```

Tabel lain (`Chapters`, `ReadingProgress`, `Bookmarks`, `Highlights`, `TranslationUnits`, `TranslationCache`, `GlossaryTerms`) mengikuti pola yang sama persis dari DDL di atas.

### 9.4 Yang Sengaja TIDAK Masuk Database

Preferensi app sederhana (target bahasa default, mode translation on-demand/paragraph/chapter, toggle show-original, provider aktif) **tidak perlu tabel database** — cukup `SharedPreferences` atau `flutter_secure_storage`. Praktik Flutter 2026 menyarankan ini secara eksplisit; membuat tabel untuk key-value sederhana adalah over-engineering yang justru menambah beban migrasi tanpa manfaat.

---

## 10. Keamanan, Privasi, Copyright/DRM

Tidak berubah secara prinsip dari v1 (section 33–35) — HTTPS wajib, tidak ada secret hardcoded, tidak upload seluruh buku tanpa consent, tidak ada fitur bypass DRM. Tambahan khusus v2:

- Karena LibreTranslate self-hosted adalah infrastrukturmu sendiri, **kamu** yang bertanggung jawab atas log yang mungkin tersimpan di sana — pastikan konfigurasi LibreTranslate tidak menyimpan teks request secara default (cek `--suggestions` dan opsi logging saat deploy).
- Badge transparansi di Settings ("Diterjemahkan oleh: LibreTranslate — Open Source" vs "Google ML Kit — Proprietary, on-device") memenuhi prinsip *user harus tahu data apa yang diproses oleh apa*.

---

## 11. Performance Targets & Risk Register

| Risiko | Sumber | Mitigasi |
|---|---|---|
| EPUB besar menghabiskan RAM | v1 (tidak berubah) | Lazy chapter extraction/rendering |
| Kompleksitas DOM/CSS WebView | v1 (tidak berubah) | Cache resource chapter, optimasi JS injeksi |
| Translation request meledak | v1 (tidak berubah) | Batching, cache, debounce |
| Layout shift akibat translasi lebih panjang | v1 (tidak berubah) | Preserve paragraph container boundaries |
| **Latensi self-hosted MT lebih lambat dari target v1** | **Baru — konsekuensi keputusan FOSS** | Lihat section 6.4: revisi target realistis + cache agresif + fallback ke ML Kit opsional |
| **Kualitas terjemahan Argos Translate lebih rendah dari Google/DeepL untuk teks sastra kompleks** | **Baru** | Transparansi lewat badge provider; glossary feature (section 9.2) untuk konsistensi istilah; biarkan power user pakai BYOK provider kalau butuh kualitas lebih tinggi |

---

## 12. Test Matrix

Tidak berubah dari v1 section 49 (EPUB kecil/besar/gambar/CSS/TOC/footnote/encoding tidak umum; bahasa EN/JA/ZH/KO/AR/DE/FR/ES). Tambahan baru:

| Case Baru | Requirement |
|---|---|
| LibreTranslate instance down | App tetap bisa membaca, translation menampilkan error graceful (bukan crash) |
| Cache hit lintas buku berbeda (kalimat identik) | `translation_cache` mengembalikan hasil tanpa request baru |
| Import file EPUB yang sama dua kali | Ditolak/di-skip berkat `file_hash UNIQUE` |
| TOC bertingkat (nested chapter) | `parent_chapter_id` merender hierarki dengan benar tanpa duplikasi konten |

---

## 13. MVP Development Phases & Definition of Done

Struktur 4 fase dari v1 (EPUB Core → Translation Core → Translation UX → Hardening) **tetap dipakai tanpa perubahan urutan.** Definition of Done v1 (section 52) tetap berlaku, ditambah satu butir:

- [ ] Default build tidak memiliki dependency ke provider berbayar atau proprietary (ML Kit hanya aktif jika pengguna eksplisit mengaktifkannya di Settings)
- [ ] Instance LibreTranslate self-hosted sudah berjalan dan diuji end-to-end sebelum submit ke Play Store

---

## 14. Roadmap

Tidak berubah dari v1 section 58 (V1 → V1.5 → V2 → V3 → V4 → V5), dengan catatan: V4 ("Offline/on-device translation") di v1 dianggap fitur masa depan yang jauh — di v2, sebagian sudah bisa dicapai lebih awal lewat `OnDeviceMLKitProvider` opsional sejak V1, karena package-nya sudah tersedia dan matang hari ini.

---

## 15. Rekomendasi Teknologi — Scorecard Final

| Layer | v1 | v2 | Status Verifikasi |
|---|---|---|---|
| Mobile framework | Flutter/Dart | Flutter/Dart | Tidak berubah |
| State management | Riverpod | Riverpod | Tidak berubah |
| Local database | Isar/SQLite | **Drift** | Isar dikonfirmasi mangkrak dari maintainer asli |
| EPUB parsing | (tidak spesifik) | `epubx` | Dikonfirmasi aktif |
| EPUB rendering | (tidak spesifik, "WebView-based") | `flutter_epub_viewer` | Dikonfirmasi aktif, verified publisher |
| Translation engine default | Google/Microsoft Translate (berbayar) | **LibreTranslate + Argos Translate** | AGPL-3.0 / MIT, dikonfirmasi aktif dikembangkan |
| Translation opsional | — | Google ML Kit (`google_mlkit_translation`) | Gratis, dikonfirmasi aktif, TAPI bukan FOSS |
| Backend gateway | FastAPI | FastAPI | Tidak berubah — alasan dipertahankan diperbarui |
| Server cache | Redis | Redis | Tidak berubah |
| Deployment | Docker + Nginx | Docker + Nginx | Tidak berubah |

---

*Dokumen ini adalah revisi dari PRD v1 ("Nexus Reader"). Bagian yang tidak disebutkan ulang di sini (accessibility, analytics event list, security checklist detail, API error codes) tetap berlaku sebagaimana tercantum di dokumen asli.*