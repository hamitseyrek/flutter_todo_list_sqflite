import 'package:flutter/material.dart';
import 'package:flutter_todo_list_sqflite/models/category.dart';
import 'package:flutter_todo_list_sqflite/utils/db_helper.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  var _myFormKey = GlobalKey<FormState>();
  late List<Category>? _allCategories;
  late DbHelper? dbHelper;
  int onSelectCatId = 1;
  Category? selectedCat;

  @override
  void initState() {
    super.initState();
    _allCategories = [];
    dbHelper = DbHelper();

    dbHelper!.getCategories().then((categoryMapList) {
      for (Map<String, dynamic> map in categoryMapList) {
        _allCategories!.add(Category.fromMap(map));
      }
      selectedCat = _allCategories![0];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Text('New Note'),
          ],
        ),
      ),
      body: Form(
          key: _myFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Category>(
                      hint: Text("Kategori Seç"),
                      value: selectedCat,
                      items: getCategories(),
                      onChanged: (value) {
                        setState(() {
                          selectedCat = value!;
                          onSelectCatId = value.id!;
                        });
                      },
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.only(left: 30, right: 15),
                ),
              ),
            ],
          )),
    );
  }

  List<DropdownMenuItem<Category>> getCategories() {
    return _allCategories!
        .map((category) => DropdownMenuItem<Category>(
              value: category,
              child: Text(category.name.toString()),
            ))
        .toList();
  }
}
