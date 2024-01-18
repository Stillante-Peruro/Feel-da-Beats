import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SongPage extends StatefulWidget {
  final String title;
  final String artist;
  final String albumImgUrl;
  final String audioPath;

  const SongPage(
      {super.key,
      required this.title,
      required this.artist,
      required this.albumImgUrl,
      required this.audioPath});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  bool isPlaying = false;
  late final AudioPlayer _audioPlayer;
  String url = "";

  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future initPlayer() async {
    _audioPlayer = AudioPlayer();
    url = widget.audioPath;

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerComplete.listen(
      (event) {
        setState(() {
          _position = _duration;
        });
      },
    );
  }

  void playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
      isPlaying = false;
      print('music paused');
    } else {
      _audioPlayer.play(UrlSource(url));
      print('playing music..');
      isPlaying = true;
    }
    setState(() {});
  }

  String formatDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // void _playAudio() async {
  //   await _audioPlayer.play(UrlSource(url));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                widget.albumImgUrl,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.artist,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 45),
              Slider(
                value: _position.inSeconds.toDouble(),
                onChanged: (value) async {
                  await _audioPlayer.seek(Duration(seconds: value.toInt()));
                  setState(() {});
                },
                min: 0,
                max: _duration.inSeconds.toDouble(),
                inactiveColor: Colors.grey[600],
                activeColor: Colors.cyan,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                    '${formatDuration(_position)}/${formatDuration(_duration)}'),
              ]),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _audioPlayer
                          .seek(Duration(seconds: _position.inSeconds - 10));
                      setState(() {});
                    },
                    child: const Icon(Icons.fast_rewind),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: playPause,
                    child: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.cyan,
                      size: 75,
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      _audioPlayer
                          .seek(Duration(seconds: _position.inSeconds + 10));
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.fast_forward,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
