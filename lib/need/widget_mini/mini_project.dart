import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../language/translate.dart';
import '../../../login/login.dart';
import '../need_detail.dart';

class MiniProject extends StatefulWidget {
  const MiniProject({Key? key, required this.callback, required this.employee, required this.callbackId}) : super(key: key);
  final String Function(String) callback;
  final String Function(String) callbackId;
  final Employee employee;

  @override
  _MiniProjectState createState() => _MiniProjectState();
}

class _MiniProjectState extends State<MiniProject> {
  TextEditingController _searchProject = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchProject.addListener(() {
      print("Current text: ${_searchProject.text}");
    });
    fetchProject(project_number, project_name);
  }

  @override
  void dispose() {
    _searchProject.dispose();
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
                Card(elevation:0,color: Colors.transparent,child: Padding(padding: EdgeInsets.only(left: 40,right: 40,top: 8)),),
                Card(color: Colors.orange.shade500,child: Padding(padding: EdgeInsets.only(left: 40,right: 40,top: 8)),),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.orange.shade500,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextField(
                        controller: _searchProject,
                        decoration: InputDecoration(
                          hintText: '$Search...',
                          hintStyle: GoogleFonts.openSans(color: Color(0xFF555555),),
                          labelStyle: GoogleFonts.openSans(color: Color(0xFF555555),),
                          border: InputBorder.none,
                          icon: Icon(Icons.search,color: Colors.orange.shade500,),
                          suffixIcon: Card(
                            elevation: 0,
                            color: Colors.orange,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                project_name = _searchProject.text;
                                _showDown = true;
                                fetchProject(int_project, project_name);
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                width: 80,
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
                            project_name = value;
                            fetchProject(int_project, project_name);
                            _searchText = value;
                            // filterData_project();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                (_searchText == '')
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
                          //         'แสดงโครงการทั้งหมด',
                          //         style: GoogleFonts.openSans(
                          //           fontSize: 18,
                          //           decoration: TextDecoration.underline,
                          //           // color: Colors.orange,
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
                          itemCount: projectList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      project_name =
                                          projectList[index].project_name ?? '';
                                      project_id = projectList[index].project_id ?? '';
                                      widget.callback(project_name ?? '');
                                      widget.callbackId(project_id ?? '');
                                      Navigator.pop(context, project_name);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "${projectList[index].project_name ?? ''}",
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
                          Icon(Icons.navigate_before,color: Colors.orange,),
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
                    //       Icon(Icons.navigate_next,color: Colors.orange,),
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
  List<ProjectData> projectOption = [];
  List<ProjectData> projectList = [];
  int int_project = 0;
  bool is_project = false;
  String? project_number = "";
  String? project_name = "";
  String? project_id = "";
  Future<void> fetchProject(project_number, project_name) async {
    final uri = Uri.parse(
        'https://www.origami.life/api/origami/need/project.php?page=$project_number&search=$project_name');
    try {
      final response = await http.post(
        uri,
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> projectJson = jsonResponse['project_data'];
          setState(() {
            final projectRespond = ProjectRespond.fromJson(jsonResponse);

            int_project = projectRespond.next_page_number ?? 0;
            is_project = projectRespond.next_page ?? false;
            projectOption = projectJson
                .map(
                  (json) => ProjectData.fromJson(json),
                )
                .toList();
            projectList = projectOption;
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
