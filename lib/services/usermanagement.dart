import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_da_beats_app/pages/admin.dart';
import 'package:feel_da_beats_app/pages/dashboard.dart';
import 'package:feel_da_beats_app/pages/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserManagement {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              return const MyHomePage();
            } else {
              return const LoginPage();
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

  Future<String?> getUsername(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      return userDoc['username'];
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const AdminOnlyPage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    }
  }
}
