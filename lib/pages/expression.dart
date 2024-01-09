import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:feel_da_beats_app/pages/expressionrecomendation.dart';

class ExpressionSearchPage extends StatefulWidget {
  const ExpressionSearchPage({Key? key}) : super(key: key);

  @override
  State<ExpressionSearchPage> createState() => _ExpressionSearchPageState();
}

class _ExpressionSearchPageState extends State<ExpressionSearchPage> {
  CameraController? _cameraController; // Menggunakan nullable (?)
  late Timer _redirectTimer;
  String emosi = 'Tidak Ada Wajah Terdeteksi';
  bool _isPageSwitched = false;
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    loadModel();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    CameraDescription? selectedCamera;

    for (var camera in _cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        selectedCamera = camera;
        break;
      }
    }

    selectedCamera ??= _cameras.first;

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();

    if (mounted) {
      _cameraController!.startImageStream((CameraImage imageStream) {
        setState(() {
          _runModel(imageStream);
        });
      });
    }
  }

  Future<void> _runModel(CameraImage? cameraImage) async {
    if (cameraImage != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        var detectedEmotion = recognitions[0]['label'];

        if (detectedEmotion != 'Tidak Ada Wajah Terdeteksi' &&
            detectedEmotion != emosi) {
          setState(() {
            emosi = detectedEmotion;
            _resetTimer(); // Reset timer jika emosi berubah
          });
        } else if (emosi == detectedEmotion) {
          _startTimerToRedirect(); // Mulai timer jika emosi tetap sama
        } else {
          _resetTimer(); // Atur ulang timer jika tidak ada wajah terdeteksi
          setState(() {
            emosi = 'Tidak Ada Wajah Terdeteksi'; // Atur pesan yang sesuai
          });
        }
      } else {
        _resetTimer();
        setState(() {
          emosi = 'Tidak Ada Wajah Terdeteksi'; // Atur pesan yang sesuai
        });
      }
    }
  }

  void _startTimerToRedirect() {
    _redirectTimer = Timer(Duration(seconds: 5), () {
      if (!_isPageSwitched) {
        // Hentikan stream kamera
        _cameraController?.stopImageStream();

        // Pastikan halaman belum berpindah untuk menghindari tindakan berulang
        if (!_isPageSwitched) {
          _isPageSwitched = true;

          // Pindah ke halaman baru
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendedSongsPage(emotion: emosi),
            ),
          );
        }
      }
    });
  }

  void _resetTimer() {
    _redirectTimer.cancel();
  }

  @override
  void dispose() {
    _cameraController
        ?.dispose(); // Gunakan '?' untuk memastikan bahwa objek terinisialisasi sebelum dipanggil
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Center(
            child: Text(
              'Feel Your Expression',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: Color(0xFF42579A),
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 4),
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
                    offset: Offset(0, 4),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              'Scan your emotion here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0x847B7B),
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: Center(
              child: Text(emosi,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color.fromARGB(181, 210, 134, 19))),
            ),
          ),
          Center(
            child: Container(
              width: 370,
              height: 400,
              child: ClipRRect(
                // Use ClipRRect to clip the corners
                borderRadius: BorderRadius.circular(16),
                child: _cameraController != null &&
                        _cameraController!.value.isInitialized
                    ? CameraPreview(_cameraController!)
                    : CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
