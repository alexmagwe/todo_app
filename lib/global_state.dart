import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlobalState extends InheritedWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const GlobalState(
      {required this.auth,
      required this.firestore,
      required Widget child,
      Key? key})
      : super(child: child, key: key);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static GlobalState? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<GlobalState>());
  }
}
