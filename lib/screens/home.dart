import '../widgets/todo.dart';
import '../widgets/worktodo.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList=ToDo.todoList();
  List<ToDo> _foundTODO =[];
  final  _toDoController=TextEditingController();

@override
  void initState() {
    _foundTODO=todoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack (
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50,bottom: 20),
                      child: Text(
                        'Works to Do',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight:FontWeight.w500,
                        ),
                      ),
                    ),
                    for(ToDo todoo in _foundTODO.reversed)
                    WorkTODo(
                      todo: todoo,
                      onToDoChanged: _handleToDoChange,
                      onDeleteItem: _deleteToDoItem,
                    ),
                  ],
                ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child: Container(
                  margin: EdgeInsets.only(bottom: 20, right:20,left: 20 ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                    boxShadow: [ BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                    ),
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                      hintText: 'add a new todo item',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20,right: 20),
                  child: ElevatedButton(
                    child: Text('+',style: TextStyle(fontSize: 40 ),),
                    onPressed: () {
                      _addTODoItem(_toDoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo){
    setState(() {
      todo.isDone =!todo.isDone;
    });
  }

  void _deleteToDoItem(String id){
    setState(() {
      todoList.removeWhere((item) => item.id==id);

    });
  }

  void _addTODoItem(String toDo){
    setState(() {
      todoList.add(
          ToDo(
          id: DateTime.now().microsecondsSinceEpoch.toString() ,
          todoText: toDo));
    });
    _toDoController.clear();
  }

  void _runFilter(String enteredKeyword){
  List<ToDo> results=[];
  if(enteredKeyword.isEmpty){
    results =todoList;
  }
  else{
    results = todoList
        .where((item) => item.todoText!.toLowerCase()
        .contains(enteredKeyword.toLowerCase()))
        .toList();
  }
  setState(() {
    _foundTODO=results;
  });
  }


  Widget searchBox(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value)=> _runFilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search,color: Colors.black,size: 20,),
            prefixIconConstraints: BoxConstraints(maxHeight: 20,minWidth: 25),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey)
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu,color: Colors.black,size: 30,),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset("assets/KashishBegmal.jpeg"),),
          )
        ],
      ),
    );
  }
}