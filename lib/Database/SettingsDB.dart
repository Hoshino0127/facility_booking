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
          "CREATE TABLE SettingsPage(id INTEGER PRIMARY KEY autoincrement, "
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
    print("Added: " + Settings.toString());
  }

  Future<List<Setting>> getSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('SettingsPage');
    return List.generate(maps.length, (i) {
      return Setting(
        id: maps[i]['id'],
        Lkey: maps[i]['Lkey'],
        EndTime: maps[i]['EndTime'],
        BufferTime: maps[i]['BufferTime'],
        BookingSlot: maps[i]['BookingSlot'],
      );
    });
  }

  Future<List<Setting>> getSettingsByKey(String LKey) async{
    final db = await database;
    String whereString = 'LKey = ?';
    List<dynamic> whereArgs = [LKey];
    List<Map> maps = await db.query(
      'SettingsPage',
      where: whereString,
      whereArgs: whereArgs
    );
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Setting(
          id: maps[0]['id'],
          Lkey: maps[0]['Lkey'],
          EndTime: maps[0]['EndTime'],
          BufferTime: maps[0]['BufferTime'],
          BookingSlot: maps[0]['BookingSlot'],
        );
      });
    }else{
      return null;
    }
  }

  Future<int> updateSettings(Setting settings) async{
    final db = await database;
    String whereString = 'LKey = ?';
    Map<String,dynamic> rows = {
      'EndTime':settings.EndTime,
      'BufferTime':settings.BufferTime,
      'BookingSlot':settings.BookingSlot
    };
    int updateCount = 0;
    updateCount = await db.update(
        'SettingsPage',
        rows,
        where: whereString,
        whereArgs:[settings.Lkey]
    );

    return updateCount;
  }

  Future<bool> deleteSettings() async{
    try{
      final db = await database;
      await db.rawQuery("DELETE FROM SettingsPage");
      return true;
    }on Exception catch (_){
      return false;
    }

  }
}
