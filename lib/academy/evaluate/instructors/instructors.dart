import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';



class Instructors extends StatefulWidget {
  Instructors({super.key, });


  @override
  _InstructorsState createState() => _InstructorsState();
}

class _InstructorsState extends State<Instructors> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }

  Widget loading() {
    return Container();
    //   FutureBuilder<List<DescriptionData>>(
    //   future: fetchDescription(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               CircularProgressIndicator(
    //                 color: Colors.orange,
    //               ),
    //               SizedBox(
    //                 width: 12,
    //               ),
    //               Text(
    //                 '$Loading...',
    //                 style: GoogleFonts.openSans(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold,
    //                   color: Color(0xFF555555),
    //                 ),
    //               ),
    //             ],
    //           ));
    //     } else if (snapshot.hasError) {
    //       return Center(child: Text('Error: ${snapshot.error}'));
    //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //       return Center(child: Text('No academies found'));
    //     } else {
    //       return _getContentWidget(snapshot.data!);
    //     }
    //   },
    // );
  }

  Widget _getContentWidget(){
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(2, (index) {
              return Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'HR Orientation ALB ${index + 1}',
                            style: GoogleFonts.openSans(
                              fontSize: 18.0,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: List.generate(1, (index) {
                      return Card(
                        color: Colors.white,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/person/19777.jpg',
                                  width: 90,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jirapat Jangsawang',
                                        style: GoogleFonts.openSans(
                                          fontSize: 18.0,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.work,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Executive',
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.0,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.building,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Allable Co.,Ltd.',
                                            style: GoogleFonts.openSans(
                                              color: Color(0xFF555555),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.people_alt_outlined,
                                                    color: Colors.amber,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    '19 Students',
                                                    style: GoogleFonts.openSans(
                                                      color: Color(0xFF555555),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.bookmark_border,
                                                    color: Colors.amber,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    '2 Courses',
                                                    style: GoogleFonts.openSans(
                                                      color: Color(0xFF555555),
                                                    ),
                                                  )
                                                ],
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
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(),
                  SizedBox(
                    height: 8,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class CourseInstructors {
  final String page;
  final List<String> courseDesc;
  final List<String> courseCode;

  CourseInstructors({
    required this.page,
    required this.courseDesc,
    required this.courseCode,
  });

  factory CourseInstructors.fromJson(Map<String, dynamic> json) {
    return CourseInstructors(
      page: json['page'],
      courseDesc: List<String>.from(json['course_desc']),
      courseCode: List<String>.from(json['course_code']),
    );
  }
}

class CoachInstructors {
  final String coachCode;
  final String coachComp;
  final int coachCourse;
  final String coachDept;
  final String coachImg;
  final String coachName;
  final int coachTrainee;

  CoachInstructors({
    required this.coachCode,
    required this.coachComp,
    required this.coachCourse,
    required this.coachDept,
    required this.coachImg,
    required this.coachName,
    required this.coachTrainee,
  });

  factory CoachInstructors.fromJson(Map<String, dynamic> json) {
    return CoachInstructors(
      coachCode: json['coach_code'],
      coachComp: json['coach_comp'],
      coachCourse: json['coach_course'],
      coachDept: json['coach_dept'],
      coachImg: json['coach_img'],
      coachName: json['coach_name'],
      coachTrainee: json['coach_trainee'],
    );
  }
}


