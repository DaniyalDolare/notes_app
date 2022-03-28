import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/views/pages/auth/login_page.dart';
import 'package:notes_app/views/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = FirebaseAuth.instance.currentUser != null;
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Notes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isAuthenticated ? const HomePage() : const LoginPage());
  }
}
