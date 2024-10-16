import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:origami_ios/chat/line/chat_whats.dart';
import 'package:origami_ios/trandar_shop/shopping_products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import 'card_monny.dart';
import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:url_launcher/url_launcher.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({
    Key? key,
    required this.itemsList,
    required this.cartProductIds,
  }) : super(key: key);
  final List<ItemModel> itemsList;
  final List<String> cartProductIds;

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<ItemModel> itemsList = [];

// ฟังก์ชันสำหรับกรอง ItemModel
  List<ItemModel> filterItemsInCart(
      List<ItemModel> items, List<String> cartIds) {
    return items.where((item) => cartIds.contains(item.productId)).toList();
  }

  @override
  void initState() {
    super.initState();
    // ฟังก์ชันเพื่อกรองและเพิ่มใน itemsListNew
    itemsList = filterItemsInCart(widget.itemsList, widget.cartProductIds);
    total = itemsList.fold(
        0, (sum, item) => sum + (item.unitPrice * item.productQuantity));
  }

  int _addCard = 0;
  int total = 0;
  List<int> numbers = [];
  void productQuantity(int price, int quantity, int index) {
    int inttotal = (quantity * price);
    numbers.add(inttotal);
    // int sum = numbers.reduce((a, b) => a + b);
    // total = sum.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Cart',
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
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView.builder(
                    itemCount: itemsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Card(
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
                                      itemsList[index].imageProduct.toString(),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 5,
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
                                              color: Colors.orange,
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
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Color(0xFF555555),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _addCard = itemsList[index]
                                                      .productQuantity;
                                                  _addCard = _addCard + 1;

                                                  itemsList[index]
                                                          .productQuantity =
                                                      _addCard;
                                                  int totalPrice =
                                                      itemsList[index]
                                                              .unitPrice *
                                                          itemsList[index]
                                                              .productQuantity;
                                                  itemsList[index].totalPrice =
                                                      totalPrice;
                                                  total = itemsList.fold(
                                                      0,
                                                      (sum, item) =>
                                                          sum +
                                                          item.totalPrice);
                                                });
                                                productQuantity(
                                                    itemsList[index].unitPrice,
                                                    itemsList[index]
                                                        .productQuantity,
                                                    index);
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                color: Color(0xFF555555),
                                              ),
                                            ),
                                            Text(
                                              itemsList[index]
                                                  .productQuantity
                                                  .toString(),
                                              style: GoogleFonts.openSans(
                                                color: Color(0xFF555555),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _addCard = itemsList[index]
                                                      .productQuantity;
                                                  if (itemsList[index]
                                                          .productQuantity >
                                                      1) {
                                                    _addCard = _addCard - 1;
                                                  } else {
                                                    _addCard = 1;
                                                  }
                                                  itemsList[index]
                                                          .productQuantity =
                                                      _addCard;
                                                  int totalPrice =
                                                      itemsList[index]
                                                              .unitPrice *
                                                          itemsList[index]
                                                              .productQuantity;
                                                  itemsList[index].totalPrice =
                                                      totalPrice;
                                                  total = itemsList.fold(
                                                      0,
                                                      (sum, item) =>
                                                          sum +
                                                          item.totalPrice);
                                                });
                                                productQuantity(
                                                    itemsList[index].unitPrice,
                                                    itemsList[index]
                                                        .productQuantity,
                                                    index);
                                              },
                                              icon: Icon(
                                                Icons.remove,
                                                color: Color(0xFF555555),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: Offset(0, -1), // x, y
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.sticky_note_2_outlined,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'coupon',
                                      style: GoogleFonts.openSans(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                              barrierColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20), // กำหนดความโค้งที่ขอบบน
                                ),
                              ),
                              context: context,
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              builder: (BuildContext context) {
                                return _couponItems();
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'select',
                                style: GoogleFonts.openSans(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.navigate_next_outlined,
                                  color: Color(0xFF555555)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Totel',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '฿${total.toDouble()}',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(1),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              // Update
                            });
                          },
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, right: 24),
                              child: Text(
                                'Payment',
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _couponItems() {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Container(),
                Spacer(),
                Text(
                  'Coupon',
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close_sharp,
                    color: Color(0xFF555555),
                  ),
                )
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: List.generate(
                        5,
                        (index) {
                          return Column(
                            children: [
                              SizedBox(height: 8),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(
                                                    '฿',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 18,
                                                      color: Color(0xFF555555),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '5',
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 32,
                                                    color: Color(0xFF555555),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                                  'คูปองส่วนลด',
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 18,
                                                    color: Colors.orange,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  'เฉพาะสินค้าที่เข้าร่วมรายการ',
                                                  maxLines: 2,
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'ใช้งานได้ถึงวันที่ 31 ธ.ค., 11:59PM',
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 12,
                                                      color: Color(0xFF555555),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Color(0xFF555555),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8,right: 8),
                                              child: Text(
                                                'T&C',
                                                style: GoogleFonts.openSans(
                                                  fontSize: 12,
                                                  color: Color(0xFF555555),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
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
                  onPressed: () => Navigator.pop(context),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Text(
                        'Confirm',
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
        ),
      ),
    );
  }
}
