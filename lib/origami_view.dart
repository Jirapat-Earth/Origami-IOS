import 'package:http/http.dart' as http;
import '../imports.dart';

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
  int _index = 12;
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
    fetchBranch();
  }

  DateTime? lastPressed;
  bool isNeed = false;
  bool isBranch = false;
  GetTimeStampSim? timeStampObject;
  List<GetTimeStampSim> timeStampList = [];
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
          elevation: 1,
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
                if (branchStr == 'Time') {
                  _changeBranch();
                } else {
                  return;
                }
              },
              child: Row(
                children: [
                  SizedBox(width: 20),
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
                          child: _ListMenu(),
                        ),
                      ),
                      // _test(),
                      _output(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: _buildPage(),
          ),
        ),
      ),
    );
  }

  Widget _ListMenu() {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 6, right: 6),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      trailing: Icon(Icons.keyboard_arrow_down,
                          color: (_index == 0 || _index == 1)
                              ? Colors.transparent
                              : Color(0xFF555555)),
                      title: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FaIcon(FontAwesomeIcons.fileText,
                                size: 18,
                                color: (_index == 0 || _index == 1)
                                    ? Colors.orange
                                    : Color(0xFF555555)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            '$need',
                            style: GoogleFonts.openSans(
                                color: (_index == 0 || _index == 1)
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
                  if (isNeed == false)
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                trailing: FaIcon(FontAwesomeIcons.handHoldingUsd,
                                    size: 18,
                                    color: (_index == 0)
                                        ? Colors.orange
                                        : Color(0xFF555555)),
                                title: Text(
                                  '$need',
                                  style: GoogleFonts.openSans(
                                      color: (_index == 0)
                                          ? Colors.orange
                                          : Color(0xFF555555)),
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
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                trailing: FaIcon(FontAwesomeIcons.checkDouble,
                                    size: 18,
                                    color: (_index == 1)
                                        ? Colors.orange
                                        : Color(0xFF555555)),
                                title: Text(
                                  '$request',
                                  style: GoogleFonts.openSans(
                                      color: (_index == 1)
                                          ? Colors.orange
                                          : Color(0xFF555555)),
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
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                trailing: FaIcon(FontAwesomeIcons.wallet,
                                    size: 18,
                                    color: (_index == 8)
                                        ? Colors.orange
                                        : Color(0xFF555555)),
                                title: Text(
                                  'Petty Cash',
                                  style: GoogleFonts.openSans(
                                      color: (_index == 8)
                                          ? Colors.orange
                                          : Color(0xFF555555)),
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
          ],
        ),
        Container(
          child: _viewMenu(12, 'Contact', Icons.keyboard_arrow_right,
              Icons.perm_contact_cal_outlined),
        ),
        Container(
          child: _viewMenu(
              13, 'Account', Icons.keyboard_arrow_right, Icons.person_sharp),
        ),
        Container(
          child: _viewMenu(10, 'Project', Icons.keyboard_arrow_right,
              FontAwesomeIcons.projectDiagram),
        ),
        Container(
          child: _viewMenu(9, 'Activity', Icons.keyboard_arrow_right,
              FontAwesomeIcons.running),
        ),
        Container(
          child: _viewMenu(14, 'Calendar', Icons.keyboard_arrow_right,
            Icons.calendar_month),
        ),
        Container(
          child: _viewMenu(
              5, 'Time', Icons.keyboard_arrow_right, FontAwesomeIcons.clock),
        ),
        Container(
          child: _viewMenu(11, 'Work', Icons.keyboard_arrow_right, Icons.work),
        ),

        Container(
          child: _viewMenu(2, 'Academy', Icons.keyboard_arrow_right,
              FontAwesomeIcons.university),
        ),
        Container(
          child: _viewMenu(3, 'Language', Icons.keyboard_arrow_right,
              FontAwesomeIcons.language),
        ),
        Container(
          child: _viewMenu(
              6, 'About', Icons.keyboard_arrow_right, FontAwesomeIcons.user),
        ),
      ],
    );
  }

  final List<String> _listTitle = [
    "$need",
    "$request",
    "Academy",
    "Language",
    "$logout",
    "Time",
    "Profile",
    "TestChat",
    "Petty Cash",
    "Activity",
    "Project",
    "Work",
    "Contact",
    "Account",
    "Calendar",
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
        timeStamp: timeStampObject,
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
      9: ActivityScreen(
        employee: widget.employee,
        pageInput: 'activity',
      ),
      10: ProjectScreen(
        employee: widget.employee,
        pageInput: 'project',
      ),
      11: WorkPage(employee: widget.employee),
      12: ContactScreen(
        employee: widget.employee,
        pageInput: 'contact',
      ),
      13: AccountList(
        employee: widget.employee,
        pageInput: 'account',
      ),
      14: CalendarScreen(
        employee: widget.employee,
        pageInput: 'calendar',
      ),
    };
    return pages[_index] ?? Container();
  }

  String branchStr = '';
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
                  branchStr = title;
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
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red),
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
              trailing: Icon(Icons.keyboard_arrow_right,
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
        //       trailing: Icon(Icons.keyboard_arrow_right,
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

  void _changeBranch() {
    showModalBottomSheet<void>(
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      builder: (BuildContext context) {
        return _getBranch();
      },
    );
  }

  Widget _getBranch() {
    return FutureBuilder<List<GetTimeStampSim>>(
      future: fetchBranch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                '$Loading...',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            '$Empty',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ));
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Branch',
                        style: GoogleFonts.openSans(
                          fontSize: 22,
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final branch = snapshot.data?[index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    timeStampObject = snapshot.data?[index];
                                  });
                                  Navigator.pop(context);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Color(0xFF555555),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Text(
                                              '${branch?.branch_name ?? ''}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.openSans(
                                                fontSize: 16,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Divider(),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<GetTimeStampSim>> fetchBranch() async {
    final uri = Uri.parse("https://www.origami.life/api/load_branch.php");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'auth_password': widget.employee.auth_password,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'];
      setState(() {
        timeStampList =
            dataJson.map((json) => GetTimeStampSim.fromJson(json)).toList();
        timeStampObject = timeStampList[0];
      });
      return dataJson.map((json) => GetTimeStampSim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }
}
