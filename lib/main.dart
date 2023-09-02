
import 'package:flutter/material.dart';
import 'package:todo_list/todo.dart';
// hi
Future<void> main() async {


  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build (BuildContext context) {
        return  MaterialApp( home:Todo(),
          debugShowCheckedModeBanner: false,

        );
  }
}