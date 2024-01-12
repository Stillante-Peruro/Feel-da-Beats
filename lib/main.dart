import 'package:feel_da_beats_app/pages/dashboard.dart';
import 'package:feel_da_beats_app/pages/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyCWRMyolLX6oUjGn4DxMqi6L2BBpcr4VZs',
          appId: '1:154614009785:android:dd33258cc983f864a23068',
          storageBucket: 'feel-da-beats.appspot.com',
          messagingSenderId: '154614009785',
          projectId: 'feel-da-beats'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Feel da Beats',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: MyHomePage()
        //kalo mau ke page login
        // LoginPage(),
        );
  }
}
