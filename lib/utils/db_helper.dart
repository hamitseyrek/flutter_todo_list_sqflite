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
  Future<List<Map<String, dynamic>>> getNotesAsMap() async {
    var db = await _getDatabase();
    var result = await db.rawQuery(
        'select * from notes inner join categories on categories.id = notes.categoryId order by id DESC');
    //query('notes', orderBy: 'id DESC');
    return result;
  }

  Future<List<Note>> getNotesAsList() async {
    var noteMapList = await getNotesAsMap();
    List<Note> noteList = [];
    for (Map<String, dynamic> map in noteMapList) {
      noteList.add(Note.fromMap(map));
    }
    return noteList;
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

  String dateFormat(DateTime dt) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String? month;

    switch (dt.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "Julay";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }

    Duration difference = today.difference(dt);

    if (difference.compareTo(oneDay) < 1) {
      return "Today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (dt.weekday) {
        case 1:
          return "Monday";
        case 2:
          return "Sunday";
        case 3:
          return "Wednesday";
        case 4:
          return "Thursday";
        case 5:
          return "Friday";
        case 6:
          return "Saturday";
        case 7:
          return "Sunday";
      }
    } else if (dt.year == today.year) {
      return '${dt.day} $month';
    } else {
      return '${dt.day} $month ${dt.year}';
    }
    return "";
  }

/* Notes finish */

}
