import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_da_beats_app/models/music_model.dart';
// import 'package:feel_da_beats_app/models/music_model.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String title = '';
  List<Map<String, dynamic>> data = [
    // {
    //   "title": "No Way",
    //   "artist": "Bi",
    //   "audioPath": "path/name.mp3",
    //   "albumImgUrl":
    //       "https://linkstorage.linkfire.com/medialinks/images/315b01a8-ea83-4493-b43e-e587d688e8c5/artwork-440x440.jpg",
    //   "emotionPlaylistType": "angry"
    // },
    // {
    //   "title": "Hold You",
    //   "artist": "Low Mileage",
    //   "audioPath": "path/name.mp3",
    //   "albumImgUrl":
    //       "https://linkstorage.linkfire.com/medialinks/images/9f7a8b8b-2f7e-4cc8-9d52-5c7989866bee/artwork-440x440.jpg",
    //   "emotionPlaylistType": "angry"
    // }
  ];

  addData() async {
    for (var element in data) {
      FirebaseFirestore.instance.collection('songs').add(element);
    }
    print('all songs added');
  }

  Future<void> audioUploadAndSaveURLs(List<String> filePaths) async {
    for (String path in filePaths) {
      Reference storageRef = FirebaseStorage.instance.ref(path);
      String audioURL = await storageRef.getDownloadURL();
      print(audioURL);
      // Simpan URL ke Firestore
      await FirebaseFirestore.instance.collection('songs').add({
        'audioPath': audioURL,
      });
    }
    print('all urls added');
  }

  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });

    List<String> audioToUpload = [
      "songs/chill_playlist/BIMINI - No Way (with Avi Snow) [NCS Release].mp3",
      "songs/chill_playlist/Low Mileage - Hold You [NCS Release].mp3",
    ];
    audioUploadAndSaveURLs(audioToUpload);
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
        backgroundColor: Colors.cyan,
      ),
      // backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
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
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Expanded(
                // child: StreamBuilder<QuerySnapshot>(
                //   stream:
                //       FirebaseFirestore.instance.collection('songs').snapshots(),
                //   builder: (BuildContext context,
                //       AsyncSnapshot<QuerySnapshot> snapshot) {
                //     if (snapshot.hasError) {
                //       return Text('Something went wrong');
                //     }

                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return Text("Loading");
                //     }

                //     return ListView.builder(
                //         itemCount: snapshot.data!.docs.length,
                //         itemBuilder: (context, index) {
                //           var data = snapshot.data!.docs[index];
                //           return ListTile(
                //             title: Text(data["title"]),
                //             subtitle: Text(data["artist"]),
                //           );
                //         });
                //   },
                // ),

                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('songs')
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
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
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(data['artist'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16)),
                                    leading:
                                        Image.network(data["albumImgUrl"]));
                              }
                              if (data['title']
                                  .toString()
                                  .startsWith(title.toLowerCase())) {
                                return ListTile(
                                    title: Text(data['title'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(data['artist'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16)),
                                    leading:
                                        Image.network(data["albumImgUrl"]));
                              }
                              return Container();
                            });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
