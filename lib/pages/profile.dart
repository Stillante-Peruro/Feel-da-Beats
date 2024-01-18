import 'package:feel_da_beats_app/pages/landing_page.dart';
import 'package:feel_da_beats_app/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String uid = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? username = await UserManagement().getUsername(user.uid);
      if (username != null) {
        setState(() {
          uid = username;
        });
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, LoginPage.id);
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                logout();
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.music_note),
            //   title: const Text('Play One Song'),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.download,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      _showSettingsMenu(context);
                    },
                    icon: const Icon(
                      Icons.settings,
                      size: 30,
                    )),
              ],
            ),
          ),
          Center(
            child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey)),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              uid,
              style: const TextStyle(
                color: Color(0XFF42579A),
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 3),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       UserManagement().signOut();
      //       logout();
      //     },
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.indigo[800],
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(0),
      //       ),
      //       fixedSize: const Size(200, 50),
      //     ),
      //     child: const Text('Log out', style: TextStyle(color: Colors.white)),
      //   ),
      // ),
    );
  }
}
