import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import 'language/translate.dart';
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import for HTTP requests

int selectedRadio = 2;

class TranslatePage extends StatefulWidget {
  const TranslatePage({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  @override
  void initState() {
    super.initState();
    _loadSelectedRadio();
  }

  // โหลดค่าที่บันทึกไว้
  _loadSelectedRadio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = prefs.getInt('selectedRadio') ?? 2;
      Translate();
    });
  }

  // บันทึกค่าเมื่อมีการเปลี่ยนแปลง
  _handleRadioValueChange(int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = value!;
      prefs.setInt('selectedRadio', selectedRadio);
      Translate();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            num: 0,
            popPage: 3,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Flag_of_Thailand_%28non-standard_colours%29.svg/180px-Flag_of_Thailand_%28non-standard_colours%29.svg.png',
                          // width: 200,
                          height: 100,
                        ),
                        TextButton(
                          // style:ButtonStyle(shadowColor:Color(colors.)),
                          onPressed: () {
                            _handleRadioValueChange(1);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (selectedRadio == 1)
                                  ? Icon(
                                      Icons.radio_button_on,
                                      color: Colors.orange,
                                    )
                                  : Icon(
                                      Icons.radio_button_off,
                                      color: Colors.orange,
                                    ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'ภาษาไทย',
                                style: GoogleFonts.openSans(
                                    fontSize: 16, color: Color(0xFF555555)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/1200px-Flag_of_the_United_Kingdom_%281-2%29.svg.png',
                          // width: 200,
                          height: 100,
                        ),
                        TextButton(
                          onPressed: () {
                            _handleRadioValueChange(2);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (selectedRadio == 2)
                                  ? Icon(
                                      Icons.radio_button_on,
                                      color: Colors.orange,
                                    )
                                  : Icon(
                                      Icons.radio_button_off,
                                      color: Colors.orange,
                                    ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'English',
                                style: GoogleFonts.openSans(
                                    fontSize: 16, color: Color(0xFF555555)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();

  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final uri =
          Uri.parse("https://www.origami.life/api/origami/profile/profile.php");
      final response = await http.post(
        uri,
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'auth_password': widget.employee.auth_password,
        },
      );

      if (response.statusCode == 200) {
        // Convert JSON response to Map
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Parse JSON data into objects
        ProfileResponse profileData =
            ProfileResponse.fromJson(jsonResponse['employee_data']);

        // Return data as a Map
        return {
          'profileData': profileData,
        };
      } else {
        print('Failed to load academy data');
        throw Exception('Failed to load academies');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  String _firstname = "";
  String _lastname = "";
  String _nicktname = "";

  @override
  void initState() {
    super.initState();
    _firstnameController.addListener(() {
      _firstname = _firstnameController.text;
    });
    _lastnameController.addListener(() {
      _lastname = _lastnameController.text;
    });
    _nicknameController.addListener(() {
      _nicktname = _nicknameController.text;
    });
  }

  Widget _loading() {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchProfile(), // รอการโหลดข้อมูลจาก API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // แสดงตัวโหลดข้อมูล
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.orange,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                '$Loading...',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF555555),
                ),
              ),
            ],
          ));
        } else if (snapshot.hasError) {
          // แสดงข้อความเมื่อมีข้อผิดพลาด
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // เมื่อโหลดข้อมูลสำเร็จ
          ProfileResponse profileData = snapshot.data!['profileData'];

          return _getContentWidget(profileData);
        } else {
          return Center(child: Text('No data found.'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.grey.shade50,
        child: _loading(),
      ),
    );
  }

  Widget _getContentWidget(ProfileResponse profileData) {
    String base64String = profileData.signature_drawing.split(',').last;
    Uint8List imageBytes = base64Decode(base64String);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 0,
            //     blurRadius: 2,
            //     offset: Offset(0, 3), // x, y
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(int.parse(
                                            '0xFF${profileData.dna_color}')),
                                        width: 5,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                          profileData.emp_avatar ?? '',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(int.parse(
                                            '0xFF${profileData.dna_color}')),
                                        width: 5,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            profileData.dna_logo ?? '',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                profileData.emp_prefix,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 18,
                                                  color: Color(0xFF555555),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                profileData.emp_firstname,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 18,
                                                  color: Color(0xFF555555),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            profileData.emp_lastname,
                                            style: GoogleFonts.openSans(
                                              fontSize: 18,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Nickname: ${profileData.emp_nickname}",
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              color: Color(0xFF555555),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'DNA',
                                      style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      profileData.dna_name,
                                      style: GoogleFonts.openSans(
                                          fontSize: 14, color: Color(0xFF555555)),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Birth Date',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              profileData.emp_birthday,
                              style: GoogleFonts.openSans(
                                  fontSize: 14, color: Color(0xFF555555)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "(${profileData.emp_age} years old)",
                              style: GoogleFonts.openSans(
                                  fontSize: 14, color: Color(0xFF555555)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Start Date',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          profileData.emp_start_date,
                          style: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF555555)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Home Location',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          profileData.home_location,
                          style: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF555555)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Signature ',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 1,
                                    // offset: Offset(0, 1), // x, y
                                  ),
                                ],
                              ),
                              child: Image.memory(
                                imageBytes,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'Signature ',
                //       style: GoogleFonts.openSans(
                //         fontSize: 16,
                //         color: Color(0xFF555555),
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     SizedBox(
                //       height: 16,
                //     ),
                //     Container(
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(15),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.grey.withOpacity(0.5),
                //             spreadRadius: 0,
                //             blurRadius: 1,
                //             // offset: Offset(0, 1), // x, y
                //           ),
                //         ],
                //       ),
                //       child: Image.memory(
                //         imageBytes,
                //         height: 150,
                //         width: double.infinity,
                //         fit: BoxFit.fill,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(1),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(0, 185, 0, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 60,
                        right: 60),
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Submit',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileResponse {
  final String emp_prefix;
  final String emp_firstname;
  final String emp_lastname;
  final String emp_nickname;
  final String dna_color;
  final String dna_name;
  final String dna_logo;
  final String emp_birthday;
  final String emp_age;
  final String emp_start_date;
  final String home_location;
  final String signature_drawing;
  final String emp_avatar;

  // Constructor
  ProfileResponse({
    required this.emp_prefix,
    required this.emp_firstname,
    required this.emp_lastname,
    required this.emp_nickname,
    required this.dna_color,
    required this.dna_name,
    required this.dna_logo,
    required this.emp_birthday,
    required this.emp_age,
    required this.emp_start_date,
    required this.home_location,
    required this.signature_drawing,
    required this.emp_avatar,
  });

  // Factory constructor to create an Employee instance from a JSON map
  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      emp_prefix: json['emp_prefix'] ?? '',
      emp_firstname: json['emp_firstname'] ?? '',
      emp_lastname: json['emp_lastname'] ?? '',
      emp_nickname: json['emp_nickname'] ?? '',
      dna_color: json['dna_color'] ?? '',
      dna_name: json['dna_name'] ?? '',
      dna_logo: json['dna_logo'] ?? '',
      emp_birthday: json['emp_birthday'] ?? '',
      emp_age: json['emp_age'] ?? '',
      emp_start_date: json['emp_start_date'] ?? '',
      home_location: json['home_location'] ?? '',
      signature_drawing: json['signature_drawing'] ?? '',
      emp_avatar: json['emp_avatar'] ?? '',
    );
  }
}
