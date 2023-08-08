import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/main.dart';
import 'package:app/providers/user_tasks.dart';

class CompletedTasksScreen extends ConsumerStatefulWidget{
const CompletedTasksScreen({super.key});

@override
ConsumerState<CompletedTasksScreen> createState()=>_CompletedTasksScreenState();

}

class _CompletedTasksScreenState extends ConsumerState<CompletedTasksScreen>{
  @override
  void initState() {
    super.initState();
    ref.read(userTasksProvider.notifier).loadCompletedTasks();
  }

  void _unCompleteTask(int id){
    setState(() {
    ref.read(userTasksProvider.notifier).unCompleteTask(id);
    });
        ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(duration: Duration(seconds: 3), content: Text('Task uncompleted!')));
  }

  @override
  Widget build(BuildContext context) {
    final userTasks=ref.watch(userTasksProvider);
    return userTasks.isEmpty?const Center(child: Text('Nothing found!')):ListView.builder(itemCount: userTasks.length, itemBuilder: (ctx, index)=>
    Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 1.2),
        borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: Text(userTasks[index].task, style: const TextStyle(fontSize: 18,),),
          leading: index%2==0?Icon(Icons.check, color: Theme.of(context).primaryColor,):const Icon(Icons.radio_button_checked_sharp, color: colorOrange,),
          onLongPress: (){
           _unCompleteTask(userTasks[index].id!); 
          },
        ),
      ),
    );
  }
}