import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_da_beats_app/pages/song_page.dart';
import 'package:flutter/material.dart';

class RecommendedSongsPage extends StatefulWidget {
  final String emotion;

  const RecommendedSongsPage({Key? key, required this.emotion})
      : super(key: key);

  @override
  State<RecommendedSongsPage> createState() => _RecommendedSongsPageState();
}

class _RecommendedSongsPageState extends State<RecommendedSongsPage> {
  List _allSongs = [];
  List _happyPlaylist = [];
  List _angryPlaylist = [];
  List _sadPlaylist = [];

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
    switch (widget.emotion) {
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

  @override
  void initState() {
    getAllSongs();
    getAngrySongs();
    getHappySongs();
    getSadSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan rekomendasi lagu berdasarkan emosi
    List recommendedSongs = getSongsBasedOnEmotion();

    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Songs'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: recommendedSongs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(recommendedSongs[index]['title'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text(recommendedSongs[index]['artist'],
                        style: TextStyle(fontSize: 16)),
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
      ),
    );
  }
}
