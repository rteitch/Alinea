// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceLanguageMeta = const VerificationMeta(
    'sourceLanguage',
  );
  @override
  late final GeneratedColumn<String> sourceLanguage = GeneratedColumn<String>(
    'source_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isbnMeta = const VerificationMeta('isbn');
  @override
  late final GeneratedColumn<String> isbn = GeneratedColumn<String>(
    'isbn',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _epubVersionMeta = const VerificationMeta(
    'epubVersion',
  );
  @override
  late final GeneratedColumn<String> epubVersion = GeneratedColumn<String>(
    'epub_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readingStatusMeta = const VerificationMeta(
    'readingStatus',
  );
  @override
  late final GeneratedColumn<String> readingStatus = GeneratedColumn<String>(
    'reading_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unread'),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    title,
    subtitle,
    author,
    publisher,
    sourceLanguage,
    isbn,
    epubVersion,
    filePath,
    fileHash,
    fileSizeBytes,
    coverPath,
    readingStatus,
    isFavorite,
    isArchived,
    addedAt,
    updatedAt,
    lastOpenedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('source_language')) {
      context.handle(
        _sourceLanguageMeta,
        sourceLanguage.isAcceptableOrUnknown(
          data['source_language']!,
          _sourceLanguageMeta,
        ),
      );
    }
    if (data.containsKey('isbn')) {
      context.handle(
        _isbnMeta,
        isbn.isAcceptableOrUnknown(data['isbn']!, _isbnMeta),
      );
    }
    if (data.containsKey('epub_version')) {
      context.handle(
        _epubVersionMeta,
        epubVersion.isAcceptableOrUnknown(
          data['epub_version']!,
          _epubVersionMeta,
        ),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('reading_status')) {
      context.handle(
        _readingStatusMeta,
        readingStatus.isAcceptableOrUnknown(
          data['reading_status']!,
          _readingStatusMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      sourceLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_language'],
      ),
      isbn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isbn'],
      ),
      epubVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}epub_version'],
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      )!,
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      ),
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      readingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_status'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      ),
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final int id;
  final String uuid;
  final String title;
  final String? subtitle;
  final String? author;
  final String? publisher;
  final String? sourceLanguage;
  final String? isbn;
  final String? epubVersion;
  final String filePath;
  final String fileHash;
  final int? fileSizeBytes;
  final String? coverPath;
  final String readingStatus;
  final bool isFavorite;
  final bool isArchived;
  final DateTime addedAt;
  final DateTime updatedAt;
  final DateTime? lastOpenedAt;
  const Book({
    required this.id,
    required this.uuid,
    required this.title,
    this.subtitle,
    this.author,
    this.publisher,
    this.sourceLanguage,
    this.isbn,
    this.epubVersion,
    required this.filePath,
    required this.fileHash,
    this.fileSizeBytes,
    this.coverPath,
    required this.readingStatus,
    required this.isFavorite,
    required this.isArchived,
    required this.addedAt,
    required this.updatedAt,
    this.lastOpenedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || sourceLanguage != null) {
      map['source_language'] = Variable<String>(sourceLanguage);
    }
    if (!nullToAbsent || isbn != null) {
      map['isbn'] = Variable<String>(isbn);
    }
    if (!nullToAbsent || epubVersion != null) {
      map['epub_version'] = Variable<String>(epubVersion);
    }
    map['file_path'] = Variable<String>(filePath);
    map['file_hash'] = Variable<String>(fileHash);
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    map['reading_status'] = Variable<String>(readingStatus);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_archived'] = Variable<bool>(isArchived);
    map['added_at'] = Variable<DateTime>(addedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      uuid: Value(uuid),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      sourceLanguage: sourceLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLanguage),
      isbn: isbn == null && nullToAbsent ? const Value.absent() : Value(isbn),
      epubVersion: epubVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(epubVersion),
      filePath: Value(filePath),
      fileHash: Value(fileHash),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      readingStatus: Value(readingStatus),
      isFavorite: Value(isFavorite),
      isArchived: Value(isArchived),
      addedAt: Value(addedAt),
      updatedAt: Value(updatedAt),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      author: serializer.fromJson<String?>(json['author']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      sourceLanguage: serializer.fromJson<String?>(json['sourceLanguage']),
      isbn: serializer.fromJson<String?>(json['isbn']),
      epubVersion: serializer.fromJson<String?>(json['epubVersion']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      readingStatus: serializer.fromJson<String>(json['readingStatus']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'author': serializer.toJson<String?>(author),
      'publisher': serializer.toJson<String?>(publisher),
      'sourceLanguage': serializer.toJson<String?>(sourceLanguage),
      'isbn': serializer.toJson<String?>(isbn),
      'epubVersion': serializer.toJson<String?>(epubVersion),
      'filePath': serializer.toJson<String>(filePath),
      'fileHash': serializer.toJson<String>(fileHash),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'coverPath': serializer.toJson<String?>(coverPath),
      'readingStatus': serializer.toJson<String>(readingStatus),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isArchived': serializer.toJson<bool>(isArchived),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
    };
  }

  Book copyWith({
    int? id,
    String? uuid,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    Value<String?> author = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<String?> sourceLanguage = const Value.absent(),
    Value<String?> isbn = const Value.absent(),
    Value<String?> epubVersion = const Value.absent(),
    String? filePath,
    String? fileHash,
    Value<int?> fileSizeBytes = const Value.absent(),
    Value<String?> coverPath = const Value.absent(),
    String? readingStatus,
    bool? isFavorite,
    bool? isArchived,
    DateTime? addedAt,
    DateTime? updatedAt,
    Value<DateTime?> lastOpenedAt = const Value.absent(),
  }) => Book(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    author: author.present ? author.value : this.author,
    publisher: publisher.present ? publisher.value : this.publisher,
    sourceLanguage: sourceLanguage.present
        ? sourceLanguage.value
        : this.sourceLanguage,
    isbn: isbn.present ? isbn.value : this.isbn,
    epubVersion: epubVersion.present ? epubVersion.value : this.epubVersion,
    filePath: filePath ?? this.filePath,
    fileHash: fileHash ?? this.fileHash,
    fileSizeBytes: fileSizeBytes.present
        ? fileSizeBytes.value
        : this.fileSizeBytes,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    readingStatus: readingStatus ?? this.readingStatus,
    isFavorite: isFavorite ?? this.isFavorite,
    isArchived: isArchived ?? this.isArchived,
    addedAt: addedAt ?? this.addedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastOpenedAt: lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      author: data.author.present ? data.author.value : this.author,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      sourceLanguage: data.sourceLanguage.present
          ? data.sourceLanguage.value
          : this.sourceLanguage,
      isbn: data.isbn.present ? data.isbn.value : this.isbn,
      epubVersion: data.epubVersion.present
          ? data.epubVersion.value
          : this.epubVersion,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      readingStatus: data.readingStatus.present
          ? data.readingStatus.value
          : this.readingStatus,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('author: $author, ')
          ..write('publisher: $publisher, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('isbn: $isbn, ')
          ..write('epubVersion: $epubVersion, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('coverPath: $coverPath, ')
          ..write('readingStatus: $readingStatus, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isArchived: $isArchived, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    title,
    subtitle,
    author,
    publisher,
    sourceLanguage,
    isbn,
    epubVersion,
    filePath,
    fileHash,
    fileSizeBytes,
    coverPath,
    readingStatus,
    isFavorite,
    isArchived,
    addedAt,
    updatedAt,
    lastOpenedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.author == this.author &&
          other.publisher == this.publisher &&
          other.sourceLanguage == this.sourceLanguage &&
          other.isbn == this.isbn &&
          other.epubVersion == this.epubVersion &&
          other.filePath == this.filePath &&
          other.fileHash == this.fileHash &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.coverPath == this.coverPath &&
          other.readingStatus == this.readingStatus &&
          other.isFavorite == this.isFavorite &&
          other.isArchived == this.isArchived &&
          other.addedAt == this.addedAt &&
          other.updatedAt == this.updatedAt &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String?> author;
  final Value<String?> publisher;
  final Value<String?> sourceLanguage;
  final Value<String?> isbn;
  final Value<String?> epubVersion;
  final Value<String> filePath;
  final Value<String> fileHash;
  final Value<int?> fileSizeBytes;
  final Value<String?> coverPath;
  final Value<String> readingStatus;
  final Value<bool> isFavorite;
  final Value<bool> isArchived;
  final Value<DateTime> addedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastOpenedAt;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.author = const Value.absent(),
    this.publisher = const Value.absent(),
    this.sourceLanguage = const Value.absent(),
    this.isbn = const Value.absent(),
    this.epubVersion = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.readingStatus = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String title,
    this.subtitle = const Value.absent(),
    this.author = const Value.absent(),
    this.publisher = const Value.absent(),
    this.sourceLanguage = const Value.absent(),
    this.isbn = const Value.absent(),
    this.epubVersion = const Value.absent(),
    required String filePath,
    required String fileHash,
    this.fileSizeBytes = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.readingStatus = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime addedAt,
    required DateTime updatedAt,
    this.lastOpenedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       title = Value(title),
       filePath = Value(filePath),
       fileHash = Value(fileHash),
       addedAt = Value(addedAt),
       updatedAt = Value(updatedAt);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? author,
    Expression<String>? publisher,
    Expression<String>? sourceLanguage,
    Expression<String>? isbn,
    Expression<String>? epubVersion,
    Expression<String>? filePath,
    Expression<String>? fileHash,
    Expression<int>? fileSizeBytes,
    Expression<String>? coverPath,
    Expression<String>? readingStatus,
    Expression<bool>? isFavorite,
    Expression<bool>? isArchived,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastOpenedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (author != null) 'author': author,
      if (publisher != null) 'publisher': publisher,
      if (sourceLanguage != null) 'source_language': sourceLanguage,
      if (isbn != null) 'isbn': isbn,
      if (epubVersion != null) 'epub_version': epubVersion,
      if (filePath != null) 'file_path': filePath,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (coverPath != null) 'cover_path': coverPath,
      if (readingStatus != null) 'reading_status': readingStatus,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isArchived != null) 'is_archived': isArchived,
      if (addedAt != null) 'added_at': addedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
    });
  }

  BooksCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<String?>? author,
    Value<String?>? publisher,
    Value<String?>? sourceLanguage,
    Value<String?>? isbn,
    Value<String?>? epubVersion,
    Value<String>? filePath,
    Value<String>? fileHash,
    Value<int?>? fileSizeBytes,
    Value<String?>? coverPath,
    Value<String>? readingStatus,
    Value<bool>? isFavorite,
    Value<bool>? isArchived,
    Value<DateTime>? addedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastOpenedAt,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      isbn: isbn ?? this.isbn,
      epubVersion: epubVersion ?? this.epubVersion,
      filePath: filePath ?? this.filePath,
      fileHash: fileHash ?? this.fileHash,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      coverPath: coverPath ?? this.coverPath,
      readingStatus: readingStatus ?? this.readingStatus,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (sourceLanguage.present) {
      map['source_language'] = Variable<String>(sourceLanguage.value);
    }
    if (isbn.present) {
      map['isbn'] = Variable<String>(isbn.value);
    }
    if (epubVersion.present) {
      map['epub_version'] = Variable<String>(epubVersion.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (readingStatus.present) {
      map['reading_status'] = Variable<String>(readingStatus.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('author: $author, ')
          ..write('publisher: $publisher, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('isbn: $isbn, ')
          ..write('epubVersion: $epubVersion, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('coverPath: $coverPath, ')
          ..write('readingStatus: $readingStatus, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isArchived: $isArchived, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES books(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _parentChapterIdMeta = const VerificationMeta(
    'parentChapterId',
  );
  @override
  late final GeneratedColumn<int> parentChapterId = GeneratedColumn<int>(
    'parent_chapter_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES chapters(id) ON DELETE SET NULL',
  );
  static const VerificationMeta _spineIndexMeta = const VerificationMeta(
    'spineIndex',
  );
  @override
  late final GeneratedColumn<int> spineIndex = GeneratedColumn<int>(
    'spine_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tocOrderMeta = const VerificationMeta(
    'tocOrder',
  );
  @override
  late final GeneratedColumn<int> tocOrder = GeneratedColumn<int>(
    'toc_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrefMeta = const VerificationMeta('href');
  @override
  late final GeneratedColumn<String> href = GeneratedColumn<String>(
    'href',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    bookId,
    parentChapterId,
    spineIndex,
    tocOrder,
    href,
    title,
    wordCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('parent_chapter_id')) {
      context.handle(
        _parentChapterIdMeta,
        parentChapterId.isAcceptableOrUnknown(
          data['parent_chapter_id']!,
          _parentChapterIdMeta,
        ),
      );
    }
    if (data.containsKey('spine_index')) {
      context.handle(
        _spineIndexMeta,
        spineIndex.isAcceptableOrUnknown(data['spine_index']!, _spineIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_spineIndexMeta);
    }
    if (data.containsKey('toc_order')) {
      context.handle(
        _tocOrderMeta,
        tocOrder.isAcceptableOrUnknown(data['toc_order']!, _tocOrderMeta),
      );
    }
    if (data.containsKey('href')) {
      context.handle(
        _hrefMeta,
        href.isAcceptableOrUnknown(data['href']!, _hrefMeta),
      );
    } else if (isInserting) {
      context.missing(_hrefMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {bookId, spineIndex},
  ];
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      parentChapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_chapter_id'],
      ),
      spineIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spine_index'],
      )!,
      tocOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}toc_order'],
      ),
      href: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}href'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      wordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_count'],
      ),
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final int id;
  final String uuid;
  final int bookId;
  final int? parentChapterId;
  final int spineIndex;
  final int? tocOrder;
  final String href;
  final String? title;
  final int? wordCount;
  const Chapter({
    required this.id,
    required this.uuid,
    required this.bookId,
    this.parentChapterId,
    required this.spineIndex,
    this.tocOrder,
    required this.href,
    this.title,
    this.wordCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['book_id'] = Variable<int>(bookId);
    if (!nullToAbsent || parentChapterId != null) {
      map['parent_chapter_id'] = Variable<int>(parentChapterId);
    }
    map['spine_index'] = Variable<int>(spineIndex);
    if (!nullToAbsent || tocOrder != null) {
      map['toc_order'] = Variable<int>(tocOrder);
    }
    map['href'] = Variable<String>(href);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || wordCount != null) {
      map['word_count'] = Variable<int>(wordCount);
    }
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      uuid: Value(uuid),
      bookId: Value(bookId),
      parentChapterId: parentChapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentChapterId),
      spineIndex: Value(spineIndex),
      tocOrder: tocOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(tocOrder),
      href: Value(href),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      wordCount: wordCount == null && nullToAbsent
          ? const Value.absent()
          : Value(wordCount),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      bookId: serializer.fromJson<int>(json['bookId']),
      parentChapterId: serializer.fromJson<int?>(json['parentChapterId']),
      spineIndex: serializer.fromJson<int>(json['spineIndex']),
      tocOrder: serializer.fromJson<int?>(json['tocOrder']),
      href: serializer.fromJson<String>(json['href']),
      title: serializer.fromJson<String?>(json['title']),
      wordCount: serializer.fromJson<int?>(json['wordCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'bookId': serializer.toJson<int>(bookId),
      'parentChapterId': serializer.toJson<int?>(parentChapterId),
      'spineIndex': serializer.toJson<int>(spineIndex),
      'tocOrder': serializer.toJson<int?>(tocOrder),
      'href': serializer.toJson<String>(href),
      'title': serializer.toJson<String?>(title),
      'wordCount': serializer.toJson<int?>(wordCount),
    };
  }

  Chapter copyWith({
    int? id,
    String? uuid,
    int? bookId,
    Value<int?> parentChapterId = const Value.absent(),
    int? spineIndex,
    Value<int?> tocOrder = const Value.absent(),
    String? href,
    Value<String?> title = const Value.absent(),
    Value<int?> wordCount = const Value.absent(),
  }) => Chapter(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    bookId: bookId ?? this.bookId,
    parentChapterId: parentChapterId.present
        ? parentChapterId.value
        : this.parentChapterId,
    spineIndex: spineIndex ?? this.spineIndex,
    tocOrder: tocOrder.present ? tocOrder.value : this.tocOrder,
    href: href ?? this.href,
    title: title.present ? title.value : this.title,
    wordCount: wordCount.present ? wordCount.value : this.wordCount,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      parentChapterId: data.parentChapterId.present
          ? data.parentChapterId.value
          : this.parentChapterId,
      spineIndex: data.spineIndex.present
          ? data.spineIndex.value
          : this.spineIndex,
      tocOrder: data.tocOrder.present ? data.tocOrder.value : this.tocOrder,
      href: data.href.present ? data.href.value : this.href,
      title: data.title.present ? data.title.value : this.title,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('bookId: $bookId, ')
          ..write('parentChapterId: $parentChapterId, ')
          ..write('spineIndex: $spineIndex, ')
          ..write('tocOrder: $tocOrder, ')
          ..write('href: $href, ')
          ..write('title: $title, ')
          ..write('wordCount: $wordCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    bookId,
    parentChapterId,
    spineIndex,
    tocOrder,
    href,
    title,
    wordCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.bookId == this.bookId &&
          other.parentChapterId == this.parentChapterId &&
          other.spineIndex == this.spineIndex &&
          other.tocOrder == this.tocOrder &&
          other.href == this.href &&
          other.title == this.title &&
          other.wordCount == this.wordCount);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> bookId;
  final Value<int?> parentChapterId;
  final Value<int> spineIndex;
  final Value<int?> tocOrder;
  final Value<String> href;
  final Value<String?> title;
  final Value<int?> wordCount;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.bookId = const Value.absent(),
    this.parentChapterId = const Value.absent(),
    this.spineIndex = const Value.absent(),
    this.tocOrder = const Value.absent(),
    this.href = const Value.absent(),
    this.title = const Value.absent(),
    this.wordCount = const Value.absent(),
  });
  ChaptersCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int bookId,
    this.parentChapterId = const Value.absent(),
    required int spineIndex,
    this.tocOrder = const Value.absent(),
    required String href,
    this.title = const Value.absent(),
    this.wordCount = const Value.absent(),
  }) : uuid = Value(uuid),
       bookId = Value(bookId),
       spineIndex = Value(spineIndex),
       href = Value(href);
  static Insertable<Chapter> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? bookId,
    Expression<int>? parentChapterId,
    Expression<int>? spineIndex,
    Expression<int>? tocOrder,
    Expression<String>? href,
    Expression<String>? title,
    Expression<int>? wordCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (bookId != null) 'book_id': bookId,
      if (parentChapterId != null) 'parent_chapter_id': parentChapterId,
      if (spineIndex != null) 'spine_index': spineIndex,
      if (tocOrder != null) 'toc_order': tocOrder,
      if (href != null) 'href': href,
      if (title != null) 'title': title,
      if (wordCount != null) 'word_count': wordCount,
    });
  }

  ChaptersCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? bookId,
    Value<int?>? parentChapterId,
    Value<int>? spineIndex,
    Value<int?>? tocOrder,
    Value<String>? href,
    Value<String?>? title,
    Value<int?>? wordCount,
  }) {
    return ChaptersCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      bookId: bookId ?? this.bookId,
      parentChapterId: parentChapterId ?? this.parentChapterId,
      spineIndex: spineIndex ?? this.spineIndex,
      tocOrder: tocOrder ?? this.tocOrder,
      href: href ?? this.href,
      title: title ?? this.title,
      wordCount: wordCount ?? this.wordCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (parentChapterId.present) {
      map['parent_chapter_id'] = Variable<int>(parentChapterId.value);
    }
    if (spineIndex.present) {
      map['spine_index'] = Variable<int>(spineIndex.value);
    }
    if (tocOrder.present) {
      map['toc_order'] = Variable<int>(tocOrder.value);
    }
    if (href.present) {
      map['href'] = Variable<String>(href.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('bookId: $bookId, ')
          ..write('parentChapterId: $parentChapterId, ')
          ..write('spineIndex: $spineIndex, ')
          ..write('tocOrder: $tocOrder, ')
          ..write('href: $href, ')
          ..write('title: $title, ')
          ..write('wordCount: $wordCount')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressTable extends ReadingProgress
    with TableInfo<$ReadingProgressTable, ReadingProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL UNIQUE REFERENCES books(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES chapters(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _cfiMeta = const VerificationMeta('cfi');
  @override
  late final GeneratedColumn<String> cfi = GeneratedColumn<String>(
    'cfi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scrollPctMeta = const VerificationMeta(
    'scrollPct',
  );
  @override
  late final GeneratedColumn<double> scrollPct = GeneratedColumn<double>(
    'scroll_pct',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    chapterId,
    cfi,
    scrollPct,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('cfi')) {
      context.handle(
        _cfiMeta,
        cfi.isAcceptableOrUnknown(data['cfi']!, _cfiMeta),
      );
    }
    if (data.containsKey('scroll_pct')) {
      context.handle(
        _scrollPctMeta,
        scrollPct.isAcceptableOrUnknown(data['scroll_pct']!, _scrollPctMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_id'],
      )!,
      cfi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cfi'],
      ),
      scrollPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scroll_pct'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingProgressTable createAlias(String alias) {
    return $ReadingProgressTable(attachedDatabase, alias);
  }
}

class ReadingProgressData extends DataClass
    implements Insertable<ReadingProgressData> {
  final int id;
  final int bookId;
  final int chapterId;
  final String? cfi;
  final double scrollPct;
  final DateTime updatedAt;
  const ReadingProgressData({
    required this.id,
    required this.bookId,
    required this.chapterId,
    this.cfi,
    required this.scrollPct,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['chapter_id'] = Variable<int>(chapterId);
    if (!nullToAbsent || cfi != null) {
      map['cfi'] = Variable<String>(cfi);
    }
    map['scroll_pct'] = Variable<double>(scrollPct);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReadingProgressCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      cfi: cfi == null && nullToAbsent ? const Value.absent() : Value(cfi),
      scrollPct: Value(scrollPct),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressData(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapterId: serializer.fromJson<int>(json['chapterId']),
      cfi: serializer.fromJson<String?>(json['cfi']),
      scrollPct: serializer.fromJson<double>(json['scrollPct']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'chapterId': serializer.toJson<int>(chapterId),
      'cfi': serializer.toJson<String?>(cfi),
      'scrollPct': serializer.toJson<double>(scrollPct),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReadingProgressData copyWith({
    int? id,
    int? bookId,
    int? chapterId,
    Value<String?> cfi = const Value.absent(),
    double? scrollPct,
    DateTime? updatedAt,
  }) => ReadingProgressData(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    chapterId: chapterId ?? this.chapterId,
    cfi: cfi.present ? cfi.value : this.cfi,
    scrollPct: scrollPct ?? this.scrollPct,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingProgressData copyWithCompanion(ReadingProgressCompanion data) {
    return ReadingProgressData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      cfi: data.cfi.present ? data.cfi.value : this.cfi,
      scrollPct: data.scrollPct.present ? data.scrollPct.value : this.scrollPct,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('cfi: $cfi, ')
          ..write('scrollPct: $scrollPct, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, chapterId, cfi, scrollPct, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.cfi == this.cfi &&
          other.scrollPct == this.scrollPct &&
          other.updatedAt == this.updatedAt);
}

class ReadingProgressCompanion extends UpdateCompanion<ReadingProgressData> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<int> chapterId;
  final Value<String?> cfi;
  final Value<double> scrollPct;
  final Value<DateTime> updatedAt;
  const ReadingProgressCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.cfi = const Value.absent(),
    this.scrollPct = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReadingProgressCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required int chapterId,
    this.cfi = const Value.absent(),
    this.scrollPct = const Value.absent(),
    required DateTime updatedAt,
  }) : bookId = Value(bookId),
       chapterId = Value(chapterId),
       updatedAt = Value(updatedAt);
  static Insertable<ReadingProgressData> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<int>? chapterId,
    Expression<String>? cfi,
    Expression<double>? scrollPct,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (cfi != null) 'cfi': cfi,
      if (scrollPct != null) 'scroll_pct': scrollPct,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReadingProgressCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<int>? chapterId,
    Value<String?>? cfi,
    Value<double>? scrollPct,
    Value<DateTime>? updatedAt,
  }) {
    return ReadingProgressCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      cfi: cfi ?? this.cfi,
      scrollPct: scrollPct ?? this.scrollPct,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (cfi.present) {
      map['cfi'] = Variable<String>(cfi.value);
    }
    if (scrollPct.present) {
      map['scroll_pct'] = Variable<double>(scrollPct.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('cfi: $cfi, ')
          ..write('scrollPct: $scrollPct, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES books(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES chapters(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _cfiMeta = const VerificationMeta('cfi');
  @override
  late final GeneratedColumn<String> cfi = GeneratedColumn<String>(
    'cfi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    bookId,
    chapterId,
    cfi,
    label,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('cfi')) {
      context.handle(
        _cfiMeta,
        cfi.isAcceptableOrUnknown(data['cfi']!, _cfiMeta),
      );
    } else if (isInserting) {
      context.missing(_cfiMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_id'],
      )!,
      cfi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cfi'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final int id;
  final String uuid;
  final int bookId;
  final int chapterId;
  final String cfi;
  final String? label;
  final String? note;
  final DateTime createdAt;
  const Bookmark({
    required this.id,
    required this.uuid,
    required this.bookId,
    required this.chapterId,
    required this.cfi,
    this.label,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['book_id'] = Variable<int>(bookId);
    map['chapter_id'] = Variable<int>(chapterId);
    map['cfi'] = Variable<String>(cfi);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      uuid: Value(uuid),
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      cfi: Value(cfi),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapterId: serializer.fromJson<int>(json['chapterId']),
      cfi: serializer.fromJson<String>(json['cfi']),
      label: serializer.fromJson<String?>(json['label']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'bookId': serializer.toJson<int>(bookId),
      'chapterId': serializer.toJson<int>(chapterId),
      'cfi': serializer.toJson<String>(cfi),
      'label': serializer.toJson<String?>(label),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bookmark copyWith({
    int? id,
    String? uuid,
    int? bookId,
    int? chapterId,
    String? cfi,
    Value<String?> label = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Bookmark(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    bookId: bookId ?? this.bookId,
    chapterId: chapterId ?? this.chapterId,
    cfi: cfi ?? this.cfi,
    label: label.present ? label.value : this.label,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      cfi: data.cfi.present ? data.cfi.value : this.cfi,
      label: data.label.present ? data.label.value : this.label,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('cfi: $cfi, ')
          ..write('label: $label, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, bookId, chapterId, cfi, label, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.cfi == this.cfi &&
          other.label == this.label &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> bookId;
  final Value<int> chapterId;
  final Value<String> cfi;
  final Value<String?> label;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.cfi = const Value.absent(),
    this.label = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int bookId,
    required int chapterId,
    required String cfi,
    this.label = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
  }) : uuid = Value(uuid),
       bookId = Value(bookId),
       chapterId = Value(chapterId),
       cfi = Value(cfi),
       createdAt = Value(createdAt);
  static Insertable<Bookmark> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? bookId,
    Expression<int>? chapterId,
    Expression<String>? cfi,
    Expression<String>? label,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (cfi != null) 'cfi': cfi,
      if (label != null) 'label': label,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BookmarksCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? bookId,
    Value<int>? chapterId,
    Value<String>? cfi,
    Value<String?>? label,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      cfi: cfi ?? this.cfi,
      label: label ?? this.label,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (cfi.present) {
      map['cfi'] = Variable<String>(cfi.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('cfi: $cfi, ')
          ..write('label: $label, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TranslationUnitsTable extends TranslationUnits
    with TableInfo<$TranslationUnitsTable, TranslationUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES chapters(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _nodePathMeta = const VerificationMeta(
    'nodePath',
  );
  @override
  late final GeneratedColumn<String> nodePath = GeneratedColumn<String>(
    'node_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sequenceIndexMeta = const VerificationMeta(
    'sequenceIndex',
  );
  @override
  late final GeneratedColumn<int> sequenceIndex = GeneratedColumn<int>(
    'sequence_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTextHashMeta = const VerificationMeta(
    'sourceTextHash',
  );
  @override
  late final GeneratedColumn<String> sourceTextHash = GeneratedColumn<String>(
    'source_text_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    nodePath,
    sequenceIndex,
    sourceTextHash,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translation_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<TranslationUnit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('node_path')) {
      context.handle(
        _nodePathMeta,
        nodePath.isAcceptableOrUnknown(data['node_path']!, _nodePathMeta),
      );
    } else if (isInserting) {
      context.missing(_nodePathMeta);
    }
    if (data.containsKey('sequence_index')) {
      context.handle(
        _sequenceIndexMeta,
        sequenceIndex.isAcceptableOrUnknown(
          data['sequence_index']!,
          _sequenceIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sequenceIndexMeta);
    }
    if (data.containsKey('source_text_hash')) {
      context.handle(
        _sourceTextHashMeta,
        sourceTextHash.isAcceptableOrUnknown(
          data['source_text_hash']!,
          _sourceTextHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceTextHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {chapterId, nodePath},
  ];
  @override
  TranslationUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranslationUnit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_id'],
      )!,
      nodePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_path'],
      )!,
      sequenceIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_index'],
      )!,
      sourceTextHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_text_hash'],
      )!,
    );
  }

  @override
  $TranslationUnitsTable createAlias(String alias) {
    return $TranslationUnitsTable(attachedDatabase, alias);
  }
}

class TranslationUnit extends DataClass implements Insertable<TranslationUnit> {
  final int id;
  final int chapterId;
  final String nodePath;
  final int sequenceIndex;
  final String sourceTextHash;
  const TranslationUnit({
    required this.id,
    required this.chapterId,
    required this.nodePath,
    required this.sequenceIndex,
    required this.sourceTextHash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chapter_id'] = Variable<int>(chapterId);
    map['node_path'] = Variable<String>(nodePath);
    map['sequence_index'] = Variable<int>(sequenceIndex);
    map['source_text_hash'] = Variable<String>(sourceTextHash);
    return map;
  }

  TranslationUnitsCompanion toCompanion(bool nullToAbsent) {
    return TranslationUnitsCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      nodePath: Value(nodePath),
      sequenceIndex: Value(sequenceIndex),
      sourceTextHash: Value(sourceTextHash),
    );
  }

  factory TranslationUnit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranslationUnit(
      id: serializer.fromJson<int>(json['id']),
      chapterId: serializer.fromJson<int>(json['chapterId']),
      nodePath: serializer.fromJson<String>(json['nodePath']),
      sequenceIndex: serializer.fromJson<int>(json['sequenceIndex']),
      sourceTextHash: serializer.fromJson<String>(json['sourceTextHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chapterId': serializer.toJson<int>(chapterId),
      'nodePath': serializer.toJson<String>(nodePath),
      'sequenceIndex': serializer.toJson<int>(sequenceIndex),
      'sourceTextHash': serializer.toJson<String>(sourceTextHash),
    };
  }

  TranslationUnit copyWith({
    int? id,
    int? chapterId,
    String? nodePath,
    int? sequenceIndex,
    String? sourceTextHash,
  }) => TranslationUnit(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    nodePath: nodePath ?? this.nodePath,
    sequenceIndex: sequenceIndex ?? this.sequenceIndex,
    sourceTextHash: sourceTextHash ?? this.sourceTextHash,
  );
  TranslationUnit copyWithCompanion(TranslationUnitsCompanion data) {
    return TranslationUnit(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      nodePath: data.nodePath.present ? data.nodePath.value : this.nodePath,
      sequenceIndex: data.sequenceIndex.present
          ? data.sequenceIndex.value
          : this.sequenceIndex,
      sourceTextHash: data.sourceTextHash.present
          ? data.sourceTextHash.value
          : this.sourceTextHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranslationUnit(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('nodePath: $nodePath, ')
          ..write('sequenceIndex: $sequenceIndex, ')
          ..write('sourceTextHash: $sourceTextHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chapterId, nodePath, sequenceIndex, sourceTextHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranslationUnit &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.nodePath == this.nodePath &&
          other.sequenceIndex == this.sequenceIndex &&
          other.sourceTextHash == this.sourceTextHash);
}

class TranslationUnitsCompanion extends UpdateCompanion<TranslationUnit> {
  final Value<int> id;
  final Value<int> chapterId;
  final Value<String> nodePath;
  final Value<int> sequenceIndex;
  final Value<String> sourceTextHash;
  const TranslationUnitsCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.nodePath = const Value.absent(),
    this.sequenceIndex = const Value.absent(),
    this.sourceTextHash = const Value.absent(),
  });
  TranslationUnitsCompanion.insert({
    this.id = const Value.absent(),
    required int chapterId,
    required String nodePath,
    required int sequenceIndex,
    required String sourceTextHash,
  }) : chapterId = Value(chapterId),
       nodePath = Value(nodePath),
       sequenceIndex = Value(sequenceIndex),
       sourceTextHash = Value(sourceTextHash);
  static Insertable<TranslationUnit> custom({
    Expression<int>? id,
    Expression<int>? chapterId,
    Expression<String>? nodePath,
    Expression<int>? sequenceIndex,
    Expression<String>? sourceTextHash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (nodePath != null) 'node_path': nodePath,
      if (sequenceIndex != null) 'sequence_index': sequenceIndex,
      if (sourceTextHash != null) 'source_text_hash': sourceTextHash,
    });
  }

  TranslationUnitsCompanion copyWith({
    Value<int>? id,
    Value<int>? chapterId,
    Value<String>? nodePath,
    Value<int>? sequenceIndex,
    Value<String>? sourceTextHash,
  }) {
    return TranslationUnitsCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      nodePath: nodePath ?? this.nodePath,
      sequenceIndex: sequenceIndex ?? this.sequenceIndex,
      sourceTextHash: sourceTextHash ?? this.sourceTextHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (nodePath.present) {
      map['node_path'] = Variable<String>(nodePath.value);
    }
    if (sequenceIndex.present) {
      map['sequence_index'] = Variable<int>(sequenceIndex.value);
    }
    if (sourceTextHash.present) {
      map['source_text_hash'] = Variable<String>(sourceTextHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationUnitsCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('nodePath: $nodePath, ')
          ..write('sequenceIndex: $sequenceIndex, ')
          ..write('sourceTextHash: $sourceTextHash')
          ..write(')'))
        .toString();
  }
}

class $HighlightsTable extends Highlights
    with TableInfo<$HighlightsTable, Highlight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES books(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES chapters(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _translationUnitIdMeta = const VerificationMeta(
    'translationUnitId',
  );
  @override
  late final GeneratedColumn<int> translationUnitId = GeneratedColumn<int>(
    'translation_unit_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES translation_units(id) ON DELETE SET NULL',
  );
  static const VerificationMeta _startAnchorMeta = const VerificationMeta(
    'startAnchor',
  );
  @override
  late final GeneratedColumn<String> startAnchor = GeneratedColumn<String>(
    'start_anchor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAnchorMeta = const VerificationMeta(
    'endAnchor',
  );
  @override
  late final GeneratedColumn<String> endAnchor = GeneratedColumn<String>(
    'end_anchor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('yellow'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    bookId,
    chapterId,
    translationUnitId,
    startAnchor,
    endAnchor,
    color,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'highlights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Highlight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('translation_unit_id')) {
      context.handle(
        _translationUnitIdMeta,
        translationUnitId.isAcceptableOrUnknown(
          data['translation_unit_id']!,
          _translationUnitIdMeta,
        ),
      );
    }
    if (data.containsKey('start_anchor')) {
      context.handle(
        _startAnchorMeta,
        startAnchor.isAcceptableOrUnknown(
          data['start_anchor']!,
          _startAnchorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startAnchorMeta);
    }
    if (data.containsKey('end_anchor')) {
      context.handle(
        _endAnchorMeta,
        endAnchor.isAcceptableOrUnknown(data['end_anchor']!, _endAnchorMeta),
      );
    } else if (isInserting) {
      context.missing(_endAnchorMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Highlight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Highlight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_id'],
      )!,
      translationUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}translation_unit_id'],
      ),
      startAnchor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_anchor'],
      )!,
      endAnchor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_anchor'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HighlightsTable createAlias(String alias) {
    return $HighlightsTable(attachedDatabase, alias);
  }
}

class Highlight extends DataClass implements Insertable<Highlight> {
  final int id;
  final String uuid;
  final int bookId;
  final int chapterId;
  final int? translationUnitId;
  final String startAnchor;
  final String endAnchor;
  final String color;
  final String? note;
  final DateTime createdAt;
  const Highlight({
    required this.id,
    required this.uuid,
    required this.bookId,
    required this.chapterId,
    this.translationUnitId,
    required this.startAnchor,
    required this.endAnchor,
    required this.color,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['book_id'] = Variable<int>(bookId);
    map['chapter_id'] = Variable<int>(chapterId);
    if (!nullToAbsent || translationUnitId != null) {
      map['translation_unit_id'] = Variable<int>(translationUnitId);
    }
    map['start_anchor'] = Variable<String>(startAnchor);
    map['end_anchor'] = Variable<String>(endAnchor);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HighlightsCompanion toCompanion(bool nullToAbsent) {
    return HighlightsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      translationUnitId: translationUnitId == null && nullToAbsent
          ? const Value.absent()
          : Value(translationUnitId),
      startAnchor: Value(startAnchor),
      endAnchor: Value(endAnchor),
      color: Value(color),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Highlight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Highlight(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapterId: serializer.fromJson<int>(json['chapterId']),
      translationUnitId: serializer.fromJson<int?>(json['translationUnitId']),
      startAnchor: serializer.fromJson<String>(json['startAnchor']),
      endAnchor: serializer.fromJson<String>(json['endAnchor']),
      color: serializer.fromJson<String>(json['color']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'bookId': serializer.toJson<int>(bookId),
      'chapterId': serializer.toJson<int>(chapterId),
      'translationUnitId': serializer.toJson<int?>(translationUnitId),
      'startAnchor': serializer.toJson<String>(startAnchor),
      'endAnchor': serializer.toJson<String>(endAnchor),
      'color': serializer.toJson<String>(color),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Highlight copyWith({
    int? id,
    String? uuid,
    int? bookId,
    int? chapterId,
    Value<int?> translationUnitId = const Value.absent(),
    String? startAnchor,
    String? endAnchor,
    String? color,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Highlight(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    bookId: bookId ?? this.bookId,
    chapterId: chapterId ?? this.chapterId,
    translationUnitId: translationUnitId.present
        ? translationUnitId.value
        : this.translationUnitId,
    startAnchor: startAnchor ?? this.startAnchor,
    endAnchor: endAnchor ?? this.endAnchor,
    color: color ?? this.color,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Highlight copyWithCompanion(HighlightsCompanion data) {
    return Highlight(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      translationUnitId: data.translationUnitId.present
          ? data.translationUnitId.value
          : this.translationUnitId,
      startAnchor: data.startAnchor.present
          ? data.startAnchor.value
          : this.startAnchor,
      endAnchor: data.endAnchor.present ? data.endAnchor.value : this.endAnchor,
      color: data.color.present ? data.color.value : this.color,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Highlight(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('translationUnitId: $translationUnitId, ')
          ..write('startAnchor: $startAnchor, ')
          ..write('endAnchor: $endAnchor, ')
          ..write('color: $color, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    bookId,
    chapterId,
    translationUnitId,
    startAnchor,
    endAnchor,
    color,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Highlight &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.translationUnitId == this.translationUnitId &&
          other.startAnchor == this.startAnchor &&
          other.endAnchor == this.endAnchor &&
          other.color == this.color &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class HighlightsCompanion extends UpdateCompanion<Highlight> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> bookId;
  final Value<int> chapterId;
  final Value<int?> translationUnitId;
  final Value<String> startAnchor;
  final Value<String> endAnchor;
  final Value<String> color;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const HighlightsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.translationUnitId = const Value.absent(),
    this.startAnchor = const Value.absent(),
    this.endAnchor = const Value.absent(),
    this.color = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HighlightsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int bookId,
    required int chapterId,
    this.translationUnitId = const Value.absent(),
    required String startAnchor,
    required String endAnchor,
    this.color = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
  }) : uuid = Value(uuid),
       bookId = Value(bookId),
       chapterId = Value(chapterId),
       startAnchor = Value(startAnchor),
       endAnchor = Value(endAnchor),
       createdAt = Value(createdAt);
  static Insertable<Highlight> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? bookId,
    Expression<int>? chapterId,
    Expression<int>? translationUnitId,
    Expression<String>? startAnchor,
    Expression<String>? endAnchor,
    Expression<String>? color,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (translationUnitId != null) 'translation_unit_id': translationUnitId,
      if (startAnchor != null) 'start_anchor': startAnchor,
      if (endAnchor != null) 'end_anchor': endAnchor,
      if (color != null) 'color': color,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HighlightsCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? bookId,
    Value<int>? chapterId,
    Value<int?>? translationUnitId,
    Value<String>? startAnchor,
    Value<String>? endAnchor,
    Value<String>? color,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return HighlightsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      translationUnitId: translationUnitId ?? this.translationUnitId,
      startAnchor: startAnchor ?? this.startAnchor,
      endAnchor: endAnchor ?? this.endAnchor,
      color: color ?? this.color,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (translationUnitId.present) {
      map['translation_unit_id'] = Variable<int>(translationUnitId.value);
    }
    if (startAnchor.present) {
      map['start_anchor'] = Variable<String>(startAnchor.value);
    }
    if (endAnchor.present) {
      map['end_anchor'] = Variable<String>(endAnchor.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighlightsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('translationUnitId: $translationUnitId, ')
          ..write('startAnchor: $startAnchor, ')
          ..write('endAnchor: $endAnchor, ')
          ..write('color: $color, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TranslationCacheTable extends TranslationCache
    with TableInfo<$TranslationCacheTable, TranslationCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceLanguageMeta = const VerificationMeta(
    'sourceLanguage',
  );
  @override
  late final GeneratedColumn<String> sourceLanguage = GeneratedColumn<String>(
    'source_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetLanguageMeta = const VerificationMeta(
    'targetLanguage',
  );
  @override
  late final GeneratedColumn<String> targetLanguage = GeneratedColumn<String>(
    'target_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTextMeta = const VerificationMeta(
    'sourceText',
  );
  @override
  late final GeneratedColumn<String> sourceText = GeneratedColumn<String>(
    'source_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTextHashMeta = const VerificationMeta(
    'sourceTextHash',
  );
  @override
  late final GeneratedColumn<String> sourceTextHash = GeneratedColumn<String>(
    'source_text_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translatedTextMeta = const VerificationMeta(
    'translatedText',
  );
  @override
  late final GeneratedColumn<String> translatedText = GeneratedColumn<String>(
    'translated_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerVersionMeta = const VerificationMeta(
    'providerVersion',
  );
  @override
  late final GeneratedColumn<String> providerVersion = GeneratedColumn<String>(
    'provider_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _styleMeta = const VerificationMeta('style');
  @override
  late final GeneratedColumn<String> style = GeneratedColumn<String>(
    'style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('natural'),
  );
  static const VerificationMeta _hitCountMeta = const VerificationMeta(
    'hitCount',
  );
  @override
  late final GeneratedColumn<int> hitCount = GeneratedColumn<int>(
    'hit_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceLanguage,
    targetLanguage,
    sourceText,
    sourceTextHash,
    translatedText,
    provider,
    providerVersion,
    style,
    hitCount,
    createdAt,
    lastUsedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translation_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<TranslationCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_language')) {
      context.handle(
        _sourceLanguageMeta,
        sourceLanguage.isAcceptableOrUnknown(
          data['source_language']!,
          _sourceLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceLanguageMeta);
    }
    if (data.containsKey('target_language')) {
      context.handle(
        _targetLanguageMeta,
        targetLanguage.isAcceptableOrUnknown(
          data['target_language']!,
          _targetLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetLanguageMeta);
    }
    if (data.containsKey('source_text')) {
      context.handle(
        _sourceTextMeta,
        sourceText.isAcceptableOrUnknown(data['source_text']!, _sourceTextMeta),
      );
    }
    if (data.containsKey('source_text_hash')) {
      context.handle(
        _sourceTextHashMeta,
        sourceTextHash.isAcceptableOrUnknown(
          data['source_text_hash']!,
          _sourceTextHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceTextHashMeta);
    }
    if (data.containsKey('translated_text')) {
      context.handle(
        _translatedTextMeta,
        translatedText.isAcceptableOrUnknown(
          data['translated_text']!,
          _translatedTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translatedTextMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('provider_version')) {
      context.handle(
        _providerVersionMeta,
        providerVersion.isAcceptableOrUnknown(
          data['provider_version']!,
          _providerVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerVersionMeta);
    }
    if (data.containsKey('style')) {
      context.handle(
        _styleMeta,
        style.isAcceptableOrUnknown(data['style']!, _styleMeta),
      );
    }
    if (data.containsKey('hit_count')) {
      context.handle(
        _hitCountMeta,
        hitCount.isAcceptableOrUnknown(data['hit_count']!, _hitCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUsedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {
      sourceTextHash,
      sourceLanguage,
      targetLanguage,
      provider,
      providerVersion,
      style,
    },
  ];
  @override
  TranslationCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranslationCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_language'],
      )!,
      targetLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_language'],
      )!,
      sourceText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_text'],
      ),
      sourceTextHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_text_hash'],
      )!,
      translatedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translated_text'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      providerVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_version'],
      )!,
      style: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}style'],
      )!,
      hitCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hit_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      )!,
    );
  }

  @override
  $TranslationCacheTable createAlias(String alias) {
    return $TranslationCacheTable(attachedDatabase, alias);
  }
}

class TranslationCacheData extends DataClass
    implements Insertable<TranslationCacheData> {
  final int id;
  final String sourceLanguage;
  final String targetLanguage;
  final String? sourceText;
  final String sourceTextHash;
  final String translatedText;
  final String provider;
  final String providerVersion;
  final String style;
  final int hitCount;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  const TranslationCacheData({
    required this.id,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.sourceText,
    required this.sourceTextHash,
    required this.translatedText,
    required this.provider,
    required this.providerVersion,
    required this.style,
    required this.hitCount,
    required this.createdAt,
    required this.lastUsedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_language'] = Variable<String>(sourceLanguage);
    map['target_language'] = Variable<String>(targetLanguage);
    if (!nullToAbsent || sourceText != null) {
      map['source_text'] = Variable<String>(sourceText);
    }
    map['source_text_hash'] = Variable<String>(sourceTextHash);
    map['translated_text'] = Variable<String>(translatedText);
    map['provider'] = Variable<String>(provider);
    map['provider_version'] = Variable<String>(providerVersion);
    map['style'] = Variable<String>(style);
    map['hit_count'] = Variable<int>(hitCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    return map;
  }

  TranslationCacheCompanion toCompanion(bool nullToAbsent) {
    return TranslationCacheCompanion(
      id: Value(id),
      sourceLanguage: Value(sourceLanguage),
      targetLanguage: Value(targetLanguage),
      sourceText: sourceText == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceText),
      sourceTextHash: Value(sourceTextHash),
      translatedText: Value(translatedText),
      provider: Value(provider),
      providerVersion: Value(providerVersion),
      style: Value(style),
      hitCount: Value(hitCount),
      createdAt: Value(createdAt),
      lastUsedAt: Value(lastUsedAt),
    );
  }

  factory TranslationCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranslationCacheData(
      id: serializer.fromJson<int>(json['id']),
      sourceLanguage: serializer.fromJson<String>(json['sourceLanguage']),
      targetLanguage: serializer.fromJson<String>(json['targetLanguage']),
      sourceText: serializer.fromJson<String?>(json['sourceText']),
      sourceTextHash: serializer.fromJson<String>(json['sourceTextHash']),
      translatedText: serializer.fromJson<String>(json['translatedText']),
      provider: serializer.fromJson<String>(json['provider']),
      providerVersion: serializer.fromJson<String>(json['providerVersion']),
      style: serializer.fromJson<String>(json['style']),
      hitCount: serializer.fromJson<int>(json['hitCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUsedAt: serializer.fromJson<DateTime>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceLanguage': serializer.toJson<String>(sourceLanguage),
      'targetLanguage': serializer.toJson<String>(targetLanguage),
      'sourceText': serializer.toJson<String?>(sourceText),
      'sourceTextHash': serializer.toJson<String>(sourceTextHash),
      'translatedText': serializer.toJson<String>(translatedText),
      'provider': serializer.toJson<String>(provider),
      'providerVersion': serializer.toJson<String>(providerVersion),
      'style': serializer.toJson<String>(style),
      'hitCount': serializer.toJson<int>(hitCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUsedAt': serializer.toJson<DateTime>(lastUsedAt),
    };
  }

  TranslationCacheData copyWith({
    int? id,
    String? sourceLanguage,
    String? targetLanguage,
    Value<String?> sourceText = const Value.absent(),
    String? sourceTextHash,
    String? translatedText,
    String? provider,
    String? providerVersion,
    String? style,
    int? hitCount,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) => TranslationCacheData(
    id: id ?? this.id,
    sourceLanguage: sourceLanguage ?? this.sourceLanguage,
    targetLanguage: targetLanguage ?? this.targetLanguage,
    sourceText: sourceText.present ? sourceText.value : this.sourceText,
    sourceTextHash: sourceTextHash ?? this.sourceTextHash,
    translatedText: translatedText ?? this.translatedText,
    provider: provider ?? this.provider,
    providerVersion: providerVersion ?? this.providerVersion,
    style: style ?? this.style,
    hitCount: hitCount ?? this.hitCount,
    createdAt: createdAt ?? this.createdAt,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
  );
  TranslationCacheData copyWithCompanion(TranslationCacheCompanion data) {
    return TranslationCacheData(
      id: data.id.present ? data.id.value : this.id,
      sourceLanguage: data.sourceLanguage.present
          ? data.sourceLanguage.value
          : this.sourceLanguage,
      targetLanguage: data.targetLanguage.present
          ? data.targetLanguage.value
          : this.targetLanguage,
      sourceText: data.sourceText.present
          ? data.sourceText.value
          : this.sourceText,
      sourceTextHash: data.sourceTextHash.present
          ? data.sourceTextHash.value
          : this.sourceTextHash,
      translatedText: data.translatedText.present
          ? data.translatedText.value
          : this.translatedText,
      provider: data.provider.present ? data.provider.value : this.provider,
      providerVersion: data.providerVersion.present
          ? data.providerVersion.value
          : this.providerVersion,
      style: data.style.present ? data.style.value : this.style,
      hitCount: data.hitCount.present ? data.hitCount.value : this.hitCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranslationCacheData(')
          ..write('id: $id, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('sourceText: $sourceText, ')
          ..write('sourceTextHash: $sourceTextHash, ')
          ..write('translatedText: $translatedText, ')
          ..write('provider: $provider, ')
          ..write('providerVersion: $providerVersion, ')
          ..write('style: $style, ')
          ..write('hitCount: $hitCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceLanguage,
    targetLanguage,
    sourceText,
    sourceTextHash,
    translatedText,
    provider,
    providerVersion,
    style,
    hitCount,
    createdAt,
    lastUsedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranslationCacheData &&
          other.id == this.id &&
          other.sourceLanguage == this.sourceLanguage &&
          other.targetLanguage == this.targetLanguage &&
          other.sourceText == this.sourceText &&
          other.sourceTextHash == this.sourceTextHash &&
          other.translatedText == this.translatedText &&
          other.provider == this.provider &&
          other.providerVersion == this.providerVersion &&
          other.style == this.style &&
          other.hitCount == this.hitCount &&
          other.createdAt == this.createdAt &&
          other.lastUsedAt == this.lastUsedAt);
}

class TranslationCacheCompanion extends UpdateCompanion<TranslationCacheData> {
  final Value<int> id;
  final Value<String> sourceLanguage;
  final Value<String> targetLanguage;
  final Value<String?> sourceText;
  final Value<String> sourceTextHash;
  final Value<String> translatedText;
  final Value<String> provider;
  final Value<String> providerVersion;
  final Value<String> style;
  final Value<int> hitCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUsedAt;
  const TranslationCacheCompanion({
    this.id = const Value.absent(),
    this.sourceLanguage = const Value.absent(),
    this.targetLanguage = const Value.absent(),
    this.sourceText = const Value.absent(),
    this.sourceTextHash = const Value.absent(),
    this.translatedText = const Value.absent(),
    this.provider = const Value.absent(),
    this.providerVersion = const Value.absent(),
    this.style = const Value.absent(),
    this.hitCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  });
  TranslationCacheCompanion.insert({
    this.id = const Value.absent(),
    required String sourceLanguage,
    required String targetLanguage,
    this.sourceText = const Value.absent(),
    required String sourceTextHash,
    required String translatedText,
    required String provider,
    required String providerVersion,
    this.style = const Value.absent(),
    this.hitCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastUsedAt,
  }) : sourceLanguage = Value(sourceLanguage),
       targetLanguage = Value(targetLanguage),
       sourceTextHash = Value(sourceTextHash),
       translatedText = Value(translatedText),
       provider = Value(provider),
       providerVersion = Value(providerVersion),
       createdAt = Value(createdAt),
       lastUsedAt = Value(lastUsedAt);
  static Insertable<TranslationCacheData> custom({
    Expression<int>? id,
    Expression<String>? sourceLanguage,
    Expression<String>? targetLanguage,
    Expression<String>? sourceText,
    Expression<String>? sourceTextHash,
    Expression<String>? translatedText,
    Expression<String>? provider,
    Expression<String>? providerVersion,
    Expression<String>? style,
    Expression<int>? hitCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUsedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceLanguage != null) 'source_language': sourceLanguage,
      if (targetLanguage != null) 'target_language': targetLanguage,
      if (sourceText != null) 'source_text': sourceText,
      if (sourceTextHash != null) 'source_text_hash': sourceTextHash,
      if (translatedText != null) 'translated_text': translatedText,
      if (provider != null) 'provider': provider,
      if (providerVersion != null) 'provider_version': providerVersion,
      if (style != null) 'style': style,
      if (hitCount != null) 'hit_count': hitCount,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
    });
  }

  TranslationCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? sourceLanguage,
    Value<String>? targetLanguage,
    Value<String?>? sourceText,
    Value<String>? sourceTextHash,
    Value<String>? translatedText,
    Value<String>? provider,
    Value<String>? providerVersion,
    Value<String>? style,
    Value<int>? hitCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastUsedAt,
  }) {
    return TranslationCacheCompanion(
      id: id ?? this.id,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      sourceText: sourceText ?? this.sourceText,
      sourceTextHash: sourceTextHash ?? this.sourceTextHash,
      translatedText: translatedText ?? this.translatedText,
      provider: provider ?? this.provider,
      providerVersion: providerVersion ?? this.providerVersion,
      style: style ?? this.style,
      hitCount: hitCount ?? this.hitCount,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceLanguage.present) {
      map['source_language'] = Variable<String>(sourceLanguage.value);
    }
    if (targetLanguage.present) {
      map['target_language'] = Variable<String>(targetLanguage.value);
    }
    if (sourceText.present) {
      map['source_text'] = Variable<String>(sourceText.value);
    }
    if (sourceTextHash.present) {
      map['source_text_hash'] = Variable<String>(sourceTextHash.value);
    }
    if (translatedText.present) {
      map['translated_text'] = Variable<String>(translatedText.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (providerVersion.present) {
      map['provider_version'] = Variable<String>(providerVersion.value);
    }
    if (style.present) {
      map['style'] = Variable<String>(style.value);
    }
    if (hitCount.present) {
      map['hit_count'] = Variable<int>(hitCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationCacheCompanion(')
          ..write('id: $id, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('sourceText: $sourceText, ')
          ..write('sourceTextHash: $sourceTextHash, ')
          ..write('translatedText: $translatedText, ')
          ..write('provider: $provider, ')
          ..write('providerVersion: $providerVersion, ')
          ..write('style: $style, ')
          ..write('hitCount: $hitCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }
}

class $GlossaryTermsTable extends GlossaryTerms
    with TableInfo<$GlossaryTermsTable, GlossaryTerm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GlossaryTermsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES books(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _sourceTermMeta = const VerificationMeta(
    'sourceTerm',
  );
  @override
  late final GeneratedColumn<String> sourceTerm = GeneratedColumn<String>(
    'source_term',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredTranslationMeta =
      const VerificationMeta('preferredTranslation');
  @override
  late final GeneratedColumn<String> preferredTranslation =
      GeneratedColumn<String>(
        'preferred_translation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceLanguageMeta = const VerificationMeta(
    'sourceLanguage',
  );
  @override
  late final GeneratedColumn<String> sourceLanguage = GeneratedColumn<String>(
    'source_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetLanguageMeta = const VerificationMeta(
    'targetLanguage',
  );
  @override
  late final GeneratedColumn<String> targetLanguage = GeneratedColumn<String>(
    'target_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    sourceTerm,
    preferredTranslation,
    sourceLanguage,
    targetLanguage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'glossary_terms';
  @override
  VerificationContext validateIntegrity(
    Insertable<GlossaryTerm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    }
    if (data.containsKey('source_term')) {
      context.handle(
        _sourceTermMeta,
        sourceTerm.isAcceptableOrUnknown(data['source_term']!, _sourceTermMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTermMeta);
    }
    if (data.containsKey('preferred_translation')) {
      context.handle(
        _preferredTranslationMeta,
        preferredTranslation.isAcceptableOrUnknown(
          data['preferred_translation']!,
          _preferredTranslationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredTranslationMeta);
    }
    if (data.containsKey('source_language')) {
      context.handle(
        _sourceLanguageMeta,
        sourceLanguage.isAcceptableOrUnknown(
          data['source_language']!,
          _sourceLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceLanguageMeta);
    }
    if (data.containsKey('target_language')) {
      context.handle(
        _targetLanguageMeta,
        targetLanguage.isAcceptableOrUnknown(
          data['target_language']!,
          _targetLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetLanguageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GlossaryTerm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GlossaryTerm(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      ),
      sourceTerm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_term'],
      )!,
      preferredTranslation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_translation'],
      )!,
      sourceLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_language'],
      )!,
      targetLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_language'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GlossaryTermsTable createAlias(String alias) {
    return $GlossaryTermsTable(attachedDatabase, alias);
  }
}

class GlossaryTerm extends DataClass implements Insertable<GlossaryTerm> {
  final int id;
  final int? bookId;
  final String sourceTerm;
  final String preferredTranslation;
  final String sourceLanguage;
  final String targetLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GlossaryTerm({
    required this.id,
    this.bookId,
    required this.sourceTerm,
    required this.preferredTranslation,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || bookId != null) {
      map['book_id'] = Variable<int>(bookId);
    }
    map['source_term'] = Variable<String>(sourceTerm);
    map['preferred_translation'] = Variable<String>(preferredTranslation);
    map['source_language'] = Variable<String>(sourceLanguage);
    map['target_language'] = Variable<String>(targetLanguage);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GlossaryTermsCompanion toCompanion(bool nullToAbsent) {
    return GlossaryTermsCompanion(
      id: Value(id),
      bookId: bookId == null && nullToAbsent
          ? const Value.absent()
          : Value(bookId),
      sourceTerm: Value(sourceTerm),
      preferredTranslation: Value(preferredTranslation),
      sourceLanguage: Value(sourceLanguage),
      targetLanguage: Value(targetLanguage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GlossaryTerm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GlossaryTerm(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int?>(json['bookId']),
      sourceTerm: serializer.fromJson<String>(json['sourceTerm']),
      preferredTranslation: serializer.fromJson<String>(
        json['preferredTranslation'],
      ),
      sourceLanguage: serializer.fromJson<String>(json['sourceLanguage']),
      targetLanguage: serializer.fromJson<String>(json['targetLanguage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int?>(bookId),
      'sourceTerm': serializer.toJson<String>(sourceTerm),
      'preferredTranslation': serializer.toJson<String>(preferredTranslation),
      'sourceLanguage': serializer.toJson<String>(sourceLanguage),
      'targetLanguage': serializer.toJson<String>(targetLanguage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GlossaryTerm copyWith({
    int? id,
    Value<int?> bookId = const Value.absent(),
    String? sourceTerm,
    String? preferredTranslation,
    String? sourceLanguage,
    String? targetLanguage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GlossaryTerm(
    id: id ?? this.id,
    bookId: bookId.present ? bookId.value : this.bookId,
    sourceTerm: sourceTerm ?? this.sourceTerm,
    preferredTranslation: preferredTranslation ?? this.preferredTranslation,
    sourceLanguage: sourceLanguage ?? this.sourceLanguage,
    targetLanguage: targetLanguage ?? this.targetLanguage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GlossaryTerm copyWithCompanion(GlossaryTermsCompanion data) {
    return GlossaryTerm(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      sourceTerm: data.sourceTerm.present
          ? data.sourceTerm.value
          : this.sourceTerm,
      preferredTranslation: data.preferredTranslation.present
          ? data.preferredTranslation.value
          : this.preferredTranslation,
      sourceLanguage: data.sourceLanguage.present
          ? data.sourceLanguage.value
          : this.sourceLanguage,
      targetLanguage: data.targetLanguage.present
          ? data.targetLanguage.value
          : this.targetLanguage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GlossaryTerm(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('sourceTerm: $sourceTerm, ')
          ..write('preferredTranslation: $preferredTranslation, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    sourceTerm,
    preferredTranslation,
    sourceLanguage,
    targetLanguage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GlossaryTerm &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.sourceTerm == this.sourceTerm &&
          other.preferredTranslation == this.preferredTranslation &&
          other.sourceLanguage == this.sourceLanguage &&
          other.targetLanguage == this.targetLanguage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GlossaryTermsCompanion extends UpdateCompanion<GlossaryTerm> {
  final Value<int> id;
  final Value<int?> bookId;
  final Value<String> sourceTerm;
  final Value<String> preferredTranslation;
  final Value<String> sourceLanguage;
  final Value<String> targetLanguage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const GlossaryTermsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.sourceTerm = const Value.absent(),
    this.preferredTranslation = const Value.absent(),
    this.sourceLanguage = const Value.absent(),
    this.targetLanguage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GlossaryTermsCompanion.insert({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    required String sourceTerm,
    required String preferredTranslation,
    required String sourceLanguage,
    required String targetLanguage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : sourceTerm = Value(sourceTerm),
       preferredTranslation = Value(preferredTranslation),
       sourceLanguage = Value(sourceLanguage),
       targetLanguage = Value(targetLanguage),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GlossaryTerm> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<String>? sourceTerm,
    Expression<String>? preferredTranslation,
    Expression<String>? sourceLanguage,
    Expression<String>? targetLanguage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (sourceTerm != null) 'source_term': sourceTerm,
      if (preferredTranslation != null)
        'preferred_translation': preferredTranslation,
      if (sourceLanguage != null) 'source_language': sourceLanguage,
      if (targetLanguage != null) 'target_language': targetLanguage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GlossaryTermsCompanion copyWith({
    Value<int>? id,
    Value<int?>? bookId,
    Value<String>? sourceTerm,
    Value<String>? preferredTranslation,
    Value<String>? sourceLanguage,
    Value<String>? targetLanguage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return GlossaryTermsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      sourceTerm: sourceTerm ?? this.sourceTerm,
      preferredTranslation: preferredTranslation ?? this.preferredTranslation,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (sourceTerm.present) {
      map['source_term'] = Variable<String>(sourceTerm.value);
    }
    if (preferredTranslation.present) {
      map['preferred_translation'] = Variable<String>(
        preferredTranslation.value,
      );
    }
    if (sourceLanguage.present) {
      map['source_language'] = Variable<String>(sourceLanguage.value);
    }
    if (targetLanguage.present) {
      map['target_language'] = Variable<String>(targetLanguage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GlossaryTermsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('sourceTerm: $sourceTerm, ')
          ..write('preferredTranslation: $preferredTranslation, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BookSettingsTable extends BookSettings
    with TableInfo<$BookSettingsTable, BookSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL UNIQUE REFERENCES books(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
    'font_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(16.0),
  );
  static const VerificationMeta _readingThemeMeta = const VerificationMeta(
    'readingTheme',
  );
  @override
  late final GeneratedColumn<String> readingTheme = GeneratedColumn<String>(
    'reading_theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('light'),
  );
  static const VerificationMeta _isTranslationEnabledMeta =
      const VerificationMeta('isTranslationEnabled');
  @override
  late final GeneratedColumn<bool> isTranslationEnabled = GeneratedColumn<bool>(
    'is_translation_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_translation_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _translationStyleMeta = const VerificationMeta(
    'translationStyle',
  );
  @override
  late final GeneratedColumn<String> translationStyle = GeneratedColumn<String>(
    'translation_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('natural'),
  );
  static const VerificationMeta _fontFamilyMeta = const VerificationMeta(
    'fontFamily',
  );
  @override
  late final GeneratedColumn<String> fontFamily = GeneratedColumn<String>(
    'font_family',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('default'),
  );
  static const VerificationMeta _lastPageIndexMeta = const VerificationMeta(
    'lastPageIndex',
  );
  @override
  late final GeneratedColumn<int> lastPageIndex = GeneratedColumn<int>(
    'last_page_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastScrollOffsetMeta = const VerificationMeta(
    'lastScrollOffset',
  );
  @override
  late final GeneratedColumn<double> lastScrollOffset = GeneratedColumn<double>(
    'last_scroll_offset',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _dailyGoalMinutesMeta = const VerificationMeta(
    'dailyGoalMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyGoalMinutes = GeneratedColumn<int>(
    'daily_goal_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    fontSize,
    readingTheme,
    isTranslationEnabled,
    translationStyle,
    fontFamily,
    lastPageIndex,
    lastScrollOffset,
    dailyGoalMinutes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    }
    if (data.containsKey('reading_theme')) {
      context.handle(
        _readingThemeMeta,
        readingTheme.isAcceptableOrUnknown(
          data['reading_theme']!,
          _readingThemeMeta,
        ),
      );
    }
    if (data.containsKey('is_translation_enabled')) {
      context.handle(
        _isTranslationEnabledMeta,
        isTranslationEnabled.isAcceptableOrUnknown(
          data['is_translation_enabled']!,
          _isTranslationEnabledMeta,
        ),
      );
    }
    if (data.containsKey('translation_style')) {
      context.handle(
        _translationStyleMeta,
        translationStyle.isAcceptableOrUnknown(
          data['translation_style']!,
          _translationStyleMeta,
        ),
      );
    }
    if (data.containsKey('font_family')) {
      context.handle(
        _fontFamilyMeta,
        fontFamily.isAcceptableOrUnknown(data['font_family']!, _fontFamilyMeta),
      );
    }
    if (data.containsKey('last_page_index')) {
      context.handle(
        _lastPageIndexMeta,
        lastPageIndex.isAcceptableOrUnknown(
          data['last_page_index']!,
          _lastPageIndexMeta,
        ),
      );
    }
    if (data.containsKey('last_scroll_offset')) {
      context.handle(
        _lastScrollOffsetMeta,
        lastScrollOffset.isAcceptableOrUnknown(
          data['last_scroll_offset']!,
          _lastScrollOffsetMeta,
        ),
      );
    }
    if (data.containsKey('daily_goal_minutes')) {
      context.handle(
        _dailyGoalMinutesMeta,
        dailyGoalMinutes.isAcceptableOrUnknown(
          data['daily_goal_minutes']!,
          _dailyGoalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}font_size'],
      )!,
      readingTheme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_theme'],
      )!,
      isTranslationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_translation_enabled'],
      )!,
      translationStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_style'],
      )!,
      fontFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}font_family'],
      )!,
      lastPageIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_page_index'],
      )!,
      lastScrollOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_scroll_offset'],
      )!,
      dailyGoalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal_minutes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BookSettingsTable createAlias(String alias) {
    return $BookSettingsTable(attachedDatabase, alias);
  }
}

class BookSetting extends DataClass implements Insertable<BookSetting> {
  final int id;
  final int bookId;
  final double fontSize;
  final String readingTheme;
  final bool isTranslationEnabled;
  final String translationStyle;
  final String fontFamily;
  final int lastPageIndex;
  final double lastScrollOffset;
  final int dailyGoalMinutes;
  final DateTime updatedAt;
  const BookSetting({
    required this.id,
    required this.bookId,
    required this.fontSize,
    required this.readingTheme,
    required this.isTranslationEnabled,
    required this.translationStyle,
    required this.fontFamily,
    required this.lastPageIndex,
    required this.lastScrollOffset,
    required this.dailyGoalMinutes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['font_size'] = Variable<double>(fontSize);
    map['reading_theme'] = Variable<String>(readingTheme);
    map['is_translation_enabled'] = Variable<bool>(isTranslationEnabled);
    map['translation_style'] = Variable<String>(translationStyle);
    map['font_family'] = Variable<String>(fontFamily);
    map['last_page_index'] = Variable<int>(lastPageIndex);
    map['last_scroll_offset'] = Variable<double>(lastScrollOffset);
    map['daily_goal_minutes'] = Variable<int>(dailyGoalMinutes);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BookSettingsCompanion toCompanion(bool nullToAbsent) {
    return BookSettingsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      fontSize: Value(fontSize),
      readingTheme: Value(readingTheme),
      isTranslationEnabled: Value(isTranslationEnabled),
      translationStyle: Value(translationStyle),
      fontFamily: Value(fontFamily),
      lastPageIndex: Value(lastPageIndex),
      lastScrollOffset: Value(lastScrollOffset),
      dailyGoalMinutes: Value(dailyGoalMinutes),
      updatedAt: Value(updatedAt),
    );
  }

  factory BookSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookSetting(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      fontSize: serializer.fromJson<double>(json['fontSize']),
      readingTheme: serializer.fromJson<String>(json['readingTheme']),
      isTranslationEnabled: serializer.fromJson<bool>(
        json['isTranslationEnabled'],
      ),
      translationStyle: serializer.fromJson<String>(json['translationStyle']),
      fontFamily: serializer.fromJson<String>(json['fontFamily']),
      lastPageIndex: serializer.fromJson<int>(json['lastPageIndex']),
      lastScrollOffset: serializer.fromJson<double>(json['lastScrollOffset']),
      dailyGoalMinutes: serializer.fromJson<int>(json['dailyGoalMinutes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'fontSize': serializer.toJson<double>(fontSize),
      'readingTheme': serializer.toJson<String>(readingTheme),
      'isTranslationEnabled': serializer.toJson<bool>(isTranslationEnabled),
      'translationStyle': serializer.toJson<String>(translationStyle),
      'fontFamily': serializer.toJson<String>(fontFamily),
      'lastPageIndex': serializer.toJson<int>(lastPageIndex),
      'lastScrollOffset': serializer.toJson<double>(lastScrollOffset),
      'dailyGoalMinutes': serializer.toJson<int>(dailyGoalMinutes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BookSetting copyWith({
    int? id,
    int? bookId,
    double? fontSize,
    String? readingTheme,
    bool? isTranslationEnabled,
    String? translationStyle,
    String? fontFamily,
    int? lastPageIndex,
    double? lastScrollOffset,
    int? dailyGoalMinutes,
    DateTime? updatedAt,
  }) => BookSetting(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    fontSize: fontSize ?? this.fontSize,
    readingTheme: readingTheme ?? this.readingTheme,
    isTranslationEnabled: isTranslationEnabled ?? this.isTranslationEnabled,
    translationStyle: translationStyle ?? this.translationStyle,
    fontFamily: fontFamily ?? this.fontFamily,
    lastPageIndex: lastPageIndex ?? this.lastPageIndex,
    lastScrollOffset: lastScrollOffset ?? this.lastScrollOffset,
    dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BookSetting copyWithCompanion(BookSettingsCompanion data) {
    return BookSetting(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      readingTheme: data.readingTheme.present
          ? data.readingTheme.value
          : this.readingTheme,
      isTranslationEnabled: data.isTranslationEnabled.present
          ? data.isTranslationEnabled.value
          : this.isTranslationEnabled,
      translationStyle: data.translationStyle.present
          ? data.translationStyle.value
          : this.translationStyle,
      fontFamily: data.fontFamily.present
          ? data.fontFamily.value
          : this.fontFamily,
      lastPageIndex: data.lastPageIndex.present
          ? data.lastPageIndex.value
          : this.lastPageIndex,
      lastScrollOffset: data.lastScrollOffset.present
          ? data.lastScrollOffset.value
          : this.lastScrollOffset,
      dailyGoalMinutes: data.dailyGoalMinutes.present
          ? data.dailyGoalMinutes.value
          : this.dailyGoalMinutes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookSetting(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('fontSize: $fontSize, ')
          ..write('readingTheme: $readingTheme, ')
          ..write('isTranslationEnabled: $isTranslationEnabled, ')
          ..write('translationStyle: $translationStyle, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('lastPageIndex: $lastPageIndex, ')
          ..write('lastScrollOffset: $lastScrollOffset, ')
          ..write('dailyGoalMinutes: $dailyGoalMinutes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    fontSize,
    readingTheme,
    isTranslationEnabled,
    translationStyle,
    fontFamily,
    lastPageIndex,
    lastScrollOffset,
    dailyGoalMinutes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookSetting &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.fontSize == this.fontSize &&
          other.readingTheme == this.readingTheme &&
          other.isTranslationEnabled == this.isTranslationEnabled &&
          other.translationStyle == this.translationStyle &&
          other.fontFamily == this.fontFamily &&
          other.lastPageIndex == this.lastPageIndex &&
          other.lastScrollOffset == this.lastScrollOffset &&
          other.dailyGoalMinutes == this.dailyGoalMinutes &&
          other.updatedAt == this.updatedAt);
}

class BookSettingsCompanion extends UpdateCompanion<BookSetting> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<double> fontSize;
  final Value<String> readingTheme;
  final Value<bool> isTranslationEnabled;
  final Value<String> translationStyle;
  final Value<String> fontFamily;
  final Value<int> lastPageIndex;
  final Value<double> lastScrollOffset;
  final Value<int> dailyGoalMinutes;
  final Value<DateTime> updatedAt;
  const BookSettingsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.readingTheme = const Value.absent(),
    this.isTranslationEnabled = const Value.absent(),
    this.translationStyle = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.lastPageIndex = const Value.absent(),
    this.lastScrollOffset = const Value.absent(),
    this.dailyGoalMinutes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BookSettingsCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    this.fontSize = const Value.absent(),
    this.readingTheme = const Value.absent(),
    this.isTranslationEnabled = const Value.absent(),
    this.translationStyle = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.lastPageIndex = const Value.absent(),
    this.lastScrollOffset = const Value.absent(),
    this.dailyGoalMinutes = const Value.absent(),
    required DateTime updatedAt,
  }) : bookId = Value(bookId),
       updatedAt = Value(updatedAt);
  static Insertable<BookSetting> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<double>? fontSize,
    Expression<String>? readingTheme,
    Expression<bool>? isTranslationEnabled,
    Expression<String>? translationStyle,
    Expression<String>? fontFamily,
    Expression<int>? lastPageIndex,
    Expression<double>? lastScrollOffset,
    Expression<int>? dailyGoalMinutes,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (fontSize != null) 'font_size': fontSize,
      if (readingTheme != null) 'reading_theme': readingTheme,
      if (isTranslationEnabled != null)
        'is_translation_enabled': isTranslationEnabled,
      if (translationStyle != null) 'translation_style': translationStyle,
      if (fontFamily != null) 'font_family': fontFamily,
      if (lastPageIndex != null) 'last_page_index': lastPageIndex,
      if (lastScrollOffset != null) 'last_scroll_offset': lastScrollOffset,
      if (dailyGoalMinutes != null) 'daily_goal_minutes': dailyGoalMinutes,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BookSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<double>? fontSize,
    Value<String>? readingTheme,
    Value<bool>? isTranslationEnabled,
    Value<String>? translationStyle,
    Value<String>? fontFamily,
    Value<int>? lastPageIndex,
    Value<double>? lastScrollOffset,
    Value<int>? dailyGoalMinutes,
    Value<DateTime>? updatedAt,
  }) {
    return BookSettingsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      fontSize: fontSize ?? this.fontSize,
      readingTheme: readingTheme ?? this.readingTheme,
      isTranslationEnabled: isTranslationEnabled ?? this.isTranslationEnabled,
      translationStyle: translationStyle ?? this.translationStyle,
      fontFamily: fontFamily ?? this.fontFamily,
      lastPageIndex: lastPageIndex ?? this.lastPageIndex,
      lastScrollOffset: lastScrollOffset ?? this.lastScrollOffset,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (readingTheme.present) {
      map['reading_theme'] = Variable<String>(readingTheme.value);
    }
    if (isTranslationEnabled.present) {
      map['is_translation_enabled'] = Variable<bool>(
        isTranslationEnabled.value,
      );
    }
    if (translationStyle.present) {
      map['translation_style'] = Variable<String>(translationStyle.value);
    }
    if (fontFamily.present) {
      map['font_family'] = Variable<String>(fontFamily.value);
    }
    if (lastPageIndex.present) {
      map['last_page_index'] = Variable<int>(lastPageIndex.value);
    }
    if (lastScrollOffset.present) {
      map['last_scroll_offset'] = Variable<double>(lastScrollOffset.value);
    }
    if (dailyGoalMinutes.present) {
      map['daily_goal_minutes'] = Variable<int>(dailyGoalMinutes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookSettingsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('fontSize: $fontSize, ')
          ..write('readingTheme: $readingTheme, ')
          ..write('isTranslationEnabled: $isTranslationEnabled, ')
          ..write('translationStyle: $translationStyle, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('lastPageIndex: $lastPageIndex, ')
          ..write('lastScrollOffset: $lastScrollOffset, ')
          ..write('dailyGoalMinutes: $dailyGoalMinutes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReadingSessionsTable extends ReadingSessions
    with TableInfo<$ReadingSessionsTable, ReadingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES books(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _chaptersReadMeta = const VerificationMeta(
    'chaptersRead',
  );
  @override
  late final GeneratedColumn<int> chaptersRead = GeneratedColumn<int>(
    'chapters_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wordsTranslatedMeta = const VerificationMeta(
    'wordsTranslated',
  );
  @override
  late final GeneratedColumn<int> wordsTranslated = GeneratedColumn<int>(
    'words_translated',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wordsReadMeta = const VerificationMeta(
    'wordsRead',
  );
  @override
  late final GeneratedColumn<int> wordsRead = GeneratedColumn<int>(
    'words_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    startedAt,
    endedAt,
    durationSeconds,
    chaptersRead,
    wordsTranslated,
    wordsRead,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('chapters_read')) {
      context.handle(
        _chaptersReadMeta,
        chaptersRead.isAcceptableOrUnknown(
          data['chapters_read']!,
          _chaptersReadMeta,
        ),
      );
    }
    if (data.containsKey('words_translated')) {
      context.handle(
        _wordsTranslatedMeta,
        wordsTranslated.isAcceptableOrUnknown(
          data['words_translated']!,
          _wordsTranslatedMeta,
        ),
      );
    }
    if (data.containsKey('words_read')) {
      context.handle(
        _wordsReadMeta,
        wordsRead.isAcceptableOrUnknown(data['words_read']!, _wordsReadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      chaptersRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapters_read'],
      )!,
      wordsTranslated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}words_translated'],
      )!,
      wordsRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}words_read'],
      )!,
    );
  }

  @override
  $ReadingSessionsTable createAlias(String alias) {
    return $ReadingSessionsTable(attachedDatabase, alias);
  }
}

class ReadingSession extends DataClass implements Insertable<ReadingSession> {
  final int id;
  final int bookId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationSeconds;
  final int chaptersRead;
  final int wordsTranslated;
  final int wordsRead;
  const ReadingSession({
    required this.id,
    required this.bookId,
    required this.startedAt,
    this.endedAt,
    required this.durationSeconds,
    required this.chaptersRead,
    required this.wordsTranslated,
    required this.wordsRead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['chapters_read'] = Variable<int>(chaptersRead);
    map['words_translated'] = Variable<int>(wordsTranslated);
    map['words_read'] = Variable<int>(wordsRead);
    return map;
  }

  ReadingSessionsCompanion toCompanion(bool nullToAbsent) {
    return ReadingSessionsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationSeconds: Value(durationSeconds),
      chaptersRead: Value(chaptersRead),
      wordsTranslated: Value(wordsTranslated),
      wordsRead: Value(wordsRead),
    );
  }

  factory ReadingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSession(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      chaptersRead: serializer.fromJson<int>(json['chaptersRead']),
      wordsTranslated: serializer.fromJson<int>(json['wordsTranslated']),
      wordsRead: serializer.fromJson<int>(json['wordsRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'chaptersRead': serializer.toJson<int>(chaptersRead),
      'wordsTranslated': serializer.toJson<int>(wordsTranslated),
      'wordsRead': serializer.toJson<int>(wordsRead),
    };
  }

  ReadingSession copyWith({
    int? id,
    int? bookId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? durationSeconds,
    int? chaptersRead,
    int? wordsTranslated,
    int? wordsRead,
  }) => ReadingSession(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    chaptersRead: chaptersRead ?? this.chaptersRead,
    wordsTranslated: wordsTranslated ?? this.wordsTranslated,
    wordsRead: wordsRead ?? this.wordsRead,
  );
  ReadingSession copyWithCompanion(ReadingSessionsCompanion data) {
    return ReadingSession(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      chaptersRead: data.chaptersRead.present
          ? data.chaptersRead.value
          : this.chaptersRead,
      wordsTranslated: data.wordsTranslated.present
          ? data.wordsTranslated.value
          : this.wordsTranslated,
      wordsRead: data.wordsRead.present ? data.wordsRead.value : this.wordsRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSession(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('chaptersRead: $chaptersRead, ')
          ..write('wordsTranslated: $wordsTranslated, ')
          ..write('wordsRead: $wordsRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    startedAt,
    endedAt,
    durationSeconds,
    chaptersRead,
    wordsTranslated,
    wordsRead,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSession &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.chaptersRead == this.chaptersRead &&
          other.wordsTranslated == this.wordsTranslated &&
          other.wordsRead == this.wordsRead);
}

class ReadingSessionsCompanion extends UpdateCompanion<ReadingSession> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> durationSeconds;
  final Value<int> chaptersRead;
  final Value<int> wordsTranslated;
  final Value<int> wordsRead;
  const ReadingSessionsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.chaptersRead = const Value.absent(),
    this.wordsTranslated = const Value.absent(),
    this.wordsRead = const Value.absent(),
  });
  ReadingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.chaptersRead = const Value.absent(),
    this.wordsTranslated = const Value.absent(),
    this.wordsRead = const Value.absent(),
  }) : bookId = Value(bookId),
       startedAt = Value(startedAt);
  static Insertable<ReadingSession> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSeconds,
    Expression<int>? chaptersRead,
    Expression<int>? wordsTranslated,
    Expression<int>? wordsRead,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (chaptersRead != null) 'chapters_read': chaptersRead,
      if (wordsTranslated != null) 'words_translated': wordsTranslated,
      if (wordsRead != null) 'words_read': wordsRead,
    });
  }

  ReadingSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? durationSeconds,
    Value<int>? chaptersRead,
    Value<int>? wordsTranslated,
    Value<int>? wordsRead,
  }) {
    return ReadingSessionsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      chaptersRead: chaptersRead ?? this.chaptersRead,
      wordsTranslated: wordsTranslated ?? this.wordsTranslated,
      wordsRead: wordsRead ?? this.wordsRead,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (chaptersRead.present) {
      map['chapters_read'] = Variable<int>(chaptersRead.value);
    }
    if (wordsTranslated.present) {
      map['words_translated'] = Variable<int>(wordsTranslated.value);
    }
    if (wordsRead.present) {
      map['words_read'] = Variable<int>(wordsRead.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('chaptersRead: $chaptersRead, ')
          ..write('wordsTranslated: $wordsTranslated, ')
          ..write('wordsRead: $wordsRead')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, Collection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Collection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Collection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Collection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }
}

class Collection extends DataClass implements Insertable<Collection> {
  final int id;
  final String name;
  final DateTime createdAt;
  const Collection({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Collection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Collection(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Collection copyWith({int? id, String? name, DateTime? createdAt}) =>
      Collection(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  Collection copyWithCompanion(CollectionsCompanion data) {
    return Collection(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Collection(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Collection &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class CollectionsCompanion extends UpdateCompanion<Collection> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CollectionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Collection> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CollectionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return CollectionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BookCollectionsTable extends BookCollections
    with TableInfo<$BookCollectionsTable, BookCollection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookCollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES books(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES collections(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, bookId, collectionId, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookCollection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {bookId, collectionId},
  ];
  @override
  BookCollection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookCollection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $BookCollectionsTable createAlias(String alias) {
    return $BookCollectionsTable(attachedDatabase, alias);
  }
}

class BookCollection extends DataClass implements Insertable<BookCollection> {
  final int id;
  final int bookId;
  final int collectionId;
  final DateTime addedAt;
  const BookCollection({
    required this.id,
    required this.bookId,
    required this.collectionId,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['collection_id'] = Variable<int>(collectionId);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  BookCollectionsCompanion toCompanion(bool nullToAbsent) {
    return BookCollectionsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      collectionId: Value(collectionId),
      addedAt: Value(addedAt),
    );
  }

  factory BookCollection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookCollection(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      collectionId: serializer.fromJson<int>(json['collectionId']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'collectionId': serializer.toJson<int>(collectionId),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  BookCollection copyWith({
    int? id,
    int? bookId,
    int? collectionId,
    DateTime? addedAt,
  }) => BookCollection(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    collectionId: collectionId ?? this.collectionId,
    addedAt: addedAt ?? this.addedAt,
  );
  BookCollection copyWithCompanion(BookCollectionsCompanion data) {
    return BookCollection(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookCollection(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('collectionId: $collectionId, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, collectionId, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookCollection &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.collectionId == this.collectionId &&
          other.addedAt == this.addedAt);
}

class BookCollectionsCompanion extends UpdateCompanion<BookCollection> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<int> collectionId;
  final Value<DateTime> addedAt;
  const BookCollectionsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  BookCollectionsCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required int collectionId,
    required DateTime addedAt,
  }) : bookId = Value(bookId),
       collectionId = Value(collectionId),
       addedAt = Value(addedAt);
  static Insertable<BookCollection> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<int>? collectionId,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (collectionId != null) 'collection_id': collectionId,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  BookCollectionsCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<int>? collectionId,
    Value<DateTime>? addedAt,
  }) {
    return BookCollectionsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      collectionId: collectionId ?? this.collectionId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookCollectionsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('collectionId: $collectionId, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $ReadingProgressTable readingProgress = $ReadingProgressTable(
    this,
  );
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $TranslationUnitsTable translationUnits = $TranslationUnitsTable(
    this,
  );
  late final $HighlightsTable highlights = $HighlightsTable(this);
  late final $TranslationCacheTable translationCache = $TranslationCacheTable(
    this,
  );
  late final $GlossaryTermsTable glossaryTerms = $GlossaryTermsTable(this);
  late final $BookSettingsTable bookSettings = $BookSettingsTable(this);
  late final $ReadingSessionsTable readingSessions = $ReadingSessionsTable(
    this,
  );
  late final $CollectionsTable collections = $CollectionsTable(this);
  late final $BookCollectionsTable bookCollections = $BookCollectionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    books,
    chapters,
    readingProgress,
    bookmarks,
    translationUnits,
    highlights,
    translationCache,
    glossaryTerms,
    bookSettings,
    readingSessions,
    collections,
    bookCollections,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chapters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chapters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmarks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chapters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmarks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chapters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('translation_units', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('highlights', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chapters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('highlights', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'translation_units',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('highlights', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('glossary_terms', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('book_settings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('book_collections', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('book_collections', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      required String uuid,
      required String title,
      Value<String?> subtitle,
      Value<String?> author,
      Value<String?> publisher,
      Value<String?> sourceLanguage,
      Value<String?> isbn,
      Value<String?> epubVersion,
      required String filePath,
      required String fileHash,
      Value<int?> fileSizeBytes,
      Value<String?> coverPath,
      Value<String> readingStatus,
      Value<bool> isFavorite,
      Value<bool> isArchived,
      required DateTime addedAt,
      required DateTime updatedAt,
      Value<DateTime?> lastOpenedAt,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> title,
      Value<String?> subtitle,
      Value<String?> author,
      Value<String?> publisher,
      Value<String?> sourceLanguage,
      Value<String?> isbn,
      Value<String?> epubVersion,
      Value<String> filePath,
      Value<String> fileHash,
      Value<int?> fileSizeBytes,
      Value<String?> coverPath,
      Value<String> readingStatus,
      Value<bool> isFavorite,
      Value<bool> isArchived,
      Value<DateTime> addedAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastOpenedAt,
    });

final class $$BooksTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTable, Book> {
  $$BooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChaptersTable, List<Chapter>> _chaptersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chapters,
    aliasName: $_aliasNameGenerator(db.books.id, db.chapters.bookId),
  );

  $$ChaptersTableProcessedTableManager get chaptersRefs {
    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingProgressTable, List<ReadingProgressData>>
  _readingProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingProgress,
    aliasName: $_aliasNameGenerator(db.books.id, db.readingProgress.bookId),
  );

  $$ReadingProgressTableProcessedTableManager get readingProgressRefs {
    final manager = $$ReadingProgressTableTableManager(
      $_db,
      $_db.readingProgress,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookmarksTable, List<Bookmark>>
  _bookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookmarks,
    aliasName: $_aliasNameGenerator(db.books.id, db.bookmarks.bookId),
  );

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager(
      $_db,
      $_db.bookmarks,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HighlightsTable, List<Highlight>>
  _highlightsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.highlights,
    aliasName: $_aliasNameGenerator(db.books.id, db.highlights.bookId),
  );

  $$HighlightsTableProcessedTableManager get highlightsRefs {
    final manager = $$HighlightsTableTableManager(
      $_db,
      $_db.highlights,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GlossaryTermsTable, List<GlossaryTerm>>
  _glossaryTermsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.glossaryTerms,
    aliasName: $_aliasNameGenerator(db.books.id, db.glossaryTerms.bookId),
  );

  $$GlossaryTermsTableProcessedTableManager get glossaryTermsRefs {
    final manager = $$GlossaryTermsTableTableManager(
      $_db,
      $_db.glossaryTerms,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_glossaryTermsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookSettingsTable, List<BookSetting>>
  _bookSettingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookSettings,
    aliasName: $_aliasNameGenerator(db.books.id, db.bookSettings.bookId),
  );

  $$BookSettingsTableProcessedTableManager get bookSettingsRefs {
    final manager = $$BookSettingsTableTableManager(
      $_db,
      $_db.bookSettings,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookSettingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingSessionsTable, List<ReadingSession>>
  _readingSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingSessions,
    aliasName: $_aliasNameGenerator(db.books.id, db.readingSessions.bookId),
  );

  $$ReadingSessionsTableProcessedTableManager get readingSessionsRefs {
    final manager = $$ReadingSessionsTableTableManager(
      $_db,
      $_db.readingSessions,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookCollectionsTable, List<BookCollection>>
  _bookCollectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookCollections,
    aliasName: $_aliasNameGenerator(db.books.id, db.bookCollections.bookId),
  );

  $$BookCollectionsTableProcessedTableManager get bookCollectionsRefs {
    final manager = $$BookCollectionsTableTableManager(
      $_db,
      $_db.bookCollections,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bookCollectionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isbn => $composableBuilder(
    column: $table.isbn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get epubVersion => $composableBuilder(
    column: $table.epubVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chaptersRefs(
    Expression<bool> Function($$ChaptersTableFilterComposer f) f,
  ) {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingProgressRefs(
    Expression<bool> Function($$ReadingProgressTableFilterComposer f) f,
  ) {
    final $$ReadingProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableFilterComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookmarksRefs(
    Expression<bool> Function($$BookmarksTableFilterComposer f) f,
  ) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableFilterComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> highlightsRefs(
    Expression<bool> Function($$HighlightsTableFilterComposer f) f,
  ) {
    final $$HighlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableFilterComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> glossaryTermsRefs(
    Expression<bool> Function($$GlossaryTermsTableFilterComposer f) f,
  ) {
    final $$GlossaryTermsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.glossaryTerms,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GlossaryTermsTableFilterComposer(
            $db: $db,
            $table: $db.glossaryTerms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookSettingsRefs(
    Expression<bool> Function($$BookSettingsTableFilterComposer f) f,
  ) {
    final $$BookSettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookSettings,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookSettingsTableFilterComposer(
            $db: $db,
            $table: $db.bookSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingSessionsRefs(
    Expression<bool> Function($$ReadingSessionsTableFilterComposer f) f,
  ) {
    final $$ReadingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookCollectionsRefs(
    Expression<bool> Function($$BookCollectionsTableFilterComposer f) f,
  ) {
    final $$BookCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookCollections,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.bookCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isbn => $composableBuilder(
    column: $table.isbn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get epubVersion => $composableBuilder(
    column: $table.epubVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get isbn =>
      $composableBuilder(column: $table.isbn, builder: (column) => column);

  GeneratedColumn<String> get epubVersion => $composableBuilder(
    column: $table.epubVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );

  Expression<T> chaptersRefs<T extends Object>(
    Expression<T> Function($$ChaptersTableAnnotationComposer a) f,
  ) {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingProgressRefs<T extends Object>(
    Expression<T> Function($$ReadingProgressTableAnnotationComposer a) f,
  ) {
    final $$ReadingProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bookmarksRefs<T extends Object>(
    Expression<T> Function($$BookmarksTableAnnotationComposer a) f,
  ) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableAnnotationComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> highlightsRefs<T extends Object>(
    Expression<T> Function($$HighlightsTableAnnotationComposer a) f,
  ) {
    final $$HighlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> glossaryTermsRefs<T extends Object>(
    Expression<T> Function($$GlossaryTermsTableAnnotationComposer a) f,
  ) {
    final $$GlossaryTermsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.glossaryTerms,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GlossaryTermsTableAnnotationComposer(
            $db: $db,
            $table: $db.glossaryTerms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bookSettingsRefs<T extends Object>(
    Expression<T> Function($$BookSettingsTableAnnotationComposer a) f,
  ) {
    final $$BookSettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookSettings,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookSettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.bookSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingSessionsRefs<T extends Object>(
    Expression<T> Function($$ReadingSessionsTableAnnotationComposer a) f,
  ) {
    final $$ReadingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bookCollectionsRefs<T extends Object>(
    Expression<T> Function($$BookCollectionsTableAnnotationComposer a) f,
  ) {
    final $$BookCollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookCollections,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookCollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.bookCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, $$BooksTableReferences),
          Book,
          PrefetchHooks Function({
            bool chaptersRefs,
            bool readingProgressRefs,
            bool bookmarksRefs,
            bool highlightsRefs,
            bool glossaryTermsRefs,
            bool bookSettingsRefs,
            bool readingSessionsRefs,
            bool bookCollectionsRefs,
          })
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> sourceLanguage = const Value.absent(),
                Value<String?> isbn = const Value.absent(),
                Value<String?> epubVersion = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> fileHash = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String> readingStatus = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                uuid: uuid,
                title: title,
                subtitle: subtitle,
                author: author,
                publisher: publisher,
                sourceLanguage: sourceLanguage,
                isbn: isbn,
                epubVersion: epubVersion,
                filePath: filePath,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                coverPath: coverPath,
                readingStatus: readingStatus,
                isFavorite: isFavorite,
                isArchived: isArchived,
                addedAt: addedAt,
                updatedAt: updatedAt,
                lastOpenedAt: lastOpenedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String title,
                Value<String?> subtitle = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> sourceLanguage = const Value.absent(),
                Value<String?> isbn = const Value.absent(),
                Value<String?> epubVersion = const Value.absent(),
                required String filePath,
                required String fileHash,
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String> readingStatus = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime addedAt,
                required DateTime updatedAt,
                Value<DateTime?> lastOpenedAt = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                uuid: uuid,
                title: title,
                subtitle: subtitle,
                author: author,
                publisher: publisher,
                sourceLanguage: sourceLanguage,
                isbn: isbn,
                epubVersion: epubVersion,
                filePath: filePath,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                coverPath: coverPath,
                readingStatus: readingStatus,
                isFavorite: isFavorite,
                isArchived: isArchived,
                addedAt: addedAt,
                updatedAt: updatedAt,
                lastOpenedAt: lastOpenedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BooksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chaptersRefs = false,
                readingProgressRefs = false,
                bookmarksRefs = false,
                highlightsRefs = false,
                glossaryTermsRefs = false,
                bookSettingsRefs = false,
                readingSessionsRefs = false,
                bookCollectionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chaptersRefs) db.chapters,
                    if (readingProgressRefs) db.readingProgress,
                    if (bookmarksRefs) db.bookmarks,
                    if (highlightsRefs) db.highlights,
                    if (glossaryTermsRefs) db.glossaryTerms,
                    if (bookSettingsRefs) db.bookSettings,
                    if (readingSessionsRefs) db.readingSessions,
                    if (bookCollectionsRefs) db.bookCollections,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chaptersRefs)
                        await $_getPrefetchedData<Book, $BooksTable, Chapter>(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._chaptersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).chaptersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingProgressRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          ReadingProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readingProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookmarksRefs)
                        await $_getPrefetchedData<Book, $BooksTable, Bookmark>(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._bookmarksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).bookmarksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (highlightsRefs)
                        await $_getPrefetchedData<Book, $BooksTable, Highlight>(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._highlightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).highlightsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (glossaryTermsRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          GlossaryTerm
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._glossaryTermsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).glossaryTermsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookSettingsRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          BookSetting
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._bookSettingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).bookSettingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingSessionsRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          ReadingSession
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readingSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookCollectionsRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          BookCollection
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._bookCollectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).bookCollectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, $$BooksTableReferences),
      Book,
      PrefetchHooks Function({
        bool chaptersRefs,
        bool readingProgressRefs,
        bool bookmarksRefs,
        bool highlightsRefs,
        bool glossaryTermsRefs,
        bool bookSettingsRefs,
        bool readingSessionsRefs,
        bool bookCollectionsRefs,
      })
    >;
typedef $$ChaptersTableCreateCompanionBuilder =
    ChaptersCompanion Function({
      Value<int> id,
      required String uuid,
      required int bookId,
      Value<int?> parentChapterId,
      required int spineIndex,
      Value<int?> tocOrder,
      required String href,
      Value<String?> title,
      Value<int?> wordCount,
    });
typedef $$ChaptersTableUpdateCompanionBuilder =
    ChaptersCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int> bookId,
      Value<int?> parentChapterId,
      Value<int> spineIndex,
      Value<int?> tocOrder,
      Value<String> href,
      Value<String?> title,
      Value<int?> wordCount,
    });

final class $$ChaptersTableReferences
    extends BaseReferences<_$AppDatabase, $ChaptersTable, Chapter> {
  $$ChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.chapters.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReadingProgressTable, List<ReadingProgressData>>
  _readingProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingProgress,
    aliasName: $_aliasNameGenerator(
      db.chapters.id,
      db.readingProgress.chapterId,
    ),
  );

  $$ReadingProgressTableProcessedTableManager get readingProgressRefs {
    final manager = $$ReadingProgressTableTableManager(
      $_db,
      $_db.readingProgress,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookmarksTable, List<Bookmark>>
  _bookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookmarks,
    aliasName: $_aliasNameGenerator(db.chapters.id, db.bookmarks.chapterId),
  );

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager(
      $_db,
      $_db.bookmarks,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TranslationUnitsTable, List<TranslationUnit>>
  _translationUnitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.translationUnits,
    aliasName: $_aliasNameGenerator(
      db.chapters.id,
      db.translationUnits.chapterId,
    ),
  );

  $$TranslationUnitsTableProcessedTableManager get translationUnitsRefs {
    final manager = $$TranslationUnitsTableTableManager(
      $_db,
      $_db.translationUnits,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _translationUnitsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HighlightsTable, List<Highlight>>
  _highlightsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.highlights,
    aliasName: $_aliasNameGenerator(db.chapters.id, db.highlights.chapterId),
  );

  $$HighlightsTableProcessedTableManager get highlightsRefs {
    final manager = $$HighlightsTableTableManager(
      $_db,
      $_db.highlights,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentChapterId => $composableBuilder(
    column: $table.parentChapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spineIndex => $composableBuilder(
    column: $table.spineIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tocOrder => $composableBuilder(
    column: $table.tocOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get href => $composableBuilder(
    column: $table.href,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readingProgressRefs(
    Expression<bool> Function($$ReadingProgressTableFilterComposer f) f,
  ) {
    final $$ReadingProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableFilterComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookmarksRefs(
    Expression<bool> Function($$BookmarksTableFilterComposer f) f,
  ) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableFilterComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> translationUnitsRefs(
    Expression<bool> Function($$TranslationUnitsTableFilterComposer f) f,
  ) {
    final $$TranslationUnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.translationUnits,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TranslationUnitsTableFilterComposer(
            $db: $db,
            $table: $db.translationUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> highlightsRefs(
    Expression<bool> Function($$HighlightsTableFilterComposer f) f,
  ) {
    final $$HighlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableFilterComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentChapterId => $composableBuilder(
    column: $table.parentChapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spineIndex => $composableBuilder(
    column: $table.spineIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tocOrder => $composableBuilder(
    column: $table.tocOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get href => $composableBuilder(
    column: $table.href,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get parentChapterId => $composableBuilder(
    column: $table.parentChapterId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get spineIndex => $composableBuilder(
    column: $table.spineIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tocOrder =>
      $composableBuilder(column: $table.tocOrder, builder: (column) => column);

  GeneratedColumn<String> get href =>
      $composableBuilder(column: $table.href, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> readingProgressRefs<T extends Object>(
    Expression<T> Function($$ReadingProgressTableAnnotationComposer a) f,
  ) {
    final $$ReadingProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bookmarksRefs<T extends Object>(
    Expression<T> Function($$BookmarksTableAnnotationComposer a) f,
  ) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableAnnotationComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> translationUnitsRefs<T extends Object>(
    Expression<T> Function($$TranslationUnitsTableAnnotationComposer a) f,
  ) {
    final $$TranslationUnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.translationUnits,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TranslationUnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.translationUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> highlightsRefs<T extends Object>(
    Expression<T> Function($$HighlightsTableAnnotationComposer a) f,
  ) {
    final $$HighlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (Chapter, $$ChaptersTableReferences),
          Chapter,
          PrefetchHooks Function({
            bool bookId,
            bool readingProgressRefs,
            bool bookmarksRefs,
            bool translationUnitsRefs,
            bool highlightsRefs,
          })
        > {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int?> parentChapterId = const Value.absent(),
                Value<int> spineIndex = const Value.absent(),
                Value<int?> tocOrder = const Value.absent(),
                Value<String> href = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int?> wordCount = const Value.absent(),
              }) => ChaptersCompanion(
                id: id,
                uuid: uuid,
                bookId: bookId,
                parentChapterId: parentChapterId,
                spineIndex: spineIndex,
                tocOrder: tocOrder,
                href: href,
                title: title,
                wordCount: wordCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int bookId,
                Value<int?> parentChapterId = const Value.absent(),
                required int spineIndex,
                Value<int?> tocOrder = const Value.absent(),
                required String href,
                Value<String?> title = const Value.absent(),
                Value<int?> wordCount = const Value.absent(),
              }) => ChaptersCompanion.insert(
                id: id,
                uuid: uuid,
                bookId: bookId,
                parentChapterId: parentChapterId,
                spineIndex: spineIndex,
                tocOrder: tocOrder,
                href: href,
                title: title,
                wordCount: wordCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChaptersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bookId = false,
                readingProgressRefs = false,
                bookmarksRefs = false,
                translationUnitsRefs = false,
                highlightsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingProgressRefs) db.readingProgress,
                    if (bookmarksRefs) db.bookmarks,
                    if (translationUnitsRefs) db.translationUnits,
                    if (highlightsRefs) db.highlights,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable: $$ChaptersTableReferences
                                        ._bookIdTable(db),
                                    referencedColumn: $$ChaptersTableReferences
                                        ._bookIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingProgressRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          ReadingProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._readingProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).readingProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookmarksRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          Bookmark
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._bookmarksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).bookmarksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (translationUnitsRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          TranslationUnit
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._translationUnitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).translationUnitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (highlightsRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          Highlight
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._highlightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).highlightsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (Chapter, $$ChaptersTableReferences),
      Chapter,
      PrefetchHooks Function({
        bool bookId,
        bool readingProgressRefs,
        bool bookmarksRefs,
        bool translationUnitsRefs,
        bool highlightsRefs,
      })
    >;
typedef $$ReadingProgressTableCreateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<int> id,
      required int bookId,
      required int chapterId,
      Value<String?> cfi,
      Value<double> scrollPct,
      required DateTime updatedAt,
    });
typedef $$ReadingProgressTableUpdateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<int> chapterId,
      Value<String?> cfi,
      Value<double> scrollPct,
      Value<DateTime> updatedAt,
    });

final class $$ReadingProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressData
        > {
  $$ReadingProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.readingProgress.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias(
        $_aliasNameGenerator(db.readingProgress.chapterId, db.chapters.id),
      );

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<int>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cfi => $composableBuilder(
    column: $table.cfi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scrollPct => $composableBuilder(
    column: $table.scrollPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cfi => $composableBuilder(
    column: $table.cfi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scrollPct => $composableBuilder(
    column: $table.scrollPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cfi =>
      $composableBuilder(column: $table.cfi, builder: (column) => column);

  GeneratedColumn<double> get scrollPct =>
      $composableBuilder(column: $table.scrollPct, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressData,
          $$ReadingProgressTableFilterComposer,
          $$ReadingProgressTableOrderingComposer,
          $$ReadingProgressTableAnnotationComposer,
          $$ReadingProgressTableCreateCompanionBuilder,
          $$ReadingProgressTableUpdateCompanionBuilder,
          (ReadingProgressData, $$ReadingProgressTableReferences),
          ReadingProgressData,
          PrefetchHooks Function({bool bookId, bool chapterId})
        > {
  $$ReadingProgressTableTableManager(
    _$AppDatabase db,
    $ReadingProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapterId = const Value.absent(),
                Value<String?> cfi = const Value.absent(),
                Value<double> scrollPct = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ReadingProgressCompanion(
                id: id,
                bookId: bookId,
                chapterId: chapterId,
                cfi: cfi,
                scrollPct: scrollPct,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                required int chapterId,
                Value<String?> cfi = const Value.absent(),
                Value<double> scrollPct = const Value.absent(),
                required DateTime updatedAt,
              }) => ReadingProgressCompanion.insert(
                id: id,
                bookId: bookId,
                chapterId: chapterId,
                cfi: cfi,
                scrollPct: scrollPct,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$ReadingProgressTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$ReadingProgressTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable:
                                    $$ReadingProgressTableReferences
                                        ._chapterIdTable(db),
                                referencedColumn:
                                    $$ReadingProgressTableReferences
                                        ._chapterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingProgressTable,
      ReadingProgressData,
      $$ReadingProgressTableFilterComposer,
      $$ReadingProgressTableOrderingComposer,
      $$ReadingProgressTableAnnotationComposer,
      $$ReadingProgressTableCreateCompanionBuilder,
      $$ReadingProgressTableUpdateCompanionBuilder,
      (ReadingProgressData, $$ReadingProgressTableReferences),
      ReadingProgressData,
      PrefetchHooks Function({bool bookId, bool chapterId})
    >;
typedef $$BookmarksTableCreateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      required String uuid,
      required int bookId,
      required int chapterId,
      required String cfi,
      Value<String?> label,
      Value<String?> note,
      required DateTime createdAt,
    });
typedef $$BookmarksTableUpdateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int> bookId,
      Value<int> chapterId,
      Value<String> cfi,
      Value<String?> label,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$BookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark> {
  $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.bookmarks.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias(
        $_aliasNameGenerator(db.bookmarks.chapterId, db.chapters.id),
      );

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<int>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cfi => $composableBuilder(
    column: $table.cfi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cfi => $composableBuilder(
    column: $table.cfi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get cfi =>
      $composableBuilder(column: $table.cfi, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (Bookmark, $$BookmarksTableReferences),
          Bookmark,
          PrefetchHooks Function({bool bookId, bool chapterId})
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapterId = const Value.absent(),
                Value<String> cfi = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BookmarksCompanion(
                id: id,
                uuid: uuid,
                bookId: bookId,
                chapterId: chapterId,
                cfi: cfi,
                label: label,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int bookId,
                required int chapterId,
                required String cfi,
                Value<String?> label = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
              }) => BookmarksCompanion.insert(
                id: id,
                uuid: uuid,
                bookId: bookId,
                chapterId: chapterId,
                cfi: cfi,
                label: label,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookmarksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$BookmarksTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$BookmarksTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable: $$BookmarksTableReferences
                                    ._chapterIdTable(db),
                                referencedColumn: $$BookmarksTableReferences
                                    ._chapterIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (Bookmark, $$BookmarksTableReferences),
      Bookmark,
      PrefetchHooks Function({bool bookId, bool chapterId})
    >;
typedef $$TranslationUnitsTableCreateCompanionBuilder =
    TranslationUnitsCompanion Function({
      Value<int> id,
      required int chapterId,
      required String nodePath,
      required int sequenceIndex,
      required String sourceTextHash,
    });
typedef $$TranslationUnitsTableUpdateCompanionBuilder =
    TranslationUnitsCompanion Function({
      Value<int> id,
      Value<int> chapterId,
      Value<String> nodePath,
      Value<int> sequenceIndex,
      Value<String> sourceTextHash,
    });

final class $$TranslationUnitsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TranslationUnitsTable, TranslationUnit> {
  $$TranslationUnitsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias(
        $_aliasNameGenerator(db.translationUnits.chapterId, db.chapters.id),
      );

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<int>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HighlightsTable, List<Highlight>>
  _highlightsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.highlights,
    aliasName: $_aliasNameGenerator(
      db.translationUnits.id,
      db.highlights.translationUnitId,
    ),
  );

  $$HighlightsTableProcessedTableManager get highlightsRefs {
    final manager = $$HighlightsTableTableManager(
      $_db,
      $_db.highlights,
    ).filter((f) => f.translationUnitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TranslationUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationUnitsTable> {
  $$TranslationUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodePath => $composableBuilder(
    column: $table.nodePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceIndex => $composableBuilder(
    column: $table.sequenceIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTextHash => $composableBuilder(
    column: $table.sourceTextHash,
    builder: (column) => ColumnFilters(column),
  );

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> highlightsRefs(
    Expression<bool> Function($$HighlightsTableFilterComposer f) f,
  ) {
    final $$HighlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.translationUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableFilterComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TranslationUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationUnitsTable> {
  $$TranslationUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodePath => $composableBuilder(
    column: $table.nodePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceIndex => $composableBuilder(
    column: $table.sequenceIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTextHash => $composableBuilder(
    column: $table.sourceTextHash,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TranslationUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationUnitsTable> {
  $$TranslationUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nodePath =>
      $composableBuilder(column: $table.nodePath, builder: (column) => column);

  GeneratedColumn<int> get sequenceIndex => $composableBuilder(
    column: $table.sequenceIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceTextHash => $composableBuilder(
    column: $table.sourceTextHash,
    builder: (column) => column,
  );

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> highlightsRefs<T extends Object>(
    Expression<T> Function($$HighlightsTableAnnotationComposer a) f,
  ) {
    final $$HighlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.translationUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TranslationUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TranslationUnitsTable,
          TranslationUnit,
          $$TranslationUnitsTableFilterComposer,
          $$TranslationUnitsTableOrderingComposer,
          $$TranslationUnitsTableAnnotationComposer,
          $$TranslationUnitsTableCreateCompanionBuilder,
          $$TranslationUnitsTableUpdateCompanionBuilder,
          (TranslationUnit, $$TranslationUnitsTableReferences),
          TranslationUnit,
          PrefetchHooks Function({bool chapterId, bool highlightsRefs})
        > {
  $$TranslationUnitsTableTableManager(
    _$AppDatabase db,
    $TranslationUnitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chapterId = const Value.absent(),
                Value<String> nodePath = const Value.absent(),
                Value<int> sequenceIndex = const Value.absent(),
                Value<String> sourceTextHash = const Value.absent(),
              }) => TranslationUnitsCompanion(
                id: id,
                chapterId: chapterId,
                nodePath: nodePath,
                sequenceIndex: sequenceIndex,
                sourceTextHash: sourceTextHash,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chapterId,
                required String nodePath,
                required int sequenceIndex,
                required String sourceTextHash,
              }) => TranslationUnitsCompanion.insert(
                id: id,
                chapterId: chapterId,
                nodePath: nodePath,
                sequenceIndex: sequenceIndex,
                sourceTextHash: sourceTextHash,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TranslationUnitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chapterId = false, highlightsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (highlightsRefs) db.highlights],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable:
                                    $$TranslationUnitsTableReferences
                                        ._chapterIdTable(db),
                                referencedColumn:
                                    $$TranslationUnitsTableReferences
                                        ._chapterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (highlightsRefs)
                    await $_getPrefetchedData<
                      TranslationUnit,
                      $TranslationUnitsTable,
                      Highlight
                    >(
                      currentTable: table,
                      referencedTable: $$TranslationUnitsTableReferences
                          ._highlightsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TranslationUnitsTableReferences(
                            db,
                            table,
                            p0,
                          ).highlightsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.translationUnitId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TranslationUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TranslationUnitsTable,
      TranslationUnit,
      $$TranslationUnitsTableFilterComposer,
      $$TranslationUnitsTableOrderingComposer,
      $$TranslationUnitsTableAnnotationComposer,
      $$TranslationUnitsTableCreateCompanionBuilder,
      $$TranslationUnitsTableUpdateCompanionBuilder,
      (TranslationUnit, $$TranslationUnitsTableReferences),
      TranslationUnit,
      PrefetchHooks Function({bool chapterId, bool highlightsRefs})
    >;
typedef $$HighlightsTableCreateCompanionBuilder =
    HighlightsCompanion Function({
      Value<int> id,
      required String uuid,
      required int bookId,
      required int chapterId,
      Value<int?> translationUnitId,
      required String startAnchor,
      required String endAnchor,
      Value<String> color,
      Value<String?> note,
      required DateTime createdAt,
    });
typedef $$HighlightsTableUpdateCompanionBuilder =
    HighlightsCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int> bookId,
      Value<int> chapterId,
      Value<int?> translationUnitId,
      Value<String> startAnchor,
      Value<String> endAnchor,
      Value<String> color,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$HighlightsTableReferences
    extends BaseReferences<_$AppDatabase, $HighlightsTable, Highlight> {
  $$HighlightsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.highlights.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias(
        $_aliasNameGenerator(db.highlights.chapterId, db.chapters.id),
      );

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<int>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TranslationUnitsTable _translationUnitIdTable(_$AppDatabase db) =>
      db.translationUnits.createAlias(
        $_aliasNameGenerator(
          db.highlights.translationUnitId,
          db.translationUnits.id,
        ),
      );

  $$TranslationUnitsTableProcessedTableManager? get translationUnitId {
    final $_column = $_itemColumn<int>('translation_unit_id');
    if ($_column == null) return null;
    final manager = $$TranslationUnitsTableTableManager(
      $_db,
      $_db.translationUnits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_translationUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HighlightsTableFilterComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startAnchor => $composableBuilder(
    column: $table.startAnchor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endAnchor => $composableBuilder(
    column: $table.endAnchor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TranslationUnitsTableFilterComposer get translationUnitId {
    final $$TranslationUnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationUnitId,
      referencedTable: $db.translationUnits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TranslationUnitsTableFilterComposer(
            $db: $db,
            $table: $db.translationUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startAnchor => $composableBuilder(
    column: $table.startAnchor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endAnchor => $composableBuilder(
    column: $table.endAnchor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TranslationUnitsTableOrderingComposer get translationUnitId {
    final $$TranslationUnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationUnitId,
      referencedTable: $db.translationUnits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TranslationUnitsTableOrderingComposer(
            $db: $db,
            $table: $db.translationUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get startAnchor => $composableBuilder(
    column: $table.startAnchor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endAnchor =>
      $composableBuilder(column: $table.endAnchor, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TranslationUnitsTableAnnotationComposer get translationUnitId {
    final $$TranslationUnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationUnitId,
      referencedTable: $db.translationUnits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TranslationUnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.translationUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HighlightsTable,
          Highlight,
          $$HighlightsTableFilterComposer,
          $$HighlightsTableOrderingComposer,
          $$HighlightsTableAnnotationComposer,
          $$HighlightsTableCreateCompanionBuilder,
          $$HighlightsTableUpdateCompanionBuilder,
          (Highlight, $$HighlightsTableReferences),
          Highlight,
          PrefetchHooks Function({
            bool bookId,
            bool chapterId,
            bool translationUnitId,
          })
        > {
  $$HighlightsTableTableManager(_$AppDatabase db, $HighlightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HighlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HighlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HighlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapterId = const Value.absent(),
                Value<int?> translationUnitId = const Value.absent(),
                Value<String> startAnchor = const Value.absent(),
                Value<String> endAnchor = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HighlightsCompanion(
                id: id,
                uuid: uuid,
                bookId: bookId,
                chapterId: chapterId,
                translationUnitId: translationUnitId,
                startAnchor: startAnchor,
                endAnchor: endAnchor,
                color: color,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int bookId,
                required int chapterId,
                Value<int?> translationUnitId = const Value.absent(),
                required String startAnchor,
                required String endAnchor,
                Value<String> color = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
              }) => HighlightsCompanion.insert(
                id: id,
                uuid: uuid,
                bookId: bookId,
                chapterId: chapterId,
                translationUnitId: translationUnitId,
                startAnchor: startAnchor,
                endAnchor: endAnchor,
                color: color,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HighlightsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bookId = false, chapterId = false, translationUnitId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable: $$HighlightsTableReferences
                                        ._bookIdTable(db),
                                    referencedColumn:
                                        $$HighlightsTableReferences
                                            ._bookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (chapterId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.chapterId,
                                    referencedTable: $$HighlightsTableReferences
                                        ._chapterIdTable(db),
                                    referencedColumn:
                                        $$HighlightsTableReferences
                                            ._chapterIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (translationUnitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.translationUnitId,
                                    referencedTable: $$HighlightsTableReferences
                                        ._translationUnitIdTable(db),
                                    referencedColumn:
                                        $$HighlightsTableReferences
                                            ._translationUnitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$HighlightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HighlightsTable,
      Highlight,
      $$HighlightsTableFilterComposer,
      $$HighlightsTableOrderingComposer,
      $$HighlightsTableAnnotationComposer,
      $$HighlightsTableCreateCompanionBuilder,
      $$HighlightsTableUpdateCompanionBuilder,
      (Highlight, $$HighlightsTableReferences),
      Highlight,
      PrefetchHooks Function({
        bool bookId,
        bool chapterId,
        bool translationUnitId,
      })
    >;
typedef $$TranslationCacheTableCreateCompanionBuilder =
    TranslationCacheCompanion Function({
      Value<int> id,
      required String sourceLanguage,
      required String targetLanguage,
      Value<String?> sourceText,
      required String sourceTextHash,
      required String translatedText,
      required String provider,
      required String providerVersion,
      Value<String> style,
      Value<int> hitCount,
      required DateTime createdAt,
      required DateTime lastUsedAt,
    });
typedef $$TranslationCacheTableUpdateCompanionBuilder =
    TranslationCacheCompanion Function({
      Value<int> id,
      Value<String> sourceLanguage,
      Value<String> targetLanguage,
      Value<String?> sourceText,
      Value<String> sourceTextHash,
      Value<String> translatedText,
      Value<String> provider,
      Value<String> providerVersion,
      Value<String> style,
      Value<int> hitCount,
      Value<DateTime> createdAt,
      Value<DateTime> lastUsedAt,
    });

class $$TranslationCacheTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationCacheTable> {
  $$TranslationCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTextHash => $composableBuilder(
    column: $table.sourceTextHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translatedText => $composableBuilder(
    column: $table.translatedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerVersion => $composableBuilder(
    column: $table.providerVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get style => $composableBuilder(
    column: $table.style,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hitCount => $composableBuilder(
    column: $table.hitCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TranslationCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationCacheTable> {
  $$TranslationCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTextHash => $composableBuilder(
    column: $table.sourceTextHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translatedText => $composableBuilder(
    column: $table.translatedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerVersion => $composableBuilder(
    column: $table.providerVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get style => $composableBuilder(
    column: $table.style,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hitCount => $composableBuilder(
    column: $table.hitCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TranslationCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationCacheTable> {
  $$TranslationCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceTextHash => $composableBuilder(
    column: $table.sourceTextHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translatedText => $composableBuilder(
    column: $table.translatedText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get providerVersion => $composableBuilder(
    column: $table.providerVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get style =>
      $composableBuilder(column: $table.style, builder: (column) => column);

  GeneratedColumn<int> get hitCount =>
      $composableBuilder(column: $table.hitCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );
}

class $$TranslationCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TranslationCacheTable,
          TranslationCacheData,
          $$TranslationCacheTableFilterComposer,
          $$TranslationCacheTableOrderingComposer,
          $$TranslationCacheTableAnnotationComposer,
          $$TranslationCacheTableCreateCompanionBuilder,
          $$TranslationCacheTableUpdateCompanionBuilder,
          (
            TranslationCacheData,
            BaseReferences<
              _$AppDatabase,
              $TranslationCacheTable,
              TranslationCacheData
            >,
          ),
          TranslationCacheData,
          PrefetchHooks Function()
        > {
  $$TranslationCacheTableTableManager(
    _$AppDatabase db,
    $TranslationCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sourceLanguage = const Value.absent(),
                Value<String> targetLanguage = const Value.absent(),
                Value<String?> sourceText = const Value.absent(),
                Value<String> sourceTextHash = const Value.absent(),
                Value<String> translatedText = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> providerVersion = const Value.absent(),
                Value<String> style = const Value.absent(),
                Value<int> hitCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
              }) => TranslationCacheCompanion(
                id: id,
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage,
                sourceText: sourceText,
                sourceTextHash: sourceTextHash,
                translatedText: translatedText,
                provider: provider,
                providerVersion: providerVersion,
                style: style,
                hitCount: hitCount,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sourceLanguage,
                required String targetLanguage,
                Value<String?> sourceText = const Value.absent(),
                required String sourceTextHash,
                required String translatedText,
                required String provider,
                required String providerVersion,
                Value<String> style = const Value.absent(),
                Value<int> hitCount = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastUsedAt,
              }) => TranslationCacheCompanion.insert(
                id: id,
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage,
                sourceText: sourceText,
                sourceTextHash: sourceTextHash,
                translatedText: translatedText,
                provider: provider,
                providerVersion: providerVersion,
                style: style,
                hitCount: hitCount,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TranslationCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TranslationCacheTable,
      TranslationCacheData,
      $$TranslationCacheTableFilterComposer,
      $$TranslationCacheTableOrderingComposer,
      $$TranslationCacheTableAnnotationComposer,
      $$TranslationCacheTableCreateCompanionBuilder,
      $$TranslationCacheTableUpdateCompanionBuilder,
      (
        TranslationCacheData,
        BaseReferences<
          _$AppDatabase,
          $TranslationCacheTable,
          TranslationCacheData
        >,
      ),
      TranslationCacheData,
      PrefetchHooks Function()
    >;
typedef $$GlossaryTermsTableCreateCompanionBuilder =
    GlossaryTermsCompanion Function({
      Value<int> id,
      Value<int?> bookId,
      required String sourceTerm,
      required String preferredTranslation,
      required String sourceLanguage,
      required String targetLanguage,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$GlossaryTermsTableUpdateCompanionBuilder =
    GlossaryTermsCompanion Function({
      Value<int> id,
      Value<int?> bookId,
      Value<String> sourceTerm,
      Value<String> preferredTranslation,
      Value<String> sourceLanguage,
      Value<String> targetLanguage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$GlossaryTermsTableReferences
    extends BaseReferences<_$AppDatabase, $GlossaryTermsTable, GlossaryTerm> {
  $$GlossaryTermsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.glossaryTerms.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager? get bookId {
    final $_column = $_itemColumn<int>('book_id');
    if ($_column == null) return null;
    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GlossaryTermsTableFilterComposer
    extends Composer<_$AppDatabase, $GlossaryTermsTable> {
  $$GlossaryTermsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTerm => $composableBuilder(
    column: $table.sourceTerm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredTranslation => $composableBuilder(
    column: $table.preferredTranslation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GlossaryTermsTableOrderingComposer
    extends Composer<_$AppDatabase, $GlossaryTermsTable> {
  $$GlossaryTermsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTerm => $composableBuilder(
    column: $table.sourceTerm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredTranslation => $composableBuilder(
    column: $table.preferredTranslation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GlossaryTermsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GlossaryTermsTable> {
  $$GlossaryTermsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceTerm => $composableBuilder(
    column: $table.sourceTerm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredTranslation => $composableBuilder(
    column: $table.preferredTranslation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GlossaryTermsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GlossaryTermsTable,
          GlossaryTerm,
          $$GlossaryTermsTableFilterComposer,
          $$GlossaryTermsTableOrderingComposer,
          $$GlossaryTermsTableAnnotationComposer,
          $$GlossaryTermsTableCreateCompanionBuilder,
          $$GlossaryTermsTableUpdateCompanionBuilder,
          (GlossaryTerm, $$GlossaryTermsTableReferences),
          GlossaryTerm,
          PrefetchHooks Function({bool bookId})
        > {
  $$GlossaryTermsTableTableManager(_$AppDatabase db, $GlossaryTermsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GlossaryTermsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GlossaryTermsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GlossaryTermsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> bookId = const Value.absent(),
                Value<String> sourceTerm = const Value.absent(),
                Value<String> preferredTranslation = const Value.absent(),
                Value<String> sourceLanguage = const Value.absent(),
                Value<String> targetLanguage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GlossaryTermsCompanion(
                id: id,
                bookId: bookId,
                sourceTerm: sourceTerm,
                preferredTranslation: preferredTranslation,
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> bookId = const Value.absent(),
                required String sourceTerm,
                required String preferredTranslation,
                required String sourceLanguage,
                required String targetLanguage,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => GlossaryTermsCompanion.insert(
                id: id,
                bookId: bookId,
                sourceTerm: sourceTerm,
                preferredTranslation: preferredTranslation,
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GlossaryTermsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$GlossaryTermsTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$GlossaryTermsTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GlossaryTermsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GlossaryTermsTable,
      GlossaryTerm,
      $$GlossaryTermsTableFilterComposer,
      $$GlossaryTermsTableOrderingComposer,
      $$GlossaryTermsTableAnnotationComposer,
      $$GlossaryTermsTableCreateCompanionBuilder,
      $$GlossaryTermsTableUpdateCompanionBuilder,
      (GlossaryTerm, $$GlossaryTermsTableReferences),
      GlossaryTerm,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$BookSettingsTableCreateCompanionBuilder =
    BookSettingsCompanion Function({
      Value<int> id,
      required int bookId,
      Value<double> fontSize,
      Value<String> readingTheme,
      Value<bool> isTranslationEnabled,
      Value<String> translationStyle,
      Value<String> fontFamily,
      Value<int> lastPageIndex,
      Value<double> lastScrollOffset,
      Value<int> dailyGoalMinutes,
      required DateTime updatedAt,
    });
typedef $$BookSettingsTableUpdateCompanionBuilder =
    BookSettingsCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<double> fontSize,
      Value<String> readingTheme,
      Value<bool> isTranslationEnabled,
      Value<String> translationStyle,
      Value<String> fontFamily,
      Value<int> lastPageIndex,
      Value<double> lastScrollOffset,
      Value<int> dailyGoalMinutes,
      Value<DateTime> updatedAt,
    });

final class $$BookSettingsTableReferences
    extends BaseReferences<_$AppDatabase, $BookSettingsTable, BookSetting> {
  $$BookSettingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.bookSettings.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $BookSettingsTable> {
  $$BookSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readingTheme => $composableBuilder(
    column: $table.readingTheme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTranslationEnabled => $composableBuilder(
    column: $table.isTranslationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationStyle => $composableBuilder(
    column: $table.translationStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPageIndex => $composableBuilder(
    column: $table.lastPageIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastScrollOffset => $composableBuilder(
    column: $table.lastScrollOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BookSettingsTable> {
  $$BookSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readingTheme => $composableBuilder(
    column: $table.readingTheme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTranslationEnabled => $composableBuilder(
    column: $table.isTranslationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationStyle => $composableBuilder(
    column: $table.translationStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPageIndex => $composableBuilder(
    column: $table.lastPageIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastScrollOffset => $composableBuilder(
    column: $table.lastScrollOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookSettingsTable> {
  $$BookSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  GeneratedColumn<String> get readingTheme => $composableBuilder(
    column: $table.readingTheme,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTranslationEnabled => $composableBuilder(
    column: $table.isTranslationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationStyle => $composableBuilder(
    column: $table.translationStyle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastPageIndex => $composableBuilder(
    column: $table.lastPageIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastScrollOffset => $composableBuilder(
    column: $table.lastScrollOffset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookSettingsTable,
          BookSetting,
          $$BookSettingsTableFilterComposer,
          $$BookSettingsTableOrderingComposer,
          $$BookSettingsTableAnnotationComposer,
          $$BookSettingsTableCreateCompanionBuilder,
          $$BookSettingsTableUpdateCompanionBuilder,
          (BookSetting, $$BookSettingsTableReferences),
          BookSetting,
          PrefetchHooks Function({bool bookId})
        > {
  $$BookSettingsTableTableManager(_$AppDatabase db, $BookSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<String> readingTheme = const Value.absent(),
                Value<bool> isTranslationEnabled = const Value.absent(),
                Value<String> translationStyle = const Value.absent(),
                Value<String> fontFamily = const Value.absent(),
                Value<int> lastPageIndex = const Value.absent(),
                Value<double> lastScrollOffset = const Value.absent(),
                Value<int> dailyGoalMinutes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BookSettingsCompanion(
                id: id,
                bookId: bookId,
                fontSize: fontSize,
                readingTheme: readingTheme,
                isTranslationEnabled: isTranslationEnabled,
                translationStyle: translationStyle,
                fontFamily: fontFamily,
                lastPageIndex: lastPageIndex,
                lastScrollOffset: lastScrollOffset,
                dailyGoalMinutes: dailyGoalMinutes,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                Value<double> fontSize = const Value.absent(),
                Value<String> readingTheme = const Value.absent(),
                Value<bool> isTranslationEnabled = const Value.absent(),
                Value<String> translationStyle = const Value.absent(),
                Value<String> fontFamily = const Value.absent(),
                Value<int> lastPageIndex = const Value.absent(),
                Value<double> lastScrollOffset = const Value.absent(),
                Value<int> dailyGoalMinutes = const Value.absent(),
                required DateTime updatedAt,
              }) => BookSettingsCompanion.insert(
                id: id,
                bookId: bookId,
                fontSize: fontSize,
                readingTheme: readingTheme,
                isTranslationEnabled: isTranslationEnabled,
                translationStyle: translationStyle,
                fontFamily: fontFamily,
                lastPageIndex: lastPageIndex,
                lastScrollOffset: lastScrollOffset,
                dailyGoalMinutes: dailyGoalMinutes,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$BookSettingsTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$BookSettingsTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookSettingsTable,
      BookSetting,
      $$BookSettingsTableFilterComposer,
      $$BookSettingsTableOrderingComposer,
      $$BookSettingsTableAnnotationComposer,
      $$BookSettingsTableCreateCompanionBuilder,
      $$BookSettingsTableUpdateCompanionBuilder,
      (BookSetting, $$BookSettingsTableReferences),
      BookSetting,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$ReadingSessionsTableCreateCompanionBuilder =
    ReadingSessionsCompanion Function({
      Value<int> id,
      required int bookId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> durationSeconds,
      Value<int> chaptersRead,
      Value<int> wordsTranslated,
      Value<int> wordsRead,
    });
typedef $$ReadingSessionsTableUpdateCompanionBuilder =
    ReadingSessionsCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> durationSeconds,
      Value<int> chaptersRead,
      Value<int> wordsTranslated,
      Value<int> wordsRead,
    });

final class $$ReadingSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReadingSessionsTable, ReadingSession> {
  $$ReadingSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.readingSessions.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chaptersRead => $composableBuilder(
    column: $table.chaptersRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordsTranslated => $composableBuilder(
    column: $table.wordsTranslated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordsRead => $composableBuilder(
    column: $table.wordsRead,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chaptersRead => $composableBuilder(
    column: $table.chaptersRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordsTranslated => $composableBuilder(
    column: $table.wordsTranslated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordsRead => $composableBuilder(
    column: $table.wordsRead,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chaptersRead => $composableBuilder(
    column: $table.chaptersRead,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wordsTranslated => $composableBuilder(
    column: $table.wordsTranslated,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wordsRead =>
      $composableBuilder(column: $table.wordsRead, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingSessionsTable,
          ReadingSession,
          $$ReadingSessionsTableFilterComposer,
          $$ReadingSessionsTableOrderingComposer,
          $$ReadingSessionsTableAnnotationComposer,
          $$ReadingSessionsTableCreateCompanionBuilder,
          $$ReadingSessionsTableUpdateCompanionBuilder,
          (ReadingSession, $$ReadingSessionsTableReferences),
          ReadingSession,
          PrefetchHooks Function({bool bookId})
        > {
  $$ReadingSessionsTableTableManager(
    _$AppDatabase db,
    $ReadingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> chaptersRead = const Value.absent(),
                Value<int> wordsTranslated = const Value.absent(),
                Value<int> wordsRead = const Value.absent(),
              }) => ReadingSessionsCompanion(
                id: id,
                bookId: bookId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                chaptersRead: chaptersRead,
                wordsTranslated: wordsTranslated,
                wordsRead: wordsRead,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> chaptersRead = const Value.absent(),
                Value<int> wordsTranslated = const Value.absent(),
                Value<int> wordsRead = const Value.absent(),
              }) => ReadingSessionsCompanion.insert(
                id: id,
                bookId: bookId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                chaptersRead: chaptersRead,
                wordsTranslated: wordsTranslated,
                wordsRead: wordsRead,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$ReadingSessionsTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$ReadingSessionsTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingSessionsTable,
      ReadingSession,
      $$ReadingSessionsTableFilterComposer,
      $$ReadingSessionsTableOrderingComposer,
      $$ReadingSessionsTableAnnotationComposer,
      $$ReadingSessionsTableCreateCompanionBuilder,
      $$ReadingSessionsTableUpdateCompanionBuilder,
      (ReadingSession, $$ReadingSessionsTableReferences),
      ReadingSession,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$CollectionsTableCreateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime createdAt,
    });
typedef $$CollectionsTableUpdateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

final class $$CollectionsTableReferences
    extends BaseReferences<_$AppDatabase, $CollectionsTable, Collection> {
  $$CollectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BookCollectionsTable, List<BookCollection>>
  _bookCollectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookCollections,
    aliasName: $_aliasNameGenerator(
      db.collections.id,
      db.bookCollections.collectionId,
    ),
  );

  $$BookCollectionsTableProcessedTableManager get bookCollectionsRefs {
    final manager = $$BookCollectionsTableTableManager(
      $_db,
      $_db.bookCollections,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bookCollectionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bookCollectionsRefs(
    Expression<bool> Function($$BookCollectionsTableFilterComposer f) f,
  ) {
    final $$BookCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookCollections,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.bookCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> bookCollectionsRefs<T extends Object>(
    Expression<T> Function($$BookCollectionsTableAnnotationComposer a) f,
  ) {
    final $$BookCollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookCollections,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookCollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.bookCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionsTable,
          Collection,
          $$CollectionsTableFilterComposer,
          $$CollectionsTableOrderingComposer,
          $$CollectionsTableAnnotationComposer,
          $$CollectionsTableCreateCompanionBuilder,
          $$CollectionsTableUpdateCompanionBuilder,
          (Collection, $$CollectionsTableReferences),
          Collection,
          PrefetchHooks Function({bool bookCollectionsRefs})
        > {
  $$CollectionsTableTableManager(_$AppDatabase db, $CollectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CollectionsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime createdAt,
              }) => CollectionsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookCollectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bookCollectionsRefs) db.bookCollections,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bookCollectionsRefs)
                    await $_getPrefetchedData<
                      Collection,
                      $CollectionsTable,
                      BookCollection
                    >(
                      currentTable: table,
                      referencedTable: $$CollectionsTableReferences
                          ._bookCollectionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CollectionsTableReferences(
                            db,
                            table,
                            p0,
                          ).bookCollectionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.collectionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionsTable,
      Collection,
      $$CollectionsTableFilterComposer,
      $$CollectionsTableOrderingComposer,
      $$CollectionsTableAnnotationComposer,
      $$CollectionsTableCreateCompanionBuilder,
      $$CollectionsTableUpdateCompanionBuilder,
      (Collection, $$CollectionsTableReferences),
      Collection,
      PrefetchHooks Function({bool bookCollectionsRefs})
    >;
typedef $$BookCollectionsTableCreateCompanionBuilder =
    BookCollectionsCompanion Function({
      Value<int> id,
      required int bookId,
      required int collectionId,
      required DateTime addedAt,
    });
typedef $$BookCollectionsTableUpdateCompanionBuilder =
    BookCollectionsCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<int> collectionId,
      Value<DateTime> addedAt,
    });

final class $$BookCollectionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $BookCollectionsTable, BookCollection> {
  $$BookCollectionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.bookCollections.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CollectionsTable _collectionIdTable(_$AppDatabase db) =>
      db.collections.createAlias(
        $_aliasNameGenerator(
          db.bookCollections.collectionId,
          db.collections.id,
        ),
      );

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookCollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $BookCollectionsTable> {
  $$BookCollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookCollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $BookCollectionsTable> {
  $$BookCollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookCollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookCollectionsTable> {
  $$BookCollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookCollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookCollectionsTable,
          BookCollection,
          $$BookCollectionsTableFilterComposer,
          $$BookCollectionsTableOrderingComposer,
          $$BookCollectionsTableAnnotationComposer,
          $$BookCollectionsTableCreateCompanionBuilder,
          $$BookCollectionsTableUpdateCompanionBuilder,
          (BookCollection, $$BookCollectionsTableReferences),
          BookCollection,
          PrefetchHooks Function({bool bookId, bool collectionId})
        > {
  $$BookCollectionsTableTableManager(
    _$AppDatabase db,
    $BookCollectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookCollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookCollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookCollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> collectionId = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => BookCollectionsCompanion(
                id: id,
                bookId: bookId,
                collectionId: collectionId,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                required int collectionId,
                required DateTime addedAt,
              }) => BookCollectionsCompanion.insert(
                id: id,
                bookId: bookId,
                collectionId: collectionId,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookCollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, collectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$BookCollectionsTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$BookCollectionsTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (collectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.collectionId,
                                referencedTable:
                                    $$BookCollectionsTableReferences
                                        ._collectionIdTable(db),
                                referencedColumn:
                                    $$BookCollectionsTableReferences
                                        ._collectionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookCollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookCollectionsTable,
      BookCollection,
      $$BookCollectionsTableFilterComposer,
      $$BookCollectionsTableOrderingComposer,
      $$BookCollectionsTableAnnotationComposer,
      $$BookCollectionsTableCreateCompanionBuilder,
      $$BookCollectionsTableUpdateCompanionBuilder,
      (BookCollection, $$BookCollectionsTableReferences),
      BookCollection,
      PrefetchHooks Function({bool bookId, bool collectionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$ReadingProgressTableTableManager get readingProgress =>
      $$ReadingProgressTableTableManager(_db, _db.readingProgress);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$TranslationUnitsTableTableManager get translationUnits =>
      $$TranslationUnitsTableTableManager(_db, _db.translationUnits);
  $$HighlightsTableTableManager get highlights =>
      $$HighlightsTableTableManager(_db, _db.highlights);
  $$TranslationCacheTableTableManager get translationCache =>
      $$TranslationCacheTableTableManager(_db, _db.translationCache);
  $$GlossaryTermsTableTableManager get glossaryTerms =>
      $$GlossaryTermsTableTableManager(_db, _db.glossaryTerms);
  $$BookSettingsTableTableManager get bookSettings =>
      $$BookSettingsTableTableManager(_db, _db.bookSettings);
  $$ReadingSessionsTableTableManager get readingSessions =>
      $$ReadingSessionsTableTableManager(_db, _db.readingSessions);
  $$CollectionsTableTableManager get collections =>
      $$CollectionsTableTableManager(_db, _db.collections);
  $$BookCollectionsTableTableManager get bookCollections =>
      $$BookCollectionsTableTableManager(_db, _db.bookCollections);
}
