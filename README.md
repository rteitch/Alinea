<p align="center">
  <img src="assets/images/logo.png" width="160" height="160" alt="Alinea App Icon" />
</p>

<h1 align="center">Alinea</h1>

<p align="center">
  <strong>FOSS EPUB Reader & In-Place Translation Engine</strong><br/>
  <em>"Read first, translate seamlessly when needed — 100% Free, 100% FOSS, $0 Marginal Cost."</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android" />
  <img src="https://img.shields.io/badge/Framework-Flutter%203.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Language-Dart%203.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Database-Drift%20(SQLite)-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="Drift" />
  <img src="https://img.shields.io/badge/Backend-FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white" alt="FastAPI" />
  <img src="https://img.shields.io/badge/Testing-ISTQB%20(48%2F48%20Passed)-4CAF50?style=for-the-badge" alt="ISTQB" />
  <img src="https://img.shields.io/badge/Status-Release%20APK%20Ready-success?style=for-the-badge" alt="Status" />
  <img src="https://img.shields.io/badge/License-MIT%20%2F%20FOSS-blue?style=for-the-badge" alt="License" />
</p>

<p align="center">
  <a href="https://github.com/rteitch/Alinea/releases/latest/download/app-release.apk">
    <img src="https://img.shields.io/badge/Download-APK%20v1.18.0-4CAF50?style=for-the-badge&logo=android&logoColor=white" alt="Download APK" />
  </a>
</p>

> **Alinea** (derived from the word for *paragraph*) is a modern, privacy-respecting digital book reader (EPUB) for Android. It bridges long-form reading with instantaneous, in-place machine translation powered by open-source translation engines (**LibreTranslate + Argos Translate**).

Unlike conventional reader applications that require clumsy copy-pasting to external translator apps or charge recurring per-character fees via proprietary cloud APIs, Alinea delivers a **zero marginal cost ($0)** experience with robust offline-first caching, scoped terminology locking, and an elegant distraction-free reading environment.

---

