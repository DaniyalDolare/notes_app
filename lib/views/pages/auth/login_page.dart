import 'package:flutter/material.dart';
import 'package:notes_app/views/pages/auth/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/views/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  String? emailError;
  String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
            ),
            Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    errorText: emailError,
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    hintText: "Password",
                    errorText: passwordError,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                // Login
                final email = emailController.text;
                final password = passwordController.text;

                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);

                  // NO issues, go to home screen
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                    emailError = "No user found for that email.";
                    passwordError = null;
                  } else if (e.code == 'wrong-password') {
                    passwordError = "Wrong password provided for that user.";
                    emailError = null;
                    print('Wrong password provided for that user.');
                  }
                  setState(() {});
                }
              },
              child: Text("Login"),
            ),
            Column(
              children: [
                Text("Do not have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text("Sign up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
