import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:origami_ios/chat/line/chat_whats.dart';
import 'package:origami_ios/trandar_shop/shopping_description.dart';
import 'package:origami_ios/trandar_shop/shopping_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import '../language/translate.dart';
import 'card_monny.dart';
import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:url_launcher/url_launcher.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    Key? key,
    required this.employee, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<ItemModel> itemsList = [
    ItemModel(
      productId: '001',
      productName: 'Fried Fish Burger',
      productDescription: 'Served with fries & coleslaw',
      imageProduct:
          'https://taytocafe.com/delivery/assets/products/642da78b9bac1_Double-Tangy-B.png',
      unitPrice: 30,
      addProduct: 0,
      productQuantity: 1,
      totalPrice: 0,
    ),
    ItemModel(
      productId: '002',
      productName: 'Loaded Beef Jalapeno',
      productDescription: '200g Premium beef with jalapeno sauce',
      imageProduct:
          'https://taytocafe.com/delivery/assets/products/642da91abab43_Loaded-Chicken-Jalapeno-B.png',
      unitPrice: 30,
      addProduct: 0,
      productQuantity: 1,
      totalPrice: 0,
    ),
    ItemModel(
      productId: '003',
      productName: 'Crispy Penny Pasta',
      productDescription:
          'Creamy mushroom sauce with three types of bell pepper mushrooms & fried breast fillet',
      imageProduct:
          'https://taytocafe.com/delivery/assets/products/1671690922.png',
      unitPrice: 50,
      addProduct: 0,
      productQuantity: 1,
      totalPrice: 0,
    ),
    ItemModel(
      productId: '004',
      productName: 'Moroccan Fish',
      productDescription:
          "Fried filet of fish served with Moroccan sauce sided by veggies & choice of side",
      imageProduct:
          'https://taytocafe.com/delivery/assets/products/1671691271.png',
      unitPrice: 20,
      addProduct: 0,
      productQuantity: 1,
      totalPrice: 0,
    ),
    ItemModel(
      productId: '005',
      productName: 'Creamy Chipotle',
      productDescription: 'Grilled chicken fillet topped with chipotle sauce',
      imageProduct:
          'https://taytocafe.com/delivery/assets/products/6569bee77d7c2_12.png',
      unitPrice: 40,
      addProduct: 0,
      productQuantity: 1,
      totalPrice: 0,
    ),
    ItemModel(
      productId: '006',
      productName: 'Onion Rings',
      productDescription:
          '10 imported crumbed onion rings served with chilli garlic sauce',
      imageProduct:
          'https://taytocafe.com/delivery/assets/products/1671634436.png',
      unitPrice: 5,
      addProduct: 0,
      productQuantity: 1,
      totalPrice: 0,
    ),
    ItemModel(
      productId: '007',
      productName: 'Pizza Fries',
      productDescription:
          'French fries topped with chicken chunks & pizza sauce with Nachos & cheese',
      imageProduct:
          'https://taytocafe.com/delivery/assets/products/1671634207.png',
      unitPrice: 10,
      addProduct: 0,
      productQuantity: 1,
      totalPrice: 0,
    ),
  ];

  TextEditingController _searchController = TextEditingController();

  // สมมติว่าเรามีอาเรย์ productId ที่อยู่ในตะกร้า
  final List<String> cartProductIds = [];

  void cartIds(String productId, int count) {
    if (count == 1) {
      cartProductIds.add(productId);
    } else {
      cartProductIds.remove(productId);
    }
  }

  String _search = "";
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  int _cartAmount = 0;
  Widget _shoppingCartBadge() {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 0, end: 3),
      badgeAnimation: badges.BadgeAnimation.slide(
        disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
      ),
      badgeStyle: badges.BadgeStyle(
        badgeColor: Colors.red,
      ),
      badgeContent: Text(
        _cartAmount.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShoppingCart(
                itemsList: itemsList,
                cartProductIds: cartProductIds,
              ),
            ),
          );
        },
        icon: Icon(
          Icons.shopping_bag_outlined,
          size: 28,
        ),
      ),
    );
  }

  int addCard = 0;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Shopping',
                style: GoogleFonts.openSans(
                  fontSize: 24,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            actions: [_shoppingCartBadge(), const SizedBox(width: 20.0)],
          ),
          body: Scaffold(
            appBar: AppBar(
              title: TextFormField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                style: GoogleFonts.openSans(
                    color: Color(0xFF555555), fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                      vertical: 12
                  ),
                  hintText: '$Search...',
                  hintStyle: GoogleFonts.openSans(
                      fontSize: 14, color: Color(0xFF555555)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFFF9900),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView.builder(
                    itemCount: itemsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Card(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailScreen(
                                    addItem: (int value) {
                                      setState(() {
                                        _cartAmount +=
                                            value; // บวกค่าที่ส่งกลับมาเข้ากับค่าที่มีอยู่เดิม
                                      });
                                    }, itemsList: itemsList[index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image.network(
                                        itemsList[index]
                                            .imageProduct
                                            .toString(),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              itemsList[index].productName,
                                              style: GoogleFonts.openSans(
                                                fontSize: 18,
                                                color: Color(0xFFFF9900),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              itemsList[index].productDescription,
                                              maxLines: 2,
                                              style: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              r"$" +
                                                  itemsList[index]
                                                      .unitPrice
                                                      .toString(),
                                              style: GoogleFonts.openSans(
                                                  fontSize: 16,
                                                  color: Color(0xFF555555),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {
                                                  int count = 0;
                                                  setState(() {
                                                    count =
                                                        itemsList[index].addProduct;
                                                    if (count == 0) {
                                                      count = 1;
                                                      _cartAmount = _cartAmount + 1;
                                                      cartIds(
                                                          itemsList[index]
                                                              .productId,
                                                          count);
                                                    } else {
                                                      count = 0;
                                                      _cartAmount = _cartAmount - 1;
                                                      if (_cartAmount <= -1) {
                                                        _cartAmount = 0;
                                                      }
                                                      cartIds(
                                                          itemsList[index]
                                                              .productId,
                                                          count);
                                                    }
                                                    itemsList[index].addProduct =
                                                        count;
                                                  });
                                                },
                                                child: (itemsList[index]
                                                            .addProduct ==
                                                        0)
                                                    ? Container(
                                                        height: 30,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.green),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 5),
                                                          child: Center(
                                                            child: Text(
                                                              'Add to cart',
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                      fontSize: 12,
                                                                      color: Color(
                                                                          0xFF555555),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 30,
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                          border: Border.all(
                                                              color: Colors.red),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Remove',
                                                            style: GoogleFonts
                                                                .openSans(
                                                                    fontSize: 12,
                                                                    color: Color(
                                                                        0xFF555555),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemModel {
  String productId;
  String productName;
  String productDescription;
  String imageProduct;
  int unitPrice;
  int addProduct;
  int productQuantity;
  int totalPrice;
  // Constructor
  ItemModel({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.imageProduct,
    required this.unitPrice,
    required this.addProduct,
    required this.productQuantity,
    required this.totalPrice,
  });
}
