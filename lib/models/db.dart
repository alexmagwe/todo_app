import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo.dart';

class Database {
  final FirebaseFirestore firestore;
  Database({required this.firestore});
  Stream<List<TodoModel>> streamTodos({required String uid}) {
    try {
      return firestore
          .collection('todos')
          .doc(uid)
          .collection('todos')
          .where('done', isEqualTo: false)
          .snapshots()
          .map((querySnapshot) {
        List<TodoModel> retVal = [];
        for (final DocumentSnapshot doc in querySnapshot.docs) {
          retVal.add(TodoModel.fromDocumentSnapshot(snapshot: doc));
        }
        return retVal;
      });
    } catch (err) {
      print('error in stream todos');
      rethrow;
    }
  }

  Future<void> addTodo({required String uid, required String content}) async {
    try {
      await firestore
          .collection("todos")
          .doc(uid)
          .collection('todos')
          .add({'content': content, 'done': false});
    } catch (err) {
      rethrow;
    }
  }

  Future<void> updateTodo({required String uid, required String todoId}) async {
    try {
      firestore
          .collection('todos')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({"done": true});
    } catch (err) {
      rethrow;
    }
  }

  Future<void> editTodo(
      {required String uid,
      required String todoId,
      required String content}) async {
    try {
      firestore
          .collection('todos')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({"content": content});
    } catch (err) {
      rethrow;
    }
  }

  Future<void> deleteTodo({required String uid, required String todoId}) async {
    try {
      firestore
          .collection('todos')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .delete();
    } catch (err) {
      rethrow;
    }
  }
}
