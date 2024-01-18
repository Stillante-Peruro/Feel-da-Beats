import 'package:flutter/material.dart';

class SongNotFound extends StatelessWidget {
  final String title;
  final String artist;
  final String album;

  const SongNotFound({
    super.key,
    required this.title,
    required this.artist,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Not Found'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Apakah anda sedang mencari lagu ini?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Title: $title',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Artist: $artist',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Album: $album',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            const Text(
              'Sayangnya lagu tersebut belum tersedia di aplikasi ini. Mohon tunggu update kedepannya untuk menampilkan lagu yang anda inginkan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
