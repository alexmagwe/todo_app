import 'package:flutter/material.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('todo app', () {
    late FlutterDriver driver;
    Future<bool> isPresent(
        {required SerializableFinder valueKey,
        Duration timeout = const Duration(seconds: 1)}) async {
      try {
        await driver.waitFor(valueKey, timeout: timeout);
        return true;
      } catch (_) {
        return false;
      }
    }

    final emailInput = find.byValueKey('emailInput');
    final passInput = find.byValueKey('passInput');
    final signinBtn = find.byValueKey('signinBtn');
    // final loginSnackbar = find.byValueKey('loginSnackbar');

    final signupBtn = find.byValueKey('signupBtn');
    final signoutBtn = find.byValueKey('signoutBtn');
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    test('login success', () async {
      if (await isPresent(valueKey: signoutBtn)) {
        await driver.tap(signoutBtn);
      }
      await driver.tap(emailInput);
      await driver.enterText('test@gmail.com');
      await driver.tap(passInput);
      await driver.enterText('qwerty12');
      await driver.tap(signinBtn);
      await driver.waitFor(signoutBtn);
    });
    test('create account', () async {
      if (await isPresent(valueKey: signoutBtn)) {
        await driver.tap(signoutBtn);
      }
      await driver.tap(emailInput);
      await driver.enterText('test@gmail.com');
      await driver.tap(passInput);
      await driver.enterText('qwerty12');
      await driver.tap(signupBtn);
      await driver.waitFor(signoutBtn);
    });

    tearDownAll(() async {
      driver.close();
    });
  });
}
