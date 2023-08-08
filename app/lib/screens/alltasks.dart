import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:app/main.dart';
import 'package:app/models/task.dart';
import 'package:app/providers/user_tasks.dart';
import 'package:app/widgets/newtask.dart';

class AllTasksScreen extends ConsumerStatefulWidget{
  const AllTasksScreen({super.key});

  @override
  ConsumerState<AllTasksScreen> createState()=>_AllTasksScreenState();
}

class _AllTasksScreenState extends ConsumerState<AllTasksScreen>{
  @override
  void initState() {
    super.initState();
    ref.read(userTasksProvider.notifier).loadTasks();
  }

  void _removeTask(Task task) async{
    var index=await ref.read(userTasksProvider.notifier).removeTask(task.id!);
    setState(() {});
    if(context.mounted){
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 3),
              content: const Text('Task removed!'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: (){
                  setState(() {
                      ref.read(userTasksProvider.notifier).removeUndoTask(task, index);
                  });
                },
              ),
              )
          );
      }
  }

  void _updateTask(Task task) async{
    final isUpdated=await showModalBottomSheet<bool>(isScrollControlled: true, context: context, builder: (ctx)=>NewTask(oldTask: task,));
    if(isUpdated==true){
    setState(() {
    });
  }
  }

  void _completeTask(int id){
    setState(() {
    ref.read(userTasksProvider.notifier).completeTask(id);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(duration: Duration(seconds: 3), content: Text('Task completed!')));
  }
  
  @override
  Widget build(BuildContext context) {
    final userTasks=ref.watch(userTasksProvider);
    return userTasks.isEmpty?const Center(child: Text('Nothing found!')):ListView.builder(itemCount: userTasks.length, itemBuilder: (ctx, index)=>
    Dismissible(
      background: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.3),
      ),
      key: ValueKey(userTasks[index].id),
      onDismissed: (direction){
        _removeTask(userTasks[index]);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
        border: Border.all(color: colorOrange, width: 1.2),
        borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: Text(userTasks[index].task, style: const TextStyle(fontSize: 18,),),
          leading: index%2==0?const Icon(Icons.emoji_emotions, color: colorOrange,):Icon(Icons.emoji_emotions_outlined, color: Theme.of(context).primaryColor),
          onTap: (){
            _updateTask(userTasks[index]);
          },
          onLongPress:(){
             _completeTask(userTasks[index].id!);
          },
          subtitle: Text(DateFormat.yMMMMd().add_jms().format(DateTime.parse(userTasks[index].updatedDate)), style: const TextStyle(fontWeight: FontWeight.bold),), 
        ),
      ),
    ));
  }
}