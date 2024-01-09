import 'package:flutter/material.dart';

class RecommendedSongsPage extends StatelessWidget {
  final String emotion;

  const RecommendedSongsPage({Key? key, required this.emotion})
      : super(key: key);

  // Metode untuk mendapatkan rekomendasi lagu berdasarkan emosi
  List<String> getSongsBasedOnEmotion() {
    // Di sini, Anda dapat menulis logika untuk mengembalikan daftar lagu berdasarkan emosi
    // Misalnya, jika emosi adalah 'happy', Anda bisa mengembalikan daftar lagu yang ceria.
    // Tambahkan logika yang sesuai dengan aplikasi Anda.
    switch (emotion) {
      case 'Happy':
        return ['Happy Song 1', 'Happy Song 2', 'Happy Song 3'];
      case 'Sad':
        return ['Sad Song 1', 'Sad Song 2', 'Sad Song 3'];
      case 'Neutral':
        return ['Random Song 1', 'Random Song 2', 'Random Song 3'];
      case 'Angry':
        return ['Angry Song 1', 'Angry Song 2', 'Angry Song 3'];
      default:
        return ['Song 1', 'Song 2', 'Song 3'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan rekomendasi lagu berdasarkan emosi
    List<String> recommendedSongs = getSongsBasedOnEmotion();

    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Songs'),
      ),
      body: ListView.builder(
        itemCount: recommendedSongs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recommendedSongs[index]),
            // Aksi ketika item di klik (misalnya putar lagu, buka detail lagu, dll.)
            onTap: () {
              // Tambahkan logika untuk menangani aksi ketika lagu dipilih
              // Misalnya, putar lagu atau tampilkan detail lagu.
              // Sesuaikan dengan fitur aplikasi Anda.
            },
          );
        },
      ),
    );
  }
}
