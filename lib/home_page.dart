import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_todo_list_sqflite/add_note.dart';
import 'package:flutter_todo_list_sqflite/models/category.dart';
import 'package:flutter_todo_list_sqflite/models/note.dart';
import 'package:flutter_todo_list_sqflite/utils/db_helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DbHelper dbHelper;
  late List<Note>? _allNotes;

  @override
  void initState() {
    super.initState();
    _allNotes = [];
    dbHelper = DbHelper();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes List'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              addCategoryDialog(context);
            },
            child: Icon(Icons.add_circle),
            heroTag: 'Add Category',
            mini: true,
          ),
          FloatingActionButton(
            heroTag: "Add Note",
            onPressed: () {
              _addNote(context);
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: dbHelper.getNotesAsList(),
          builder: (context, AsyncSnapshot<List<Note>> snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              _allNotes = snapShot.data;
              sleep((Duration(milliseconds: 500)));

              return ListView.builder(
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(_allNotes![index].title!.toString()),
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Category:',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _allNotes![index].categoryName.toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Created At:',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    dbHelper.dateFormat(DateTime.parse(
                                        _allNotes![index].date.toString())),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Content: ',
                                    style: TextStyle(
                                        color: Colors.redAccent),
                                  ),
                                  Text(
                                      _allNotes![index].description.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
                itemCount: _allNotes!.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      /*ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_allNotes![index].title!.toString()),
                );
              },
              itemCount: _allNotes!.length,
            ),*/
    );
  }

  addCategoryDialog(BuildContext context) {
    GlobalKey<FormState> _myFormKey = GlobalKey<FormState>();
    String? categoryName;

    return showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
            title: Text('Add Category',
                style: TextStyle(color: Theme.of(context).primaryColor)),
            children: [
              Form(
                key: _myFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (catName) {
                      categoryName = catName!;
                    },
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                    validator: (enterName) {
                      if (enterName == null) {
                        return 'Category name cannot be null';
                      } else if (enterName.length < 3) {
                        return 'Category name cannot be less than 3 characters';
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orangeAccent)),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        if (_myFormKey.currentState!.validate()) {
                          _myFormKey.currentState!.save();
                          dbHelper
                              .categoryCreate(Category(name: categoryName))
                              .then((value) {
                            if (value > 0) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Category succesfull added'),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.greenAccent)),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          );
        });
  }

  _addNote(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (conteat) => AddNote()));
  }
}
