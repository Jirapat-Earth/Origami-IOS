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
  var _isDesktop;
  var _isMobile;
  String _searchA = '';
  String _comment = '';

  @override
  void initState() {
    super.initState();
    fetchAcademies();
    _searchController.addListener(() {
      _searchA = _searchController.text;
      print("Current text: ${_searchController.text}");
      fetchAcademies();
    });
    _commentController.addListener(() {
      _comment = _commentController.text;
      print("Current text: ${_commentController.text}");
    });
    // fetchAcademy();
  }

  void _showDialogA() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.file_copy_outlined),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Enroll form',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF555555),
                    width: 1.0,
                  ),
                ),
                child: TextFormField(
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  controller: _commentController,
                  style: GoogleFonts.openSans(
                      color: const Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '$Request_reason...',
                    hintStyle: GoogleFonts.openSans(
                        fontSize: 14, color: const Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          content: InkWell(
            onTap: () {},
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'History request',
                  style: GoogleFonts.openSans(
                    decoration: TextDecoration.underline,
                    // fontWeight: FontWeight.bold,
                    // color: Color(0xFF555555),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '$Cancel',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF555555),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Enroll',
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
  }

  void _showDialogB() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.file_copy_outlined),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Enroll form',
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF555555),
                      width: 1.0,
                    ),
                  ),
                  child: Text("No data available in table",
                    style: GoogleFonts.openSans(
                      decoration: TextDecoration.underline,
                      // fontWeight: FontWeight.bold,
                      color: Color(0xFF555555),
                    ),),
                ),
              ],
            ),
          ),
          content: InkWell(
            onTap: () {},
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'History request',
                  style: GoogleFonts.openSans(
                    decoration: TextDecoration.underline,
                    // fontWeight: FontWeight.bold,
                    // color: Color(0xFF555555),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '$Cancel',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF555555),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Enroll',
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
  }

  Future<List<AcademyRespond>> fetchAcademies() async {
    final uri =
        Uri.parse("https://www.origami.life/api/origami/academy/course.php");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'pages': page,
        'search': _searchA,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'academy_data'
      final List<dynamic> academiesJson = jsonResponse['academy_data'];
      // แปลงข้อมูลจาก JSON เป็น List<AcademyRespond>
      return academiesJson
          .map((json) => AcademyRespond.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load academies');
    }
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
      fetchAcademies();
    });
  }

  // Future<void> _refreshData() async {
  //   // Call the fetchAcademies() function to refresh the data
  //
  //   await Future.delayed(
  //     const Duration(seconds:1),
  //   );
  //   setState(() {fetchAcademies();});
  // }

  Widget loading() {
    return FutureBuilder<List<AcademyRespond>>(
      future: fetchAcademies(),
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
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No academies found'));
        } else {
          return condition(snapshot.data!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading(),
      bottomNavigationBar: BottomBarInspiredInside(
        items: [
          const TabItem(
            icon: Icons.account_balance,
            title: 'My Learning',
          ),
          const TabItem(
            icon: Icons.star_border_purple500_rounded,
            title: 'My Challenge',
          ),
          const TabItem(
            icon: Icons.list_alt,
            title: 'Catalog',
          ),
          const TabItem(
            icon: Icons.favorite,
            title: 'Favorite',
          ),
          const TabItem(
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

  Widget condition(List<AcademyRespond> _academy) {
    // Determine the screen size
    double screenSize = MediaQuery.of(context).size.shortestSide;
    // Define a threshold to distinguish between mobile and desktop
    _isDesktop = screenSize <= 900;
    _isMobile = screenSize <= 600;
    if (screenSize <= 600) {
      _isMobile == true;
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    return SafeArea(child: _Learning(_isMobile, _isDesktop, _academy));
  }

  bool _isMenu = false;
  bool _isFavorite = false;

  Widget _Learning(_isMobile, _isDesktop, List<AcademyRespond> _academy) {
    return (_academy.length != 0)
        ? SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
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
                                color: const Color(0xFF555555),
                              ),
                              labelStyle: GoogleFonts.openSans(
                                color: const Color(0xFF555555),
                              ),
                              prefixIcon: const Icon(
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
                                      icon: const Icon(Icons.close),
                                      color: Colors.orange,
                                      iconSize: 16),
                                ),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            (_isMenu == false)
                                ? _isMenu = true
                                : _isMenu = false;
                          });
                        },
                        icon: Container(
                            // padding: EdgeInsets.only(right: 8),
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              Icons.filter_list,
                              size: 36,
                            )),
                      ),
                    ],
                  ),
                ),
                (_isMenu == true)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: List.generate(_academy.length, (indexI) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EvaluateModule(
                                              employee: widget.employee,
                                              academy: _academy[indexI], callback: () {
                                              favorite(
                                                  _academy[indexI]
                                                      .academy_id,
                                                  _academy[indexI]
                                                      .academy_type
                                              );
                                            },

                                            )),
                                      );
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                '${_academy[indexI].academy_image}',
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _academy[indexI]
                                                      .academy_subject,
                                                  style: GoogleFonts.openSans(
                                                    color:
                                                        const Color(0xFF555555),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                (_academy[indexI]
                                                            .academy_date ==
                                                        "Time Out")
                                                    ? Text(
                                                        _academy[indexI]
                                                            .academy_date,
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color: Colors.red,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )
                                                    : Text(
                                                        '$Start : ${_academy[indexI].academy_date}',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color: const Color(
                                                              0xFF555555),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Divider()
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
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
                        itemCount: _academy.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (_academy[index].favorite == 0) {
                            _isFavorite = true;
                          } else {
                            _isFavorite =
                                false; // _academy[index].favorite = 0;
                          }
                          return InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EvaluateModule(
                                        employee: widget.employee,
                                        academy: _academy[index],
                                        callback: () {
                                          favorite(
                                              _academy[index]
                                                  .academy_id,
                                              _academy[index]
                                                  .academy_type
                                          );
                                        },
                                      )),
                                );
                              });
                            },
                            child: Card(
                              // elevation: 0,
                              color: Color(0xFFF5F5F5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 2,
                                      offset: Offset(0, 3), // x, y
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Card(
                                            elevation: 0,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                '${_academy[index].academy_image}',
                                                width: double.infinity,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Text(
                                                        _academy[index]
                                                            .academy_category,
                                                        style: GoogleFonts
                                                            .openSans(
                                                          fontSize: 12.0,
                                                          color: Colors.white,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 4,
                                            left: 4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Text(
                                                  _academy[index].academy_type,
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _academy[index].academy_subject ??
                                                '',
                                            style: GoogleFonts.openSans(
                                              fontSize: 16.0,
                                              color: const Color(0xFF555555),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(
                                                _academy[index]
                                                    .academy_coach_data
                                                    .length, (indexII) {
                                              final coach_data = _academy[index]
                                                  .academy_coach_data;
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Image.network(
                                                            '${coach_data?[indexII].avatar ?? ''}',
                                                            height: 40,
                                                            width: 40,
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            (coach_data[indexII]
                                                                        .name ==
                                                                    '')
                                                                ? ""
                                                                : coach_data[
                                                                        indexII]
                                                                    .name,
                                                            style: GoogleFonts
                                                                .openSans(
                                                              color: const Color(
                                                                  0xFF555555),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                      (_selectedIndex == 0)
                                          ? Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: (_academy[index]
                                                                .academy_date ==
                                                            "Time Out")
                                                        ? Text(
                                                            '${_academy[index].academy_date ?? ''}',
                                                            style: GoogleFonts
                                                                .openSans(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        : Text(
                                                            '$Start : ${_academy[index].academy_date ?? ''}',
                                                            style: GoogleFonts
                                                                .openSans(
                                                              color: const Color(
                                                                  0xFF555555),
                                                            ),
                                                          ),
                                                  ),
                                                  (_academy[index]
                                                              .academy_date ==
                                                          "Time Out")
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0),
                                                          child: InkWell(
                                                            onTap: _showDialogA,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                // border: Border.all(color: Colors.grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(6),
                                                                child: Text(
                                                                  '$Enroll',
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              (_isFavorite ==
                                                                      true)
                                                                  ? _isFavorite =
                                                                      false
                                                                  : _isFavorite =
                                                                      true;
                                                            });
                                                            favorite(
                                                                _academy[index]
                                                                    .academy_id,
                                                                _academy[index]
                                                                    .academy_type);
                                                          },
                                                          icon: Icon(
                                                              Icons.favorite,
                                                              color:
                                                                  (_isFavorite ==
                                                                          true)
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .red),
                                                        )
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: _showDialogA,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.green,
                                                            // border: Border.all(color: Colors.grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            child: Text(
                                                              '$Enroll',
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            (_isFavorite ==
                                                                    true)
                                                                ? _isFavorite =
                                                                    false
                                                                : _isFavorite =
                                                                    true;
                                                          });
                                                          favorite(
                                                              _academy[index]
                                                                  .academy_id,
                                                              _academy[index]
                                                                  .academy_type);
                                                        },
                                                        icon: Icon(
                                                            Icons.favorite,
                                                            color:
                                                                (_isFavorite ==
                                                                        true)
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .red),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
              ],
            ),
          )
        : Container(
            alignment: Alignment.center,
            child: Text(
              'NOT FOUND COURSE',
              style: GoogleFonts.openSans(
                fontSize: 16.0,
                color: const Color(0xFF555555),
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
  }



  // bool isPlan = false;
  // Future<void> fetchIDPlan(
  //     String academyId, String academyType, AcademyRespond academy) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://www.origami.life/api/origami/academy/favorite.php'),
  //       body: {
  //         'comp_id': widget.employee.comp_id,
  //         'emp_id': widget.employee.emp_id,
  //         'academy_id': academyId,
  //         'academy_type': academyType,
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == true) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => EvaluateModule(
  //                     id: '5',
  //                     employee: widget.employee,
  //                     academy: academy,
  //                   )),
  //         );
  //       } else {
  //         isPlan = false;
  //       }
  //     } else {
  //       throw Exception(
  //           'Failed to load personal data: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load personal data: $e');
  //   }
  // }

  Future<void> favorite(
      String academyId,
      String academyType,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('https://www.origami.life/api/origami/academy/favorite.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'academy_id': academyId,
          'academy_type': academyType,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          print("message: true");
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
  final String academy_id;
  final String academy_type;
  final String academy_subject;
  final String academy_image;
  final String academy_category;
  final String academy_date;
  final List<AcademyCoachData> academy_coach_data;
  final int favorite;

  AcademyRespond({
    required this.academy_id,
    required this.academy_type,
    required this.academy_subject,
    required this.academy_image,
    required this.academy_category,
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

  // การแปลง Object ของ Academy กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'academy_id': academy_id,
      'academy_type': academy_type,
      'academy_subject': academy_subject,
      'academy_image': academy_image,
      'academy_category': academy_category,
      'academy_date': academy_date,
      'academy_coach_data':
          academy_coach_data?.map((item) => item.toJson()).toList(),
      'favorite': favorite,
    };
  }
}

class AcademyCoachData {
  final String name;
  final String avatar;

  AcademyCoachData({
    required this.name,
    required this.avatar,
  });

  // ฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ AcademyCoachData
  factory AcademyCoachData.fromJson(Map<String, dynamic> json) {
    return AcademyCoachData(
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  // การแปลง Object ของ AcademyCoachData กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
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
