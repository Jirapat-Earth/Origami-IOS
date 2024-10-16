import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;

class SkoopScreen extends StatefulWidget {
  const SkoopScreen({super.key, required this.isSkoop});
  final Function(int) isSkoop;

  @override
  _SkoopScreenState createState() => _SkoopScreenState();
}

class _SkoopScreenState extends State<SkoopScreen> {
  TextEditingController _descriptionController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<String> _addImage = [];
  String? _base64Image;

  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      // _search = _descriptionController.text;
      print("Current text: ${_descriptionController.text}");
    });
  }

  Future<void> _pickAndCompressImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        File imageFile = File(image.path);
        final bytes = await imageFile.readAsBytes();

        int originalSize = bytes.lengthInBytes; // ขนาดไฟล์ก่อนบีบอัด
        print('Original size: ${originalSize / 1024} KB'); // แสดงขนาดเป็น KB

        img.Image? decodedImage = img.decodeImage(bytes);

        if (decodedImage != null) {
          List<int> compressedImage = [];
          int quality = 100;
          int maxSize = 500 * 1024;

          do {
            compressedImage = img.encodeJpg(decodedImage, quality: quality);
            if (compressedImage.length > maxSize) {
              quality -= 25;
            }
          } while (compressedImage.length > maxSize && quality > 0);

          final compressedImageFile = File('${imageFile.path}_compressed.jpg');
          await compressedImageFile.writeAsBytes(compressedImage);
          int compressedSize = compressedImage.length; // ขนาดไฟล์หลังบีบอัด
          print('Compressed size: ${compressedSize / 1024} KB'); // แสดงขนาดเป็น KB

          // แปลงเป็น Base64
          String base64Image = base64Encode(compressedImage);
          setState(() {
            _image = compressedImageFile;
            _addImage.add(_image!.path);
            _base64Image = base64Image;
          });
        }
      } catch (e) {
        // จัดการข้อผิดพลาดที่เกิดขึ้น
        print('Error: $e');
      }
    }
  }

  void _removeImageAtIndex(int index) {
    setState(() {
      _addImage.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Skoop',
          style: GoogleFonts.openSans(
            fontSize: 30,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              widget.isSkoop(1);
            },
            child: Row(
              children: [
                Text(
                  'DONE',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16)
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  minLines: 3,
                  maxLines: null,
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.openSans(
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    hintText: '',
                    hintStyle: GoogleFonts.openSans(
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    filled: true, // เปิดการใช้สีพื้นหลัง
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange, // ขอบสีส้มตอนที่โฟกัส
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _locationGM(),
                _showImagePhoto(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showImagePhoto() {
    return _addImage.isNotEmpty
        ? InkWell(
            onTap: () => _pickAndCompressImage(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.orange,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: _addImage.length,
                        shrinkWrap: true, // ทำให้ GridView มีขนาดพอดีกับเนื้อหา
                        physics:
                            NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ GridView
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // ตั้งค่าให้มี 2 รูปต่อ 1 แถว
                          crossAxisSpacing: 2, // ระยะห่างระหว่างรูปแนวนอน
                          mainAxisSpacing: 2, // ระยะห่างระหว่างรูปแนวตั้ง
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(_addImage[index]),
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () => _removeImageAtIndex(index),
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.white,
                                        ),
                                        Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here to select an image.',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.orange.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () => _pickAndCompressImage(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.orange,
                        width: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here to select an image.',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.orange.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _locationGM() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Lication',
          maxLines: 1,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => LocationGoogleMap(
            //       latLng: (LatLng? value) {
            //         setState(() {
            //           _selectedLocation = value;
            //         });
            //       },
            //     ),
            //   ),
            // );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.orange,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    (_selectedLocation == null)
                        ? ''
                        : '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                    maxLines: 1,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
                Icon(Icons.location_on, color: Color(0xFF555555), size: 20),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
