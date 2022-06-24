import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String todoId;
  String content;
  bool done;
  TodoModel({required this.todoId, required this.content, required this.done});
  TodoModel.fromDocumentSnapshot({required DocumentSnapshot<Object?> snapshot})
      : todoId = snapshot.id,
        content = (snapshot.data() as Map)["content"]! as String,
        done = (snapshot.data() as Map)['done'] as bool;
}
