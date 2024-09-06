import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _handleSubmit(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: text,
          isMe: true,
          imageUrl: null, // ใส่ URL ของภาพโปรไฟล์ที่นี่ถ้าต้องการ
        ));
        _messages.add(ChatMessage(
          text: 'Received: $text',
          isMe: false,
          imageUrl: 'https://www.origami.life/uploads/employee/5/employee/19777.jpg', // ตัวอย่าง URL ของภาพโปรไฟล์
        ));
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ChatBubble(message: _messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                    ),
                    onSubmitted: _handleSubmit,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmit(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
        message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe && message.imageUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(message.imageUrl!),
            ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: message.isMe ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.text,
              style: TextStyle(color: message.isMe ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String? imageUrl; // ใช้สำหรับการแสดงภาพโปรไฟล์

  ChatMessage({
    required this.text,
    required this.isMe,
    this.imageUrl,
  });
}

