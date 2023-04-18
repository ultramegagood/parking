/// Авторизация беті
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parking/service_locator.dart';
import 'package:parking/stores/auth_store.dart';

class LoginPage extends StatelessWidget {
  final userStore = serviceLocator<UserStore>();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "parking app",
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  userStore.email = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,

                onChanged: (value) {
                  userStore.password = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                   await userStore.signIn().then((value) => context.go("/"));

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
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.go("/signup");
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
