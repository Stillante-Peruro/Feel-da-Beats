import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:feel_da_beats_app/utils/camera_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:feel_da_beats_app/pages/expressionrecomendation.dart';

class ExpressionSearchPage extends StatefulWidget {
  final bool gagalIdentifikasi;

  const ExpressionSearchPage({Key? key, required this.gagalIdentifikasi})
      : super(key: key);

  @override
  State<ExpressionSearchPage> createState() => _ExpressionSearchPageState();
}

class _ExpressionSearchPageState extends State<ExpressionSearchPage>
    with WidgetsBindingObserver {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  var _cameraLensDirection = CameraLensDirection.front;
  String emosi = 'Tidak Ada Wajah Terdeteksi';
  late Timer _redirectTimer;
  bool _isPageSwitched = false;
  bool _gagalIdentifikasi = false;
  bool _timerAlreadyStarted = false;
  late Timer _faceDetectionTimer;
  bool _timeRedirect = false;
  late InputImage gambarBaru;
  Directory? tempDir;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.gagalIdentifikasi == false) {
      _startTimerToCancel();
    }
    _faceDetectionTimer = Timer(Duration(seconds: 0), () {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _canProcess = false;
    _faceDetector.close();
    _redirectTimer.cancel();
    _faceDetectionTimer.cancel();
    _cleanUpResources();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _cleanUpResources();
    } else if (state == AppLifecycleState.resumed) {
      if (_isPageSwitched && emosi == 'Wajah Terdeteksi') {
        _saveFaceImage(gambarBaru);
      }
    }
  }

  Future<void> _cleanUpResources() async {
    if (tempDir != null) {
      try {
        tempDir!.deleteSync(recursive: true);
        tempDir!.create(recursive: true);
      } catch (e) {
        print('Error cleaning up resources: $e');
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
              'Feel Your Expression',
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
                height: 500,
                child: widget.gagalIdentifikasi
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Hero(
                              tag: 'refresh_icon',
                              child: Icon(Icons.refresh, size: 100),
                            ),
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
                          onImage: (inputImage) {
                            _processImage(inputImage);
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

  void _startTimerToCancel() {
    if (!_timerAlreadyStarted) {
      _timerAlreadyStarted = true;
      _redirectTimer = Timer(Duration(seconds: 10), () {
        if (emosi == 'Tidak Ada Wajah Terdeteksi') {
          setState(() {
            _isPageSwitched = true;
            _gagalIdentifikasi = true;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ExpressionSearchPage(gagalIdentifikasi: _gagalIdentifikasi),
              ),
            );
          });
        } else {
          _saveFaceImage(gambarBaru);
        }
      });
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    try {
      final faces = await _faceDetector.processImage(inputImage);

      _isBusy = false;

      gambarBaru = inputImage;

      if (mounted) {
        if (faces.isNotEmpty) {
          setState(() {
            emosi = 'Wajah Terdeteksi';
            print('jalan');
            _startFaceDetectionTimer(faces.first);
          });
        } else {
          setState(() {
            emosi = 'Tidak Ada Wajah Terdeteksi';
            _timeRedirect = false;
          });
        }
      }
    } catch (e) {
      print('Error processing image: $e');
      _isBusy = false;
    }
  }

  void _startFaceDetectionTimer(Face face) {
    if (!_timeRedirect) {
      _timeRedirect = true;
      bool imageSaved = false;
      _faceDetectionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timer.tick >= 3 && !imageSaved) {
          imageSaved = true;
          if (emosi == 'Wajah Terdeteksi') {
            print('jalan1');
            _saveFaceImage(gambarBaru);
            timer.cancel();
          }
        }
      });
    }
  }

  Future<void> _saveFaceImage(InputImage inputImage) async {
    try {
      print('jalan2');
      final image = decodeYUV420SP(inputImage);
      print('jalan3');
      if (!_isPageSwitched) {
        tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir!.path}/face_image.jpg';
        File(filePath).writeAsBytesSync(img.encodeJpg(image));
        setState(() {
          _isPageSwitched = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendedSongsPage(imagePath: filePath),
            ),
          );
        });
      }
    } catch (e) {
      print('Error saving face image: $e');
    }
  }

  img.Image decodeYUV420SP(InputImage image) {
    final width = image.metadata!.size.width.toInt();
    final height = image.metadata!.size.height.toInt();

    Uint8List yuv420sp = image.bytes!;

    final outImg = img.Image(width, height);

    final int frameSize = width * height;

    for (int j = 0, yp = 0; j < height; j++) {
      int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
      for (int i = 0; i < width; i++, yp++) {
        int y = (0xff & yuv420sp[yp]) - 16;
        if (y < 0) y = 0;
        if ((i & 1) == 0) {
          v = (0xff & yuv420sp[uvp++]) - 128;
          u = (0xff & yuv420sp[uvp++]) - 128;
        }
        int y1192 = 1192 * y;
        int r = (y1192 + 1634 * v);
        int g = (y1192 - 833 * v - 400 * u);
        int b = (y1192 + 2066 * u);

        if (r < 0) {
          r = 0;
        } else if (r > 262143) {
          r = 262143;
        }
        if (g < 0) {
          g = 0;
        } else if (g > 262143) {
          g = 262143;
        }
        if (b < 0) {
          b = 0;
        } else if (b > 262143) {
          b = 262143;
        }

        r = (r < 0) ? 0 : ((r > 262143) ? 262143 : r);
        g = (g < 0) ? 0 : ((g > 262143) ? 262143 : g);
        b = (b < 0) ? 0 : ((b > 262143) ? 262143 : b);

        outImg.setPixelRgba(i, j, r >> 10, g >> 10, b >> 10, 255);
      }
    }
    final rotatedImg = img.copyRotate(outImg, 270);
    return rotatedImg;
  }
}
