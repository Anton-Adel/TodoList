import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/shared/cubit/states.dart';

import '../../To_Do/Archive.dart';
import '../../To_Do/Done_task.dart';
import '../../To_Do/New_task.dart';

class TodoCubit extends Cubit<TodoStates>{
  TodoCubit() : super(InitialState());
  static TodoCubit get(context)=> BlocProvider.of(context);


  List<Widget> Screens = [
    new_task(),
    done_task(),
    archive_task(),
  ];

  int current_index = 0;
  void Bottom_Nav_Bar(int index){
    current_index=index;
    emit(MoveInBottomNavBar());
  }

  bool is_showbuttonSheet = false;
  IconData f_icon=Icons.edit;

  void Changefloatingbottom(bool b,IconData icon)
  {
    is_showbuttonSheet=b;
    f_icon=icon;
    emit(changefloatingbottom());
  }
  List<Map> newtasks=[];
  List<Map> donetasks=[];
  List<Map> archivedtasks=[];
  Database? database;

 void create_DB()  {
    openDatabase('to_do.db',
        version: 1,
        onCreate: (db, version) {
          print("database is created");
          db.execute(
              "CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)")
              .then((value) {
            print("table is created");
          }).catchError((error) {
            print("error in create table ${error.toString()}");
          });
        }, onOpen: (database) {
      emit(loading());
          GetFromDB(database);
          print("database is opened");
        }).then((value){
          database=value;
          emit(createDB());
    });
  }

  InsertToDB(
      {required String title, required String time, required String date}) async {
    await database!.transaction((txn) async {
      txn.rawInsert(
          "insert into tasks (title,date,time,status) values ('$title','$date','$time','new')")
          .then((value) {
        print("$value success");
        emit(loading());
        GetFromDB(database!);
        emit(insertinDB());
      }).catchError((error) {
        print("error ${error.toString()}");
      });
    });
  }

  void GetFromDB(Database db) {
   newtasks=[];
   donetasks=[];
   archivedtasks=[];
    db.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element) {
        if(element['status']=='new')
          newtasks.add(element);
       else if(element['status']=='done')
          donetasks.add(element);
       else
         archivedtasks.add(element);
      });
      emit(getfromDB());
      print(value);
    });
  }

 void update (String sta,int index)  {
     database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$sta', index],
    ).then((value){
      emit(updateDB());
      GetFromDB(database!);
    });
  }


  void delete (int index){
    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [index]
    ).then((value){
      emit(deletefromDB());
      GetFromDB(database!);
    });
  }

}