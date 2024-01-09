import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class AddSong extends StatelessWidget {
//   final String title;
//   final String artist;
//   final String albumImgUrl;
//   final String audioPath;
//   final String emotionPlaylistType;

//   AddSong(this.title, this.artist, this.albumImgUrl, this.audioPath, this.emotionPlaylistType);

//   @override
//   Widget build(BuildContext context) {
//     // Create a CollectionReference called users that references the firestore collection
//     CollectionReference songs = FirebaseFirestore.instance.collection('songs');

//     Future<void> addUser() {
//       // Call the user's CollectionReference to add a new user
//       return songs
//           .add({
//             'title': title, // 42
//             'artist': artist, // 42
//             'albumImgUrl': albumImgUrl, // 42
//             'audioPath': audioPath, // 42
//             'emotionPlaylistType': emotionPlaylistType // 42
//           })
//           .then((value) => print("User Added"))
//           .catchError((error) => print("Failed to add user: $error"));
//     }

//     return TextButton(
//       onPressed: addUser,
//       child: Text(
//         "Add User",
//       ),
//     );
//   }
// }




