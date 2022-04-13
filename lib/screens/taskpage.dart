import 'package:flutter/material.dart';
import 'package:todo/database/database.dart';
import 'package:todo/model/task.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/widget/widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  TaskPage({this.task});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _tasktitle = '';
  String _taskdescription = '';

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _isVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      _isVisible = true;

      _tasktitle = widget.task.title;
      _taskId = widget.task.id;
      _taskdescription = widget.task.description;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(FontAwesomeIcons.arrowLeft,
                              size: 30.0, color: Colors.black),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              if (value != '') {
                                if (widget.task == null) {
                                  Task _newTask = Task(
                                    title: value,
                                  );
                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _isVisible = true;
                                    _tasktitle = value;
                                  });
                                } else {
                                  await _dbHelper.updateTaskTitle(
                                      _taskId, value);
                                }
                              }
                              _descriptionFocus.requestFocus();
                            },
                            controller: TextEditingController()
                              ..text = _tasktitle,
                            decoration: InputDecoration(
                              hintText: 'Enter Task Title',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff231551),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != '') {
                            if (_taskId != 0) {
                              await _dbHelper.updateTaskDescription(
                                  _taskId, value);
                              _taskdescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskdescription,
                        decoration: InputDecoration(
                          hintText: 'Task Description',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 24.0),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodos(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data[index].isDone == 0) {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 0);
                                  }
                                  setState(() {});
                                },
                                child: ToDo(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 20.0,
                            width: 20.0,
                            margin: EdgeInsets.only(right: 12.0),
                            child: Icon(
                              FontAwesomeIcons.checkCircle,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = '',
                              onSubmitted: (value) async {
                                if (value != '') {
                                  if (_taskId != 0) {
                                    DatabaseHelper _dbHelper = DatabaseHelper();

                                    Todo _newToDo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    await _dbHelper.insertTodo(_newToDo);
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                  } else {}
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter task item.',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _isVisible,
                child: Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(FontAwesomeIcons.trash),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
