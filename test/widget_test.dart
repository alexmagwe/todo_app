import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:todo_app/screens/home.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:todo_app/models/db.dart';
import 'package:todo_app/models/todo.dart';

void main() async {
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  setUp(() async {
    TodoModel todoItem = TodoModel(
      todoId: 'todoId',
      content: 'this is a test',
      done: false,
    );
    firestore = FakeFirebaseFirestore();
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'test@gmail.com',
      displayName: 'test',
    );
    auth = MockFirebaseAuth(mockUser: user, signedIn: true);
    await Database(firestore: firestore)
        .addTodo(content: todoItem.content, uid: 'someuid');
  });

  testWidgets('streaming todo items', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Home(auth: auth, firestore: firestore)));
    await tester.idle();
    await tester.pump();
    expect(find.byType(ListTile), findsOneWidget);
  });
  testWidgets('complete todo item ', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Home(auth: auth, firestore: firestore)));
    await tester.idle();
    await tester.pump();
    expect(find.byType(ListTile), findsOneWidget);
    final checkBox = find.byType(Checkbox);
    expect(checkBox, findsOneWidget);
    await tester.tap(checkBox);
    await tester.idle();
    await tester.pump();
    expect(find.byType(ListTile), findsNothing);
  });
  testWidgets('adding todo item', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Home(auth: auth, firestore: firestore)));
    final ctaBtn = find.byKey(const ValueKey('floatingActionBtn'));
    expect(ctaBtn, findsOneWidget);
    await tester.tap(ctaBtn);
    await tester.idle();
    await tester.pumpAndSettle();
    final textInput = find.byKey(const ValueKey('todoTextField'));
    final addTodoBtn = find.byKey(const ValueKey('addTodoBtn'));
    expect(find.byType(CreateTodo), findsOneWidget);
    expect(addTodoBtn, findsOneWidget);
    expect(textInput, findsOneWidget);
    await tester.enterText(textInput, 'added another item');
    await tester.tap(addTodoBtn);
    await tester.idle();
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));
  });
}
