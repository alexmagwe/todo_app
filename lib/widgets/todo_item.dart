import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/db.dart';
import '../services/auth.dart';

class TodoItem extends StatefulWidget {
  final String content;
  final String todoId;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final bool done;
  TodoItem(
      {Key? key,
      required this.content,
      required this.done,
      required this.auth,
      required this.firestore,
      required this.todoId})
      : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool showOpts = false;
  bool editMode = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController editTextController =
        TextEditingController(text: widget.content);
    return GestureDetector(
      onLongPress: () => setState(() => showOpts = true),
      onTap: () => setState(() => showOpts = false),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: showOpts
              ? PopupMenuButton(
                  onSelected: (selected) {
                    switch (selected) {
                      case 'Edit':
                        setState(() {
                          showOpts = false;
                          editMode = true;
                        });
                        break;
                      //show text form input
                      case 'Delete':
                        Database(firestore: widget.firestore).deleteTodo(
                            uid: widget.auth.currentUser!.uid,
                            todoId: widget.todoId);
                        setState(() {
                          showOpts = false;
                        });
                        break;

                      default:
                        break;
                    }
                  },
                  child: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return {'Edit', 'Delete'}.map((String choice) {
                      return PopupMenuItem(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          title: !editMode
              ? Text(
                  widget.content,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                )
              : TextFormField(controller: editTextController),
          trailing: !editMode
              ? Checkbox(
                  shape: const CircleBorder(),
                  splashRadius: 10,
                  value: widget.done,
                  onChanged: (val) {
                    Database(firestore: widget.firestore).updateTodo(
                        uid: widget.auth.currentUser!.uid,
                        todoId: widget.todoId);
                  })
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    Database(firestore: widget.firestore).editTodo(
                        uid: widget.auth.currentUser!.uid,
                        todoId: widget.todoId,
                        content: editTextController.text);
                    setState(() {
                      editMode = false;
                    });
                  }),
        ),
      ),
    );
  }
}
