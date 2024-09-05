import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final String accessToken = 'AV15YUHGS6Xp2DYGw5FID8Gwlc4gxRJCAKlDjSMG9Bm'; // ใส่ Access Token ที่นี่
  final String userId = '2006248746'; // ใส่ User ID ที่นี่

  Future<void> sendMessage(String message) async {
    final url = 'https://www.origami.life/webhook';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = jsonEncode({
      'to': userId,
      'messages': [
        {
          'type': 'text',
          'text': message,
        },
      ],
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LINE Messaging'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => sendMessage('Hello from Flutter!'),
          child: Text('Send Message'),
        ),
      ),
    );
  }
}