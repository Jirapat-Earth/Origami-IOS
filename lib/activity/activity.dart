import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import '../language/translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'activity_add.dart';
import 'activity_edit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


class activityScreen extends StatefulWidget {
  const activityScreen({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _activityScreenState createState() => _activityScreenState();
}

class _activityScreenState extends State<activityScreen> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _search = "";
  bool isLoading = false; // ใช้แสดงสถานะการโหลดข้อมูลเพิ่มเติม
  bool isEndOfList = false;
  List<ModelActivity> filterSearch = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMoreAccounts(); // โหลดชุดแรกของบัญชี
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text.toLowerCase();
        filterSearch = activityList
            .where((activity) =>
        activity.activity_project_name != null &&
            activity.activity_project_name!.toLowerCase().contains(_search))
            .toList();
      });
    });

    print("Current text: ${_searchController.text}");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ฟังก์ชันโหลดข้อมูลเพิ่มเติม
  Future<void> _loadMoreAccounts() async {
    if (isLoading || isEndOfList) return; // ป้องกันการโหลดข้อมูลซ้ำเมื่อสิ้นสุดรายการแล้ว

    setState(() {
      isLoading = true;
    });

    try {
      List<ModelActivity> newActivities = await fetchModelActivity();
      setState(() {
        activityList.addAll(newActivities);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  // ฟังก์ชันตรวจจับการเลื่อนถึงตำแหน่งสุดท้าย
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _loadMoreAccounts(); // เรียกฟังก์ชันโหลดข้อมูลเพิ่มเติมเมื่อเลื่อนถึงสุดท้าย
    }
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
              builder: (context) => activityAdd(
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
                        horizontal: 12, vertical: 12),
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
                child: _getContentWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return Card(
      elevation: 0,
      color: Colors.white,
      // color: Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
            itemCount: filterSearch.length +
                (isLoading ? 1 : 0), // เพิ่ม 1 ถ้ากำลังโหลด
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == filterSearch.length) {
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
              }
              final activity = filterSearch[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => activityEdit(
                        employee: widget.employee, activity: activity,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, right: 8),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey,
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        widget.employee.emp_avatar ?? '',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Icon(
                                  Icons.bolt,
                                  color: Colors.amber,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.activity_project_name!,
                                  maxLines: 1,
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  activity.activity_location!,
                                  maxLines: 1,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${widget.employee.emp_name!} - ${activity.projectname!}',
                                  maxLines: 1,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${activity.activity_start_date!} ${activity.time_start!} - ${activity.activity_end_date!} ${activity.time_end!}',
                                  maxLines: 1,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Type : Website & Application',
                                        maxLines: 1,
                                        style: GoogleFonts.openSans(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // height: 28,
                                      padding: const EdgeInsets.only(
                                          left: 18, right: 18),
                                      decoration: BoxDecoration(
                                        color: (activity.activity_status == 'close')?Colors.orange:Colors.blue.shade200,
                                        border:
                                            Border.all(color: (activity.activity_status == 'close')?Colors.orange:Colors.blue.shade200,),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          (activity.activity_status == null)
                                              ? 'plan'
                                              : activity.activity_status!,
                                          style: GoogleFonts.openSans(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  int imax = 0;
  List<ModelActivity> activityList = [];
  Future<List<ModelActivity>> fetchModelActivity() async {
    final uri = Uri.parse("https://www.origami.life/crm/activity.php");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'idemp': widget.employee.emp_id,
        'auth_password': widget.employee.auth_password,
        'index': imax.toString(),
        'txt_search': _search,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('data')) {
        final List<dynamic> dataJson = jsonResponse['data'];
        int max = jsonResponse['max'];
        int sum = jsonResponse['sum'];

        // แปลงข้อมูล JSON เป็น List<ModelActivity> และเพิ่มลงใน activityList
        setState(() {
          activityList = dataJson
              .map((json) => ModelActivity.fromJson(json))
              .toList();
          filterSearch = activityList;  // เริ่มต้นให้แสดงข้อมูลทั้งหมด
        });

        int n = sum - imax;
        int a = 0;
        if (n > max) {
          if(a > 5){
            imax += 20;
          }else{
            imax = 114;
          }
          a += 1;
        } else {
          print('object');
          setState(() {
            isEndOfList = true;
          });
        }
        return dataJson.map((json) => ModelActivity.fromJson(json)).toList();
      } else {
        throw Exception('Data key not found in the response');
      }
    } else {
      throw Exception('Failed to load activities. Status code: ${response.statusCode}');
    }
  }
}

class ModelActivity {
  String? activity_id;
  String? activity_location;
  String? activity_project_name;
  String? activity_description;
  String? activity_start_date;
  String? comp_id;
  String? activity_create_date;
  String? emp_id;
  String? activity_end_date;
  String? time_start;
  String? time_end;
  String? activity_real_start_date;
  String? activity_status;
  String? activity_lat;
  String? activity_lng;
  String? activity_real_comment;
  String? activity_create_user;
  String? projectname;
  String? activity_place_type;

  ModelActivity({
    this.activity_id,
    this.activity_location,
    this.activity_project_name,
    this.activity_description,
    this.activity_start_date,
    this.comp_id,
    this.activity_create_date,
    this.emp_id,
    this.activity_end_date,
    this.time_start,
    this.time_end,
    this.activity_real_start_date,
    this.activity_status,
    this.activity_lat,
    this.activity_lng,
    this.activity_real_comment,
    this.activity_create_user,
    this.projectname,
    this.activity_place_type,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelActivity.fromJson(Map<String, dynamic> json) {
    return ModelActivity(
      activity_id: json['activity_id'],
      activity_location: json['activity_location'],
      activity_project_name: json['activity_project_name'],
      activity_description: json['activity_description'],
      activity_start_date: json['activity_start_date'],
      comp_id: json['comp_id'],
      activity_create_date: json['activity_create_date'],
      emp_id: json['emp_id'],
      activity_end_date: json['activity_end_date'],
      time_start: json['time_start'],
      time_end: json['time_end'],
      activity_real_start_date: json['activity_real_start_date'],
      activity_status: json['activity_status'],
      activity_lat: json['activity_lat'],
      activity_lng: json['activity_lng'],
      activity_real_comment: json['activity_real_comment'],
      activity_create_user: json['activity_create_user'],
      projectname: json['projectname'],
      activity_place_type: json ['activity_place_type'],
    );
  }
}
