import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:origami_ios/work/work_apply.dart';

import '../../../language/translate.dart';
import '../../../login/login.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({Key? key, required this.employee}) : super(key: key);
  final Employee employee;

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  TextEditingController _searchDivision = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchDivision.addListener(() {
      print("Current text: ${_searchDivision.text}");
    });
  }

  @override
  void dispose() {
    _searchDivision.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   foregroundColor: Colors.orange,
        //   backgroundColor: Colors.white,
        //   bottom: TabBar(
        //     indicatorColor: Colors.orange,
        //     tabs: [
        //       Tab(text: 'HISTORY'),
        //       Tab(text: 'STATUS'),
        //     ],
        //     labelStyle: GoogleFonts.openSans(
        //       fontSize: 14,
        //       color: Color(0xFF555555),
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
        body: TabBarView(
          children: [
            _historyWork(),
            _statusWork(),
          ],
        ),
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       backgroundColor: Colors.orange,
  //       title: Align(
  //         alignment: Alignment.centerLeft,
  //         child: Text(
  //           '',
  //           style: GoogleFonts.openSans(
  //             fontSize: 24,
  //             color: Colors.white,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //       leading: IconButton(
  //         icon: Icon(
  //           Icons.arrow_back_ios,
  //           color: Colors.white,
  //         ),
  //         onPressed: () => Navigator.pop(context),
  //       ),
  //       actions: [
  //         InkWell(
  //           onTap: () {
  //             Navigator.pop(context);
  //           },
  //           child: Row(
  //             children: [
  //               Text(
  //                 'DONE',
  //                 style: GoogleFonts.openSans(
  //                   fontSize: 14,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //               SizedBox(width: 16)
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: DefaultTabController(
  //       length: 2, // Number of tabs
  //       child: StreamBuilder<Object>(
  //         stream: null,
  //         builder: (context, snapshot) {
  //           return Scaffold(
  //             body: CustomScrollView(
  //               slivers: <Widget>[
  //                 SliverFillRemaining(
  //                   child: TabBarView(
  //                     children: [
  //                       _historyWork(),
  //                       _statusWork(),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //       ),
  //     ),
  //   );
  // }

  Widget _historyWork() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkApplyPage(
                    employee: widget.employee,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.orange,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '[ Personal ]',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Reason : หาหมอ',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      '( Approved )',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset('assets/images/ic_calen.png', height: 45),
                        SizedBox(width: 16),
                        Text(
                          'Start : 2024-06-14 09:00  \nEnd : 2024-06-14 18:00',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _statusWork() {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              // border: Border.all(
              //   color: Colors.orange,
              //   width: 1.0,
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(color: Colors.orange, width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '[ Personal ]',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Divider(),
                      Text(
                        'Used : 08:00:00 Hour',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Available : 48:00:00 Hour',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Total : 56.00 Hour',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
