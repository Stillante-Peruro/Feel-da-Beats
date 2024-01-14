import 'package:flutter/material.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(200, 90),
        child: SizedBox(
          width: 500,
          height: 70,
        ),
      ),
      floatingActionButton: BackButton(
        style: ButtonStyle(iconSize: MaterialStateProperty.all(30)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              'Feel Your Tone',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: Color(0xFF42579A),
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 3),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              'Welcome! User',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Color(0xFF3EB6EC),
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 3),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              'Scan your song here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xff847B7B),
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              height: 480,
              width: 370,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey,
              ),
              child: Icon(
                Icons.graphic_eq,
                size: 350,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(color: const Color(0xff3EB6EC), width: 4)),
              child: IconButton(
                  icon: const Icon(
                    Icons.mic_none,
                    color: Color(0xff3EB6EC),
                  ),
                  iconSize: 40,
                  onPressed: () {}),
            ),
          )
        ],
      ),
    );
  }
}
