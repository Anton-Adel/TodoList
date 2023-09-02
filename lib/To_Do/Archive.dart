
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/component.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class archive_task extends StatelessWidget {
  const archive_task({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context,state){},
      builder: (context,state){
        var task=TodoCubit.get(context).archivedtasks;
        return
         Task_build(task);
      },


    );

  }
}
