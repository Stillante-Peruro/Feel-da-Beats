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
  bool isPlaying = false;
  bool isnLiked = false;
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back),
                    onTap: () {
                      print("back");
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  child: Image.network(
                    widget.albumImgUrl,
                    width: 325,
                    height: 325,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.tryParse('325'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(99, 124, 178, 1),
                            shadows: [
                              Shadow(
                                  offset: Offset(0, 4),
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  blurRadius: 4)
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(widget.artist,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: Color.fromRGBO(132, 123, 123, 1),
                            )),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          if (isnLiked) {
                            isnLiked = false;
                            print('tidak disukai' + ' ${isnLiked}');
                          } else {
                            isnLiked = true;
                            print('disukai' + " ${isnLiked}");
                          }

                          setState(() {});
                        },
                        child: Icon(
                          isnLiked
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Color.fromRGBO(62, 182, 236, 1),
                          size: 35,
                        ))
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.tryParse('350'),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    formatDuration(_position),
                    style: TextStyle(
                        color: Color.fromRGBO(62, 182, 236, 1),
                        fontFamily: 'Poppins',
                        fontSize: 16),
                  ),
                  SizedBox(height: 100),
                  Container(
                    width: 267,
                    child: Slider(
                      value: _position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        await _audioPlayer
                            .seek(Duration(seconds: value.toInt()));
                        setState(() {});
                      },
                      min: 0,
                      max: _duration.inSeconds.toDouble(),
                      inactiveColor: Color.fromRGBO(230, 224, 233, 1),
                      activeColor: Color.fromRGBO(62, 182, 236, 1),
                    ),
                  ),
                  Text(
                    formatDuration(_duration),
                    style: TextStyle(
                        color: Color.fromRGBO(62, 182, 236, 1),
                        fontFamily: 'Poppins',
                        fontSize: 16),
                  ),
                ]),
              ),
              // SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.repeat,
                      color: Color.fromRGBO(62, 182, 236, 1),
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      _audioPlayer
                          .seek(Duration(seconds: _position.inSeconds - 10));
                      setState(() {});
                    },
                    child: Icon(
                      Icons.skip_previous_outlined,
                      color: Color.fromRGBO(62, 182, 236, 1),
                      size: 50,
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: playPause,
                    child: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Color.fromRGBO(62, 182, 236, 1),
                      size: 75,
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      _audioPlayer
                          .seek(Duration(seconds: _position.inSeconds + 10));
                      setState(() {});
                    },
                    child: Icon(Icons.skip_next_outlined,
                        color: Color.fromRGBO(62, 182, 236, 1), size: 50),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.playlist_play,
                      color: Color.fromRGBO(62, 182, 236, 1),
                      size: 30,
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
