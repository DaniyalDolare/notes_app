import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/views/pages/home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
              "Sign up",
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
                final email = emailController.text;
                final password = passwordController.text;

                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    passwordError = "The password provided is too weak.";
                    emailError = null;
                  } else if (e.code == 'email-already-in-use') {
                    emailError = "The account already exists for that email.";
                    passwordError = null;
                    print('The account already exists for that email.');
                  }
                  setState(() {});
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
