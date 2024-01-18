import 'dart:io';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_da_beats_app/pages/song_page.dart';
import 'package:flutter/material.dart';

class RecommendedSongsPage extends StatefulWidget {
  final String imagePath;

  const RecommendedSongsPage({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<RecommendedSongsPage> createState() => _RecommendedSongsPageState();
}

class _RecommendedSongsPageState extends State<RecommendedSongsPage> {
  String emotion = "";

  List _allSongs = [];
  List _happyPlaylist = [];
  List _angryPlaylist = [];
  List _sadPlaylist = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
    getAllSongs();
    getAngrySongs();
    getHappySongs();
    getSadSongs();
  }

  @override
  void dispose() {
    File(widget.imagePath).deleteSync(recursive: true);
    _deleteFile(widget.imagePath);
    super.dispose();
  }

  void _deleteFile(String filePath) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
    _runModel(widget.imagePath);
  }

  Future<void> _runModel(String imagePath) async {
    try {
      print('jalan1');
      var recognitions = await Tflite.runModelOnImage(path: imagePath);
      print('jalan2');
      if (recognitions != null && recognitions.isNotEmpty) {
        var detectedEmotion = recognitions[0]['label'];
        emotion = detectedEmotion;
        print('emosi: $emotion');
      }
    } catch (e) {
      print('Error during model inference: $e');
    }
  }

  getAllSongs() async {
    var data = await FirebaseFirestore.instance
        .collection('songs')
        .orderBy('title')
        .get();

    setState(() {
      _allSongs = data.docs;
    });
  }

  getHappySongs() async {
    var data = await FirebaseFirestore.instance
        .collection('songs')
        .where('emotionPlaylistType', isEqualTo: 'Happy')
        .get();

    setState(() {
      _happyPlaylist = data.docs;
    });
  }

  getAngrySongs() async {
    var data = await FirebaseFirestore.instance
        .collection('songs')
        .where('emotionPlaylistType', isEqualTo: 'Angry')
        .get();

    setState(() {
      _angryPlaylist = data.docs;
    });
  }

  getSadSongs() async {
    var data = await FirebaseFirestore.instance
        .collection('songs')
        .where('emotionPlaylistType', isEqualTo: 'Sad')
        .get();

    setState(() {
      _sadPlaylist = data.docs;
    });
  }

  // Metode untuk mendapatkan rekomendasi lagu berdasarkan emosi
  List getSongsBasedOnEmotion() {
    // Di sini, Anda dapat menulis logika untuk mengembalikan daftar lagu berdasarkan emosi
    // Misalnya, jika emosi adalah 'happy', Anda bisa mengembalikan daftar lagu yang ceria.
    // Tambahkan logika yang sesuai dengan aplikasi Anda.
    switch (emotion) {
      case 'Happy':
        return _happyPlaylist;
      case 'Sad':
        return _sadPlaylist;
      case 'Angry':
        return _angryPlaylist;
      default:
        return _allSongs;
    }
  }

  AssetImage _emotionBackground() {
    switch (emotion) {
      case 'Happy':
        return const AssetImage("assets/images/Happy.png");
      case 'Sad':
        return const AssetImage("assets/images/Sad.png");
      case 'Angry':
        return const AssetImage("assets/images/Angry.png");
      case 'Neutral':
        return const AssetImage("assets/images/Happy.png");
      default:
        return const AssetImage("assets/images/Blank.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    List recommendedSongs = getSongsBasedOnEmotion();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: 210,
            width: 370,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // color: _emotionColor()),
                image: DecorationImage(
                    image: _emotionBackground(), fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: Text(
                "$emotion mood",
                style: const TextStyle(
                    fontSize: 32,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Container(
            width: 360,
            height: 35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Here your Playlist!',
                style: TextStyle(
                  color: Color(0XFF42579A),
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      offset: Offset(0, 3),
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recommendedSongs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recommendedSongs[index]['title'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: Text(recommendedSongs[index]['artist'],
                      style: const TextStyle(fontSize: 16)),
                  leading:
                      Image.network(recommendedSongs[index]['albumImgUrl']),
                  // Aksi ketika item di klik (misalnya putar lagu, buka detail lagu, dll.)
                  onTap: () {
                    // Tambahkan logika untuk menangani aksi ketika lagu dipilih
                    // Misalnya, putar lagu atau tampilkan detail lagu.
                    // Sesuaikan dengan fitur aplikasi Anda.

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SongPage(
                                title: recommendedSongs[index]['title'],
                                artist: recommendedSongs[index]['artist'],
                                albumImgUrl: recommendedSongs[index]
                                    ['albumImgUrl'],
                                audioPath: recommendedSongs[index]
                                    ['audioPath']))));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
