import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:origami_ios/login/login.dart';
import '../../language/translate.dart';
import 'evaluate/evaluate_module.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class AcademyPage extends StatefulWidget {
  AcademyPage({
    super.key,
    required this.employee,
  });
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

  void filterSearchResults(String query) {
    // if (query.isEmpty) {
    //   setState(() {
    //     _academy = filteredAcademyData;
    //   });
    // } else {
    //   setState(() {
    //     _academy = filteredAcademyData
    //         .where((academy) =>
    //         academy.academy_date.toLowerCase().contains(query.toLowerCase()))
    //         .toList();
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    futureLoadData = loadData();
    fetchAcademy();
    filteredAcademyData = _academy;
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
  String page = "course";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "course";
      } else if (index == 1) {
        page = "course";
      } else if (index == 2) {
        page = "catalog";
      } else if (index == 3) {
        page = "favorite";
      } else if (index == 4) {
        page = "enroll";
      }
      fetchAcademy();
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
        itemStyle: ItemStyle.circle,
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
                    ? _FAVORITE(_isMobile, _isDesktop)
                    : _COURSE();
  }

  bool _isMenu = false;

  Widget _learning(bool _isMobile, bool _isDesktop) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
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
                      onChanged: filterSearchResults,
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
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: List.generate(_academy.length ?? 0, (indexI) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EvaluateModule(
                                          id: '5',
                                          employee: widget.employee,
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
                                        '${_academy[indexI].academy_image}',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _academy[indexI].academy_subject ??
                                              '',
                                          style: GoogleFonts.openSans(
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        (_academy[indexI].academy_date ==
                                                "Time Out")
                                            ? Text(
                                                '${_academy[indexI].academy_date ?? ''}',
                                                style: GoogleFonts.openSans(
                                                  color: Colors.red,
                                                ),
                                              )
                                            : Text(
                                                '$Start : ${_academy[indexI].academy_date ?? ''}',
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
                  itemCount: _academy.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    // String _startDate = formatDate(academyRespond[index].academy_start_date??'');
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EvaluateModule(
                                    id: '5',
                                    employee: widget.employee,
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
                          children: [
                            Stack(
                              children: [
                                Card(
                                  elevation: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      '${_academy[index].academy_image}',
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: Card(
                                    color: Colors.black26,
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Text(
                                        _academy[index].academy_category ?? '',
                                        style: GoogleFonts.openSans(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
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
                                        _academy[index].academy_type ?? '',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
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
                                      _academy[index].academy_subject ?? '',
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
                                        (_academy[index]
                                                        .academy_coach_data
                                                        ?.length ??
                                                    0) >
                                                2
                                            ? 2
                                            : _academy[index]
                                                    .academy_coach_data
                                                    ?.length ??
                                                0, (indexII) {
                                      final coach_data =
                                          _academy[index].academy_coach_data;
                                      return Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                '${coach_data?[indexII].avatar ?? ''}',
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
                            ((_academy[index].academy_coach_data?.length ??
                                        0) >=
                                    2)
                                ? Container()
                                : Expanded(child: SizedBox()),
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    (_academy[index].academy_date == "Time Out")
                                        ? Text(
                                            '${_academy[index].academy_date ?? ''}',
                                            style: GoogleFonts.openSans(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            '$Start : ${_academy[index].academy_date ?? ''}',
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
              ? 0.68
              : _isDesktop
                  ? 0.68
                  : 1.5 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _academy.length,
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
                children: [
                  Stack(
                    children: [
                      Card(
                        elevation: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            '${_academy[index].academy_image}',
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Card(
                          color: Colors.black26,
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              _academy[index].academy_category ?? '',
                              style: GoogleFonts.openSans(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
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
                              _academy[index].academy_type ?? '',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
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
                            _academy[index].academy_subject ?? '',
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
                              (_academy[index].academy_coach_data?.length ??
                                          0) >
                                      2
                                  ? 2
                                  : _academy[index]
                                          .academy_coach_data
                                          ?.length ??
                                      0, (indexII) {
                            final coach_data =
                                _academy[index].academy_coach_data;
                            return Padding(
                              padding: EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      '${coach_data?[indexII].avatar ?? ''}',
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
                                      (coach_data?[indexII].name == '')
                                          ? ""
                                          : coach_data?[indexII].name ?? '',
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
                  ((_academy[index].academy_coach_data?.length ?? 0) >= 2)
                      ? Container()
                      : Expanded(child: SizedBox()),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
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
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  // border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
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
                                  (_academy[index].favorite == 0)
                                      ? _academy[index].favorite == 1
                                      : _academy[index].favorite == 0;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: (_academy[index].favorite == 1)
                                      ? Colors.red.shade100
                                      : Color(0xFFE5E5E5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: (_academy[index].favorite == 1)
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
                                          color: (_academy[index].favorite == 1)
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

  Widget _FAVORITE(_isMobile, _isDesktop) {
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
              ? 0.68
              : _isDesktop
                  ? 0.68
                  : 1.5 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _academy.length,
        itemBuilder: (BuildContext context, int index) {
          return (_academy[index].favorite == 1)
              ? InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Card(
                              elevation: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  '${_academy[index].academy_image}',
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Card(
                                color: Colors.black26,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    _academy[index].academy_category ?? '',
                                    style: GoogleFonts.openSans(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
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
                                    _academy[index].academy_type ?? '',
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
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
                                  _academy[index].academy_subject ?? '',
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
                                    (_academy[index]
                                                    .academy_coach_data
                                                    ?.length ??
                                                0) >
                                            2
                                        ? 2
                                        : _academy[index]
                                                .academy_coach_data
                                                ?.length ??
                                            0, (indexII) {
                                  final coach_data =
                                      _academy[index].academy_coach_data;
                                  return Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            '${coach_data?[indexII].avatar ?? ''}',
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
                                            (coach_data?[indexII].name == '')
                                                ? ""
                                                : coach_data?[indexII].name ??
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
                        ((_academy[index].academy_coach_data?.length ?? 0) >= 2)
                            ? Container()
                            : Expanded(child: SizedBox()),
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            content: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: Color(0xFF555555),
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: TextFormField(
                                                minLines: 3,
                                                maxLines: null,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: _commentController,
                                                style: GoogleFonts.openSans(
                                                    color: Color(0xFF555555),
                                                    fontSize: 14),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText:
                                                      '$Request_reason...',
                                                  hintStyle:
                                                      GoogleFonts.openSans(
                                                          fontSize: 14,
                                                          color: Color(
                                                              0xFF555555)),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
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
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        // border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
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
                                        (_academy[index].favorite == 0)
                                            ? _academy[index].favorite == 1
                                            : _academy[index].favorite == 0;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: (_academy[index].favorite == 1)
                                            ? Colors.red.shade100
                                            : Color(0xFFE5E5E5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color:
                                                (_academy[index].favorite == 1)
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
                                                color:
                                                    (_academy[index].favorite ==
                                                            1)
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
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
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
        },
        // Set the grid view to shrink wrap its contents.
        shrinkWrap: true,
        // Disable scrolling in the grid view.
        physics: NeverScrollableScrollPhysics(),
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

  List<AcademyRespond> _academy = [];
  List<AcademyRespond> filteredAcademyData = [];

  Future<void> fetchAcademy() async {
    final uri =
        Uri.parse('https://www.origami.life/api/origami/academy/course.php');
    try {
      final response = await http.post(
        uri,
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'pages': page,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> academyJson = jsonResponse['academy_data'];
          setState(() {
            _academy = academyJson
                .map((json) => AcademyRespond.fromJson(json))
                .toList();
          });
          print(_academy);
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class AcademyRespond {
  final String? academy_id;
  final String academy_type;
  final String academy_subject;
  final String academy_image;
  final String? academy_category;
  final String academy_date;
  final List<AcademyCoachData> academy_coach_data;
  final int favorite;

  AcademyRespond({
    this.academy_id,
    required this.academy_type,
    required this.academy_subject,
    required this.academy_image,
    this.academy_category,
    required this.academy_date,
    required this.academy_coach_data,
    required this.favorite,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory AcademyRespond.fromJson(Map<String, dynamic> json) {
    return AcademyRespond(
      academy_id: json['academy_id'],
      academy_type: json['academy_type'],
      academy_subject: json['academy_subject'],
      academy_image: json['academy_image'],
      academy_category: json['academy_category'],
      academy_date: json['academy_date'],
      academy_coach_data: (json['academy_coach_data'] as List)
          .map((statusJson) => AcademyCoachData.fromJson(statusJson))
          .toList(),
      favorite: json['favorite'],
    );
  }
  //
  // // การแปลง Object ของ Academy กลับเป็น JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'academy_id': academy_id,
  //     'academy_type': academy_type,
  //     'academy_subject': academy_subject,
  //     'academy_image': academy_image,
  //     'academy_category': academy_category,
  //     'academy_date': academy_date,
  //     'academy_coach_data': academy_coach_data?.map((item) => item.toJson()).toList(),
  //     'favorite': favorite,
  //   };
  // }
}

class AcademyCoachData {
  final String? name;
  final String? avatar;

  AcademyCoachData({
    this.name,
    this.avatar,
  });

  // ฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ AcademyCoachData
  factory AcademyCoachData.fromJson(Map<String, dynamic> json) {
    return AcademyCoachData(
      name: json['name'],
      avatar: json['avatar'],
    );
  }
  //
  // // การแปลง Object ของ AcademyCoachData กลับเป็น JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'avatar': avatar,
  //     'name': name,
  //   };
  // }
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
