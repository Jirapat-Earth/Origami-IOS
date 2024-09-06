import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import 'chat_line_oa.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
  }

  // void line_oa() {
  //   // LineSDK.instance.setup('YOUR_CHANNEL_ID');
  //   runApp(LineOA());
  // }

  int _selectedIndex = 0;
  Widget _bodySwitch() {
    switch (_selectedIndex) {
      case 0:
        return LineOAPage();
      case 1:
        return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Text(
            'Messenger',
            style: GoogleFonts.openSans(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(
            'ERROR!',
            style: GoogleFonts.openSans(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Row(
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://www.rocket.in.th/wp-content/uploads/2023/03/%E0%B8%AA%E0%B8%A3%E0%B8%B8%E0%B8%9B-Line-Official-Account.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://www.computerhope.com/jargon/f/facebook-messenger.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: _bodySwitch()
      ),
    );

  }
}
