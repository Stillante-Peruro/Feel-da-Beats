import 'dart:async';
import 'package:camera/camera.dart';
import 'package:feel_da_beats_app/utils/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tflite_v2/tflite_v2.dart';

// import 'package:feel_da_beats/utils/face_detector_painter.dart';
// import 'package:feel_da_beats/utils/detector_view.dart';
import 'package:feel_da_beats_app/pages/expressionrecomendation.dart';

class ExpressionSearchPage extends StatefulWidget {
  final bool gagalIdentifikasi;

  const ExpressionSearchPage({Key? key, required this.gagalIdentifikasi})
      : super(key: key);

  @override
  State<ExpressionSearchPage> createState() => _ExpressionSearchPageState();
}

class _ExpressionSearchPageState extends State<ExpressionSearchPage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  // String? _text;
  var _cameraLensDirection = CameraLensDirection.front;
  String emosi = 'Tidak Ada Wajah Terdeteksi';
  late Timer _redirectTimer;
  bool _isPageSwitched = false;
  bool _gagalIdentifikasi = false;
  bool _timerAlreadyStarted = false;

  @override
  void initState() {
    super.initState();
    if (widget.gagalIdentifikasi == false) {
      _startTimerToCancel();
    }
    _loadModel();
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    Tflite.close();
    _resetTimer();
    _redirectTimer.cancel(); // Pastikan timer di-cancel saat halaman di-dispose
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
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color.fromARGB(181, 210, 134, 19))),
            ),
          ),
          Center(
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey),
                width: 370,
                height: 400,
                child: widget.gagalIdentifikasi
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.refresh,
                                size: 100), // Icon reload besar
                            onPressed: () {
                              setState(() {
                                _gagalIdentifikasi = false;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExpressionSearchPage(
                                        gagalIdentifikasi: _gagalIdentifikasi),
                                  ),
                                );
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Coba Lagi',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CameraView(
                          customPaint: _customPaint,
                          onImage: (inputImage, cameraImage) {
                            _processImage(inputImage, cameraImage);
                          },
                          initialCameraLensDirection: _cameraLensDirection,
                          onCameraLensDirectionChanged: (value) =>
                              _cameraLensDirection = value,
                        ))),
          ),
        ],
      ),
    );
  }

  _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<void> _runModel(CameraImage cameraImage) async {
    try {
      if (!_canProcess) return;
      if (_isBusy) return;
      _isBusy = true;
      setState(() {
        // _text = 'Hola';
      });
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
      _isBusy = false;

      if (recognitions != null && recognitions.isNotEmpty) {
        var detectedEmotion = recognitions[0]['label'];

        if (detectedEmotion != null && detectedEmotion != emosi) {
          setState(() {
            emosi = detectedEmotion;
            _resetTimer();
          });
        } else if (emosi == detectedEmotion) {
          _startTimerToRedirect();
        } else {
          _resetTimer();
          setState(() {
            emosi = 'Tidak Ada Wajah Terdeteksi';
          });
        }
      } else {
        _resetTimer();
        setState(() {
          emosi = 'Tidak Ada Wajah Terdeteksi';
        });
      }
    } catch (e) {
      print('Error during model inference: $e');
    }
  }

  void _startTimerToRedirect() {
    String temp = emosi;
    _redirectTimer = Timer(Duration(seconds: 4), () {
      if (temp != 'Tidak Ada Wajah Terdeteksi' &&
          emosi == temp &&
          !_isPageSwitched) {
        _isPageSwitched = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecommendedSongsPage(emotion: emosi),
          ),
        );
      }
    });
  }

  void _startTimerToCancel() {
    if (!_timerAlreadyStarted) {
      _redirectTimer = Timer(Duration(seconds: 10), () {
        _isPageSwitched = true;

        // Ubah nilai _gagalIdentifikasi menjadi true
        setState(() {
          _gagalIdentifikasi = true;
        });

        // Pindah ke halaman baru dengan membawa argument
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ExpressionSearchPage(gagalIdentifikasi: _gagalIdentifikasi),
          ),
        ); // Hapus halaman saat ini dari tumpukan halaman
      });

      _timerAlreadyStarted = true;
    }
  }

  void _resetTimer() {
    _redirectTimer.cancel();
    _isPageSwitched = false; // Reset _isPageSwitched
  }

  Future<void> _processImage(
      InputImage inputImage, CameraImage cameraImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      // _text = 'Hola';
    });
    final faces = await _faceDetector.processImage(inputImage);

    _isBusy = false;

    if (faces.isNotEmpty) {
      setState(() {
        emosi = "Wajah Terdeteksi";
        _startTimerToRedirect();
        _runModel(
            cameraImage); //seharusny kalo ini jalan bener. tapi ado exception jadi dk jalan dio
      });
    } else {
      // _startTimerToCancel();
      setState(() {
        emosi = 'Tidak Ada Wajah Terdeteksi(faces)';
      });
    }

    if (mounted) {
      setState(() {});
    }
  }
}
