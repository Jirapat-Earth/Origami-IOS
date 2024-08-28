import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../../../../language/translate.dart';

class Description extends StatefulWidget {
  Description({
    super.key,
  });


  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$DescriptionT',
              style: GoogleFonts.openSans(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF555555),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '   ด้วยในการประเมินประจำปีที่ผ่านมา เราใช้แบบประเมินใน  Google Sheets  ที่ต้องมีการแชร์ไฟล์ส่งแบบประเมินให้พนักงานทำ เสร็จแล้วต้องมายกเลิกการแชร์ไฟล์ให้กับพนักงาน หลังจากนั้นต้องมาแชร์ไฟล์ส่งให้หัวหน้างาน และส่งต่อให้กับผู้บริหาร ตามลำดับ ประกอบกับจำนวนพนักงานของเราที่เพิ่มมากขึ้นในทุกๆ ปี ซึ่งทำให้ทางฝ่ายบุคคลทำงานในส่วนประเมินค่อนข้างลำบากมาก กว่าจะรวบรวมข้อมูลในแต่ละส่วนได้ ใช้เวลานานมากค่ะ\n   ในการประเมินประจำปี 2565 นี้ (ระหว่างวันที่ 01/01/2565 - 31/12/2565) ทางฝ่ายบุคคลได้ร่วมกับทีมออลลาเบิล จัดทำแบบประเมินประจำปีในระบบ Origami >EVALUATE เพื่อให้พนักงานสามารถเข้าไปทำแบบประเมินในระบบได้อย่างสะดวก รวดเร็ว มากยิ่งขึ้นกว่าเดิม พนักงานและหัวหน้างานสามารถที่จะทำประเมินไปพร้อมๆ กันได้เลย ไม่ต้องมารอการแชร์ไฟล์จากทางฝ่ายบุคคล เหมือนเช่นเดิมค่ะ',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(),
            SizedBox(
              height: 16,
            ),
            Text("$What_you_learn",
                style: GoogleFonts.openSans(
                  color: Color(0xFF555555),
                )),
            Column(
              children: List.generate(2, (index) {
                return Row(
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      "$Class ${index + 1} :ORIGAMI > EVALUATE",
                      style: GoogleFonts.openSans(
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(),
            SizedBox(
              height: 16,
            ),
            Column(
              children: List.generate(4, (index) {
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
                          Text('${'0'}%',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                              )),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF555555),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$What_you_learn",
                              style: GoogleFonts.openSans(
                                fontSize: 16.0,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              children: List.generate(2, (index) {
                                return Text(
                                    "$Class ${index + 1} : ORIGAMI > EVALUATE",
                                    style: GoogleFonts.openSans(
                                      color: Color(0xFF555555),
                                    ));
                              }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "This course includes",
                                style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.videocam_rounded,
                                        color: Color(0xFF555555),
                                      ),
                                      Text(
                                        "${'2'} $Videos",
                                        style: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.picture_as_pdf_outlined,
                                        color: Color(0xFF555555),
                                      ),
                                      Text(
                                        "${'0'} $Documents",
                                        style: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.school,
                                        color: Color(0xFF555555),
                                      ),
                                      Text(
                                        "$Certificate",
                                        style: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetail {
  final String challengeCount;
  final String courseCode;
  final List<String> courseDesc;
  final String? courseDescription;
  final String documentCount;
  final String eventCount;
  final String linkCount;
  final String page;
  final int save;
  final List<String> topicId;
  final int topicLength;
  final List<String> topicName;
  final List<String> topicOption;
  final List<String> topicTitle;
  final String videoCount;
  final String youtubeCount;

  CourseDetail({
    required this.challengeCount,
    required this.courseCode,
    required this.courseDesc,
    this.courseDescription,
    required this.documentCount,
    required this.eventCount,
    required this.linkCount,
    required this.page,
    required this.save,
    required this.topicId,
    required this.topicLength,
    required this.topicName,
    required this.topicOption,
    required this.topicTitle,
    required this.videoCount,
    required this.youtubeCount,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      challengeCount: json['challenge_count'],
      courseCode: json['course_code'],
      courseDesc: json['course_desc'].map((item) => List<String>.from(item)),
      courseDescription:json['course_description'],
      documentCount: json['document_count'],
      eventCount: json['event_count'],
      linkCount: json['link_count'],
      page: json['page'],
      save: json['save'],
      topicId: json['topic_id'].map((item) => List<String>.from(item)),
      topicLength: json['topic_length'],
      topicName: json['topic_name'].map((item) => List<String>.from(item)),
      topicOption: json['topic_option'].map((item) => List<String>.from(item)),
      topicTitle: json['topic_title'].map((item) => List<String>.from(item)),
      videoCount: json['video_count'],
      youtubeCount: json['youtube_count'],
    );
  }
}
