import 'package:feel_da_beats_app/models/music_model.dart';
import 'package:feel_da_beats_app/pages/dashboard.dart';
import 'package:feel_da_beats_app/services/firestore_service.dart';
import 'package:flutter/material.dart';

class adminOnlyPage extends StatefulWidget {
  const adminOnlyPage({super.key});

  @override
  State<adminOnlyPage> createState() => _adminOnlyPageState();
}

class _adminOnlyPageState extends State<adminOnlyPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  TextEditingController audioController = TextEditingController();
  TextEditingController emotionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Admin Only')),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: "Enter tittle song",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: artistController,
                    decoration: const InputDecoration(
                      hintText: "Enter the artist",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: audioController,
                    decoration: const InputDecoration(
                      hintText: "Enter audio url",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: albumController,
                    decoration: const InputDecoration(
                      hintText: "Enter url album photo",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emotionController,
                    decoration: const InputDecoration(
                      hintText: "Enter mood (Angry/Happy/Sad)",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Song song = Song(
                          title: titleController.text,
                          artist: artistController.text,
                          audioPath: audioController.text,
                          albumImgUrl: albumController.text,
                          emotionPlaylistType: emotionController.text);

                      FirestoreService.uploadSong(song);

                      titleController.clear();
                      artistController.clear();
                      audioController.clear();
                      albumController.clear();
                      emotionController.clear();
                    },
                    child:
                        Text("Add song", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      fixedSize: const Size(200, 50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage()));
                    },
                    child: Text("Go to homepage",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      fixedSize: const Size(200, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
