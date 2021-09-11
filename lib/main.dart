import 'package:flutter/material.dart';
import 'package:flutter_todo_list_sqflite/utils/db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
      var dbHelper = DbHelper();

    dbHelper.getCategories();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Text('merhaba'),
    );
  }
}
