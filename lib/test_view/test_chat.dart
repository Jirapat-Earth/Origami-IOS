import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:google_fonts/google_fonts.dart';
import '../language/translate.dart';
import 'package:badges/badges.dart' as badges;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _launchWhatsApp() async {
    const url = 'https://wa.me/1234567890'; // แทนที่ด้วยหมายเลขโทรศัพท์ของคุณ
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  void _launchLineOA() async {
    const url = 'line://ti/p/earth_33743'; // แทนที่ด้วย LINE ID ของคุณ
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open LINE OA';
    }
  }

  void _launchMessenger() async {
    const url = 'https://m.me/100084047544943'; // URL scheme สำหรับ Messenger
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open Messenger';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            InkWell(
              onTap: () => _launchWhatsApp(),
              child: CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(
                    'https://d1xsi6mgo67kia.cloudfront.net/uploads/2021/10/whatsapp.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 16,),
            InkWell(
              onTap: () => _launchLineOA(),
              child: CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(
                    'https://www.rocket.in.th/wp-content/uploads/2023/03/%E0%B8%AA%E0%B8%A3%E0%B8%B8%E0%B8%9B-Line-Official-Account.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 16,),
            InkWell(
              onTap: () => _launchMessenger(),
              child: CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(
                    'https://logos-world.net/wp-content/uploads/2021/02/Facebook-Messenger-Logo.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WhatsAppChatScreen extends StatefulWidget {
  @override
  _WhatsAppChatScreenState createState() => _WhatsAppChatScreenState();
}

class _WhatsAppChatScreenState extends State<WhatsAppChatScreen> {
  List<Map<String, dynamic>> messages = [];
  String? _replyMessage;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final String accessToken = 'YOUR_ACCESS_TOKEN';
    final String pageId = 'YOUR_PAGE_ID';
    final url = 'https://graph.facebook.com/v16.0/$pageId/conversations?access_token=$accessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var conversations = data['data'];
      setState(() {
        messages = conversations.map<Map<String, dynamic>>((conversation) {
          return {
            'message': 'ข้อความจากผู้ใช้',
            'isMe': false,
            'imageUrl': null,
          };
        }).toList();
      });
    } else {
      print('Failed to load messages');
    }
  }

  void _sendMessage({String? imageUrl}) {
    if (_messageController.text.isEmpty && imageUrl == null) {
      return;
    }

    setState(() {
      messages.add({
        'message': _messageController.text,
        'isMe': true, //false เขาส่ง , true เราส่ง
        'imageUrl': imageUrl,
      });
      _messageController.clear();
    });

    // ส่งข้อความไปยังเซิร์ฟเวอร์ที่นี่
  }

  void _replyToMessage(String message) {
    setState(() {
      _replyMessage = message;
    });
  }

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return WhatsAppChatBubble(
                  message: messages[index]['message'],
                  isMe: messages[index]['isMe'],
                  imageUrl: messages[index]['imageUrl'],
                  onReply: () => _replyToMessage(messages[index]['message']), // การตอบกลับ
                );
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (_replyMessage != null)
            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Replying to: $_replyMessage',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {
              _sendMessage(imageUrl: 'https://scontent.whatsapp.net/v/t39.8562-34/344863700_3406380742943638_5599738503671813172_n.png?ccb=1-7&_nc_sid=73b08c&_nc_ohc=0LrWDr9DXVAQ7kNvgFqa446&_nc_ht=scontent.whatsapp.net&_nc_gid=A8k3s-2q-c3IuNi8lBmle6W&oh=01_Q5AaIDPRyfvOteXUTdMSKsWxD2CGxl_e9aLzVKJBKYrJdnh8&oe=66EFA39E');
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF075E54)),
            onPressed: () => _sendMessage(),
          ),
        ],
      ),
    );
  }
}

class WhatsAppChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String? imageUrl;
  final VoidCallback? onReply;

  WhatsAppChatBubble({required this.message, required this.isMe, this.imageUrl, this.onReply});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: imageUrl!),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl!,
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (message.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                decoration: BoxDecoration(
                  color: isMe ? Colors.deepPurple.shade400 : Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isMe ? Radius.circular(12) : Radius.circular(5),
                    bottomRight: isMe ? Radius.circular(5) : Radius.circular(12),
                  ),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Image'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await _downloadImage(imageUrl);
              // เปิดลิงค์ภาพในเบราว์เซอร์
              // if (await canLaunch(imageUrl)) {
              //   await launch(imageUrl);
              // } else {
              //   throw 'Could not launch $imageUrl';
              // }
              // final Uri _url = Uri.parse(imageUrl);
              // if (!await launchUrl(_url)) {
              //   throw Exception('Could not launch ${_url}');
              // }
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.black,
          child: Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Future<void> _downloadImage(String url) async {
    try {
      // ตรวจสอบสิทธิ์การเข้าถึงที่จัดเก็บไฟล์
      // var status = await Permission.photos.request();
      // if (!status.isGranted) {
      //   Fluttertoast.showToast(
      //     msg: 'Photos permission is required to download the image',
      //     toastLength: Toast.LENGTH_LONG,
      //   );
      //   return;
      // }

      // ดาวน์โหลดไฟล์
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await _saveFile(response.bodyBytes, 'image.jpg');
        Fluttertoast.showToast(
          msg: 'Image downloaded successfully',
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        print('Failed to download image. Status code: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'Failed to download image',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Error downloading image: $e',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> _saveFile(Uint8List bytes, String filename) async {
    try {
      final directory = await getExternalStorageDirectory(); // ใช้ getExternalStorageDirectory สำหรับ Android
      if (directory == null) {
        throw Exception('Unable to get the external storage directory');
      }
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(bytes);
    } catch (e) {
      print('Error saving file: $e');
      throw Exception('Error saving file: $e');
    }
  }

  // Future<void> _downloadImage(String url) async {
  //   try {
  //     // ตรวจสอบสิทธิ์การเข้าถึงที่จัดเก็บไฟล์
  //     // var status = await Permission.photos.request();
  //     // if (!status.isGranted) {
  //     //   Fluttertoast.showToast(msg: 'Photos permission is required to download the image');
  //     //   return;
  //     // }
  //
  //     // ดาวน์โหลดไฟล์
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       await _saveFile(response.bodyBytes, 'image.jpg');
  //       Fluttertoast.showToast(msg: 'Image downloaded successfully');
  //     } else {
  //       print('Failed to download image. Status code: ${response.statusCode}');
  //       Fluttertoast.showToast(msg: 'Failed to download image');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     Fluttertoast.showToast(msg: 'Error downloading image: $e');
  //   }
  // }
  //
  // Future<void> _saveFile(Uint8List bytes, String filename) async {
  //   try {
  //     final directory = await getExternalStorageDirectory(); // ใช้ getExternalStorageDirectory สำหรับ Android
  //     if (directory == null) {
  //       throw Exception('Unable to get the external storage directory');
  //     }
  //     final file = File('${directory.path}/$filename');
  //     await file.writeAsBytes(bytes);
  //   } catch (e) {
  //     print('Error saving file: $e');
  //     throw Exception('Error saving file: $e');
  //   }
  // }
}

// class WhatsAppChatBubble extends StatelessWidget {
//   final String message;
//   final bool isMe;
//   final String? imageUrl; // Optional image URL
//
//   WhatsAppChatBubble({required this.message, required this.isMe, this.imageUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: isMe ? Color(0xFFDCF8C6) : Colors.blue,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(12),
//             topRight: Radius.circular(12),
//             bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
//             bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (imageUrl != null) // Display image if available
//               Image.network(
//                 imageUrl!,
//                 width: 200,
//                 height: 200,
//                 fit: BoxFit.cover,
//               ),
//             if (message.isNotEmpty) // Display message if available
//               Text(
//                 message,
//                 style: TextStyle(
//                   color: Colors.black87,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class WhatsAppChatScreen extends StatefulWidget {
//   @override
//   _WhatsAppChatScreenState createState() => _WhatsAppChatScreenState();
// }
//
// class _WhatsAppChatScreenState extends State<WhatsAppChatScreen> {
//   final List<Map<String, dynamic>> messages = [
//     {'message': 'Hey there!', 'isMe': false, 'imageUrl': null},
//     {'message': 'Hello! How are you?', 'isMe': true, 'imageUrl': null},
//     {'message': '', 'isMe': false, 'imageUrl': 'https://dev.origami.life/uploads/employee/185_20170727151718.png'}, // Example image message
//   ];
//
//   final TextEditingController _messageController = TextEditingController();
//
//   void _sendMessage({String? imageUrl}) {
//     if (_messageController.text.isEmpty && imageUrl == null) {
//       return;
//     }
//
//     setState(() {
//       messages.add({
//         'message': _messageController.text,
//         'isMe': true,
//         'imageUrl': imageUrl,
//       });
//       _messageController.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF075E54),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {},
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: AssetImage('assets/user_avatar.png'),
//             ),
//             SizedBox(width: 10),
//             Text('John Doe'),
//           ],
//         ),
//         actions: [
//           IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
//           IconButton(icon: Icon(Icons.call), onPressed: () {}),
//           IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return WhatsAppChatBubble(
//                   message: messages[index]['message'],
//                   isMe: messages[index]['isMe'],
//                   imageUrl: messages[index]['imageUrl'],
//                 );
//               },
//             ),
//           ),
//           _buildMessageInputField(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMessageInputField() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.attach_file, color: Colors.grey),
//             onPressed: () {
//               _sendMessage(imageUrl: 'https://via.placeholder.com/150'); // Simulate sending an image
//             },
//           ),
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Type a message',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send, color: Color(0xFF075E54)),
//             onPressed: () => _sendMessage(),
//           ),
//         ],
//       ),
//     );
//   }
// }