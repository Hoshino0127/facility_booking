import 'dart:async';
import 'package:facility_booking/model/SettingsModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  static Database _database;
  static final DbManager db = DbManager._();

  DbManager._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await openDb();

    return _database;
  }

  Future openDb() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), "main.db"),
      version: 1,
      onCreate: (
        db,
        int version,
      ) async {
        await db.execute(
            "CREATE TABLE SettingsPage(id INTEGER PRIMARY KEY, "
            "Lkey TEXT, "
            "EndTime TEXT,"
            "BufferTime TEXT,"
            "BookingSlot TEXT)",
            );
      },
    );
    return database;
  }

  Future<void> insertLKey(Setting Settings) async {

    final db = await database;
    await db.insert(
      'SettingsPage',
      Settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(await Settings);
  }

  Future<List<Setting>> getSettings() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('SettingsPage');
    return List.generate(maps.length, (i) {
      return Setting(
        id: maps[0]['id'],
        Lkey: maps[0]['Lkey'],
        EndTime: maps[0]['EndTime'],
        BufferTime: maps[0]['BufferTime'],
        BookingSlot: maps[0]['BookingSlot'],
      );
    });
  }
}
