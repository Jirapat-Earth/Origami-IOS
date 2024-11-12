import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../language/translate.dart';
import '../../../login/login.dart';
import '../need_view/need_detail.dart';

class MiniDepartment extends StatefulWidget {
  const MiniDepartment({Key? key, required this.callback, required this.employee, required this.callbackId, required this.Authorization}) : super(key: key);
  final String Function(String) callback;
  final String Function(String) callbackId;
  final Employee employee;
  final String Authorization;
  @override
  _MiniDepartmentState createState() => _MiniDepartmentState();
}

class _MiniDepartmentState extends State<MiniDepartment> {
  TextEditingController _searchDepartment = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchDepartment.addListener(() {
      print("Current text: ${_searchDepartment.text}");
    });
    fetchDepartment(Department_number, Department_name);
  }

  @override
  void dispose() {
    _searchDepartment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(color: Color(0xFFFF9900),child: Padding(padding: EdgeInsets.only(left: 40,right: 40,top: 8)),),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color(0xFFFF9900),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextField(
                        controller: _searchDepartment,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '$Search...',
                          hintStyle: GoogleFonts.openSans(color: Color(0xFF555555),),
                          labelStyle: GoogleFonts.openSans(color: Color(0xFF555555),),
                          border: InputBorder.none,
                          icon: Icon(Icons.search,color: Color(0xFFFF9900),),
                          suffixIcon: Card(
                            elevation: 0,
                            color: Color(0xFFFF9900),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Department_name = _searchDepartment.text;
                                _showDown = true;
                                fetchDepartment(int_Department, _searchText);
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                width: 10,
                                child: Center(
                                    child: Text('$Search',
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ))),
                              ),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            Department_name = value;
                            fetchDepartment(int_Department, Department_name);
                            _searchText = value;
                            // filterData_Department();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                (_searchText == '' )
                    ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$SearchFor',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Color(0xFF555555),
                        ),
                      ),
                      SizedBox(height: 8,),
                      // InkWell(
                      //   onTap: (){
                      //     setState(() {
                      //       _showDown = true;
                      //     });
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         'ฝ่ายทั้งหมด',
                      //         style: GoogleFonts.openSans(
                      //           fontSize: 18,
                      //           decoration: TextDecoration.underline,
                      //           // color: Color(0xFFFF9900),
                      //         ),),
                      //       SizedBox(width: 8,),
                      //       Icon(Icons.arrow_drop_down,color:Color(0xFF555555),)
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                )
                    : Expanded(
                  child: ListView.builder(
                    itemCount: DepartmentList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                Department_name =
                                    DepartmentList[index].department_name ?? '';
                                widget.callback(Department_name ?? '');
                                data_Id = DepartmentList[index].department_id ?? '';
                                widget.callbackId(data_Id ?? '');
                                Navigator.pop(context, Department_name);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "${DepartmentList[index].department_name ?? ''}",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16),
                            child: Divider(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // int_project = int_project - 2;
                          // fetchProject(int_project.toString(), "");
                          Navigator.pop(context);
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.navigate_before,color: Color(0xFFFF9900),),
                          Text(
                            "$Back",
                            style: GoogleFonts.openSans(
                              color: Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   '',
                    //   style: GoogleFonts.openSans(
                    //       fontSize: 24,
                    //       color: Color(0xFF555555),
                    //       fontWeight: FontWeight.bold),
                    // ),
                    // TextButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       int_project = int_project++;
                    //       fetchProject(int_project.toString(), "");
                    //       // Navigator.pop(context);
                    //     });
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "ถัดไป",
                    //         style: GoogleFonts.openSans(
                    //           fontSize: 16,
                    //           color: Color(0xFF555555),
                    //         ),
                    //         overflow: TextOverflow.ellipsis,
                    //         maxLines: 1,
                    //       ),
                    //       Icon(Icons.navigate_next,color: Color(0xFFFF9900),),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  //fillter
  List<DepartmentData> DepartmentOption = [];
  List<DepartmentData> DepartmentList = [];
  int int_Department = 0;
  bool is_Department = false;
  String? Department_number = "";
  String? Department_name = "";
  String? data_Id = "";
  Future<void> fetchDepartment(Department_number, Department_name) async {
    final uri = Uri.parse(
        'https://www.origami.life/api/origami/need/department.php?page=$Department_number&search=$Department_name');
    try {
      final response = await http.post(
        uri,
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> DepartmentJson = jsonResponse['department_data'];
          setState(() {
            final departmentRespond = DepartmentRespond.fromJson(jsonResponse);

            int_Department = departmentRespond.next_page_number ?? 0;
            is_Department = departmentRespond.next_page ?? false;
            DepartmentOption = DepartmentJson
                .map(
                  (json) => DepartmentData.fromJson(json),
            )
                .toList();
            DepartmentList = DepartmentOption;
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}
