import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/db.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets/todo_item.dart';

import '../global_state.dart';
import '../services/auth.dart';
import 'add_todo.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const Home({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // print(_auth.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App'), actions: [
        IconButton(
            key: const Key('signoutBtn'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Auth(auth: widget.auth).signOut();
            })
      ]),
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: StreamBuilder(
              stream: Database(firestore: widget.firestore)
                  .streamTodos(uid: widget.auth.currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TodoModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    widthFactor: 50,
                    heightFactor: 50,
                    child: CircularProgressIndicator(color: Colors.cyanAccent),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                return ListView(
                    children: snapshot.data!.map((todoItem) {
                  return TodoItem(
                      auth: widget.auth,
                      firestore: widget.firestore,
                      content: todoItem.content,
                      done: todoItem.done,
                      todoId: todoItem.todoId);
                }).toList());
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          key: const Key("floatingActionBtn"),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CreateTodo(
                    auth: widget.auth, firestore: widget.firestore)));
          }),
    );
  }
}
