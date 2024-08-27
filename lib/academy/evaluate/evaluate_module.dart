import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../../Language/translate.dart';
import 'Announcements/announcements.dart';
import 'attach_file/attach_file.dart';
import 'certification/certification.dart';
import 'curriculum/curriculum.dart';
import 'description/description.dart';
import 'discussion/discussion.dart';
import 'instructors/instructors.dart';

class EvaluateModule extends StatefulWidget {
  EvaluateModule({super.key, required this.id,});
  final String id;

  @override
  _EvaluateModuleState createState() => _EvaluateModuleState();
}

class _EvaluateModuleState extends State<EvaluateModule>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isScrollable = true;
  bool showNextIcon = false;
  bool showBackIcon = false;
  bool _isClick = false;

  String URL = '';
  String imageUrl = '';

  List<String> _tabs = [
    '$DescriptionT',
    '$CurriculumT',
    '$InstructorsT',
    '$DiscussionT',
    '$AnnouncementsT',
    '$Attach_FileT',
    '$CertificationT',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange,
        title: Text(
          'Academy',
          style: GoogleFonts.openSans(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Allable On Boarding',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Stack(
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                (callImage != '')
                                    ? callImage
                                    : culums[0].curriculums?[0].avatar ?? '',
                                width: 90,
                                height: 80,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Watched ',
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '0h 41m 33s',
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.0,
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          ' Of ',
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '0h 44m 12s',
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.0,
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'You have passed ',
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '94 %',
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ' of the class',
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          "Start ",
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "07/05/2024",
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          " End ",
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "31/07/2024",
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            (_isClick == true)
                                ? _isClick = false
                                : _isClick = true;
                          });
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: (_isClick == false) ? Colors.grey : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people_alt_outlined,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '7 Students',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '1 Video : 0h 7m 7s',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Allable Academy',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              TabBar(
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  print(_selectedIndex);
                },
                controller: _tabController,
                isScrollable: true,
                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              ),
            ],
          ),
          Expanded(child: _bodyAcademy()),
        ],
      ),
    );
  }

  int _selectedIndex = 0;
  String callImage = '';
  String callUrl = '';

  Widget _bodyAcademy() {
    switch (_selectedIndex) {
      case 0:
        return Description(
        );
      case 1:
        return Curriculum(
          culums: culums,
          callImage: (String value) {
            setState(() {
              callImage = value;
            });
            print("Image URL: $value");
            return callImage;
          },
          callUrl: (String value) {
            setState(() {
              callUrl = value;
            });
            print("Video URL: $value");
            return callUrl;
          },
        );
      case 2:
        return Instructors(
        );
      case 3:
        return Discussion(
        );
      case 4:
        return Announcements(
        );
      case 5:
        return AttachFile(
        );
      case 6:
        return Certification(
        );
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(
            'ERROR!',
            style: GoogleFonts.openSans(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
    }
  }

  List<Culums> culums = [
    Culums(
      number: 0,
      name: 'Subject Origami',
      persen: '8',
      curriculums: [
        Curriculums(
          number: 0,
          avatar:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZ1HWZtXfc2IbUyn8h13AoP1rOrKZ6v_Lry7cRWPH4E5ntBFpKW5lcxWhS9NOdEjiTK2U&usqp=CAU',
          name: 'Origami.life',
          type: 'VIDEO',
        ),
      ],
    ),
    Culums(
      number: 1,
      name: 'Subject Trandar',
      persen: '30',
      curriculums: [
        Curriculums(
          number: 0,
          avatar:
              'https://i0.wp.com/toptotravel.com/wp-content/uploads/2018/11/Trandar-AMF-125.jpg?ssl=1',
          name: 'นวัตกรรมฝ้าอะคูสติก “Trandar AMF”',
          type: 'YOUTUBE',
        ),
        Curriculums(
          number: 0,
          avatar:
              'https://i0.wp.com/toptotravel.com/wp-content/uploads/2018/11/Trandar-AMF-125.jpg?ssl=1',
          name: 'Office Building Grade A',
          type: 'YOUTUBE',
        ),
      ],
    ),
    Culums(
      number: 2,
      name: 'Subject Netizen',
      persen: '80',
      curriculums: [
        Curriculums(
          number: 0,
          avatar: 'http://www.allaboutthailand2018.com/photo/2192.jpg',
          name: 'หัวเว่ย คลาวด์ 1',
          type: 'PDF',
        ),
        Curriculums(
          number: 0,
          avatar: 'http://www.allaboutthailand2018.com/photo/2192.jpg',
          name: 'หัวเว่ย คลาวด์ 2',
          type: 'PDF',
        ),
        Curriculums(
          number: 0,
          avatar: 'http://www.allaboutthailand2018.com/photo/2192.jpg',
          name: 'หัวเว่ย คลาวด์ 3',
          type: 'PDF',
        ),
      ],
    ),
  ];

  // evaluate
  List<CourseData> courseData = [
    CourseData(
        cover:
            "https://www.origami.life/uploads/photo/trn_picture_title_20230511151925.jpg",
        enroll: "Enroll",
        balance: "-92",
        count: "2494.00",
        course: "15424",
        exp: "Start 07/05/2024 End 31/07/2024",
        id: "7005",
        item: "5058",
        no: "1",
        option: "0",
        text:
            "Watched text-orange 0h 41m 34s Of  0h 44m 12s\nYou have passed 94.04% of the class "),
  ];
}

class CourseData {
  final String cover;
  final String enroll;
  final String balance;
  final String count;
  final String course;
  final String exp;
  final String id;
  final String item;
  final String no;
  final String option;
  final String text;

  CourseData({
    required this.cover,
    required this.enroll,
    required this.balance,
    required this.count,
    required this.course,
    required this.exp,
    required this.id,
    required this.item,
    required this.no,
    required this.option,
    required this.text,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      cover: json['cover'],
      enroll: json['enroll'],
      balance: json['balance'],
      count: json['count'],
      course: json['course'],
      exp: json['exp'],
      id: json['id'],
      item: json['item'],
      no: json['no'],
      option: json['option'],
      text: json['text'],
    );
  }
}

class TopicData {
  final String topicName;
  final String topicDescription;
  final String metaImage;
  final String mataLink;
  final String category;
  final String countAnnounce;
  final int favorite;
  final String student;
  final String videoCount;
  final String videoTime;

  TopicData({
    required this.topicName,
    required this.topicDescription,
    required this.metaImage,
    required this.mataLink,
    required this.category,
    required this.countAnnounce,
    required this.favorite,
    required this.student,
    required this.videoCount,
    required this.videoTime,
  });

  factory TopicData.fromJson(Map<String, dynamic> json) {
    return TopicData(
      topicName: json['topic_name'],
      topicDescription: json['topic_description'],
      metaImage: json['meta_image'],
      mataLink: json['mata_link'],
      category: json['category'],
      countAnnounce: json['count_announce'],
      favorite: json['favorite'],
      student: json['student'],
      videoCount: json['video_count'],
      videoTime: json['video_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic_name': topicName,
      'topic_description': topicDescription,
      'meta_image': metaImage,
      'mata_link': mataLink,
      'category': category,
      'count_announce': countAnnounce,
      'favorite': favorite,
      'student': student,
      'video_count': videoCount,
      'video_time': videoTime,
    };
  }
}