## 📑 Table of Contents
- [Download APK](#-download-apk)
- [Key Features](#-key-features)
- [System Architecture](#-system-architecture)
  - [End-to-End Translation Pipeline](#end-to-end-translation-pipeline)
  - [Why is there a Python Backend Gateway?](#why-is-there-a-python-backend-gateway)
  - [Connecting Android Client to Local Backend over LAN/Wi-Fi](#connecting-android-client-to-local-backend-over-lanwi-fi)
- [UI/UX & Accessibility Highlights](#-uiux--accessibility-highlights)
- [Database Schema (Drift SQLite)](#-database-schema-drift-sqlite)
- [ISTQB Test Suite & Verification](#-istqb-test-suite--verification)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Running the Flutter Client](#1-running-the-flutter-client)
  - [Building Android APK](#2-building-android-apk)
  - [Deploying the Translation Gateway](#3-deploying-the-translation-gateway)
- [Project Directory Structure](#-project-directory-structure)
- [Product Roadmap](#-product-roadmap)
- [License](#-license)

---

## 📥 Download APK

| Platform | Link |
|---|---|
| **Android** | [**Download app-release.apk (v1.4.1)**](https://github.com/rteitch/Alinea/releases/latest/download/app-release.apk) |

> **Requirements:** Android 7.0+ (API 24+). For translation features, deploy the backend gateway ([see below](#3-deploying-the-translation-gateway)).

---

## 🌟 Key Features

### 📖 1. Native EPUB Engine (v2.0 & v3.0)
- **Zero Heavy Bloat:** Dart-native uncompressed and streaming parsing built directly on `archive` and `xml`.
- **Rich Metadata Extraction:** Title, author, publisher, source language, cover image extraction, and chapter word count estimation.
- **Hierarchical Table of Contents (TOC):** Support for multi-level nested chapter hierarchies and sequential spine navigation.
- **Content Deduplication:** Automatic SHA-256 book fingerprinting preventing redundant library entries.

### ⚡ 2. In-Place Contextual Translation
- **Native Selection Context Menu:** Select any word, phrase, or paragraph and tap **"Terjemahkan"** (Translate) without leaving the page.
- **Mode C Display (Original with On-Demand):** Presents source text and target translation side-by-side in a responsive modal bottom sheet, preserving original typography and reading flow.
- **FOSS Transparency Badge:** Explicit transparency badge (`100% FOSS ($0)`) indicating open-source compute integrity.

### 💾 3. Content-Addressed Local Cache
- **Instantaneous Lookup (< 200ms):** Cached translations are retrieved immediately without touching network sockets.
- **Cross-Book Reuse:** Translations are indexed by `sha256(normalized_source_text + lang_pair + provider_version)` so identical sentences across different books share the cache.
- **Automatic LRU Eviction:** Tracks `hit_count` and `last_used_at` timestamps to ensure local storage stays lean.

### 🔒 4. Scoped Terminology Lock (Glossary)
- **Custom Translations:** Lock specific domain terms, character names, or idioms.
- **Precedence Hierarchy:** `Scoped Book Glossary > Global Glossary > Translation Engine`.
- Direct pinning to glossary directly from the translation overlay.

### 🎨 5. Ergonomic Reading Themes & Typography
- **4 Crafted Color Themes:**
  - **Light:** Crisp, high-contrast day mode.
  - **Sepia (`#FBF0D9`):** Warm, paper-like palette scientifically designed to minimize eye strain.
  - **Dark (`#1E293B`):** Elegant slate dark mode.
  - **AMOLED (`#000000`):** Pitch black mode optimizing power consumption on OLED/AMOLED displays.
- **Dynamic Font Scaling:** Smooth real-time typography slider ranging from 12sp to 28sp.
- **Reading Progress State Engine:** Automatically tracks scroll percentage and updates reading status (`unread` $\rightarrow$ `in_progress` $\rightarrow$ `finished`).

### 🖍️ 6. Visual In-Text Highlighting
- **Embedded Color Spans:** Highlights are rendered directly into the paragraph flow using semi-transparent, comfortable tinting:
  - 🟡 **Yellow** (`#FFF59D`)
  - 🟢 **Green** (`#A5D6A7`)
  - 🔵 **Blue** (`#90CAF9`)
  - 🔴 **Pink** (`#F48FB1`)
- **Seamless Interaction:** Highlighted passages can still be re-selected, translated, or annotated without breaking the document stream.

### 📓 7. Translation History & Vocabulary Notebook
- **Dedicated Vocab Hub:** Review all past lookups stored in the offline SQLite cache.
- **Instant Search:** Filter through original phrases and translated results in real time.
- **1-Tap Glossary Pinning:** Lock any translated term into your permanent terminology glossary with one tap.
- **Usage Frequency:** Live badge tracking (`hitCount`) showing how often words recur across your reading.

### 📊 8. Precision Shelf Progress Tracking
- **Accurate Book Progress:** Calculated dynamically using chapter position and scroll percentage:
  $$\text{Progress} = \frac{\text{Current Chapter Index} + \text{Scroll Percentage}}{\text{Total Chapters}} \times 100\%$$
- **Visual Feedback:** Horizontal `LinearProgressIndicator` and exact percentages (`65% selesai`) on every library book card.

### 📤 9. One-Click Markdown Export (Notion & Obsidian)
- **Comprehensive Summary:** Export complete book study notes formatted in clean GitHub-Flavored Markdown.
- **Included Sections:** Book metadata, highlighted quotes with chapter labels and personal thoughts, bookmarks with dates, and book-scoped glossary definitions.
- **Clipboard Preview:** Fast modal preview with one-tap copy directly into personal knowledge management tools like Notion, Obsidian, Logseq, or Google Keep.

### 🔊 10. Voice Audio Pronunciation (Text-to-Speech)
- **Instant Listening:** Listen to native pronunciations of foreign words or translated sentences directly within the translation bottom sheet or from the Vocabulary Notebook.

---

## 🏗️ System Architecture

### End-to-End Translation Pipeline

```text
User selects text in Reader
            │
            ▼
   TranslationCoordinator
   ┌────────────────────────────────────────────────────────┐
   │ 1. Check Glossary (Scoped Book Terms -> Global Terms)  │
   │    └── HIT  ───────────────────────────────────────────┼──► Return Preferred Term
   │                                                        │
   │ 2. Check Local Cache (Drift SQLite Table)              │
   │    └── HIT (<200ms, $0, No Network) ───────────────────┼──► Return Cached Text
   │                                                        │
   │ 3. Cache MISS ─────────────────────────────────────────┘
            │
            ▼
   Translation Gateway (FastAPI / Reverse Proxy)
   ┌────────────────────────────────────────────────────────┐
   │ 4. Rate-Limiting & Abuse Prevention Check              │
   │ 5. Shared Redis Cache Check (Optional, Cross-User)     │
   │    └── HIT ────────────────────────────────────────────┼──► Return & Save to Local Cache
   │                                                        │
   │ 6. Forward to LibreTranslate (Argos Translate Engine)  │
   │    └── Local CPU/GPU Model Inference (AGPL-3.0 / MIT)   │
   └────────────────────────────────────────────────────────┘
            │
            ▼
   Save to Local Drift SQLite (LRU indexed) ──► Render in Mode C Overlay
```

---

### ❓ Why is there a Python Backend Gateway?

The `backend/` directory contains a high-performance **FastAPI Translation Gateway**. Its purpose is rooted in production resilience and operational freedom:

1. **Compute Protection & Abuse Prevention:** Self-hosted neural machine translation (Argos/LibreTranslate) is CPU-bound. The gateway enforces token-bucket rate limiting to prevent individual devices from crashing your server.
2. **Shared Multi-User Caching:** A Redis layer caches translations of popular public-domain books across multiple readers anonymously, dramatically cutting inference wait times.
3. **Decoupled Provider Architecture:** You can upgrade or switch translation backends (e.g., migrate to a faster GPU instance or custom fine-tuned Argos model) on the server without needing to publish a new APK to Google Play or F-Droid.
4. **Provider-Agnostic Freedom:** The Flutter client is **100% decoupled**. Through the **Settings** screen, users can:
   - Point the URL to their self-hosted gateway.
   - Point directly to any public LibreTranslate instance.
   - Switch to **BYOK (Bring Your Own Key)** mode (e.g., personal DeepL API key).

---

### 🌐 Connecting Android Client to Local Backend over LAN/Wi-Fi

Can you run the backend on your PC and connect the Android app running on your phone via the same local Wi-Fi network? **Yes, absolutely!**

#### Step 1: Start Backend on Local Network Host
Run the FastAPI backend bound to `0.0.0.0` (all network interfaces) rather than `127.0.0.1`:
```bash
cd backend
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

#### Step 2: Obtain Your PC's Local IP Address
- **Windows:** Run `ipconfig` in terminal (look for *IPv4 Address*, e.g., `192.168.1.15`).
- **Linux/macOS:** Run `ifconfig` or `ip a`.

#### Step 3: Configure Gateway in Alinea Mobile App
1. Open **Alinea** on your Android device (connected to the same Wi-Fi).
2. Tap the **Settings** tab.
3. Set **Gateway URL** to:
   ```text
   http://192.168.1.15:8000/v1/translate
   ```
   *(If using the official Android Studio Emulator, use `http://10.0.2.2:8000/v1/translate`)*
4. Tap **Simpan Perubahan** (Save).

> [!NOTE]
> Android disables cleartext HTTP by default. Alinea has `android:usesCleartextTraffic="true"` configured in its `AndroidManifest.xml` alongside CORS wildcard allowance on FastAPI, ensuring local LAN HTTP connections connect immediately without SSL certificate friction.

---

## 🗄️ Database Schema (Drift SQLite)

The database schema is strictly normalized into **9 relational entities**, with foreign key constraints, indexation, and dual identity (`id` integer + `uuid` RFC-4122 v4):

| Table | Role | Key Constraints & Indexes |
|---|---|---|
| `books` | Book catalog & metadata | `file_hash UNIQUE`, `uuid UNIQUE`, soft-delete flag `is_archived` |
| `chapters` | TOC hierarchy & spine elements | `UNIQUE (book_id, spine_index)`, `parent_chapter_id` foreign key |
| `reading_progress` | Per-book scroll position & CFI | `UNIQUE (book_id)` with `ON DELETE CASCADE` |
| `bookmarks` | User page markers | `uuid UNIQUE`, `chapter_id REFERENCES chapters` |
| `highlights` | Highlighted passages & color notes | Linked optionally to `translation_units` |
| `translation_units` | Stable DOM node anchor index | `UNIQUE (chapter_id, node_path)` |
| `translation_cache` | Content-addressed LRU cache | `UNIQUE (source_text_hash, source_lang, target_lang, provider, provider_version, style)` |
| `glossary_terms` | Terminology lock definitions | Scoped index `ux_glossary_scoped` + Global partial index `ux_glossary_global` |
| `book_settings` | Per-book reader preferences | `UNIQUE (book_id)` with `ON DELETE CASCADE`; font size, theme, translation, scroll position |

---

## 🧪 ISTQB Test Suite & Verification

Alinea enforces rigorous automated testing aligned with **ISTQB (International Software Testing Qualifications Board)** methodologies:

| ISTQB Technique | Test Scope | Verification Artifact |
|---|---|---|
| **Equivalence Partitioning (EP)** | EPUB 2.0 vs 3.0 valid structures; empty files (0 bytes); corrupt ZIP archives; missing OPF/manifest; Unicode edge cases (Arabic, CJK, German umlauts, zero-width characters). | [`hashing_test.dart`](file:///d:/Project/Alinea/test/core/utils/hashing_test.dart), [`epub_parser_service_test.dart`](file:///d:/Project/Alinea/test/features/epub/epub_parser_service_test.dart) |
| **Boundary Value Analysis (BVA)** | Reading progress clamps (`scroll_pct < 0.0`, `> 1.0`); chapter boundary (0 words vs 1 word); cache capacity limits. | [`database_test.dart`](file:///d:/Project/Alinea/test/core/storage/database_test.dart) |
| **Decision Table Testing** | Book deduplication: New book vs duplicate rejection vs restore archived book; Translation resolution hierarchy: Scoped glossary $\rightarrow$ Global glossary $\rightarrow$ Local cache $\rightarrow$ Remote inference. | [`database_test.dart`](file:///d:/Project/Alinea/test/core/storage/database_test.dart), [`translation_coordinator_test.dart`](file:///d:/Project/Alinea/test/features/translation/translation_coordinator_test.dart) |
| **State Transition Testing** | Reading status lifecycle (`unread` $\rightarrow$ `in_progress` $\rightarrow$ `finished`); Cache lifecycle (MISS $\rightarrow$ Store $\rightarrow$ HIT with incremented `hit_count`). | [`database_test.dart`](file:///d:/Project/Alinea/test/core/storage/database_test.dart) |

### Test Execution Summary
```text
✅ Flutter Client Tests:  48 / 48 passed (100%)
✅ Static Analysis:       0 Errors, 0 Warnings, 0 Lints (dart analyze)
✅ FastAPI Backend Tests: 4 / 4 passed (pytest)
✅ Android Release Build: 60.0 MB standalone APK compiled
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `>= 3.22.0`
- **Dart SDK**: `>= 3.4.0`
- **Android SDK**: API Level 34+
- **Python**: `>= 3.10` (for translation gateway)

### 1. Running the Flutter Client
```bash
# Clone the repository
git clone https://github.com/rteitch/Alinea.git
cd Alinea

# Get dependencies
flutter pub get

# Launch on connected Android device or emulator
flutter run
```

### 2. Building Android APK
```bash
# Compile Debug APK
flutter build apk --debug

# Compile Production Release APK
flutter build apk --release
```
The compiled APK will be output to:
`build/app/outputs/flutter-apk/app-release.apk` (or `app-debug.apk`).

### 3. Deploying the Translation Gateway

#### Option A: Direct Python Execution
```bash
cd backend
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

#### Option B: Production Docker Compose (Gateway + LibreTranslate + Redis)
```bash
cd backend/infra
docker compose up -d
```

---

## 📂 Project Directory Structure

```text
Alinea/
├── android/                     # Native Android Gradle configuration & manifest
├── assets/                      # Application brand assets & app icons
│   └── images/logo.png          # Alinea high-res squircle icon
├── backend/                     # Translation Gateway service
│   ├── app/
│   │   ├── main.py              # FastAPI server & route handlers
│   │   └── services/            # LibreTranslate & Redis integration
│   ├── infra/
│   │   ├── docker-compose.yml   # Multi-container deployment
│   │   └── nginx.conf           # Reverse proxy configuration
│   └── tests/                   # Pytest test suite
├── lib/
│   ├── app/                     # Riverpod state providers, theme & app entrypoint
│   ├── core/
│   │   ├── errors/              # Exception & Failure hierarchies
│   │   ├── storage/             # Drift SQLite database schema & generated ORM
│   │   └── utils/               # SHA-256 hashing & text normalization
│   └── features/
│       ├── bookmarks/           # Bookmark repository & models
│       ├── epub/                # Native Dart EPUB 2/3 parser service
│       ├── glossary/            # Scoped & global terminology lock repository
│       ├── highlights/          # Highlight annotations repository & in-text spans
│       ├── library/             # Library view, search, category filter & import
│       ├── reader/              # Responsive reading canvas, TOC, notes export & Mode C overlay
│       ├── settings/            # Gateway URL, theme, language & LRU cache management
│       └── translation/         # Translation coordinator, cache, history screen & providers
├── test/                        # ISTQB-compliant test suite (48 tests, 100% pass)
└── pubspec.yaml                 # Dependencies & project metadata
```

---

## 🗺️ Product Roadmap

- [x] **v1.0 (MVP Core & Full Refinement):** Native EPUB 2/3 parsing, Drift SQLite normalized engine, In-Place translation (Mode C), LibreTranslate FOSS integration, Scoped glossary, 4 reading themes, ISTQB verification.
- [x] **Visual In-Text Highlighting:** 4 comfortable semi-transparent colors (Yellow, Green, Blue, Pink) rendered directly in the reading flow.
- [x] **Translation History & Vocab Notebook:** Searchable history screen with audio pronunciation, 1-tap copy, and direct glossary locking.
- [x] **Text-to-Speech (TTS):** Native voice pronunciation for foreign words and translated sentences.
- [x] **Markdown Study Export:** One-tap export of book metadata, notes, highlights, bookmarks, and terms into Obsidian/Notion markdown.
- [x] **Precise Book Progress Metric:** Dynamic chapter + scroll completion percentage on library book cards.
- [ ] **v1.1:** Custom translation prompt styles (*Natural*, *Literal*, *Academic*).
- [ ] **v2.0:** Multi-device synchronization using end-to-end encrypted protocol (utilizing existing RFC-4122 `uuid` fields).

---

## 📄 License

- **Alinea Client:** Licensed under the [MIT License](LICENSE).
- **Translation Engine:** Powered by [LibreTranslate](https://github.com/LibreTranslate/LibreTranslate) (AGPL-3.0) and [Argos Translate](https://github.com/argosopentech/argos-translate) (MIT License).
