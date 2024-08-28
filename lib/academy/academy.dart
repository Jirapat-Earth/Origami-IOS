import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:origami_ios/login/login.dart';
import '../../Language/translate.dart';
import 'evaluate/evaluate_module.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class AcademyPage extends StatefulWidget {
  AcademyPage({super.key, required this.employee});
  final Employee employee;
  @override
  _AcademyPageState createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage> {
  TextEditingController _commentController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  int _itemCountChallenge = 3;
  var _isDesktop;
  var _isMobile;
  bool _isClick = false;

  @override
  void initState() {
    super.initState();
    futureLoadData = loadData();
    _searchController.addListener(() {
      // ฟังก์ชันนี้จะถูกเรียกทุกครั้งเมื่อข้อความใน _searchController เปลี่ยนแปลง
      print("Current text: ${_searchController.text}");
    });
    // fetchAcademy();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget loading() {
    return FutureBuilder<String>(
      future: futureLoadData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.orange,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                '$Loading...',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF555555),
                ),
              ),
            ],
          ));
        } else {
          return condition(_isMobile, _isDesktop);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the screen size
    double screenSize = MediaQuery.of(context).size.shortestSide;
    // Define a threshold to distinguish between mobile and desktop
    _isDesktop = screenSize <= 900;
    _isMobile = screenSize <= 600;
    if (screenSize <= 600) {
      _isMobile == true;
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Academy'),
      ),
      body: loading(),
      bottomNavigationBar: BottomBarInspiredInside(
        items: [
          TabItem(
            icon: Icons.account_balance,
            title: 'My Learning',
          ),
          TabItem(
            icon: Icons.star_border_purple500_rounded,
            title: 'My Challenge',
          ),
          TabItem(
            icon: Icons.list_alt,
            title: 'Catalog',
          ),
          TabItem(
            icon: Icons.favorite,
            title: 'Favorite',
          ),
          TabItem(
            icon: Icons.school,
            title: 'Coach Course',
          ),
        ],
        elevation: 10,
        colorSelected: Colors.white,
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        indexSelected: _selectedIndex,
        onTap: _onItemTapped,
        chipStyle: const ChipStyle(convexBridge: true),
        // itemStyle: ItemStyle.hexagon,
        animated: false,
      ),
    );
  }

  Widget condition(bool _isMobile, bool _isDesktop) {
    return (_selectedIndex == 0)
        ? _learning(_isMobile, _isDesktop)
        : (_selectedIndex == 1)
            ? _challenge(_isMobile, _isDesktop)
            : (_selectedIndex == 2)
                ? _CATALOG(_isMobile, _isDesktop)
                : (_selectedIndex == 3)
                    ? _FAVORITE()
                    : _COURSE();
  }

  bool _isMenu = false;

  Widget _learning(bool _isMobile, bool _isDesktop) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.orange,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '$Search...',
                        hintStyle: GoogleFonts.openSans(
                          color: Color(0xFF555555),
                        ),
                        labelStyle: GoogleFonts.openSans(
                          color: Color(0xFF555555),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.orange,
                        ),
                        border: InputBorder.none,
                        suffixIcon: Container(
                          alignment: Alignment.centerRight,
                          width: 80,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                },
                                icon: Icon(Icons.close),
                                color: Colors.orange,
                                iconSize: 18),
                          ),
                        ),
                      ),
                      onChanged: (value) {

                      },
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      (_isMenu == false) ? _isMenu = true : _isMenu = false;
                    });
                  },
                  icon: Container(
                      // padding: EdgeInsets.only(right: 8),
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.table_rows_rounded)),
                ),
              ],
            ),
          ),
          (_isMenu == true)
              ? Column(
                children: [
                  SizedBox(height: 8,),
                  Column(
                      children: List.generate(academyRespond.length ?? 0, (indexI) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EvaluateModule(
                                      id: '5',
                                    )),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 8,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        'https://www.origami.life/${academyRespond[indexI].academy_image}',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          academyRespond[indexI].academy_subject ??
                                              '',
                                          style: GoogleFonts.openSans(
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                          (academyRespond[indexI].academy_status ==
                                            "0")
                                            ? Text(
                                          'TIME OUT',
                                          style: GoogleFonts.openSans(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        ):
                                        Text(
                                          academyRespond[indexI].academy_start_date ??
                                              '',
                                          style: GoogleFonts.openSans(
                                            color: Color(0xFF555555),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Divider()
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                ],
              )
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _isMobile
                        ? 2
                        : _isDesktop
                            ? 4
                            : 2,
                    childAspectRatio: _isMobile
                        ? 0.7
                        : _isDesktop
                            ? 0.7
                            : 1.5 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: academyRespond.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    // String _startDate = formatDate(academyRespond[index].academy_start_date??'');
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EvaluateModule(
                                    id: '5',
                                  )),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Text(academyRespond[index].test![index]),
                            // Column(
                            //   children: List.generate(
                            //       academyRespond[index].test![index].length ?? 0, (indexC) {
                            //     return Text(academyRespond[index].test![indexC]);
                            //   }),
                            // ),
                            Stack(
                              children: [
                                Card(
                                  elevation: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      'https://www.origami.life/${academyRespond[index].academy_image}',
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 4,
                                  left: 4,
                                  child: Card(
                                    color: Colors.black26,
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Text(
                                        academyRespond[index].academy_type ??
                                            '',
                                        style: GoogleFonts.openSans(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                    child: Text(
                                      academyRespond[index].academy_subject ??
                                          '',
                                      style: GoogleFonts.openSans(
                                        fontSize: 18.0,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Column(
                                    children: List.generate(
                                        (academyRespond[index]
                                                        .academy_coach_data
                                                        ?.length ??
                                                    0) >
                                                2
                                            ? 2
                                            : academyRespond[index]
                                                    .academy_coach_data
                                                    ?.length ??
                                                0, (indexII) {
                                      final coach_data = academyRespond[index]
                                          .academy_coach_data;
                                      return Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                'https://www.origami.life/${coach_data?[indexII].avatar ?? ''}',
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Text(
                                                (coach_data?[indexII].name ==
                                                        '')
                                                    ? ""
                                                    : coach_data?[indexII]
                                                            .name ??
                                                        '',
                                                style: GoogleFonts.openSans(
                                                  color: Color(0xFF555555),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            ((academyRespond[index]
                                            .academy_coach_data
                                            ?.length ??
                                        0) >=
                                    2)
                                ? Container()
                                : Expanded(child: SizedBox()),
                            Expanded(
                              child: Container(
                                //Time Out , category:(stack)
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.all(8.0),
                                child: (academyRespond[index].academy_status ==
                                        "0")
                                    ? Text(
                                        'TIME OUT',
                                        style: GoogleFonts.openSans(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        '$Start : ${academyRespond[index].academy_start_date??''}',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  // Set the grid view to shrink wrap its contents.
                  shrinkWrap: true,
                  // Disable scrolling in the grid view.
                  physics: NeverScrollableScrollPhysics(),
                ),
        ],
      ),
    );
  }

  Widget _challenge(bool _isMobile, bool _isDesktop) {
    return SingleChildScrollView(
      child: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _isMobile
              ? 2
              : _isDesktop
                  ? 4
                  : 2,
          childAspectRatio: _isMobile
              ? 0.7
              : _isDesktop
                  ? 0.7
                  : 1.5 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _itemCountChallenge,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://www.origami.life/uploads/challenge/5/1137/logo/20242322068108.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          'Test new sqli (writing)',
                          style: GoogleFonts.openSans(
                            fontSize: 16.0,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Column(
                        children: List.generate(1, (index) {
                          return Padding(
                            padding: EdgeInsets.all(4),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_outlined,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '0/0',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '0/0',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.ac_unit_rounded,
                                      size: 20.0,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        ' - ',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '00:00:00',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '04/06/2024 - 30/06/2034',
                                              style: GoogleFonts.openSans(
                                                color: Color(0xFF555555),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          );
        },
        // Set the grid view to shrink wrap its contents.
        shrinkWrap: true,
        // Disable scrolling in the grid view.
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  String _comment = '';
  Widget _CATALOG(_isMobile, _isDesktop) {
    return SingleChildScrollView(
      child: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _isMobile
              ? 2
              : _isDesktop
                  ? 4
                  : 2,
          childAspectRatio: _isMobile
              ? 0.7
              : _isDesktop
                  ? 0.7
                  : 1.5 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => EvaluateModule(
              //             id: '5',
              //             employee: widget.employee,
              //           )),
              // );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Card(
                          elevation: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://www.origami.life/images/training.jpg',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Card(
                            color: Colors.black26,
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Text(
                                'catalog',
                                style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          'Allable On Boarding',
                          style: GoogleFonts.openSans(
                            fontSize: 18.0,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Column(
                        children: List.generate(2, (index) {
                          return Padding(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      'https://cdn-icons-png.flaticon.com/512/180/180644.png',
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.fitHeight,
                                    )),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    'Academy Subject',
                                    style: GoogleFonts.openSans(
                                      color: Color(0xFF555555),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  title: Row(
                                    children: [
                                      Icon(Icons.file_copy_outlined),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Enroll form',
                                        style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF555555),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  content: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Color(0xFF555555),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: TextFormField(
                                      minLines: 3,
                                      maxLines: null,
                                      keyboardType: TextInputType.text,
                                      controller: _commentController,
                                      style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                          fontSize: 14),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: '$Request_reason...',
                                        hintStyle: GoogleFonts.openSans(
                                            fontSize: 14,
                                            color: Color(0xFF555555)),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        _comment = value;
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        '$Cancel',
                                        style: GoogleFonts.openSans(
                                          color: Color(0xFF555555),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _comment = "";
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        '$Ok',
                                        style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // fetchApprovelMassage(setApprovel?.mny_request_id,"N",_commentN);
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              // border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                '$Enroll',
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              (_isClick == true)
                                  ? _isClick = false
                                  : _isClick = true;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: (_isClick != false)
                                  ? Colors.red.shade100
                                  : Color(0xFFE5E5E5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: (_isClick != false)
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    'Favorite',
                                    style: GoogleFonts.openSans(
                                      color: (_isClick != false)
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        // Set the grid view to shrink wrap its contents.
        shrinkWrap: true,
        // Disable scrolling in the grid view.
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _FAVORITE() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'NOT FOUND FAVORITE',
        style: GoogleFonts.openSans(
          fontSize: 18.0,
          color: Color(0xFF555555),
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _COURSE() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'NOT FOUND COURSE',
        style: GoogleFonts.openSans(
          fontSize: 18.0,
          color: Color(0xFF555555),
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

List<AcademyRespond> academyRespond = [
  AcademyRespond(
    test: ["11", "12", "13", "14"],
    academy_id: "course_15917",
    ref_id: "15917",
    emp_id: "19777",
    academy_type: "course",
    academy_category: "Trandar Product",
    academy_category_id: ["14203"],
    academy_coach: null,
    academy_coach_contact: null,
    academy_coach_data: [
      AcademyCoachData(
          avatar: "uploads/employee/5/employee/18597.png",
          name: "Nopparin Nopvichai (Pik)",
          type: "inhouse"),
    ],
    academy_coach_emp: ["18597"],
    academy_end_date: "2024-08-21 00:00:00",
    academy_image: "images/training.jpg",
    academy_start_date: "2024-08-21 00:00:00",
    academy_status: "0",
    academy_subject: "Trandar product training",
    enroll_class: "",
    enroll_key: "Enroll",
    favorite: "",
  ),
  AcademyRespond(
    test: ["11", "12", "13", "14"],
    academy_category: "Origami",
    academy_category_id: ["13905"],
    academy_coach: null,
    academy_coach_contact: null,
    academy_coach_data: [],
    academy_coach_emp: [],
    academy_end_date: null,
    academy_id: "course_15900",
    academy_image: "images/training.jpg",
    academy_start_date: "2024-08-02 00:00:00",
    academy_status: "1",
    academy_subject: "AI training by DevRev",
    academy_type: "course",
    emp_id: "19777",
    enroll_class: "",
    enroll_key: "Enroll",
    favorite: "",
    ref_id: "15900",
  ),
  AcademyRespond(
    test: ["11", "12", "13", "14"],
    academy_category: "Allable Academy",
    academy_category_id: ["13912"],
    academy_coach: null,
    academy_coach_contact: null,
    academy_coach_data: [
      AcademyCoachData(
          avatar: "uploads/employee/5/employee/14357.jpg",
          name: "Karnjana Kruaparkpang (Na)",
          type: "inhouse"),
      AcademyCoachData(
          name: "Kannika Somrak (มด)",
          avatar: "uploads/employee/5/employee/14444.jpg",
          type: "inhouse"),
    ],
    academy_coach_emp: ["14357", "14444"],
    academy_end_date: "2024-07-31 00:00:00",
    academy_id: "course_15424",
    academy_image: "uploads/photo/trn_picture_title_20230511151925.jpg",
    academy_start_date: "2024-05-07 00:00:00",
    academy_status: "0",
    academy_subject: "Evaluate Module",
    academy_type: "course",
    emp_id: "19777",
    enroll_class: "",
    enroll_key: "Enroll",
    favorite: "",
    ref_id: "15424",
  ),
  AcademyRespond(
    test: ["11", "12", "13", "14"],
    academy_category: "Allable Academy,Human Resource Management (HRM)",
    academy_category_id: ["13912", "13997"],
    academy_coach: null,
    academy_coach_contact: null,
    academy_coach_data: [
      AcademyCoachData(
        avatar: "uploads/employee/3/employee/70.png",
        name: "Seree Satukijchai (Tube)",
        type: "inhouse",
      ),
      AcademyCoachData(
        avatar: "uploads/employee/5/employee/100.jpg",
        name: "Kridsada Satukijchai (Krid)",
        type: "inhouse",
      ),
      AcademyCoachData(
        avatar: "uploads/employee/3/employee/155.png",
        name: "Chanyanuch Amnone (Nok)",
        type: "inhouse",
      ),
      AcademyCoachData(
        avatar: "uploads/employee/3/employee/184.jpg",
        name: "Karnjana Kruaparkpang (Na)",
        type: "inhouse",
      ),
      AcademyCoachData(
        avatar: "uploads/employee/5/employee/14427.png",
        name: "Matee Wattanasirisakul (Tee)",
        type: "inhouse",
      ),
    ],
    academy_coach_emp: ["100", "155", "70", "14427", "184"],
    academy_end_date: "2024-07-31 00:00:00",
    academy_id: "learning_map_10",
    academy_image: "uploads/photo/learning_map_pic_20200720115352.jpg",
    academy_start_date: "2024-05-07 00:00:00",
    academy_status: "0",
    academy_subject: "Allable On Boarding",
    academy_type: "learning-map",
    emp_id: "19777",
    enroll_class: "",
    enroll_key: "Enroll",
    favorite: "",
    ref_id: "10",
  ),
];

class AcademyRespond {
  final List<String>? test;
  final String? academy_id;
  final String? ref_id;
  final String? emp_id;
  final String? academy_type;
  final String? academy_category;
  final List<String>? academy_category_id;
  final String? academy_coach;
  final String? academy_coach_contact;
  final List<AcademyCoachData>? academy_coach_data;
  final List<String>? academy_coach_emp;
  final String? academy_end_date;
  final String? academy_image;
  final String? academy_start_date;
  final String? academy_status;
  final String? academy_subject;
  final String? enroll_class;
  final String? enroll_key;
  final String? favorite;

  AcademyRespond({
    this.test,
    this.academy_id,
    this.ref_id,
    this.emp_id,
    this.academy_type,
    this.academy_category,
    this.academy_category_id,
    this.academy_coach,
    this.academy_coach_contact,
    this.academy_coach_data,
    this.academy_coach_emp,
    this.academy_end_date,
    this.academy_image,
    this.academy_start_date,
    this.academy_status,
    this.academy_subject,
    this.enroll_class,
    this.enroll_key,
    this.favorite,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory AcademyRespond.fromJson(Map<String, dynamic> json) {
    return AcademyRespond(
      academy_category: json['academy_category'],
      academy_category_id: json['academy_category_id'],
      academy_coach: json['academy_coach'],
      academy_coach_contact: json['academy_coach_contact'],
      academy_coach_data: json['academy_coach_data'] != null
          ? (json['academy_coach_data'] as List)
              .map((item) => AcademyCoachData.fromJson(item))
              .toList()
          : null,
      academy_coach_emp: json['academy_coach_emp'],
      academy_end_date: json['academy_end_date'],
      academy_id: json['academy_id'],
      academy_image: json['academy_image'],
      academy_start_date: json['academy_start_date'],
      academy_status: json['academy_status'],
      academy_subject: json['academy_subject'],
      academy_type: json['academy_type'],
      emp_id: json['emp_id'],
      enroll_class: json['enroll_class'],
      enroll_key: json['enroll_key'],
      favorite: json['favorite'],
      ref_id: json['ref_id'],
    );
  }

  // การแปลง Object ของ Academy กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'academy_category': academy_category,
      'academy_category_id': academy_category_id,
      'academy_coach': academy_coach,
      'academy_coach_contact': academy_coach_contact,
      'academy_coach_data':
          academy_coach_data?.map((item) => item.toJson()).toList(),
      'academy_coach_emp': academy_coach_emp,
      'academy_end_date': academy_end_date,
      'academy_id': academy_id,
      'academy_image': academy_image,
      'academy_start_date': academy_start_date,
      'academy_status': academy_status,
      'academy_subject': academy_subject,
      'academy_type': academy_type,
      'emp_id': emp_id,
      'enroll_class': enroll_class,
      'enroll_key': enroll_key,
      'favorite': favorite,
      'ref_id': ref_id,
    };
  }
}

class AcademyCoachData {
  final String? avatar;
  final String? name;
  final String? type;

  AcademyCoachData({
    this.avatar,
    this.name,
    this.type,
  });

  // ฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ AcademyCoachData
  factory AcademyCoachData.fromJson(Map<String, dynamic> json) {
    return AcademyCoachData(
      avatar: json['avatar'],
      name: json['name'],
      type: json['type'],
    );
  }

  // การแปลง Object ของ AcademyCoachData กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
      'type': type,
    };
  }
}

class Challenge {
  String challengeDescription;
  String challengeDuration;
  String challengeEnd;
  String challengeId;
  String challengeLogo;
  String challengeName;
  String challengePointValue;
  String challengeQuestionPart;
  String challengeRank;
  String challengeRule;
  String challengeStart;
  String challengeStatus;
  int correctAnswer;
  String endDate;
  String requestId;
  int specificQuestion;
  String startDate;
  String status;
  String? timerFinish;
  String timerStart;

  Challenge({
    required this.challengeDescription,
    required this.challengeDuration,
    required this.challengeEnd,
    required this.challengeId,
    required this.challengeLogo,
    required this.challengeName,
    required this.challengePointValue,
    required this.challengeQuestionPart,
    required this.challengeRank,
    required this.challengeRule,
    required this.challengeStart,
    required this.challengeStatus,
    required this.correctAnswer,
    required this.endDate,
    required this.requestId,
    required this.specificQuestion,
    required this.startDate,
    required this.status,
    this.timerFinish,
    required this.timerStart,
  });

  // การสร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Challenge
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      challengeDescription: json['challenge_description'],
      challengeDuration: json['challenge_duration'],
      challengeEnd: json['challenge_end'],
      challengeId: json['challenge_id'],
      challengeLogo: json['challenge_logo'],
      challengeName: json['challenge_name'],
      challengePointValue: json['challenge_point_value'],
      challengeQuestionPart: json['challenge_question_part'],
      challengeRank: json['challenge_rank'],
      challengeRule: json['challenge_rule'],
      challengeStart: json['challenge_start'],
      challengeStatus: json['challenge_status'],
      correctAnswer: json['correct_answer'],
      endDate: json['end_date'],
      requestId: json['request_id'],
      specificQuestion: json['specific_question'],
      startDate: json['start_date'],
      status: json['status'],
      timerFinish: json['timer_finish'],
      timerStart: json['timer_start'],
    );
  }

  // การแปลง Object ของ Challenge กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'challenge_description': challengeDescription,
      'challenge_duration': challengeDuration,
      'challenge_end': challengeEnd,
      'challenge_id': challengeId,
      'challenge_logo': challengeLogo,
      'challenge_name': challengeName,
      'challenge_point_value': challengePointValue,
      'challenge_question_part': challengeQuestionPart,
      'challenge_rank': challengeRank,
      'challenge_rule': challengeRule,
      'challenge_start': challengeStart,
      'challenge_status': challengeStatus,
      'correct_answer': correctAnswer,
      'end_date': endDate,
      'request_id': requestId,
      'specific_question': specificQuestion,
      'start_date': startDate,
      'status': status,
      'timer_finish': timerFinish,
      'timer_start': timerStart,
    };
  }
}
