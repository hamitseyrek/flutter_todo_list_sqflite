import 'package:flutter/services.dart';
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


Future<Database> _getDatabase() async{
  if (_database == null) {
    _database = await _initializeDatabase();
    return _database!;
  } else {
    return _database!;
  }
}


Future<Database> _initializeDatabase () async{
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

getCategories() async {
  var db = await _getDatabase();
  var result = await db.query('category');
  print(result);
}

}