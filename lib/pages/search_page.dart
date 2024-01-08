import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_da_beats_app/models/music_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String title = '';
  List<Map<String, dynamic>> data = [
    {
      "songs": {
        "chill": {
          {
            "title": "No Way",
            "artist": "Bi",
            "audioPath": "",
            "albumImgUrl":
                "https://linkstorage.linkfire.com/medialinks/images/315b01a8-ea83-4493-b43e-e587d688e8c5/artwork-440x440.jpg",
            "emotionPlaylistType": "angry"
          },
          {
            "title": "Hold You",
            "artist": "Low Mileage",
            "audioPath": "",
            "albumImgUrl":
                "https://linkstorage.linkfire.com/medialinks/images/9f7a8b8b-2f7e-4cc8-9d52-5c7989866bee/artwork-440x440.jpg",
            "emotionPlaylistType": "angry"
          },
        },
      }
    }
  ];

  addData() async {
    for (var element in data) {
      FirebaseFirestore.instance.collection('songs').add(element);
    }
    print('all songs added');
  }

  void initState() async {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    addData();
  }

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
                ),
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                }),
            SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('songs').snapshots(),
              builder: (context, snapshots) {
                return (snapshots.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshots.data!.docs[index].data()
                              as Map<String, dynamic>;

                          if (title.isEmpty) {
                            return ListTile(
                                title: Text(data['title'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(data['artist'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                leading:
                                    Image.network(data[index].albumImageUrl));
                          }
                          if (data['title']
                              .toSTring()
                              .startWith(title.toLowerCase())) {
                            return ListTile(
                                title: Text(data['title'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(data['artist'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                leading:
                                    Image.network(data[index].albumImageUrl));
                          }
                        });
              },
            )
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
