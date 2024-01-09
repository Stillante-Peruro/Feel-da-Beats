import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ExpressionSearchPage extends StatefulWidget {
  const ExpressionSearchPage({Key? key}) : super(key: key);

  @override
  State<ExpressionSearchPage> createState() => _ExpressionSearchPageState();
}

class _ExpressionSearchPageState extends State<ExpressionSearchPage> {
  CameraController? _cameraController; // Menggunakan nullable (?)

  String emosi = '';

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

    if (selectedCamera == null) {
      selectedCamera = _cameras.first;
    }

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
        setState(() {
          emosi = recognitions[0]['label'];
        });
      }
    }
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
