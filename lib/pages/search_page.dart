import 'package:audioplayers/audioplayers.dart';
import 'package:feel_da_beats_app/models/music_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // final databaseReference = FirebaseDatabase.instance.ref();
  // final AudioPlayer audioPlayer = AudioPlayer();
  // List<Song> songs = [];

  // void updateList(){

  // }

  // static List<Song> songs = [];

  // List<Song> display_song = List.from(songs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan[300],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Search for a Music',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                )),
            SizedBox(height: 20),
            TextField(
                decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 235, 235, 235),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide.none,
              ),
              hintText: 'Enter song name',
              prefixIcon: Icon(Icons.search),
            )),
            SizedBox(height: 20),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: display_song.length,
            //     itemBuilder: (context, index) => ListTile(
            //       title: Text(
            //         display_song[index].title,
            //         style: TextStyle(fontWeight: FontWeight.bold)
            //         ),
            //       subtitle: Text(
            //         display_song[index].artist,
            //       ),
            //     ),
            //     )
            // ),
            //   Expanded(
            //   child: ListView.builder(
            //     itemCount: songs.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         leading: Image.network(
            //           songs[index].albumImageUrl,
            //           width: 50,
            //           height: 50,
            //         ),
            //         title: Text(songs[index].title),
            //         subtitle: Text(songs[index].artist),
            //         onTap: () {
            //           playSong(songs[index].audioPath);
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
