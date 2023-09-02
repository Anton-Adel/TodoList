import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/shared/components/component.dart';
import 'package:todo_list/shared/cubit/cubit.dart';
import 'package:todo_list/shared/cubit/states.dart';
// 1. create database
// 2. create table
// 3. open database
// 4. insert in database
// 5. get from database
// 6. update in database
// 7. delete from database

class Todo extends StatelessWidget {
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var calendercontroller = TextEditingController();


  @override
  // void initState() {
  // super.initState();
  // create_DB();
  // }

  @override
  Widget build(BuildContext context) {

  return BlocProvider(

    create: (BuildContext context)=>TodoCubit()..create_DB(),
    child: BlocConsumer<TodoCubit,TodoStates>(
      listener: (context,state){
        if(state is insertinDB)
          {
            Navigator.pop(context);
          }
      },
      builder: (context,state){
        TodoCubit cubit=TodoCubit.get(context);
        return Scaffold(
          key: ScaffoldKey,
          appBar: AppBar(
            title: Text("Todo"),
          ),

          body: (state is loading)?Center(child: CircularProgressIndicator()):cubit.Screens[cubit.current_index],
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (cubit.is_showbuttonSheet) {
                if (formKey.currentState!.validate()) {

                  cubit.Changefloatingbottom(false, Icons.edit);
                  cubit.InsertToDB(title: titlecontroller.text, time: timecontroller.text, date: calendercontroller.text);


                }
              }
              else {
                ScaffoldKey.currentState!.showBottomSheet(
                      (context) =>
                      Container(

                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                DefaultTextFeild(
                                  controller: titlecontroller,
                                  type: TextInputType.text,
                                  label: "title",
                                  prefix: Icons.title,
                                  ontap: () {
                                    print("Done");
                                  },
                                  validate: (value) {
                                    if (value.isEmpty)
                                      return "empty title";
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                DefaultTextFeild(
                                    controller: timecontroller,
                                    type: TextInputType.none,
                                    label: "Time",
                                    prefix: Icons.watch_later_outlined,
                                    validate: (value) {
                                      if (value.isEmpty)
                                        return "empty time";
                                      else
                                        return null;
                                    },
                                    ontap: () {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timecontroller.text = value!.format(context);
                                      });
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                DefaultTextFeild(
                                    controller: calendercontroller,
                                    type: TextInputType.none,
                                    label: "Date",
                                    prefix: Icons.calendar_today,
                                    validate: (value) {
                                      if (value.isEmpty)
                                        return "empty Date";
                                      else
                                        return null;
                                    },
                                    ontap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse("2022-12-16"),
                                      ).then((value) {
                                        calendercontroller.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                  elevation: 12,
                ).closed.then((value){
                  // setState(() {
                  // f_icon=Icons.edit;
                  // is_showbuttonSheet = false;
                  // });
                  cubit.Changefloatingbottom(false, Icons.edit);
                });


                cubit.Changefloatingbottom(true, Icons.add);
              }

            },
            child: Icon(cubit.f_icon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex:TodoCubit.get(context).current_index,
            onTap: (index) {
              // setState(() {
              // current_index = index;
              // });
              TodoCubit.get(context).Bottom_Nav_Bar(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'New task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check),
                label: 'Done task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined),
                label: 'Archived',
              ),
            ],
          ),
        );
      },

    ),
  );
  }

  // Future<String>? Get_name() async {
  //   return "Anton";
  // }


}



