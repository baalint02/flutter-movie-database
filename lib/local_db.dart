import 'package:film_database/data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  late final Future<Database> _db;

  LocalDatabase() {
    _db = _open();
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'films.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE watchlist(id INTEGER PRIMARY KEY, title TEXT, year INTEGER, poster_url TEXT, added_timestamp INTEGER)',
        );
      },
      version: 2,
    );
  }

  Future<void> addToWatchlist(Film film) async {
    final db = await _db;
    final data = {
      'id': film.id,
      'title': film.title,
      'year': film.year,
      'poster_url': film.posterUrl,
      'added_timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    db.insert('watchlist', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFromWatchlist(int id) async {
    final db = await _db;
    await db.delete('watchlist', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Film>> getWatchlist() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'watchlist',
      orderBy: 'added_timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return Film(
        id: maps[i]['id'],
        title: maps[i]['title'],
        year: maps[i]['year'],
        posterUrl: maps[i]['poster_url'],
      );
    });
  }

  Future<bool> isInWatchlist(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'watchlist',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}
