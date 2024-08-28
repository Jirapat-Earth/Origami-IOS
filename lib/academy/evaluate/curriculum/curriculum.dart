import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../youtube.dart';

class Curriculum extends StatefulWidget {
  Curriculum({super.key, required this.culums, required this.callImage, required this.callUrl,});
  final List<Culums> culums;
  final String Function(String) callImage;
  final String Function(String) callUrl;

  @override
  _CurriculumState createState() => _CurriculumState();
}

class _CurriculumState extends State<Curriculum> {
  bool isSwitch = false;
  List<Culums> culums = [];
  // late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    culums = widget.culums;
    // กำหนดลิงค์วิดีโอที่ต้องการเล่น
    // _controller = YoutubePlayerController(
    //   initialVideoId: 'KpDQhbYzf4Y', // ใส่ Video ID ของ YouTube
    //   flags: YoutubePlayerFlags(
    //     autoPlay: true,
    //     mute: false,
    //   ),
    // );
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(culums.length, (index) {
            return Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      (isSwitch == false) ? isSwitch = true : isSwitch = false;
                    });
                  },
                  child: (isSwitch == true)
                      ? Card(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 6, right: 6, top: 8, bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    culums[index].name ?? '',
                                    style: GoogleFonts.openSans(
                                      fontSize: 18.0,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text('${culums[index].persen ?? ''} %',
                                    style: GoogleFonts.openSans(
                                      color: Color(0xFF555555),
                                    )),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF555555),
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.transparent,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  culums[index].name ?? '',
                                  style: GoogleFonts.openSans(
                                    fontSize: 18.0,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text('${culums[index].persen ?? ''} %',
                                  style: GoogleFonts.openSans(
                                    color: Color(0xFF555555),
                                  )),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF555555),
                                size: 30,
                              )
                            ],
                          ),
                        ),
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  children: List.generate(
                      culums[index].curriculums?.length ?? 0, (indexC) {
                    final curriculums = culums[index].curriculums?[indexC];
                    return (isSwitch == false)
                        ? Card(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  widget.callImage(curriculums?.avatar ?? '');
                                });
                                if (curriculums?.type == 'YOUTUBE') {
                                  // String callUrl = widget.callUrl("http://www.thapra.lib.su.ac.th/m-talk/attachments/article/75/ebook.pdf");
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => YouTubeScreen()),
                                    );
                                  });
                                }else if(curriculums?.type == 'PDF'){
                                  String callUrl = widget.callUrl("http://www.thapra.lib.su.ac.th/m-talk/attachments/article/75/ebook.pdf");
                                  final Uri _url = Uri.parse(callUrl);
                                  setState(() {
                                    _launchURL(_url);
                                  });
                                }
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
                                      curriculums?.avatar ?? '',
                                      width: 110,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            curriculums?.name ?? '',
                                            style: GoogleFonts.openSans(
                                              fontSize: 16.0,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                (curriculums?.type == 'VIDEO')
                                                    ? Icons
                                                        .video_collection_outlined
                                                    : (curriculums?.type ==
                                                            'PDF')
                                                        ? Icons
                                                            .picture_as_pdf_outlined
                                                        : Icons
                                                            .ondemand_video_outlined,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                curriculums?.type ?? '',
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
                                                Icons.access_time,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                '0h 7m 7s',
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
                                                      Icons.people_alt_outlined,
                                                      color: Colors.amber,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      '0h 0m 8s',
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color:
                                                            Color(0xFF555555),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.hourglass_bottom,
                                                      color: Colors.amber,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text('8 %',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color:
                                                              Color(0xFF555555),
                                                        ))
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
                          )
                        : Container();
                  }),
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

  late Future<CourseCurriculum?> _curriculum;

  // @override
  // void initState() {
  //   super.initState();
  //   // เรียกฟังก์ชัน getAcademy และส่ง URL ของ API
  //   _academy = getCurriculum();
  // }

}

class CourseCurriculum {
  final String page;
  final List<String> courseName;
  final List<String> courseCode;
  final List<CurriculumDetails>? curriculum;

  CourseCurriculum({
    required this.page,
    required this.courseName,
    required this.courseCode,
    required this.curriculum,
  });

  factory CourseCurriculum.fromJson(Map<String, dynamic> json) {
    return CourseCurriculum(
      page: json['page'],
      courseName: List<String>.from(json['course_name']),
      courseCode: List<String>.from(json['course_code']),
      curriculum: json['curriculum'] != null
          ? (json['curriculum'] as List)
          .map((item) => CurriculumDetails.fromJson(item))
          .toList()
          : null,
    );
  }
}

class CurriculumDetails {
  final String topicId;
  final String topicNo;
  final String topicName;
  final String topicOption;
  final String balance;
  final String learnFlag;
  final String topicButton;
  final String topicCover;
  final String topicDuration;
  final String topicIcon;
  final String topicItem;
  final String topicPercent;
  final String topicRequire;
  final String topicTile;
  final String topicViews;

  CurriculumDetails({
    required this.topicId,
    required this.topicNo,
    required this.topicName,
    required this.topicOption,
    required this.balance,
    required this.learnFlag,
    required this.topicButton,
    required this.topicCover,
    required this.topicDuration,
    required this.topicIcon,
    required this.topicItem,
    required this.topicPercent,
    required this.topicRequire,
    required this.topicTile,
    required this.topicViews,
  });

  factory CurriculumDetails.fromJson(Map<String, dynamic> json) {
    return CurriculumDetails(
      topicId: json['topic_id'],
      topicNo: json['topic_no'],
      topicName: json['topic_name'],
      topicOption: json['topic_option'],
      balance: json['balance'],
      learnFlag: json['learn_flag'],
      topicButton: json['topic_button'],
      topicCover: json['topic_cover'],
      topicDuration: json['topic_duration'],
      topicIcon: json['topic_icon'],
      topicItem: json['topic_item'],
      topicPercent: json['topic_percent'],
      topicRequire: json['topic_require'],
      topicTile: json['topic_tile'],
      topicViews: json['topic_views'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic_id': topicId,
      'topic_no': topicNo,
      'topic_name': topicName,
      'topic_option': topicOption,
      'balance': balance,
      'learn_flag': learnFlag,
      'topic_button': topicButton,
      'topic_cover': topicCover,
      'topic_duration': topicDuration,
      'topic_icon': topicIcon,
      'topic_item': topicItem,
      'topic_percent': topicPercent,
      'topic_require': topicRequire,
      'topic_tile': topicTile,
      'topic_views': topicViews,
    };
  }
}

class Culums {
  final int? number;
  final String? name;
  final String? persen;
  final List<Curriculums>? curriculums;

  Culums({
    this.number,
    this.name,
    this.persen,
    this.curriculums,
  });
}

class Curriculums {
  final int? number;
  final String? avatar;
  final String? name;
  final String? type;

  Curriculums({
    this.number,
    this.avatar,
    this.name,
    this.type,
  });
}
