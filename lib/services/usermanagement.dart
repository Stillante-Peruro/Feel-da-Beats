import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_da_beats_app/pages/admin.dart';
import 'package:feel_da_beats_app/pages/dashboard.dart';
import 'package:feel_da_beats_app/pages/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class userManagement {
  Widget handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              return MyHomePage();
            } else {
              return LoginPage();
            }
          }
        }));
  }

  signOut() {
    try {
      FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  void saveUserDataToFirestore(String uid, String email, String username) {
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'username': username,
      'role': 'user',
    });
  }

  Future<String> getUserRole(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return snapshot['role'];
  }

  void navigateBasedOnRole(BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
      String role = await getUserRole(uid);
      if (role == 'admin') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => adminOnlyPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
  }
}
