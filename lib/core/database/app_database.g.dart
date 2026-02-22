// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bannerUrlMeta =
      const VerificationMeta('bannerUrl');
  @override
  late final GeneratedColumn<String> bannerUrl = GeneratedColumn<String>(
      'banner_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
      'genre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, bannerUrl, genre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<Favorite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('banner_url')) {
      context.handle(_bannerUrlMeta,
          bannerUrl.isAcceptableOrUnknown(data['banner_url']!, _bannerUrlMeta));
    } else if (isInserting) {
      context.missing(_bannerUrlMeta);
    }
    if (data.containsKey('genre')) {
      context.handle(
          _genreMeta, genre.isAcceptableOrUnknown(data['genre']!, _genreMeta));
    } else if (isInserting) {
      context.missing(_genreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      bannerUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}banner_url'])!,
      genre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genre'])!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;
  final String title;
  final String bannerUrl;
  final String genre;
  const Favorite(
      {required this.id,
      required this.title,
      required this.bannerUrl,
      required this.genre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['banner_url'] = Variable<String>(bannerUrl);
    map['genre'] = Variable<String>(genre);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: Value(id),
      title: Value(title),
      bannerUrl: Value(bannerUrl),
      genre: Value(genre),
    );
  }

  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      bannerUrl: serializer.fromJson<String>(json['bannerUrl']),
      genre: serializer.fromJson<String>(json['genre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'bannerUrl': serializer.toJson<String>(bannerUrl),
      'genre': serializer.toJson<String>(genre),
    };
  }

  Favorite copyWith(
          {int? id, String? title, String? bannerUrl, String? genre}) =>
      Favorite(
        id: id ?? this.id,
        title: title ?? this.title,
        bannerUrl: bannerUrl ?? this.bannerUrl,
        genre: genre ?? this.genre,
      );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      bannerUrl: data.bannerUrl.present ? data.bannerUrl.value : this.bannerUrl,
      genre: data.genre.present ? data.genre.value : this.genre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('genre: $genre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, bannerUrl, genre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.title == this.title &&
          other.bannerUrl == this.bannerUrl &&
          other.genre == this.genre);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> bannerUrl;
  final Value<String> genre;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.genre = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String bannerUrl,
    required String genre,
  })  : title = Value(title),
        bannerUrl = Value(bannerUrl),
        genre = Value(genre);
  static Insertable<Favorite> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? bannerUrl,
    Expression<String>? genre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (bannerUrl != null) 'banner_url': bannerUrl,
      if (genre != null) 'genre': genre,
    });
  }

  FavoritesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? bannerUrl,
      Value<String>? genre}) {
    return FavoritesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      genre: genre ?? this.genre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (bannerUrl.present) {
      map['banner_url'] = Variable<String>(bannerUrl.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('genre: $genre')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favorites];
}

typedef $$FavoritesTableCreateCompanionBuilder = FavoritesCompanion Function({
  Value<int> id,
  required String title,
  required String bannerUrl,
  required String genre,
});
typedef $$FavoritesTableUpdateCompanionBuilder = FavoritesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> bannerUrl,
  Value<String> genre,
});

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bannerUrl => $composableBuilder(
      column: $table.bannerUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnFilters(column));
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bannerUrl => $composableBuilder(
      column: $table.bannerUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnOrderings(column));
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get bannerUrl =>
      $composableBuilder(column: $table.bannerUrl, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);
}

class $$FavoritesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritesTable,
    Favorite,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
    Favorite,
    PrefetchHooks Function()> {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> bannerUrl = const Value.absent(),
            Value<String> genre = const Value.absent(),
          }) =>
              FavoritesCompanion(
            id: id,
            title: title,
            bannerUrl: bannerUrl,
            genre: genre,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String bannerUrl,
            required String genre,
          }) =>
              FavoritesCompanion.insert(
            id: id,
            title: title,
            bannerUrl: bannerUrl,
            genre: genre,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoritesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritesTable,
    Favorite,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
    Favorite,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
}
