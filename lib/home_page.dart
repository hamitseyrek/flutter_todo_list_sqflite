import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({ Key? key }) : super(key: key);

  var _myFormKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes List'),),
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
      FloatingActionButton(onPressed: (){
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.4),
          barrierDismissible: false,
          builder: (context){
          return SimpleDialog(
            title: Text('Add Category', style: TextStyle(color: Theme.of(context).primaryColor)),
            children: [
              Form(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(alignLabelWithHint: true,
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                validator: (enterName){
                  if (enterName == null) {
                    return 'Category name cannot be null';
                  } else if(enterName.length<3){
                    return 'Category name cannot be less than 3 characters';
                  }
                },
                ),
              ),
              key: _myFormKey,
              
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(onPressed: (){Navigator.pop(context);}, style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orangeAccent)), child: Text('Cancel', style: TextStyle(color: Colors.white),)),
                  ElevatedButton(onPressed: (){}, style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.greenAccent)), child: Text('Save', style: TextStyle(color: Colors.white),)),
                ],
              ),
            ],
            shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
          );
        });
      }, child: Icon(Icons.add_circle), tooltip: 'Add Category', mini: true,),
      FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (context){
          return SimpleDialog(
            title: Text('Add Note', style: TextStyle(color: Theme.of(context).primaryColor),),
            children: [
              Form(child: TextFormField(
                decoration: InputDecoration(alignLabelWithHint: true,
                labelText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              ))
            ],
          );
        });
      }, child: Icon(Icons.add), tooltip: 'Add Note',),
    ],),
    body: Container(child: Center(child: Text('data'),),),
    );
  }
}