import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:origami_ios/trandar_shop/shopping_products.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:google_fonts/google_fonts.dart';
import '../language/translate.dart';
import 'card_monny.dart';
import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:url_launcher/url_launcher.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen(
      {Key? key, required this.addItem, required this.itemsList})
      : super(key: key);
  final Function(int) addItem;
  final ItemModel itemsList;

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController _questionController = TextEditingController();
  int addCard = 0;
  ItemModel? items;
  String _question = "";
  @override
  void initState() {
    super.initState();
    items = widget.itemsList;
    _questionController.addListener(() {
      _question = _questionController.text;
      print("Current text: ${_questionController.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          items!.productName,
          style: GoogleFonts.openSans(
            fontSize: 22,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.grey.shade50,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(items!.imageProduct),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '฿ ',
                              style: GoogleFonts.openSans(
                                fontSize: 32,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${items!.unitPrice}',
                              style: GoogleFonts.openSans(
                                fontSize: 64,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment:Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4,bottom: 4,left: 8,right: 8),
                              child: Text(
                                'คูปองส่วนลด ฿1.25',
                                style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: 'Description: ',
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '${items!.productDescription}',
                                style: GoogleFonts.openSans(
                                  // fontSize: 16,
                                  color: Color(0xFF555555),
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                          ),
                        ),
                  
                        SizedBox(height: 18),
                        // Choose Color
                        Row(
                          children: [
                            Text(
                              'Choose Size: ',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                color: Color(0xFF555555),
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Add Color Circles
                            _buildColorOption(Colors.blue,"S"),
                            _buildColorOption(Colors.green,"M"),
                            _buildColorOption(Colors.redAccent,"L"),
                            _buildColorOption(Colors.amber,"XL"),
                          ],
                        ),
                        SizedBox(height: 18),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Question: ',
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xFF555555),
                              width: 1.0,
                            ),
                          ),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.text,
                            controller: _questionController,
                            style: GoogleFonts.openSans(
                                color: const Color(0xFF555555), fontSize: 14),
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '',
                              hintStyle: GoogleFonts.openSans(
                                  fontSize: 14, color: const Color(0xFF555555)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF555555)),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(1),
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                setState(() {
                  addCard = addCard + 1;
                  widget.addItem(addCard);
                });
                Navigator.pop(context);
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Text(
                    'Add to cart',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, String size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          size,
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<String> title = [
    "Kitchen",
    "Bedroom",
    "Hallway",
    "Living Room",
    "Kitchen",
    "Bedroom",
    "Hallway"
  ];

  void _launchWhatsApp() async {
    const url = 'https://wa.me/0947428943';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Trandar Shop',
          style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555)),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              SizedBox(
                width: 18,
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Scaffold(
        appBar: AppBar(
          title: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.orange,
                width: 1.0,
              ),
            ),
            child: TextField(
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
                  color: Colors.orange,
                ),
                border: InputBorder.none,
                suffixIcon: Container(
                  alignment: Alignment.centerRight,
                  width: 10,
                  child: Center(
                    child: IconButton(
                        onPressed: () {
                          // _searchController.clear();
                        },
                        icon: Icon(Icons.close),
                        color: Colors.orange,
                        iconSize: 18),
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                    // border: Border.all(
                    //   color: Colors.orange.shade100,
                    //   width: 1.0,
                    // ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: List.generate(title.length, (index) {
                        return _buildCategoryTab(title[index], context, index);
                      }),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Column(children: [
                  SizedBox(
                    height: 16,
                  ),
                  _buildPopularCategories(),
                  _buildNewItems(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int selectedIndex = 0;
  Widget _buildCategoryTab(String title, BuildContext context, int index) {
    return InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: (selectedIndex == index)
                    ? Colors.orange
                    : Colors.orange.shade200),
          ),
        ));
  }

  Widget _buildPopularCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(
                'Popular Categories',
                style: GoogleFonts.openSans(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                'See all',
                style: GoogleFonts.openSans(fontSize: 14),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(title.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateQuoteScreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundImage: NetworkImage(
                            'https://www.iconic-office.com/wp-content/uploads/2022/08/%E0%B9%80%E0%B8%81%E0%B9%89%E0%B8%B2%E0%B8%AD%E0%B8%B5%E0%B9%89%E0%B8%97%E0%B8%B3%E0%B8%87%E0%B8%B2%E0%B8%99-%E0%B8%A3%E0%B8%B8%E0%B9%88%E0%B8%99-OC201-Side.jpg'),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'V-OC201',
                        style: GoogleFonts.openSans(
                            fontSize: 14, color: Color(0xFF555555)),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _buildNewItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'New items',
            style:
                GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(title.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryItemsScreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://www.iconic-office.com/wp-content/uploads/2022/08/%E0%B9%80%E0%B8%81%E0%B9%89%E0%B8%B2%E0%B8%AD%E0%B8%B5%E0%B9%89%E0%B8%97%E0%B8%B3%E0%B8%87%E0%B8%B2%E0%B8%99-%E0%B8%A3%E0%B8%B8%E0%B9%88%E0%B8%99-OC201-Side.jpg',
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'V-OC201',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Color(0xFF555555),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '฿ 25',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class CategoryItemsScreen extends StatefulWidget {
  @override
  _CategoryItemsScreenState createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  int _cartBadgeAmount = 0;
  // bool _showCartBadge = true;
  Color color = Colors.red;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chairs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // _launchWhatsApp();
          },
        ),
        actions: [
          _shoppingCartBadge(),
          // IconButton(
          //   icon: Icon(Icons.filter_list),
          //   onPressed: () {},
          // ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ItemDetailScreen(
                //       addItem: (int value) {
                //         setState(() {
                //           _cartBadgeAmount +=
                //               value; // บวกค่าที่ส่งกลับมาเข้ากับค่าที่มีอยู่เดิม
                //         });
                //       },
                //     ),
                //   ),
                // );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ItemDetailScreen(
                //       addItem: (int value) {
                //         setState(() {
                //           _cartBadgeAmount = value;
                //         });
                //         return _cartBadgeAmount;
                //       },
                //     ),
                //   ),
                // );
              },
              child: IntrinsicHeight(
                child: Card(
                  child: Column(
                    children: [
                      Image.network(
                        'https://www.iconic-office.com/wp-content/uploads/2022/08/%E0%B9%80%E0%B8%81%E0%B9%89%E0%B8%B2%E0%B8%AD%E0%B8%B5%E0%B9%89%E0%B8%97%E0%B8%B3%E0%B8%87%E0%B8%B2%E0%B8%99-%E0%B8%A3%E0%B8%B8%E0%B9%88%E0%B8%99-OC201-Side.jpg',
                      ),
                      Text(
                        'V-OC201',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Color(0xFF555555),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '฿ 25',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: 10, // Replace with your item count
          padding: EdgeInsets.all(8.0),
          shrinkWrap: true, // ปรับให้ GridView ไม่เต็มความสูงทั้งหมด
          // physics: NeverScrollableScrollPhysics(), // ปิดการ scroll ของ GridView ถ้าต้องการ
        ),
      ),
    );
  }

  Widget _shoppingCartBadge() {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 0, end: 3),
      badgeAnimation: badges.BadgeAnimation.slide(
        disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
      ),
      // showBadge: _showCartBadge,
      badgeStyle: badges.BadgeStyle(
        badgeColor: Colors.red,
      ),
      badgeContent: Text(
        _cartBadgeAmount.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
    );
  }
}
