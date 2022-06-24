import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth.dart';

class Login extends StatefulWidget {
  final FirebaseAuth auth;
  const Login({
    Key? key,
    required this.auth,
  }) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
              key: const Key('emailInput'),
              textAlign: TextAlign.center,
              controller: _emailController,
              decoration: const InputDecoration(hintText: "Email")),
          TextFormField(
              key: const Key('passInput'),
              controller: _passwordController,
              decoration: const InputDecoration(hintText: "Password"),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          if (!_loading) ...[
            ElevatedButton(
                key: const Key('signinBtn'),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  child: Text('Sign In'),
                ),
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  String retValue = await Auth(auth: widget.auth).signIn(
                      email: _emailController.text,
                      password: _passwordController.text);
                  if (retValue == 'Success') {
                    _emailController.clear();
                    _passwordController.clear();
                    setState(() {
                      _loading = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        key: const Key('loginSnackbar'),
                        content: Text(retValue),
                      ),
                    );
                    setState(() {
                      _loading = false;
                    });
                  }
                }),
            TextButton(
                key: const Key('signupBtn'),
                child: const Text('Create Account?'),
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  String retValue = await Auth(auth: widget.auth).createAccount(
                      email: _emailController.text,
                      password: _passwordController.text);
                  if (retValue == 'Success') {
                    _emailController.clear();
                    _passwordController.clear();
                    setState(() {
                      _loading = false;
                    });
                    // Navigator.of(context).pushNamed('/register');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(retValue),
                      ),
                    );
                    setState(() {
                      _loading = false;
                    });
                  }
                })
          ],
          if (_loading) ...[const CircularProgressIndicator()],
        ]),
      ),
    );
  }
}
