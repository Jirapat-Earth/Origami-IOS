import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../academy/academy.dart';
import '../language/translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../origami_view.dart';
import '../setting_translate.dart';
import '../trandar_shop/trandar_shop.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.num,
    required this.popPage,
  }) : super(key: key);
  final int num;
  final int popPage;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    // _loadSelectedRadio();
    String username = _usernameController.text;
    String password = _passwordController.text;
    _saveCredentials(username, password);
    if (username.isEmpty && password.isEmpty) {
      // Show error message if username or password is empty
      // if (_formKey.currentState!.validate()) {
      //   String email = _usernameController.text;
      //   String password = _passwordController.text;
      //   Fluttertoast.showToast(msg: 'Logged in as $email');
      // }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password.',
              style: GoogleFonts.openSans(
                color: Colors.white,
              )),
        ),
      );
      return;
    } else if (username.isNotEmpty && password.isNotEmpty) {
      final uri = Uri.parse('https://www.origami.life/api/origami/signin.php');
      final response = await http.post(
        uri,
        body: {
          'username': username, //chakrit@trandar.com
          'password': password, //@HengL!ke08
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> employeeJson = jsonResponse['employee_data'];
          List<Employee> employee = [];
          setState(() {
            employee =
                employeeJson.map((json) => Employee.fromJson(json)).toList();
          });
          setState(() {
            _isLoading = true;
          });
          await Future.delayed(Duration(seconds: 1));
          final Employee employee1 = employee[0];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrigamiPage(
                employee: employee1,
                popPage: widget.popPage,
              ),
            ),
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => TrandarShop(),
          //   ),
          // );

        } else {
          // If login fails, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              'Username not found!',
              style: GoogleFonts.openSans(
                color: Colors.white,
              ),
            )
                // 'Email or Password is incorrect, please try again',),
                ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please try again.',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                )),
          ),
        );
      }
    }
  }

  Future<void> _saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if(widget.num != 0){
    //   showModalBottomSheet<void>(
    //     barrierColor: Colors.black87,
    //     backgroundColor: Colors.transparent,
    //     context: context,
    //     isScrollControlled: true,
    //     isDismissible: false,
    //     enableDrag: false,
    //     builder: (BuildContext context) {
    //       return _listItem();
    //     },
    //   );
    // }

    if (widget.num == 1) {
      prefs.clear();
    }
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    setState(() {
      _usernameController.text = username;
      _passwordController.text = password;
    });
    if (username.isNotEmpty && password.isNotEmpty) {
      if (widget.num == 0) {
        _login();
      }else{
        prefs.clear();
      }

    }

  }

  Widget _listItem() {
    return FractionallySizedBox(
      heightFactor: 1,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black12,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: SizedBox()),
                      Container(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          'assets/images/logoOrigami/ogm_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                        style: GoogleFonts.openSans(color: Color(0xFF555555),),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 60,
                                right: 60,
                                bottom: 16,
                                top: 16),
                            child: Text(
                              'Log in',
                              style: GoogleFonts.openSans(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 16,),
                        ElevatedButton(
                          onPressed: _login,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 60,
                                right: 60,
                                bottom: 16,
                                top: 16),
                            child: Text(
                              'Contact',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                                fontSize:18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16,bottom: 16,left: 30,right: 30),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                            "https://t3.ftcdn.net/jpg/02/92/36/80/360_F_292368014_9EgJRdKkquD0THERDS3ZqEj94WsSoHAo.jpg",height: 160,width: double.infinity,fit: BoxFit.fill,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  _loadSelectedRadio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = prefs.getInt('selectedRadio') ?? 2;
      Translate();
    });
  }

  @override
  void initState() {
    super.initState();
    Translate();
    _loadSelectedRadio();
    _loadCredentials();
  }

  DateTime? lastPressed;
  bool isPass = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // เช็คว่ามีการกดปุ่มย้อนกลับครั้งล่าสุดหรือไม่ และเวลาห่างจากปัจจุบันมากกว่า 2 วินาทีหรือไม่
        final now = DateTime.now();
        final maxDuration = Duration(seconds: 2);
        final isWarning = lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          // ถ้ายังไม่ได้กดสองครั้งภายในเวลาที่กำหนด ให้แสดง SnackBar แจ้งเตือน
          lastPressed = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press back again to exit',style: GoogleFonts.openSans(
                color: Colors.white,
              ),),
              duration: maxDuration,
            ),
          );
          return false; // ไม่ออกจากแอป
        }

        // ถ้ากดปุ่มย้อนกลับสองครั้งภายในเวลาที่กำหนด ให้ออกจากแอป
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logoOrigami/default_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Card(
                            color: Colors.white60,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    child: Image.asset(
                                      'assets/images/logoOrigami/ogm_logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  _isLoading
                                      ? Center(
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                      size: 75,
                                      color: Colors.amber,
                                    ),
                                  )
                                      : Container(),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _usernameController,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: GoogleFonts.openSans(
                                              color: Color(0xFF555555),
                                            ),
                                            hintStyle: GoogleFonts.openSans(
                                              color: Color(0xFF555555),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Color(0xFF555555),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: isPass,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: GoogleFonts.openSans(
                                              color: Color(0xFF555555),
                                            ),
                                            hintStyle: GoogleFonts.openSans(
                                              color: Color(0xFF555555),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Color(0xFF555555),
                                            ),
                                            suffixIcon: Container(
                                              alignment: Alignment.centerRight,
                                              width: 80,
                                              child: Center(
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        (isPass == true)?isPass = false:isPass = true;
                                                      });
                                                    },
                                                    icon: Icon(isPass?Icons.remove_red_eye:Icons.remove_red_eye_outlined),
                                                    color: Color(0xFF555555),
                                                    iconSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        ElevatedButton(
                                          onPressed: _login,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 60,
                                                right: 60,
                                                bottom: 16,
                                                top: 16),
                                            child: Text(
                                              'LOGIN',
                                              style: GoogleFonts.openSans(
                                                color: Color(0xFF555555),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'version 1.0.2',
                  style: GoogleFonts.openSans(
                    color: Color(0xFF555555),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class Employee {
  final String? emp_id;
  final String? emp_code;
  final String? emp_name;
  final String? emp_avatar;
  final String? comp_id;
  final String? comp_description;
  final String? comp_logo;
  final String? dept_id;
  final String? dept_description;
  final String? dna_id;
  final String? dna_name;
  final String? dna_color;
  final String? dna_logo;
  final String? auth_password;

  const Employee({
    this.emp_id,
    this.emp_code,
    this.emp_name,
    this.emp_avatar,
    this.comp_id,
    this.comp_description,
    this.comp_logo,
    this.dept_id,
    this.dept_description,
    this.dna_id,
    this.dna_name,
    this.dna_color,
    this.dna_logo,
    this.auth_password,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      emp_name: json['emp_name'] ?? '',
      emp_avatar: json['emp_avatar'] ?? '',
      comp_id: json['comp_id'] ?? '',
      comp_description: json['comp_description'] ?? '',
      comp_logo: json['comp_logo'] ?? '',
      dept_id: json['dept_id'] ?? '',
      dept_description: json['dept_description'] ?? '',
      dna_id: json['dna_id'] ?? '',
      dna_name: json['dna_name'] ?? '',
      dna_color: json['dna_color'] ?? '',
      auth_password: json['auth_password'] ?? '',
      dna_logo: json['dna_logo'] ?? '',
    );

  }
}

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
}
