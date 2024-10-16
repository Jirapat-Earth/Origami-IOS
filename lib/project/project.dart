import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:origami_ios/project/project_add.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import '../language/translate.dart';

class projectScreen extends StatefulWidget {
  const projectScreen({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _projectScreenState createState() => _projectScreenState();
}

class _projectScreenState extends State<projectScreen> {
  TextEditingController _searchController = TextEditingController();

  String _search = "";
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // tooltip: 'Increment',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => projectAdd(
                employee: widget.employee,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(100),
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
            topLeft: Radius.circular(100),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.openSans(
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 14),
                    hintText: '$Search...',
                    hintStyle: GoogleFonts.openSans(
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.orange,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange, // ขอบสีส้มตอนที่โฟกัส
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  // color: Color(0xFFF5F5F5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => activityEdit(
                                      //       employee: widget.employee,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4, right: 8),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.orange,
                                            child: CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.orange,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Text(
                                                  'P',
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 24,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Origami Skoop',
                                                maxLines: 1,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                'Trandar International',
                                                maxLines: 1,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 12,
                                                  color: Color(0xFF555555),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.grey),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<ModelProject>> fetchModelProject() async {
    final uri =
    Uri.parse("https://www.origami.life/api/origami/");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'auth_password': widget.employee.auth_password,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['Model_Project'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => ModelProject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

}

class ModelProject {
  String? prId;
  String? prName;
  String? prLat;
  String? prLng;
  String? prStrat;
  String? prEnd;
  String? prTotal;
  String? prCompId;
  String? prDate;
  String? emp_id;
  String? project_value;
  String? project_type_name;
  String? project_description;
  String? project_sale_status_name;
  String? project_oppo_reve;
  String? prComp_id;
  String? con_id;
  String? con_name;
  String? typeId;
  String? sale;
  String? projct_location;

  ModelProject({
    this.prId,
    this.prName,
    this.prLat,
    this.prLng,
    this.prStrat,
    this.prEnd,
    this.prTotal,
    this.prCompId,
    this.prDate,
    this.emp_id,
    this.project_value,
    this.project_type_name,
    this.project_description,
    this.project_sale_status_name,
    this.project_oppo_reve,
    this.prComp_id,
    this.con_id,
    this.con_name,
    this.typeId,
    this.sale,
    this.projct_location,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelProject.fromJson(Map<String, dynamic> json) {
    return ModelProject(
      prId: json['prId'],
      prName: json['prName'],
      prLat: json['prLat'],
      prLng: json['prLng'],
      prStrat: json['prStrat'],
      prEnd: json['prEnd'],
      prTotal: json['prTotal'],
      prCompId: json['prCompId'],
      prDate: json['prDate'],
      emp_id: json['emp_id'],
      project_value: json['project_value'],
      project_type_name: json['project_type_name'],
      project_description: json['project_description'],
      project_sale_status_name: json['project_sale_status_name'],
      project_oppo_reve: json['project_oppo_reve'],
      prComp_id: json['prComp_id'],
      con_id: json['con_id'],
      con_name: json['con_name'],
      typeId: json['typeId'],
      sale: json['sale'],
      projct_location: json['projct_location'],
    );
  }
}
