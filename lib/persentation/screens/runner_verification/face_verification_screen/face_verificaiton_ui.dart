import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:kydu/persentation/screens/home_page/bottom_nav/home_page.dart';

class FaceVerificationUI extends StatefulWidget {
  final CameraController cameraController;

  const FaceVerificationUI({super.key, required this.cameraController});

  @override
  State<FaceVerificationUI> createState() => _FaceVerificationUIState();
}

class _FaceVerificationUIState extends State<FaceVerificationUI> {
  FaceDetector? _faceDetector;
  String _faceStatusMessage = '';
  bool _faceVerified = false;
  bool _canNavigateToHomePage = false;

  @override
  void initState() {
    super.initState();
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
      ),
    );
  }

  @override
  void dispose() {
    _faceDetector?.close();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      XFile imageFile = await widget.cameraController.takePicture();
      await _processCapturedImage(imageFile.path);
    } catch (e) {
      log('Error capturing image: $e');
    }
  }

  Future<void> _processCapturedImage(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final List<Face> faces = await _faceDetector!.processImage(inputImage);

    if (faces.isNotEmpty) {
      setState(() {
        _updateFaceStatusMessage('Face detected!');
        _verifyFace(faces.first);
      });
    } else {
      setState(() {
        _updateFaceStatusMessage('No face detected. Please try again.');
        _faceVerified = false;
      });
    }
  }

  void _updateFaceStatusMessage(String message) {
    setState(() {
      _faceStatusMessage = message;

      // Check if the message is "Face detected!" to enable navigation
      if (message == 'Face detected!') {
        _faceVerified = true;
      } else {
        _faceVerified = false;
      }
    });
  }

  void _verifyFace(Face face) async {
    bool isVerified = await _faceVerificationLogic(face);

    setState(() {
      _faceVerified = isVerified;
      _canNavigateToHomePage = _faceVerified; // Set to true if face is verified
    });
  }

  Future<bool> _faceVerificationLogic(Face face) async {
    // Replace this with your actual face comparison logic
    if (face.smilingProbability != null && face.smilingProbability! > 0.5) {
      return true;
    } else {
      return false;
    }
  }

  void _verifyFaceManually() {
    _captureImage();
  }

  void _navigateToHomePage() {
    if (_canNavigateToHomePage) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraPreview(widget.cameraController),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _faceStatusMessage,
                  style: const TextStyle(fontSize: 20.0),
                ),
                if (_faceVerified)
                  const Text(
                    'Face verified! Navigating to Home Page...',
                    style: TextStyle(fontSize: 20.0, color: Colors.green),
                  ),
                ElevatedButton(
                  onPressed: () {
                    _faceVerified
                        ? _navigateToHomePage()
                        : _verifyFaceManually();
                  },
                  child: Text(_faceVerified ? 'Continue' : 'Capture Image'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
