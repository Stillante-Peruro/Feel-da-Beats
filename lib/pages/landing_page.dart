// import 'package:feel_da_beats_app/pages/dashboard.dart';
import 'package:feel_da_beats_app/pages/register.dart';
import 'package:feel_da_beats_app/services/userManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String id = "login";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showSpinner = false;
  String email = "";
  String password = "";
  String _errorMessage = "";
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: Text('Feel da beats'),
        // ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/vector138.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter
                // Atur properti lain sesuai kebutuhan
                ),
          ),
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/vector139.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.bottomCenter
                    // Atur properti lain sesuai kebutuhan
                    )),
            child: Column(
              children: [
                const SizedBox(height: 75),
                const SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Login',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: Color.fromRGBO(103, 80, 163, 1))),
                            hintText: "Enter your email",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: Color.fromRGBO(103, 80, 163, 1))),
                            hintText: "Enter your password",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(_errorMessage,
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              await _auth
                                  .signInWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((value) {
                                setState(() {
                                  showSpinner = false;
                                });
                              });
                              userManagement().navigateBasedOnRole(context);
                            } catch (e) {
                              print(e);
                              if (e is FirebaseAuthException) {
                                print("${e.code}");
                                setState(() {
                                  _errorMessage =
                                      "Password or email incorrect, try again";
                                });
                              }
                            }
                          },
                          child: const Text('Login',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(66, 87, 154, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              fixedSize: const Size(200, 50),
                              side: const BorderSide(
                                  width: 3,
                                  color: Color.fromRGBO(103, 80, 163, 1))),
                        ),
                        const SizedBox(height: 180),
                        const Text("Don't have an account?",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
                              print('signup');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Color.fromRGBO(66, 87, 154, 1),
                                  fontWeight: FontWeight.bold),
                            ))
                      ]),
                ),
              ],
            ),
          ),
        ));
  }
}
