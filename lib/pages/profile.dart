import 'package:feel_da_beats_app/pages/landing_page.dart';
import 'package:feel_da_beats_app/services/userManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, LoginPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            userManagement().signOut();
            logout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            fixedSize: const Size(200, 50),
          ),
          child: const Text('Log out', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
