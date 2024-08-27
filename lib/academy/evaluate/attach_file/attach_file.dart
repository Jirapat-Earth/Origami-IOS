import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';


class AttachFile extends StatefulWidget {
  AttachFile({super.key, });

  @override
  _AttachFileState createState() => _AttachFileState();
}

class _AttachFileState extends State<AttachFile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(4, (index) {
            return Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          // Image.asset(
                          //   'assets/images/celebrity/bella6.jpg',
                          //   width: 90,
                          //   fit: BoxFit.fill,
                          // ),
                          Icon(
                            Icons.picture_as_pdf,
                            size: 90,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Netizen New Home 2019 by CEO.pdf',
                                  style: GoogleFonts.openSans(
                                    fontSize: 18.0,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.tags,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Allable Culture/ Core Values',
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
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'May,24 2021 11:42:09',
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
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '0',
                                            style: GoogleFonts.openSans(
                                              color: Color(0xFF555555),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.cloud_download,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '0',
                                            style: GoogleFonts.openSans(
                                              color: Color(0xFF555555),
                                            ),
                                          )
                                        ],
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
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

}

class AttachFileData {
  final String filesId;
  final String filesName;
  final String filesPath;
  final String filesDate;
  final String filesExt;
  final String filesFill;
  final String courseName;
  final String countDown;
  final String countView;

  AttachFileData({
    required this.filesId,
    required this.filesName,
    required this.filesPath,
    required this.filesDate,
    required this.filesExt,
    required this.filesFill,
    required this.courseName,
    required this.countDown,
    required this.countView,
  });

  factory AttachFileData.fromJson(Map<String, dynamic> json) {
    return AttachFileData(
      filesId: json['files_id'],
      filesName: json['files_name'],
      filesPath: json['files_path'],
      filesDate: json['files_date'],
      filesExt: json['files_ext'],
      filesFill: json['files_fill'],
      courseName: json['course_name'],
      countDown: json['count_down'],
      countView: json['count_view'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'files_id': filesId,
      'files_name': filesName,
      'files_path': filesPath,
      'files_date': filesDate,
      'files_ext': filesExt,
      'files_fill': filesFill,
      'course_name': courseName,
      'count_down': countDown,
      'count_view': countView,
    };
  }
}

class CourseAttachment {
  final String page;
  final List<String> courseDesc;
  final List<String> courseCode;

  CourseAttachment({
    required this.page,
    required this.courseDesc,
    required this.courseCode,
  });

  factory CourseAttachment.fromJson(Map<String, dynamic> json) {
    return CourseAttachment(
      page: json['page'],
      courseDesc: List<String>.from(json['course_desc']),
      courseCode: List<String>.from(json['course_code']),
    );
  }
}
