import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:origami_ios/test_view/camera_ml_new.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'database_helper.dart';
import 'face_recognition.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = path.join(directory.path,
            'my_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await File(image.path).copy(filePath);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImagePreviewScreen(imagePath: filePath),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    return await _databaseHelper.getUsers();
  }

  void _deleteUser(int id) async {
    await _databaseHelper.deleteUser(id);
    setState(() {}); // Refresh the UI after deletion
  }

  void _confirmDelete(int id, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete $name?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(id);
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available.'));
                  } else {
                    final users = snapshot.data!;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.file(
                                File(user['imagePath']),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                user['name'],
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(
                                  user['id'], user['name']); // Confirm deletion
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera, context),
                    child: Text('Take Picture'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery, context),
                    child: Text('Gallery'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;

  ImagePreviewScreen({required this.imagePath});

  final FaceDetector _faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Preview')),
      body: Center(
        child: Column(
          children: [
            Image.file(File(imagePath)),
            ElevatedButton(
              onPressed: () async {
                try {
                  // สแกนใบหน้าและลงทะเบียน
                  final inputImage = InputImage.fromFile(File(imagePath));
                  final faces = await _faceDetector.processImage(inputImage);

                  if (faces.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FaceRecognitionScreen(imagePath: imagePath),
                      ),
                    );
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => RegistrationScreen(filePath: imagePath),
                    //   ),
                    // );
                  } else {
                    print("No face detected.");
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Scan Face'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  final String filePath;

  RegistrationScreen({required this.filePath});
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  await DatabaseHelper().insertUserData(name, filePath);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FaceRecognitionScreen(imagePath: filePath),
                    ),
                  );
                } else {
                  print("Please enter a name.");
                }
                print('Registered name: $name');
                // Navigate back or to another screen if needed
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
