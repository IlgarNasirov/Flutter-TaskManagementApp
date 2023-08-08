import 'package:flutter/material.dart';

import 'package:app/screens/alltasks.dart';
import 'package:app/screens/completedtasks.dart';
import 'package:app/widgets/newtask.dart';

class TabsScreen extends StatefulWidget{
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState()=>_TabsScreenState();

}

class _TabsScreenState extends State<TabsScreen>{
  var _selectedPageIndex=0;

  void _selectPage(int index){
    setState(() {
      _selectedPageIndex=index;
    });
  }

  void _addTask() async{
    final isAdded=await showModalBottomSheet<bool>(isScrollControlled: true, context: context, builder: (ctx)=>const NewTask());
    if(isAdded==true){
    setState(() {
    });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var activePageTitle='All tasks';
    if(_selectedPageIndex==1){
      activePageTitle='Completed tasks';
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: _selectedPageIndex==0?[
          IconButton(
          onPressed: _addTask, 
          icon: const Icon(Icons.add),
          ),
        ]:[],
      ),
      body: _selectedPageIndex==0?const AllTasksScreen():const CompletedTasksScreen(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'All tasks' ),
        BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Completed tasks')
        ],
      ),
    );
  }
}