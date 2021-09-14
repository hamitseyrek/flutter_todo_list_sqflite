import 'package:flutter/material.dart';
import 'package:flutter_todo_list_sqflite/models/category.dart';
import 'package:flutter_todo_list_sqflite/models/note.dart';
import 'package:flutter_todo_list_sqflite/utils/db_helper.dart';

class AddNote extends StatefulWidget {
  final String title;
  Note? editNote;
  AddNote({required this.title, Key? key}) : super(key: key);
  AddNote.update({required this.editNote, required this.title, Key? key})
      : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  var _myFormKey = GlobalKey<FormState>();
  late List<Category>? _allCategories;
  late DbHelper? dbHelper;
  int onSelectCatId = 1;
  Category? selectedCat;
  int selectedPri = 0;
  String? title, content;
  static var _priority = ['Low', 'Middle', 'High'];

  @override
  void initState() {
    super.initState();
    _allCategories = [];
    dbHelper = DbHelper();

    dbHelper!.getCategories().then((categoryMapList) {
      for (Map<String, dynamic> map in categoryMapList) {
        _allCategories!.add(Category.fromMap(map));
      }

      setState(() {
        if (widget.editNote != null) {
          selectedCat = _allCategories![widget.editNote!.categoryId!];
          selectedPri = widget.editNote!.priority!;
          onSelectCatId = _allCategories![widget.editNote!.categoryId!].id!;
        } else {
          selectedCat = _allCategories![0];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Text(widget.title),
          ],
        ),
      ),
      body: _allCategories!.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Form(
                key: _myFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Category:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Category>(
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
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.only(left: 30, right: 15),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.editNote != null
                            ? widget.editNote!.title
                            : "",
                        validator: (value) {
                          if (value!.length < 3) {
                            return 'Title value min length mus be 3';
                          }
                        },
                        onSaved: (value) {
                          title = value!;
                        },
                        decoration: InputDecoration(
                          hintText: 'Note Title',
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.editNote != null
                            ? widget.editNote!.description
                            : "",
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Note Content',
                          labelText: 'Content',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          content = value!;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Priority:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: selectedPri,
                              onChanged: (value) {
                                setState(() {
                                  selectedPri = value!;
                                });
                              },
                              items: _priority.map((oncelik) {
                                return DropdownMenuItem<int>(
                                  child: Text(
                                    oncelik,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  value: _priority.indexOf(oncelik),
                                );
                              }).toList(),
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.only(left: 30, right: 15),
                        ),
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.orange.shade400),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_myFormKey.currentState!.validate()) {
                              _myFormKey.currentState!.save();
                              var nowDate = DateTime.now();
                              widget.editNote != null
                                  ? dbHelper!
                                      .noteUpdate(Note.withID(
                                          widget.editNote!.id,
                                          selectedCat!.id,
                                          title,
                                          content,
                                          nowDate.toString(),
                                          selectedPri))
                                      .then((value) {
                                      if (value != 0) {
                                        Navigator.pop(context);
                                      }
                                    })
                                  : dbHelper!
                                      .noteCreate(Note(
                                          selectedCat!.id,
                                          title,
                                          content,
                                          nowDate.toString(),
                                          selectedPri))
                                      .then((value) {
                                      if (value != 0) {
                                        Navigator.pop(context);
                                      }
                                    });
                            }
                          },
                          child:
                              Text(widget.editNote != null ? 'Update' : "Save"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.green.shade400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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

/**
 * Form(
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
 */