import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class DBHelper {
  static Database? _db;

  static Future<Database> getDB() async {
    if (_db != null) return _db!;

    String path = join(await getDatabasesPath(), "dict.db");

    if (!await File(path).exists()) {
      ByteData data = await rootBundle.load("assets/dict.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }

    _db = await openDatabase(path);
    return _db!;
  }

  static Future<String?> getMeaning(String word) async {
    final db = await getDB();

    var result = await db.query(
      "dictionary",
      where: "word = ?",
      whereArgs: [word.toLowerCase()],
    );

    if (result.isNotEmpty) {
      return result.first["meaning"] as String;
    }
    return null;
  }
}
