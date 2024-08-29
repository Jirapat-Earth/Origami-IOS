import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import '../language/translate.dart';

class TrandarShop extends StatefulWidget {
  TrandarShop({super.key, });

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
        title: Text("Trandar Shop"),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
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
                  onChanged: (value) {},
                ),
              ),
              SizedBox(height: 16,),
              CarouselSlider.builder(
                controller: _controller,
                itemCount: 5,
                itemBuilder: (context, index, realIndex) {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.orange.shade300,
                          width: 1.0,
                        ),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                              "https://onlyflutter.com/wp-content/uploads/2024/03/flutter_banner_onlyflutter.png")),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.64,
                  autoPlay: false,
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
            ],
          ),
          // Column(
          //   children: List.generate(2, (index) {
          //     return Container();
          //   }),
          // ),
        ),
      ),
    );
  }
}

