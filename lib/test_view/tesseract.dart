import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_vcard_parser/simple_vcard_parser.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});

  @override
  _OcrScreenState createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  String _extractedText = '';
  File? _image;
  List<String> lines = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _voidExtractText(); // เรียกใช้ _voidExtractText หลังจากเลือกภาพ
    }
  }

  Future<void> _voidExtractText() async {
    if (_image != null) {
      try {
        final text = await FlutterTesseractOcr.extractText(_image!.path);
        setState(() {
          _extractedText = text;
          // แยกข้อความเป็นบรรทัดที่ไม่ว่าง
          lines = _extractedText.split('\n').where((line) => line.trim().isNotEmpty).toList();
          print(lines);
        });
        await _addContactFromExtractedText();
      } catch (e) {
        print('Error extracting text: $e');
      }
    }
  }

  Future<void> _addContactFromExtractedText() async {
    // ขออนุญาตเข้าถึงสมุดโทรศัพท์
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      String name = lines.isNotEmpty ? lines[0] : 'Unknown'; // แถวแรกคือชื่อ
      String email = '';
      String telephone = '';
      String company = '';
      String postalAddress = '';

      // ตรวจสอบบรรทัดที่มี @ และกำหนดให้เป็นอีเมล
      for (String line in lines) {
        if (line.contains('@')) {
          email = line; // ถ้าบรรทัดมี @ ให้เก็บเป็นอีเมล
        } else if (line.contains('Company:')) {
          company = line.replaceAll('Company:', '').trim(); // กำหนดให้เป็นบริษัท
        } else if (line.contains('Address:')) {
          postalAddress = line.replaceAll('Address:', '').trim(); // กำหนดให้เป็นที่อยู่ทางไปรษณีย์
        } else {
          // ถ้าบรรทัดไม่มี @ หรือคำว่า Company: หรือ Address: ให้เก็บเป็นหมายเลขโทรศัพท์
          telephone = cleanPhoneNumber(line); // ใช้บรรทัดสุดท้ายเป็นหมายเลขโทรศัพท์
        }
      }

      // สร้าง vCard เป็น String
      String vCardString = 'BEGIN:VCARD\n'
          'VERSION:3.0\n'
          'FN:$name\n'
          'EMAIL:$email\n'
          'TEL:$telephone\n'
          'ORG:$company\n'
          'ADR:$postalAddress\n'
          'END:VCARD';


      // สร้าง contact สำหรับ contacts_service
      final contact = Contact(
        givenName: name,
        emails: email.isNotEmpty ? [Item(label: 'email', value: email)] : [],
        phones: telephone.isNotEmpty ? [Item(label: 'mobile', value: telephone)] : [],
        company: company.isNotEmpty ? company : null,
        postalAddresses: postalAddress.isNotEmpty
            ? [PostalAddress(label: 'home', street: postalAddress)]
            : [],
      );

      // เพิ่มผู้ติดต่อในสมุดโทรศัพท์
      await ContactsService.addContact(contact);
      print('Contact added: $name');

      // บันทึก vCard ลงในไฟล์ (ถ้าต้องการ)
      final file = File('path/to/your.vcf'); // เปลี่ยนที่อยู่ที่ต้องการเก็บไฟล์
      await file.writeAsString(vCardString);
      print('vCard saved to ${file.path}');
    } else {
      print('Permission denied to access contacts.');
    }
  }

  String cleanPhoneNumber(String rawNumber) {
    // ใช้ RegExp เพื่อลบอักขระพิเศษและเก็บเฉพาะตัวเลข
    final RegExp regExp = RegExp(r'[^\d]');
    String cleanedNumber = rawNumber.replaceAll(regExp, '');

    // ตรวจสอบว่าเป็นหมายเลขโทรศัพท์ที่ถูกต้องหรือไม่
    if (cleanedNumber.startsWith('0')) {
      cleanedNumber = cleanedNumber.substring(1); // ลบศูนย์แรกออก
    }

    // หากหมายเลขโทรศัพท์มีความยาวที่ถูกต้อง
    if (cleanedNumber.length == 9) {
      return '+66$cleanedNumber'; // แปลงหมายเลขโทรศัพท์เป็นรูปแบบ +66
    } else if (cleanedNumber.length == 8) {
      return '02$cleanedNumber'; // ถ้าเป็นเบอร์บ้านในกรุงเทพ
    }

    return rawNumber; // หากหมายเลขไม่ถูกต้อง ให้คืนค่ากลับเป็นหมายเลขเดิม
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('VCard'),
            Spacer(),
            IconButton(onPressed: ()=> _pickImage(), icon: Icon(Icons.document_scanner_outlined))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // แสดงภาพที่เลือก
              if (_image != null)
                Image.file(_image!),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _pickImage,
              //   child: Text('เลือกภาพถ่าย'),
              // ),
              SizedBox(height: 20),
              // แสดงข้อความที่ถูกดึงมา
              Text(_extractedText.isNotEmpty ? _extractedText : ''),
              // แสดงบรรทัดที่ถูกแยก
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: lines.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         title: Text(lines[index]),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
