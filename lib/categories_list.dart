import 'package:flutter/material.dart';
import 'package:flutter_todo_list_sqflite/models/category.dart';
import 'package:flutter_todo_list_sqflite/utils/db_helper.dart';

class Categories extends StatefulWidget {
  Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<Category> _allCategories = [];
  late DbHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    dbHelper.getCategories().then((allCat) {
      for (Map<String, dynamic> map in allCat) {
        _allCategories.add(Category.fromMap(map));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        body: Center(
          child: _allCategories.length < 1
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemBuilder: (contect, index) {
                    return ListTile(
                      title: Text(_allCategories[index].name!),
                      trailing: InkWell(
                        onTap: () => _deleteCategory(_allCategories[index].id!),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () =>
                          _updateCategory(contect, _allCategories[index]),
                      leading: Icon(Icons.category),
                    );
                  },
                  itemCount: _allCategories.length,
                ),
        ),
      ),
    );
  }

  void _deleteCategory(int id) {
    /*
    dbHelper.categoryDelete(id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Category succesfull deleted!'),
          duration: Duration(seconds: 3)));
      setState(() {});
    });
    */
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Kategori Sil ",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Raleway')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Are you sure ?"),
                ButtonBar(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        dbHelper.categoryDelete(id).then((result) {
                          if (result != 0) {
                            setState(() {
                              Navigator.pop(context);
                              _allCategories.remove(result);
                              _updateList();
                            });
                          }
                        });
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _updateList() {
    _allCategories = [];
    dbHelper.getCategories().then((allCat) {
      for (Map<String, dynamic> map in allCat) {
        _allCategories.add(Category.fromMap(map));
      }
      setState(() {});
    });
  }

  _updateCategory(BuildContext context, Category categori) {
    GlobalKey<FormState> _myFormKey = GlobalKey<FormState>();
    String? categoryName;
    return showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
            title: Text('Update Category',
                style: TextStyle(color: Theme.of(context).primaryColor)),
            children: [
              Form(
                key: _myFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: categori.name,
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
                              .categoryUpdate(Category.withID(
                                  id: categori.id, name: categoryName))
                              .then((value) {
                            if (value > 0) {
                              _updateList();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Category succesfull updated'),
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
}
