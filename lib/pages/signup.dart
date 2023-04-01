import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:parking/routes.dart';

import '../service_locator.dart';
import '../stores/auth_store.dart';

class SignUpPage extends StatelessWidget {
  final userStore = serviceLocator<UserStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Observer(builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.mail),
                  ),
                  onChanged: (val) {
                    userStore.email = val;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.password),
                  ),
                  onChanged: (val) {
                    userStore.password = val;
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userStore.signUp().then((value) => context.go("/"));
                    } on FirebaseAuthException catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Ошибка"),
                              content: Text(e.code),
                            );
                          });
                    }
                  },
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    context.go('/auth');
                  },
                  child: const Text('Already have an account? Log in.'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
