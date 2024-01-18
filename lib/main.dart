import 'package:feel_da_beats_app/pages/dashboard.dart';
import 'dart:async';
import 'package:feel_da_beats_app/pages/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:feel_da_beats_app/services/userManagement.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCWRMyolLX6oUjGn4DxMqi6L2BBpcr4VZs',
          appId: '1:154614009785:android:dd33258cc983f864a23068',
          storageBucket: 'feel-da-beats.appspot.com',
          messagingSenderId: '154614009785',
          projectId: 'feel-da-beats'));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feel da Beats',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? LoginPage.id
          : MyHomePage.id,
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        MyHomePage.id: (context) => const MyHomePage(),
      },
      home: const MyHomePage(),

      // userManagement().handleAuth()
    );
  }
}
