import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/music_model.dart';

class FirestoreService {
  static void uploadSong(Song song) {
    FirebaseFirestore.instance.collection('songs').add({
      'title': song.title,
      'artist': song.artist,
      'audioPath': song.audioPath,
      'albumImgUrl': song.albumImgUrl,
      'emotionPlaylistType': song.emotionPlaylistType,
    });
  }
}
