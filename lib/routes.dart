///роутер чтоб задать маршруты и подмаршруты используется пакет go_router
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parking/pages/home.dart';
import 'package:parking/pages/login.dart';
import 'package:parking/pages/payment_page.dart';
import 'package:parking/pages/signup.dart';
import 'package:parking/service_locator.dart';
import 'package:parking/stores/auth_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
///
///роутер чтоб задать маршруты и подмаршруты используется пакет go_router
///
final userStore = serviceLocator<UserStore>();

GoRouter routes = GoRouter(
  initialLocation: '/auth',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: "/auth",
      builder: (context, state) =>  LoginPage(),
      redirect: (context, state){
        if(userStore.user != null){
          return "/";
        }
        return null;
      }
    ),

    GoRoute(
      path: "/signup",
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(path: '/',
      builder: (context, state) => const HomePage(),
      routes: [

        GoRoute(
          path: "payment",
          builder: (context, state) => PaymentPage(),
        ),
      ],
      redirect: (context, state){
        if(userStore.user == null){
          return "/auth";
        }
        return null;
      }
      ,),
  ],
);

///
/// Логгер чтобы выводить касивые логи на консоль
///
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 30,
    errorMethodCount: 5,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);
