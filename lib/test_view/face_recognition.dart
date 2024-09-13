import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'camera_ml.dart';
import 'database_helper.dart';

class FaceRecognitionScreen extends StatefulWidget {
  final String imagePath;

  FaceRecognitionScreen({required this.imagePath});

  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  String? recognizedName;
  bool _isLoading = true;
  String? errorMessage;
  late FaceDetector _faceDetector;

  @override
  void initState() {
    super.initState();
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
      ),
    );
    _recognizeFace();
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _recognizeFace() async {
    setState(() {
      _isLoading = true;
    });

    List<Map<String, dynamic>> users = await DatabaseHelper().getUsers();

    final inputImage = InputImage.fromFile(File(widget.imagePath));
    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) {
      setState(() {
        _isLoading = false;
        errorMessage = "No face detected in the captured image.";
      });
      return;
    }

    final faceToMatch = faces[0];
    bool isMatched = false;

    for (var user in users) {
      String imagePath = user['imagePath'];
      final dbImage = InputImage.fromFile(File(imagePath));
      final dbFaces = await _faceDetector.processImage(dbImage);

      if (dbFaces.isNotEmpty) {
        final dbFace = dbFaces[0];
        double similarity = _calculateFaceSimilarity(
          faceToMatch.boundingBox,
          dbFace.boundingBox,
        );

        if (similarity > 0.8) { // Adjust threshold as needed
          setState(() {
            recognizedName = user['name'];
            isMatched = true;
          });
          break;
        }
      }
    }

    setState(() {
      _isLoading = false;
      if (!isMatched) {
        errorMessage = "Error: No matching face found in the database.";
      }
    });
  }

  double _calculateFaceSimilarity(Rect rect1, Rect rect2) {
    // Calculate intersection
    final intersectRect = rect1.intersect(rect2);
    final intersectionArea = intersectRect.width * intersectRect.height;

    // Calculate union
    final rect1Area = rect1.width * rect1.height;
    final rect2Area = rect2.width * rect2.height;
    final unionArea = rect1Area + rect2Area - intersectionArea;

    if (unionArea == 0) {
      return 0;
    }

    return intersectionArea / unionArea;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition Result'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : recognizedName != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              File(widget.imagePath)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios)),
                Text(
                  recognizedName!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(),
              ],
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Expanded(
              child: Column(
                children: [
                  Icon(
                    Icons.error,
                    size: 100,
                    color: Colors.red,
                  ),
                  SizedBox(height: 20),
                  Text(
                    errorMessage ?? "An unknown error occurred.",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationScreen(filePath: widget.imagePath),
                    ),
                  );
                },
                child: Text('Register'),
              ),
            ),
          ],
        )

        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Icon(
        //       Icons.error,
        //       size: 100,
        //       color: Colors.red,
        //     ),
        //     SizedBox(height: 20),
        //     Text(
        //       errorMessage ?? "An unknown error occurred.",
        //       style: TextStyle(fontSize: 18, color: Colors.red),
        //       textAlign: TextAlign.center,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
