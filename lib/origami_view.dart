import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:origami_ios/project/project.dart';
import 'package:origami_ios/setting.dart';
import 'package:origami_ios/work/work_page.dart';
import '../language/translate.dart';
import '../login/login.dart';
import 'academy/academy.dart';
import 'activity/activity.dart';
import 'chat/chat.dart';
import 'google_map/custom_info_windows.dart';
import 'google_map/google_map.dart';
import 'need/need_view/need.dart';
import 'need/need_view/need_approve.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'need/petty_cash/petty_cash.dart';

class OrigamiPage extends StatefulWidget {
  const OrigamiPage({
    super.key,
    required this.employee,
    required this.popPage,
  });
  final Employee employee;
  final int popPage;
  @override
  State<OrigamiPage> createState() => _OrigamiPageState();
}

class _OrigamiPageState extends State<OrigamiPage> {
  int _index = 0;
  static var optionStyle = GoogleFonts.openSans(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF555555),
  );

  @override
  void initState() {
    super.initState();
    _index = widget.popPage;
    futureLoadData = loadData();
  }

  DateTime? lastPressed;
  bool isNeed = false;
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.6;
    return WillPopScope(
      onWillPop: () async {
        // เช็คว่ามีการกดปุ่มย้อนกลับครั้งล่าสุดหรือไม่ และเวลาห่างจากปัจจุบันมากกว่า 2 วินาทีหรือไม่
        final now = DateTime.now();
        final maxDuration = Duration(seconds: 2);
        final isWarning =
            lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          // ถ้ายังไม่ได้กดสองครั้งภายในเวลาที่กำหนด ให้แสดง SnackBar แจ้งเตือน
          lastPressed = DateTime.now();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Press back again to exit the origami application.',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                ),
              ),
              duration: maxDuration,
            ),
          );
          return false; // ไม่ออกจากแอป
        }

        // ถ้ากดปุ่มย้อนกลับสองครั้งภายในเวลาที่กำหนด ให้ออกจากแอป
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.orange,
          backgroundColor: Colors.white,
          title: Text(
            _listTitle[_index],
            style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => WhatsAppChatScreen(),
                //   ),
                // );
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    child: Image.network(
                      widget.employee.comp_logo ?? '',
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
        drawer: Container(
          // width: drawerWidth,
          child: Drawer(
            elevation: 0,
            backgroundColor: Colors.white,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    const UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/logoOrigami/default_bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      accountName: null,
                      accountEmail: null,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 8, bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                widget.employee.emp_avatar ?? '',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                '$Name: ',
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Expanded(
                                child: Text(
                                  '${widget.employee.emp_name}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Text(
                                '$Position1: ',
                                style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Expanded(
                                child: Text(
                                  '${widget.employee.dept_description}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.white,
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
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 2, left: 6, right: 6),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        trailing: Icon(
                                            Icons.arrow_drop_down_outlined,
                                            color: (_index == 0 || _index == 1)
                                                ? Colors.orange
                                                : Color(0xFF555555)),
                                        title: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: FaIcon(
                                                  FontAwesomeIcons.fileText,
                                                  size: 18,
                                                  color: (_index == 0 ||
                                                          _index == 1)
                                                      ? Colors.orange
                                                      : Color(0xFF555555)),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              '$need',
                                              style: GoogleFonts.openSans(
                                                  color: (_index == 0 ||
                                                          _index == 1)
                                                      ? Colors.orange
                                                      : Color(0xFF555555)),
                                            ),
                                          ],
                                        ),
                                        // selected: _index == 0,
                                        // onTap: () {
                                        //   setState(() {
                                        //     (isNeed == true) ? _index = 0 : _index = _index;
                                        //     (isNeed == true) ? isNeed = false : isNeed = true;
                                        //   });
                                        // },
                                      ),
                                    ),
                                    (isNeed == true)
                                        ? Container()
                                        : Container(
                                            padding: EdgeInsets.only(left: 16),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: ListTile(
                                                      trailing: FaIcon(
                                                          FontAwesomeIcons
                                                              .handHoldingUsd,
                                                          size: 18,
                                                          color: (_index == 0)
                                                              ? Colors.orange
                                                              : Color(
                                                                  0xFF555555)),
                                                      title: Text(
                                                        '$need',
                                                        style: GoogleFonts.openSans(
                                                            color: (_index == 0)
                                                                ? Colors.orange
                                                                : Color(
                                                                    0xFF555555)),
                                                      ),
                                                      selected: _index == 0,
                                                      onTap: () {
                                                        setState(() {
                                                          _index = 0;
                                                        });

                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: ListTile(
                                                      trailing: FaIcon(
                                                          FontAwesomeIcons
                                                              .checkDouble,
                                                          size: 18,
                                                          color: (_index == 1)
                                                              ? Colors.orange
                                                              : Color(
                                                                  0xFF555555)),
                                                      title: Text(
                                                        '$request',
                                                        style: GoogleFonts.openSans(
                                                            color: (_index == 1)
                                                                ? Colors.orange
                                                                : Color(
                                                                    0xFF555555)),
                                                      ),
                                                      selected: _index == 1,
                                                      onTap: () {
                                                        setState(() {
                                                          _index = 1;
                                                        });

                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: ListTile(
                                                      trailing: FaIcon(
                                                          FontAwesomeIcons
                                                              .wallet,
                                                          size: 18,
                                                          color: (_index == 8)
                                                              ? Colors.orange
                                                              : Color(
                                                                  0xFF555555)),
                                                      title: Text(
                                                        'Petty Cash',
                                                        style: GoogleFonts.openSans(
                                                            color: (_index == 8)
                                                                ? Colors.orange
                                                                : Color(
                                                                    0xFF555555)),
                                                      ),
                                                      selected: _index == 8,
                                                      onTap: () {
                                                        setState(() {
                                                          _index = 8;
                                                        });

                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: Divider(),
                              ),
                              _viewMenu(10, 'Project', Icons.chevron_right,
                                  FontAwesomeIcons.book),
                              _viewMenu(9, 'Activity', Icons.chevron_right,
                                  FontAwesomeIcons.running),
                              _viewMenu(11, 'Time', Icons.chevron_right,
                                  FontAwesomeIcons.clock),
                              _viewMenu(
                                  12, 'Work', Icons.chevron_right, Icons.work),
                              _viewMenu(2, '$academy', Icons.chevron_right,
                                  FontAwesomeIcons.university),
                              _viewMenu(3, '$language', Icons.chevron_right,
                                  FontAwesomeIcons.language),
                              _viewMenu(6, 'About', Icons.chevron_right,
                                  FontAwesomeIcons.user),
                            ],
                          ),
                        ),
                      ),
                      _test(),
                      _output(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: _buildPage(),
        ),
      ),
    );
  }

  List<String> _listTitle = [
    "$need",
    "$request",
    "$academy",
    "$language",
    "$logout",
    "Time",
    "Profile",
    "TestChat",
    "Petty Cash",
    "Activity",
    "Project",
    "Time",
    "Work",
  ];

  Widget _buildPage() {
    final pages = {
      0: NeedsView(employee: widget.employee),
      1: NeedRequest(employee: widget.employee),
      2: AcademyPage(employee: widget.employee),
      3: TranslatePage(employee: widget.employee),
      4: Text('Index 6: LogOut', style: optionStyle),
      5: TimeSample(
        employee: widget.employee,
      ),
      6: ProfilePage(
        employee: widget.employee,
      ),
      7: ChatView(
        employee: widget.employee,
      ),
      8: PettyCash(
        employee: widget.employee,
      ),
      9: activityScreen(
        employee: widget.employee,
      ),
      10: projectScreen(
        employee: widget.employee,
      ),
      11: TimeSample(employee: widget.employee),
      12: WorkPage(employee: widget.employee),
    };
    return pages[_index] ?? Container();
  }

  Widget _viewMenu(int page, String title, IconData icons, IconData faIcon) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              trailing: Icon(icons,
                  color: (_index == page) ? Colors.orange : Color(0xFF555555)),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FaIcon(faIcon,
                        size: 18,
                        color: (_index == page)
                            ? Colors.orange
                            : Color(0xFF555555)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.openSans(
                        color: (_index == page)
                            ? Colors.orange
                            : Color(0xFF555555)),
                  ),
                ],
              ),
              selected: _index == page,
              onTap: () {
                setState(() {
                  _index = page;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Divider(),
        ),
      ],
    );
  }

  Widget _output() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          trailing: Icon(Icons.chevron_right, color: Colors.red),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.door_back_door_outlined,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '$logout',
                style: GoogleFonts.openSans(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // selected: _index == 4,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  elevation: 0,
                  title: Text(
                    'Do you want to log out?',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Color(0xFF555555),
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        '$Cancel',
                        style: GoogleFonts.openSans(
                          color: Color(0xFF555555),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.of(dialogContext).pop();
                          // Navigator.pop(context);
                        });
                      },
                    ),
                    TextButton(
                      child: Text(
                        '$logout',
                        style: GoogleFonts.openSans(
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                    num: 1,
                                    popPage: 0,
                                  )),
                          (Route<dynamic> route) =>
                              false, // ลบหน้าทั้งหมดใน stack
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _test() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              trailing: Icon(Icons.chevron_right,
                  color: (_index == 5) ? Colors.orange : Color(0xFF555555)),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.autorenew_sharp,
                        color:
                            (_index == 5) ? Colors.orange : Color(0xFF555555)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Test',
                    style: GoogleFonts.openSans(
                        color:
                            (_index == 5) ? Colors.orange : Color(0xFF555555)),
                  ),
                ],
              ),
              selected: _index == 5,
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ProductsScreen(
                //       employee: widget.employee,
                //     ),
                //   ),
                // );

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => OcrScreen(),
                //   ),
                // );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkPage(
                      employee: widget.employee,
                    ),
                  ),
                );
                // setState(() {
                //   _index = 5;
                // });
                //
                // Navigator.pop(context);
              },
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.orange.shade50,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: ListTile(
        //       trailing: Icon(Icons.chevron_right,
        //           color: (_index == 7) ? Colors.orange : Color(0xFF555555)),
        //       title: Row(
        //         children: [
        //           Container(
        //             padding: EdgeInsets.all(8),
        //             decoration: BoxDecoration(
        //               color: Colors.orange.shade200,
        //               borderRadius: BorderRadius.circular(10),
        //             ),
        //             child: Icon(Icons.mark_chat_unread_outlined,
        //                 color:
        //                     (_index == 7) ? Colors.orange : Color(0xFF555555)),
        //           ),
        //           SizedBox(
        //             width: 8,
        //           ),
        //           Text(
        //             'TestChat',
        //             style: GoogleFonts.openSans(
        //                 color:
        //                     (_index == 7) ? Colors.orange : Color(0xFF555555)),
        //           ),
        //         ],
        //       ),
        //       selected: _index == 7,
        //       onTap: () {
        //         setState(() {
        //           // _index = 7;
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => ChatView(
        //                 employee: widget.employee,
        //               ),
        //             ),
        //           );
        //         });
        //         // Navigator.pop(context);
        //       },
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
