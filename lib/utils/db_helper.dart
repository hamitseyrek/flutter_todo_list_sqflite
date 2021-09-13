import 'package:flutter/services.dart';
import 'package:flutter_todo_list_sqflite/models/category.dart';
import 'package:flutter_todo_list_sqflite/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DbHelper {
  static DbHelper? _dbHelper;
  static Database? _database;

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._internal();
      return _dbHelper!;
    } else {
      return _dbHelper!;
    }
  }
  DbHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notes.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notes.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);
  }

/* CRUD for Categories Table */
  getCategories() async {
    var db = await _getDatabase();
    var result = await db.query('categories');
    return result;
  }

  Future<int> categoryCreate(Category category) async {
    var db = await _getDatabase();
    var id = await db.insert('categories', category.toMap());
    return id;
  }

  Future<int> categoryUpdate(Category category) async {
    var db = await _getDatabase();
    var id = await db.update('categories', category.toMap(),
        where: 'id = ?', whereArgs: [category.id]);
    return id;
  }

  Future<int> categoryDelete(int catId) async {
    var db = await _getDatabase();
    var result =
        await db.delete('categories', where: 'id = ?', whereArgs: [catId]);
    return result;
  }
/* Categories finish */

/* CRUD for Notes Table */
  getNotes() async {
    var db = await _getDatabase();
    var result = await db.query('notes', orderBy: 'id DESC');
    return result;
  }

  Future<int> noteCreate(Note note) async {
    var db = await _getDatabase();
    var id = await db.insert('notes', note.toMap());
    return id;
  }

  Future<int> noteUpdate(Note note) async {
    var db = await _getDatabase();
    var id = await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    return id;
  }

  Future<int> noteDelete(int noteId) async {
    var db = await _getDatabase();
    var result = await db.delete('notes', where: 'id = ?', whereArgs: [noteId]);
    return result;
  }
/* Notes finish */

}
