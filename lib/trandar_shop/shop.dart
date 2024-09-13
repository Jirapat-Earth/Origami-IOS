import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:google_fonts/google_fonts.dart';
import '../language/translate.dart';
import 'card_monny.dart';
import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:url_launcher/url_launcher.dart';

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

  void _launchWhatsApp() async {
    const url = 'https://wa.me/0656257183'; // แทนที่ด้วยหมายเลขโทรศัพท์ของคุณ
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
        title: Text('Chairs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _launchWhatsApp();
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailScreen(
                      addItem: (int value) {
                        setState(() {
                          _cartBadgeAmount +=
                              value; // บวกค่าที่ส่งกลับมาเข้ากับค่าที่มีอยู่เดิม
                        });
                      },
                    ),
                  ),
                );
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

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({Key? key, required this.addItem}) : super(key: key);
  final Function(int) addItem;
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int addCard = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item\'s Name'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.grey.shade50,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Image.network(
                  'https://www.iconic-office.com/wp-content/uploads/2022/08/%E0%B9%80%E0%B8%81%E0%B9%89%E0%B8%B2%E0%B8%AD%E0%B8%B5%E0%B9%89%E0%B8%97%E0%B8%B3%E0%B8%87%E0%B8%B2%E0%B8%99-%E0%B8%A3%E0%B8%B8%E0%B9%88%E0%B8%99-OC201-Side.jpg',
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'V-OC201',
                        style: GoogleFonts.openSans(
                          fontSize: 22,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '฿ 25',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: Color(0xFF555555),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Choose Color
                      Row(
                        children: [
                          Text('Choose Color:'),
                          // Add Color Circles
                          _buildColorOption(Colors.blue),
                          _buildColorOption(Colors.pink),
                          _buildColorOption(Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  addCard = addCard + 1;
                  widget.addItem(addCard);
                });
                Navigator.pop(context);
              },
              child: Text('+ Add to cart'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addRemoveCartButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton.icon(
              onPressed: () => setState(() {
                    addCard = addCard + 1;
                    widget.addItem(addCard);
                  }),
              icon: Icon(Icons.add),
              label: Text('Add to cart')),
          // ElevatedButton.icon(
          //     onPressed: () => setState(() {
          //       if (_cartBadgeAmount != 0) {
          //         _cartBadgeAmount--;
          //       }
          //       // color = Colors.blue;
          //     }),
          //     icon: Icon(Icons.remove),
          //     label: Text('Remove from cart')),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 30,
      height: 30,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
