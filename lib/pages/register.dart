import 'package:feel_da_beats_app/pages/dashboard.dart';
import 'package:feel_da_beats_app/pages/landing_page.dart';
import 'package:feel_da_beats_app/services/userManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = '';
  String username = "";
  String password = "";
  String _errorMessage = "";
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Feel da beats'),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/vector138.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter
              // Atur properti lain sesuai kebutuhan
              ),
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/vector139.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter
                // Atur properti lain sesuai kebutuhan
                ),
          ),
          child: Column(
            children: [
              SizedBox(height: 75),
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                    textAlign: TextAlign.start,
                  ),
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
                          username = value;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Color.fromRGBO(103, 80, 163, 1))),
                          hintText: "Enter your username",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
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
                      SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
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
                      SizedBox(height: 20),
                      Text(_errorMessage, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          if (username.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            setState(() {
                              _errorMessage =
                                  "Field can't empty, fill the field!";
                            });
                          } else {
                            try {
                              await _auth
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((value) {
                                setState(() {
                                  showSpinner = false;
                                });
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()));
                            } catch (e) {
                              if (e is FirebaseAuthException) {
                                setState(() {
                                  _errorMessage = e.message!;
                                });
                              }
                            }
                            print(FirebaseAuth.instance.currentUser?.uid);
                            userManagement().saveUserDataToFirestore(
                                FirebaseAuth.instance.currentUser!.uid,
                                email,
                                username);
                          }
                        },
                        child: Text('Sign Up',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(66, 87, 154, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            fixedSize: Size(200, 50),
                            side: BorderSide(
                                width: 3,
                                color: Color.fromRGBO(103, 80, 163, 1))),
                      ),
                      SizedBox(height: 120),
                      Text("Already have an account?",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                            print('Login');
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Color.fromRGBO(66, 87, 154, 1),
                                fontWeight: FontWeight.bold),
                          ))
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
