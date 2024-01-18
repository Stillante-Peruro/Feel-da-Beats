import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_da_beats_app/pages/song_not_found.dart';
import 'package:feel_da_beats_app/pages/song_page.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with TickerProviderStateMixin {
  ACRCloudResponseMusicItem? music;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _heightAnimations;
  bool _isRecording = false;
  bool _success = false;
  String _text = 'Tekan tombol micophone untuk mulai mendeteksi lagu';
  String _loadingText = 'Putar, nyanyikan, atau senandungkan lagu';
  late Timer _timer;
  late ACRCloudSession _acrCloud;
  List songData = [];

  getSongsData() async {
    var data = await FirebaseFirestore.instance
        .collection('songs')
        .orderBy('title')
        .get();

    setState(() {
      songData = data.docs;
    });
  }

  // final List<int> durasi = [500, 800, 600, 700, 900];
  int _generateRandomDuration() {
    final random = Random();
    return random.nextInt(400) + 400;
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _checkPermission() async {
    await _requestMicrophonePermission();
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
    getSongsData();

    ACRCloud.setUp(const ACRCloudConfig(
        "bd5e3132a5d266920f2d0f05655093d3",
        "S8MDMZdLJs7fifE0OLYARSTlmV8Menk8IoCbZjDE",
        "identify-ap-southeast-1.acrcloud.com"));

    _controllers = List.generate(
      8,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: _generateRandomDuration()),
      ),
    );

    Timer.periodic(const Duration(seconds: 4), (timer) {
      _updateAnimationDurations();
    });

    _heightAnimations = List.generate(
      8,
      (index) => Tween<double>(
        begin: 13.0,
        end: 200.0,
      ).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  void _updateAnimationDurations() {
    for (var controller in _controllers) {
      controller.duration = Duration(milliseconds: _generateRandomDuration());
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
      _success = false;
      _text = 'Tekan tombol micophone untuk mulai mendeteksi lagu';
      _loadingText = 'Putar, nyanyikan, atau senandungkan lagu';
    });

    for (var controller in _controllers) {
      controller.repeat(reverse: true);
    }
    _acrCloud = ACRCloud.startSession();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_success) {
        _timer.cancel();
      }
      if (timer.tick == 5) {
        setState(() {
          _loadingText = 'Teruskan';
        });
      }
      if (timer.tick == 10) {
        setState(() {
          _loadingText = 'Sedikit lagi';
        });
      }
      if (timer.tick == 15) {
        setState(() {
          _text = 'Gagal Mendeteksi lagu, mohon coba lagi';
          _acrCloud.cancel();
          _acrCloud.dispose;
          _stopRecording();
        });
      }
    });

    final result = await _acrCloud.result;
    if (result == null) {
      setState(() {
        for (var controller in _controllers) {
          controller.animateBack(0.0);
        }
        _stopRecording();
        _acrCloud.cancel();
        _acrCloud.dispose();
      });
      return;
    } else if (result.metadata == null) {
      setState(() {
        _text = 'Gagal Mendeteksi lagu, mohon coba lagi';
        for (var controller in _controllers) {
          controller.animateBack(0.0);
        }
        _stopRecording();
        _acrCloud.cancel();
        _acrCloud.dispose();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Tidak dapat mengenali lagu'),
      ));
      return;
    }

    music = result.metadata!.music.first;

    if (music != null) {
      setState(() {
        _stopRecording();
      });
      if (!_success) {
        setState(() {
          _success = true;
          _acrCloud.dispose();
          _acrCloud.cancel();
        });
        checkAndNavigate();
        // [
        //   print('Track: ${music!.title}\n'),
        //   print('Album: ${music!.album.name}\n'),
        //   print('Artist: ${music!.artists.first.name}\n')
        // ];
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Berhasil mengenali lagu: ${music!.title} by Artist: ${music!.artists.first.name}'),
        // ));
      }
    }
  }

  void checkAndNavigate() {
    bool songFound = false;

    for (var song in songData) {
      var title = song['title'].toString();
      var artist = song['artist'].toString();
      print("Title: $title, Artist: $artist");
      if (music!.title == title ||
          music!.artists.first.name == artist ||
          music!.album.name == artist) {
        print(
            'Match found - Title: ${song['title']}, Artist: ${song['artist']}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SongPage(
              title: song['title'],
              artist: song['artist'],
              albumImgUrl: song['albumImgUrl'],
              audioPath: song['audioPath'],
            ),
          ),
        );
        songFound = true;
        break;
      }
    }

    if (!songFound) {
      print('No match found. Redirecting to SongNotFound.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SongNotFound(
            title: music!.title,
            artist: music!.artists.first.name,
            album: music!.album.name,
          ),
        ),
      );
    }
  }

  void _stopRecording() {
    _acrCloud.cancel();
    _acrCloud.dispose();
    setState(() {
      _isRecording = false;
    });
    _timer.cancel(); // Batalkan timer
    if (!_isRecording) {
      for (var controller in _controllers) {
        controller.animateBack(0.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(200, 90),
        child: SizedBox(
          width: 500,
          height: 70,
        ),
      ),
      floatingActionButton: BackButton(
        style: ButtonStyle(iconSize: MaterialStateProperty.all(30)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              'Feel Your Tone',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: Color(0xFF42579A),
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 3),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              'Welcome! User',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Color(0xFF3EB6EC),
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 3),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              'Scan your song here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xff847B7B),
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              height: 480,
              width: 370,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 120,
                      child: Text(
                        _isRecording ? _loadingText : _text,
                        style:
                            const TextStyle(fontSize: 25, fontFamily: 'Roboto'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: 350,
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(8, (index) {
                            return AnimatedBuilder(
                              animation: _heightAnimations[index],
                              builder: (context, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Container(
                                    width: 15,
                                    height: _heightAnimations[index].value,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: _getColorByIndex(index),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                border: Border.all(color: const Color(0xff3EB6EC), width: 4),
              ),
              child: IconButton(
                icon: _isRecording
                    ? const Icon(Icons.stop, color: Color(0xff3EB6EC))
                    : const Icon(
                        Icons.mic_none,
                        color: Color(0xff3EB6EC),
                      ),
                iconSize: 40,
                onPressed: () {
                  _isRecording ? _stopRecording() : _startRecording();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorByIndex(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.yellow;
      default:
        return Colors.red;
    }
  }

  @override
  void didUpdateWidget(covariant MusicPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isRecording) {
      for (var controller in _controllers) {
        controller.repeat(reverse: true);
      }
    } else {
      for (var controller in _controllers) {
        controller.stop();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer.cancel();
    _acrCloud.cancel();
    _acrCloud.dispose();
    super.dispose();
  }
}
