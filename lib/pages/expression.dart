import 'package:flutter/material.dart';

class EmojiPage extends StatefulWidget {
  const EmojiPage({super.key});

  @override
  State<EmojiPage> createState() => _EmojiPageState();
}

class _EmojiPageState extends State<EmojiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emoji Page'),
      ),
      body: Center(
        child: Text('Emoji Page'),
      ),
    );
  }
}
