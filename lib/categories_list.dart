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
                      trailing: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () => _deleteCategory(_allCategories[index].id!),
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
    dbHelper.getCategories().then((allCat) {
      for (Map<String, dynamic> map in allCat) {
        _allCategories.add(Category.fromMap(map));
      }
      setState(() {});
    });
  }
}
