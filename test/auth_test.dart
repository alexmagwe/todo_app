// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/services/auth.dart';

class MockUser extends Mock implements User {}

class MockCredential extends Mock implements UserCredential {}

MockCredential mockCredential = MockCredential();
final mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable({mockUser});
  }

  @override
  Future<MockCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    if (password.length < 6) {
      throw FirebaseAuthException(
          code: 'short-password',
          message: 'password should be longer than 6 characters');
    }
    return Future.value(mockCredential);
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) {
    if (email == 'test@gmail.com' && password == '123456') {
      return Future.value(mockCredential);
    } else {
      throw FirebaseAuthException(
          code: 'invalid-credentials', message: 'invalid credentials');
    }
  }

  @override
  Future<void> signOut() {
    return Future.value();
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);
  setUp(() {});
  tearDown(() {});
  test('emit occurs', () async {
    expectLater(auth.user, emitsInOrder([mockUser]));
  });
  test('create account', () async {
    // when(
    //   mockFirebaseAuth.createUserWithEmailAndPassword(
    //       email: 'test@gmail.com', password: '123456'),
    // ).thenAnswer((invocation) => Future.value(mockCredential));
    expectLater(
        await auth.createAccount(email: 'test@gmail.com', password: '123456'),
        'Success');
  });
  test('signup exception', () async {
    expectLater(
        await auth.createAccount(email: 'test@gmail.com', password: '1234'),
        'password should be longer than 6 characters');
  });
  test('login success', () async {
    expectLater(await auth.signIn(email: 'test@gmail.com', password: '123456'),
        'Success');
  });
  test('login exception', () async {
    expectLater(await auth.signIn(email: 'test@gmail.com', password: 'random'),
        'invalid credentials');
  });
  test('sign out', () async {
    expectLater(await auth.signOut(), 'Success');
  });
}
