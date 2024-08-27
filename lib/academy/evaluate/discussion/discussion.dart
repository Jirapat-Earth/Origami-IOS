import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class Discussion extends StatefulWidget {
  Discussion({super.key, });


  @override
  _DiscussionState createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {

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
          children: List.generate(1, (index) {
            return Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            'https://webcodeft.com/wp-content/uploads/2021/11/dummy-user.png',
                            width: 90,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Test Allable On Boarding',
                                  style: GoogleFonts.openSans(
                                    fontSize: 18.0,
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
                                      Icons.people_alt_outlined,
                                      color: Colors.amber,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Charoenwich Rujirussawarawong [trainee]',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.amber,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Feb,13 2024 09:28:36\n(4 months ago)',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Discussion Test',
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.comment_outlined,
                              size: 30,
                              color: Colors.amber,
                            ),
                            tooltip: '',
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

class CourseDiscussion {
  final int count;
  final String discussionDates;
  final String discussionDesc;
  final String discussionEmp;
  final String discussionId;
  final String discussionSubject;
  final String discussionType;
  final String empName;
  final String empPic;
  final String reply;
  final String replyGroup;
  final String showTime;

  CourseDiscussion({
    required this.count,
    required this.discussionDates,
    required this.discussionDesc,
    required this.discussionEmp,
    required this.discussionId,
    required this.discussionSubject,
    required this.discussionType,
    required this.empName,
    required this.empPic,
    required this.reply,
    required this.replyGroup,
    required this.showTime,
  });

  factory CourseDiscussion.fromJson(Map<String, dynamic> json) {
    return CourseDiscussion(
      count: json['count'],
      discussionDates: json['discussion_dates'],
      discussionDesc: json['discussion_desc'],
      discussionEmp: json['discussion_emp'],
      discussionId: json['discussion_id'],
      discussionSubject: json['discussion_subject'],
      discussionType: json['discussion_type'],
      empName: json['emp_name'],
      empPic: json['emp_pic'],
      reply: json['reply'],
      replyGroup: json['reply_group'],
      showTime: json['show_time'],
    );
  }
}

