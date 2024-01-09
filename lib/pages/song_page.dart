import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SongPage extends StatefulWidget {
  final String title;
  final String artist;
  final String albumImgUrl;
  final String audioPath;

  SongPage(
      {super.key,
      required this.title,
      required this.artist,
      required this.albumImgUrl,
      required this.audioPath});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playAudio();
  }

  void _playAudio() async {
    String url = widget.audioPath;
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              widget.albumImgUrl,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              widget.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.artist,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('clicked!');
          if (_audioPlayer.state == PlayerState.paused) {
            _audioPlayer.resume();
          } else {
            _audioPlayer.pause();
          }
        },
        child: Icon(
          _audioPlayer.state == PlayerState.paused
              ? Icons.play_arrow
              : Icons.pause,
        ),
      ),
    );
  }
}
