import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/task.dart';
import 'package:app/providers/user_tasks.dart';


class NewTask extends ConsumerStatefulWidget{
  const NewTask({this.oldTask, super.key});

  final Task? oldTask;
  @override
  ConsumerState<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends ConsumerState<NewTask> {
  final _taskController=TextEditingController();
  
  void _addTask(){
    if(_taskController.text.length<3){
      showDialog(context: context, builder: (ctx)=>AlertDialog(
        title: const Text('Invalid input'),
        content: const Text('Please enter at least three characters for task.'),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(ctx);
          }, 
          child: const Text('Okay')
          ),
        ],
      ));
    }
    else{
      if(widget.oldTask!=null){
        ref.read(userTasksProvider.notifier).updateTask(Task(updatedDate: DateTime.now().toIso8601String(), task: _taskController.text, id: widget.oldTask!.id));
      }
      else{
        ref.read(userTasksProvider.notifier).addTask(Task(updatedDate: DateTime.now().toIso8601String(), task: _taskController.text));
      }
      Navigator.of(context).pop(true);
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.oldTask!=null){
      _taskController.text=widget.oldTask!.task;
    }
  }
  
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: [
            TextField(
            controller: _taskController,
            maxLines: 2,
            maxLength: 300,
            decoration: InputDecoration(
              label: widget.oldTask!=null?const Text('Update your task'):const Text('Add your task',),
            ),
          ),
          ElevatedButton.icon(onPressed: _addTask, 
          label: widget.oldTask!=null?const Text('Update task'):const Text('Add task',),
          icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}