import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

// void main() {
//   // ตั้งค่า LINE SDK โดยใช้ Channel ID ของคุณ
//   LineSDK.instance.setup('YOUR_CHANNEL_ID').then((_) {
//     print('LINE SDK is Prepared');
//   });
//   runApp(LineOAPage());
// }

class LineOAPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LINE Login Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _userId = '';
  String _userName = '';
  var _userEmail;

  // ฟังก์ชันสำหรับการล็อกอิน
  Future<void> _loginWithLine() async {
    try {
      final result = await LineSDK.instance.login(
        scopes: ["profile", "openid", "email"],
      );

      setState(() {
        _userId = result.userProfile!.userId;
        _userName = result.userProfile!.displayName;
        _userEmail = result.accessToken!.idToken!;
      });

      print('User ID: $_userId');
      print('User Name: $_userName');
      print('User Email: $_userEmail');

    } catch (e) {
      print('Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LINE Login Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _loginWithLine,
              child: Text('Login with LINE'),
            ),
            SizedBox(height: 20),
            if (_userId.isNotEmpty) ...[
              Text('User ID: $_userId'),
              Text('User Name: $_userName'),
              Text('User Email: $_userEmail'),
            ]
          ],
        ),
      ),
    );
  }
}
