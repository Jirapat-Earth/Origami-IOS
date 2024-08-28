import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:origami_ios/setting_translate.dart';
import '../language/translate.dart';
import '../login/login.dart';
import 'academy/academy.dart';
import 'need/need.dart';
import 'need/need_approve.dart';

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

  List<String> _listTitle = [
    "$need",
    "$request",
    "$academy",
    "$language",
    "$logout",
  ];

  bool isNeed = false;
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.6;
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                elevation: 0,
                title: Text(
                  '$ExitApp',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Color(0xFF555555),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      '$NotNow',
                      style: GoogleFonts.openSans(
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      '$Ok',
                      style: GoogleFonts.openSans(
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange.shade500,
          title: Text(
            _listTitle[_index],
            style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            Container(
              width: 40,
              child: Image.network(
                widget.employee.comp_logo ?? '',
              ),
            ),
          ],
        ),
        drawer: Container(
          // width: drawerWidth,
          child: Drawer(
            elevation: 0,
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.all(0),
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
                                '$Position: ',
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
                Column(
                  children: [
                    ListTile(
                      trailing: Icon(Icons.arrow_drop_down_outlined,color: (_index == 0 || _index == 1)?Colors.orange:Color(0xFF555555)),
                      title: Text(
                        '$need',
                        style: GoogleFonts.openSans(color: (_index == 0 || _index == 1)?Colors.orange:Color(0xFF555555)),
                      ),
                      // selected: _index == 0,
                      // onTap: () {
                      //   setState(() {
                      //     (isNeed == true) ? _index = 0 : _index = _index;
                      //     (isNeed == true) ? isNeed = false : isNeed = true;
                      //   });
                      // },
                    ),
                    (isNeed == true)
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              children: [
                                ListTile(
                                  trailing: Icon(Icons.file_present_outlined,color: (_index == 0 )?Colors.orange:Color(0xFF555555)),
                                  title: Text(
                                    '$need',
                                    style: GoogleFonts.openSans(color: (_index == 0 )?Colors.orange:Color(0xFF555555)),
                                  ),
                                  selected: _index == 0,
                                  onTap: () {
                                    setState(() {
                                      _index = 0;
                                    });
                                    
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  trailing: Icon(Icons.done_all_outlined,color: (_index == 1)?Colors.orange:Color(0xFF555555)),
                                  title: Text(
                                    '$request',
                                    style: GoogleFonts.openSans(color: (_index == 1)?Colors.orange:Color(0xFF555555)),
                                  ),
                                  selected: _index == 1,
                                  onTap: () {
                                    setState(() {
                                      _index = 1;
                                    });
                                    
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
                ListTile(
                  trailing: Icon(Icons.home_repair_service_outlined,color: (_index == 2)?Colors.orange:Color(0xFF555555)),
                  title: Text(
                    '$academy',
                    style: GoogleFonts.openSans(color:(_index == 2)?Colors.orange:Color(0xFF555555)),
                  ),
                  selected: _index == 2,
                  onTap: () {
                    setState(() {
                      _index = 2;
                    });
                    
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  trailing: Icon(Icons.language_outlined,color: (_index == 3)?Colors.orange:Color(0xFF555555)),
                  title: Text(
                    '$language',
                    style: GoogleFonts.openSans(color:(_index == 3)?Colors.orange:Color(0xFF555555)),
                  ),
                  selected: _index == 3,
                  onTap: () {
                    setState(() {
                      _index = 3;
                    });
                    
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  trailing: Icon(Icons.output,color:(_index == 6)?Colors.orange:Color(0xFF555555)),
                  title: Text(
                    '$logout',
                    style: GoogleFonts.openSans(color: (_index == 6)?Colors.orange:Color(0xFF555555)),
                  ),
                  selected: _index == 6,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          elevation: 0,
                          title: Image.network(
                            'https://cdn-icons-png.flaticon.com/512/5087/5087579.png',
                            height: 180,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                '$Cancel',
                                style: GoogleFonts.openSans(
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.bold,
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
                                  MaterialPageRoute(builder: (context) =>  LoginPage(
                                    num: 1,
                                    popPage: 0,
                                  )),
                                      (Route<dynamic> route) => false, // ลบหน้าทั้งหมดใน stack
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
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

  Widget _buildPage() {
    final pages = {
      0: NeedsView(employee: widget.employee),
      1: NeedRequest(employee: widget.employee),
      2: AcademyPage(employee: widget.employee,),
      3: TranslatePage(employee: widget.employee),
      4: Text('Index 6: LogOut', style: optionStyle),
    };
    return pages[_index] ?? Container();
  }
}
