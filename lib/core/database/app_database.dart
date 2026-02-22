import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Favorites extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get bannerUrl => text()();
  TextColumn get genre => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Favorites])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Favorite>> getAllFavorites() => select(favorites).get();

  Stream<List<Favorite>> watchAllFavorites() => select(favorites).watch();

  Future<void> addFavorite(FavoritesCompanion entry) =>
      into(favorites).insertOnConflictUpdate(entry);

  Future<void> removeFavorite(int movieId) =>
      (delete(favorites)..where((t) => t.id.equals(movieId))).go();

  Future<bool> isFavorite(int movieId) async {
    final result = await (select(favorites)
          ..where((t) => t.id.equals(movieId)))
        .getSingleOrNull();
    return result != null;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'movies.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
