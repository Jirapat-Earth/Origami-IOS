import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../language/translate.dart';

class TrandarShop extends StatefulWidget {
  TrandarShop({
    super.key,
  });

  @override
  _TrandarShopState createState() => _TrandarShopState();
}

class _TrandarShopState extends State<TrandarShop> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      // ฟังก์ชันนี้จะถูกเรียกทุกครั้งเมื่อข้อความใน _searchController เปลี่ยนแปลง
      print("Current text: ${_searchController.text}");
    });
  }

  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Trandar Shop",
          style: GoogleFonts.openSans(
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        leading: IconButton(
          icon: Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAoLaToxHhMZr63aa4WcVfi5jibLRCiLjs4uYC-KpbaAxme7AjxfWOK8g1Xi33qp977LY&usqp=CAU',
            fit: BoxFit.fill,
          ),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Color(0xFFFF9900),
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '$Search...',
                    hintStyle: GoogleFonts.openSans(
                      color: Color(0xFF555555),
                    ),
                    labelStyle: GoogleFonts.openSans(
                      color: Color(0xFF555555),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFFFF9900),
                    ),
                    border: InputBorder.none,
                    suffixIcon: Container(
                      alignment: Alignment.centerRight,
                      width: 10,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              _searchController.clear();
                            },
                            icon: Icon(Icons.close),
                            color: Color(0xFFFF9900),
                            iconSize: 18),
                      ),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Trandar Shop",
                style: GoogleFonts.openSans(
                  color: Color(0xFF555555),
                ),
              ),
              CarouselSlider.builder(
                controller: _controller,
                itemCount: 5,
                itemBuilder: (context, index, realIndex) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                          "https://onlyflutter.com/wp-content/uploads/2024/03/flutter_banner_onlyflutter.png"));
                },
                options: CarouselOptions(
                  // height: MediaQuery.of(context).size.height * 0.64,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: _currentIndex,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item',
                            style: GoogleFonts.openSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 9, // Number of items to display
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      'https://www.thaihealth.or.th/data/content/26220/cms/e_bcdijkluwyz2.jpg'),
                                  backgroundColor: Colors.transparent,
                                ),
                              );
                            },
                          )
                        ]),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: GoogleFonts.openSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 9, // Number of items to display
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    child: Image.network(
                                      'https://www.thaihealth.or.th/data/content/26220/cms/e_bcdijkluwyz2.jpg',
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // ClipRRect(
                                  //   borderRadius: RenderClipRRect(
                                  //     borderRadius: ,
                                  //     clipper: clipper,
                                  //     clipBehavior: clipBehavior,
                                  //     textDirection: Directionality.maybeOf(context),
                                  //   ),
                                  //   child: Image.network(
                                  //     'https://www.thaihealth.or.th/data/content/26220/cms/e_bcdijkluwyz2.jpg',
                                  //     // height: 120,
                                  //     width: 150,
                                  //   ),
                                  // ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                        BorderRadius.circular(
                                            10),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Categories',
                                              style: GoogleFonts.openSans(
                                                  // fontSize: 16,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: List.generate(
                        //       9,
                        //       (index) {
                        //         // double drawerWidth = MediaQuery.of(context).size.width * 1;
                        //         return Padding(
                        //           padding: const EdgeInsets.only(right: 8),
                        //           child: Stack(
                        //             children: [
                        //               ClipRRect(
                        //                 borderRadius: BorderRadius.circular(10),
                        //                 child: Image.network(
                        //                   'https://www.thaihealth.or.th/data/content/26220/cms/e_bcdijkluwyz2.jpg',
                        //                   // height: 120,
                        //                   width: 150,
                        //                 ),
                        //               ),
                        //               Positioned(
                        //                 bottom: 0,
                        //                 child: Container(
                        //                   decoration: BoxDecoration(
                        //                     color: Colors.black,
                        //                     // border: Border.all(color: Color(0xFFFF9900)),
                        //                     borderRadius:
                        //                         BorderRadius.circular(8),
                        //                   ),
                        //                   width: 150,
                        //                   padding: EdgeInsets.only(
                        //                       top: 8, bottom: 8),
                        //                   child: Center(
                        //                     child: Text(
                        //                       'Categories',
                        //                       style: GoogleFonts.openSans(
                        //                           fontSize: 16,
                        //                           fontWeight: FontWeight.bold,
                        //                           color: Colors.white),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    color: Colors.grey,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Suggested products',
                          style: GoogleFonts.openSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        // TextButton(
                        //   Text('View all',style: GoogleFonts.openSans(fontSize: 16,),)
                        //
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Item Details',
                              style: GoogleFonts.openSans(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children: List.generate(
                                50,
                                (index) {
                                  // double drawerWidth = MediaQuery.of(context).size.width * 1;
                                  return Card(
                                    elevation: 2,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    'https://www.thaihealth.or.th/data/content/26220/cms/e_bcdijkluwyz2.jpg',
                                                    // height: 120,
                                                    width: 100,
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
                                                      'Item ${index + 1}',
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      'Details',
                                                      style:
                                                          GoogleFonts.openSans(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.mark_chat_read,
                                              size: 30,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        // Column(
        //   children: List.generate(2, (index) {
        //     return Container();
        //   }),
        // ),
      ),
    );
  }
}
