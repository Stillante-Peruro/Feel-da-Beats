import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ExpressionSearchPage extends StatefulWidget {
  const ExpressionSearchPage({Key? key}) : super(key: key);

  @override
  State<ExpressionSearchPage> createState() => _ExpressionSearchPageState();
}

class _ExpressionSearchPageState extends State<ExpressionSearchPage> {
  CameraController? _cameraController; // Menggunakan nullable (?)

  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras.first,
      ResolutionPreset.medium,
    );
    await _cameraController!
        .initialize(); // Gunakan '!' karena pasti sudah diinisialisasi di sini
    if (mounted) {
      setState(() {});
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
          const SizedBox(
            height: 80,
            child: Center(
              child: Text('Output Emosi',
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
