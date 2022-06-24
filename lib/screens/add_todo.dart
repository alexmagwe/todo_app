import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/db.dart';

import '../global_state.dart';

class CreateTodo extends StatefulWidget {
  final FirebaseAuth auth;
  // print(_auth.currentUser);
  final FirebaseFirestore firestore;
  const CreateTodo({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: todoController,
            key: const Key('todoTextField'),
          ),
          const SizedBox(
            height: 40,
          ),
          IconButton(
              key: const Key('addTodoBtn'),
              onPressed: () {
                try {
                  Database(firestore: widget.firestore).addTodo(
                      uid: widget.auth.currentUser!.uid,
                      content: todoController.text);
                  Navigator.of(context).pop();
                } catch (err) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(err.toString())));
                }
              },
              icon: const Icon(Icons.check),
              iconSize: 50.0),
        ],
      ),
    ));
  }
}
