import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';


class Certification extends StatefulWidget {
  Certification({super.key, });

  @override
  _CertificationState createState() => _CertificationState();
}

class _CertificationState extends State<Certification> {

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
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/certificate_1.png',
                              width: 90,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.cloud_download,
                                      color: Colors.amber[400],
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'Download',
                                      style: GoogleFonts.openSans(
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                                'Certificate Bronze',
                                style: GoogleFonts.openSans(
                                  fontSize: 18.0,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Congratulation You can do 80% for this course',
                                style: GoogleFonts.openSans(
                                  fontSize: 14.0,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text('50 %',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Pass 80% For this Course.',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text('100 %',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Quality of education 25% For this Course.',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
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

class CourseCertification {
  final String page;
  final List<String> courseDesc;
  final List<String> courseCode;

  CourseCertification({
    required this.page,
    required this.courseDesc,
    required this.courseCode,
  });

  factory CourseCertification.fromJson(Map<String, dynamic> json) {
    return CourseCertification(
      page: json['page'],
      courseDesc: List<String>.from(json['course_desc']),
      courseCode: List<String>.from(json['course_code']),
    );
  }
}
