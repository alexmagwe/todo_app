import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/db.dart';

class TodoItem extends StatefulWidget {
  final String content;
  final String todoId;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  final bool done;
  const TodoItem(
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        title: Text(
          widget.content,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        trailing: Checkbox(
            shape: const CircleBorder(),
            splashRadius: 10,
            value: widget.done,
            onChanged: (val) {
              Database(firestore: widget.firestore).updateTodo(
                  uid: widget.auth.currentUser!.uid, todoId: widget.todoId);
            }),
      ),
    );
  }
}

class Popup extends StatelessWidget {
  const Popup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (selected) {
        switch (selected) {
          case 'Edit':
            break;
          //show text form input
          case 'Delete':
            //db delete
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
    );
  }
}
