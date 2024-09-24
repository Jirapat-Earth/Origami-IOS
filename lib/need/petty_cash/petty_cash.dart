import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../language/translate.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../login/login.dart';
import '../need_view/need_detail.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PettyCash extends StatefulWidget {
  PettyCash({
    super.key,
    required this.employee,
  });
  final Employee employee;

  @override
  _PettyCashState createState() => _PettyCashState();
}

class _PettyCashState extends State<PettyCash> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _detailyController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  double usedColorPercentage = 0.75; // เริ่มต้นที่ 75% ใช้ไปแล้ว
  bool isSave = true;

  @override
  void initState() {
    super.initState();
    fetchStatus();
    fetchUnit();
    fetchItem();
    _searchController.addListener(() {
      // ฟังก์ชันนี้จะถูกเรียกทุกครั้งเมื่อข้อความใน _searchController เปลี่ยนแปลง
      // item_name = _searchController.text;
      // fetchItem();
      print("Current text: ${_searchController.text}");
    });
    _detailyController.addListener(() {
      use_detail = _detailyController.text;
      print("Current text: ${_detailyController.text}");
    });
    _quantityController.addListener(() {
      quantity = _quantityController.text;
      print("Current text: ${_quantityController.text}");
    });
    _priceController.addListener(() {
      price = _priceController.text;
      print("Current text: ${_priceController.text}");
    });
    _amountController.addListener(() {
      print("Current text: ${_amountController.text}");
    });
    _subjectController.addListener(() {
      need_subject = _subjectController.text;
      print("Current text: ${_subjectController.text}");
    });
    _descriptionController.addListener(() {
      need_description = _descriptionController.text;
      print("Current text: ${_descriptionController.text}");
    });
  }

  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;
  String startDate = '';
  void _startTime(CashData cashData) {
    String cashStart = cashData.cash_start;
    if (cashStart == null || cashStart.isEmpty) {
      print('No date provided'); // หรือจัดการกับกรณีค่าว่างที่นี่
    } else {
      try {
        // แปลง string เป็น DateTime
        DateTime date = DateFormat('yyyy/MM/dd').parse(cashStart);

        // ใช้วันที่ 24 ของเดือนและปีจากวันที่ที่ระบุ
        DateTime updatedDate = DateTime(date.year, date.month, 24);

        // แปลง DateTime เป็น string รูปแบบใหม่
        startDate = DateFormat('dd/MM').format(updatedDate);

        print(startDate); // ผลลัพธ์: 24/09
      } catch (e) {
        print(
            'Error parsing date: $e'); // จัดการกับข้อผิดพลาดการแปลงวันที่ที่อาจเกิดขึ้น
      }
    }
  }

  String endDate = '';
  void _endTime(CashData cashData) {
    String cashEnd = cashData.cash_end;
    if (cashEnd == null || cashEnd.isEmpty) {
      print('No date provided'); // หรือจัดการกับกรณีค่าว่างที่นี่
    } else {
      try {
        // แปลง string เป็น DateTime
        DateTime date = DateFormat('yyyy/MM/dd').parse(cashEnd);

        // ใช้วันที่ 24 ของเดือนและปีจากวันที่ที่ระบุ
        DateTime updatedDate = DateTime(date.year, date.month, 24);

        // แปลง DateTime เป็น string รูปแบบใหม่
        endDate = DateFormat('dd/MM').format(updatedDate);

        print(endDate); // ผลลัพธ์: 24/09
      } catch (e) {
        print(
            'Error parsing date: $e'); // จัดการกับข้อผิดพลาดการแปลงวันที่ที่อาจเกิดขึ้น
      }
    }
  }

  double longAmount = 0.0;
  double longBalance = 0.0;

  void _sumLong(CashData cashData) {
    double amount = double.parse(cashData.cash_amount.replaceAll(',', ''));
    double balance = double.parse(cashData.cash_balance.replaceAll(',', ''));
    longAmount = (balance * 100) / amount;
    longBalance = longAmount / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: (isSave != false)
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  used_id = '';
                  _detailyController.clear();
                  _quantityController.clear();
                  _priceController.clear();
                  _amountController.clear();
                  isSave = false;
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                  topLeft: Radius.circular(100),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.orange,
            )
          : Container(),
      body: loading(),
    );
  }

  Widget loading() {
    return FutureBuilder<List<CashData>>(
      future: fetchCash(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: GoogleFonts.openSans(
              color: const Color(0xFF555555),
            ),
          ));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        } else {
          return _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Widget _getContentWidget(List<CashData> cashData) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                controller: _controller,
                itemCount: cashData.length,
                itemBuilder: (context, index, realIndex) {
                  return _mainPerryCash(cashData[index]);
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 1.1,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: true,
                  enableInfiniteScroll:
                      false, // false ปิดใช้งานการเลื่อนที่ไม่สิ้นสุด
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
            ),
            (isSave != false) ? Container() : _elevatedButton(),
          ],
        ),
      ),
    );
  }

  bool expense = false;
  Widget _mainPerryCash(CashData cashData) {
    _startTime(cashData);
    _endTime(cashData);
    _sumLong(cashData);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          // color:Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.green
                            ], // สีเริ่มต้นและสิ้นสุด
                            begin:
                                Alignment.topLeft, // จุดเริ่มต้นของการไล่ระดับ
                            end: Alignment
                                .bottomRight, // จุดสิ้นสุดของการไล่ระดับ
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Opacity(
                            opacity: 0.6,
                            child: Image.network(
                              "https://www.shutterstock.com/image-vector/cashback-icon-credit-card-isolated-600nw-2455671009.jpg",
                              width: constraints.maxWidth,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cashData.cash_no,
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Start ${startDate}',
                                      style: GoogleFonts.openSans(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    if (endDate != '')
                                      Text(
                                        'End ${endDate}',
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  cashData.cash_name,
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  cashData.cash_amount,
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Balance',
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            cashData.cash_balance,
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      // Background LinearProgressIndicator (สีเทา)
                      LinearProgressIndicator(
                        value: 1.0, // ให้ความยาวเต็มเพื่อใช้เป็นพื้นหลัง
                        backgroundColor: Colors.grey.shade300,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                        minHeight: 10,
                      ),
                      // Foreground LinearProgressIndicator (ใช้ ShaderMask สำหรับไล่ระดับสี)
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.orange, Colors.orange.shade200],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: LinearProgressIndicator(
                          value: longBalance, // ค่าความคืบหน้า
                          backgroundColor:
                              Colors.transparent, // ไม่ใช้พื้นหลังเพิ่มเติม
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white), // สีชั่วคราว
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isSave == true)
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      (isSave != false && expense == false)
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  expense = true;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  'Expense',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  expense = false;
                                  selectedIds = [];
                                  _subjectController.clear();
                                });
                              },
                              icon: Icon(Icons.arrow_back_ios_sharp)),
                      Spacer(),
                      Container(
                        height: 45,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.orange,
                            width: 1.0,
                          ),
                        ),
                        child: DropdownButton2<StatusCash>(
                          isExpanded: true,
                          hint: Text(
                            'Select Status',
                            style: GoogleFonts.openSans(
                              color: Color(0xFF555555),
                            ),
                          ),
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                          items: statusList
                              .map((status) => DropdownMenuItem<StatusCash>(
                                    value: status,
                                    child: Container(
                                      child: Text(
                                        status.status_name,
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedStatus,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value as StatusCash?;
                              status_id = value?.status_id ?? '';
                              fetchUsed();
                            });
                          },
                          underline: SizedBox.shrink(),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.black, size: 30),
                            iconSize: 30,
                          ),
                          buttonStyleData: ButtonStyleData(
                            height: 40,
                            width: 120,
                          ),
                          // กำหนดคุณสมบัติ dropdown ให้แสดงได้สูงสุด 5 บรรทัด
                          dropdownStyleData: DropdownStyleData(
                            maxHeight:
                                200, // ความสูงสำหรับ 5 บรรทัด (ปรับค่าได้ตามต้องการ)
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: 40, // ความสูงของแต่ละรายการ
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _searchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: _searchController,
                                keyboardType: TextInputType.text,
                                style: GoogleFonts.openSans(
                                    color: Color(0xFF555555), fontSize: 14),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: '$Search...',
                                  hintStyle: GoogleFonts.openSans(
                                      fontSize: 14, color: Color(0xFF555555)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value!.status_name
                                  .toLowerCase()
                                  .contains(searchValue.toLowerCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              _searchController
                                  .clear(); // Clear the search field when the menu closes
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: (isSave != false && expense == false)
              ? _tableExpense(cashData)
              : (isSave != false && expense == true)
                  ? Container(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 8, right: 16, left: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _dataTable(cashData),
                    )
                  : Container(
            padding: EdgeInsets.only(
                top: 8, bottom: 8,),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
            ),
              child: _editCashTable(),
          ),
        ),
      ],
    );
  }

  List<String> selectedIds = []; // รายการ used_id ที่เลือก
  List<String> expense_used_id = [];
  void _onCheckboxChanged(String usedId, bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        selectedIds.add(usedId); // เพิ่ม used_id ลงในรายการเมื่อเลือก
      } else {
        selectedIds.remove(usedId); // ลบ used_id เมื่อไม่เลือก
      }
      print(selectedIds);
    });
  }

  Widget _dataTable(CashData cashData) {
    return FutureBuilder<List<UsedData>>(
        future: fetchUsed(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.openSans(
                color: const Color(0xFF555555),
              ),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              Empty,
              style: GoogleFonts.openSans(
                color: const Color(0xFF555555),
              ),
            ));
          } else {
            return Column(
              children: [
                Expanded(
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Select',
                            style: GoogleFonts.openSans(
                              color: const Color(0xFF555555),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Item Name',
                            style: GoogleFonts.openSans(
                              color: const Color(0xFF555555),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Amount',
                            style: GoogleFonts.openSans(
                              color: const Color(0xFF555555),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // เพิ่มคอลัมน์เพิ่มเติมตามต้องการ
                    ],
                    rows: snapshot.data!
                        .where((item) => item.can_action == "Y")
                        .map<DataRow>((item) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Checkbox(
                              value: selectedIds.contains(item.used_id),
                              onChanged: (bool? isChecked) {
                                _onCheckboxChanged(item.used_id, isChecked);
                                print(selectedIds);
                              },
                              activeColor: Colors.green,
                            ),
                          ),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.item_name,
                                  style: GoogleFonts.openSans(
                                    color: const Color(0xFF555555),
                                  ),
                                ),
                                Text(
                                  "(${item.used_date})",
                                  style: GoogleFonts.openSans(
                                    color: const Color(0xFF555555),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${item.used_amount}฿',
                                style: GoogleFonts.openSans(
                                  color: const Color(0xFF555555),
                                ),
                              ),
                            ),
                          ),
                          // เพิ่มข้อมูลในเซลล์เพิ่มเติมตามต้องการ
                        ],
                      );
                    }).toList(),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(1),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(0, 185, 0, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
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
                                    const Icon(Icons.currency_bitcoin_outlined),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Expense request',
                                        style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: const Color(0xFF555555),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 48,
                                  padding: EdgeInsets.only(left: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Color(0xFF555555),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _subjectController,
                                    decoration: InputDecoration(
                                      hintText: 'subject',
                                      hintStyle: GoogleFonts.openSans(
                                        color: const Color(0xFF555555),
                                      ),
                                      labelStyle: GoogleFonts.openSans(
                                        color: const Color(0xFF555555),
                                      ),
                                      border: InputBorder.none,
                                      suffixIcon: Container(
                                        alignment: Alignment.centerRight,
                                        width: 10,
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              _subjectController.clear();
                                            },
                                            icon: const Icon(Icons.close),
                                            color: Color(0xFF555555),
                                            iconSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {},
                                  ),
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
                                    controller: _descriptionController,
                                    style: GoogleFonts.openSans(
                                        color: const Color(0xFF555555),
                                        fontSize: 14),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '$Type_something...',
                                      hintStyle: GoogleFonts.openSans(
                                          fontSize: 14,
                                          color: const Color(0xFF555555)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF555555)),
                                      ),
                                    ),
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
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
                                  _subjectController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Confirme',
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (need_subject != "") {
                                      expense_used_id = selectedIds;
                                      _expenseR();
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  },
                  child: Center(
                    child: Text(
                      'Expense Request',
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }

  List<UsedData> _usedData = [];
  int _index = 0;
  Widget _tableExpense(CashData cashData) {
    return FutureBuilder<List<UsedData>>(
      future: fetchUsed(),
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
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: GoogleFonts.openSans(
              color: const Color(0xFF555555),
            ),
          ));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            Empty,
            style: GoogleFonts.openSans(
              color: const Color(0xFF555555),
            ),
          ));
        } else {
          return Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final usedData = snapshot.data![index];
                  return _cardCashTable(cashData, usedData,index);
                }),
          );
        }
      },
    );
  }

  Widget _cardCashTable(CashData cashData, UsedData usedData, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _index = index;
          // selectedUnit2 = usedData.uom_description as UnitData?;
          setState(() {
            _detailyController.text = usedData.used_description;
            _quantityController.text = usedData.used_quantity;
            _priceController.text = usedData.used_price;
            _amountController.text = usedData.used_amount;
          });
          cash_id = cashData.cash_id;
          used_id = usedData.used_id;
          // item_id = usedData.item_id;
          fetchDetail();
          unit_id = usedData.uom_code;
          item_id = usedData.item_id;
          isSave = false;
        });
      },
      child: Stack(
        children: [
          Card(
            elevation: 0,
            color: Color(0xFFF5F5F5),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: Offset(0, 1), // x, y
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Date: ',
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF555555)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  child: Text(
                                    usedData.used_date,
                                    style: GoogleFonts.openSans(
                                        fontSize: 14, color: Color(0xFF555555)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Item: ',
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF555555)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  child: Text(
                                    usedData.item_name,
                                    style: GoogleFonts.openSans(
                                        fontSize: 14, color: Color(0xFF555555)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            'Detail: ',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF555555),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              (usedData.used_description == '')
                                  ? ' - '
                                  : usedData.used_description,
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                color: Color(0xFF555555),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Quantity: ',
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF555555)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  child: Text(
                                    usedData.used_quantity,
                                    style: GoogleFonts.openSans(
                                        fontSize: 14, color: Color(0xFF555555)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Price: ',
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF555555)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  child: Text(
                                    '${usedData.used_price} ${usedData.uom_description}',
                                    style: GoogleFonts.openSans(
                                        fontSize: 14, color: Color(0xFF555555)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            'Amount: ',
                            style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF555555)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              usedData.used_amount,
                              style: GoogleFonts.openSans(
                                  fontSize: 14, color: Color(0xFF555555)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // IconButton(
          //   icon: FaIcon(FontAwesomeIcons.wallet), // ไอคอนจาก Font Awesome
          //   onPressed: () {
          //     print('Facebook icon clicked');
          //   },
          // ),
          Positioned(
              right: 4,
              bottom: 4,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.trashAlt,
                    color: Colors.redAccent,
                    ),
                  onPressed: () {
                    setState(() {
                      cash_id = cashData.cash_id;
                      used_id = usedData.used_id;
                      fetchDeleteCash();
                    });
                  },
                ),
                // child: IconButton(
                //     onPressed: () {
                //       setState(() {
                //         cash_id = cashData.cash_id;
                //         used_id = usedData.used_id;
                //         fetchDeleteCash();
                //       });
                //     },
                //     icon: Icon(
                //       Icons.delete_outline,
                //       color: Colors.redAccent,
                //       size: 34,
                //     )),
              ))
        ],
      ),
    );
  }

  //fetchDetail()
  Widget _editCashTable() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '$Item : ',
                    style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF555555)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 45,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.orange,
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButton2<ItemData>(
                    isExpanded: true,
                    hint: Text(
                      'Select Item',
                      style: GoogleFonts.openSans(
                        color: Color(0xFF555555),
                      ),
                    ),
                    style: GoogleFonts.openSans(
                      color: Color(0xFF555555),
                    ),
                    items: itemList
                        .map((ItemData item) => DropdownMenuItem<ItemData>(
                              value: item,
                              child: Text(
                                item.item_name!,
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: selectedItem,
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value;
                        item_id = value?.item_id ?? '';
                      });
                    },
                    underline: SizedBox.shrink(),
                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.black, size: 30),
                      iconSize: 30,
                    ),
                    buttonStyleData: ButtonStyleData(
                      height: 40,
                      width: double.infinity,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight:
                          200, // Height for displaying up to 5 lines (adjust as needed)
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 40, // Height for each menu item
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: _searchController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _searchController,
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.openSans(
                              color: Color(0xFF555555), fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: '$Search...',
                            hintStyle: GoogleFonts.openSans(
                                fontSize: 14, color: Color(0xFF555555)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value!.item_name!
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        _searchController
                            .clear(); // Clear the search field when the menu closes
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  '$Detail : ',
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.orange,
                      width: 1.0,
                    ),
                  ),
                  child: TextFormField(
                    minLines: 2,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    controller: _detailyController,
                    style: GoogleFonts.openSans(
                        color: Color(0xFF555555), fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Color(0xFF555555),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  '$Quantity : ',
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.orange,
                      width: 1.0,
                    ),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _quantityController,
                    style: GoogleFonts.openSans(
                        color: Color(0xFF555555), fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '0',
                      hintStyle: GoogleFonts.openSans(
                          fontSize: 14, color: Color(0xFF555555)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        '$Price : ',
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF555555)),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.orange,
                            width: 1.0,
                          ),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                          style: GoogleFonts.openSans(
                              color: Color(0xFF555555), fontSize: 14),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: '0',
                            hintStyle: GoogleFonts.openSans(
                                fontSize: 14, color: Color(0xFF555555)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$Unit : ',
                      style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF555555)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.orange,
                            width: 1.0,
                          ),
                        ),
                        child: DropdownButton2<UnitData>(
                          isExpanded: true,
                          hint: Text(
                            'Select Unit',
                            style: GoogleFonts.openSans(
                              color: Color(0xFF555555),
                            ),
                          ),
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                          items: unitList2
                              .map((unit) => DropdownMenuItem<UnitData>(
                                    value: unit,
                                    child: Container(
                                      child: Text(
                                        unit.unit_name!,
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedUnit2,
                          onChanged: (value) {
                            setState(() {
                              selectedUnit2 = value as UnitData?;
                              unit_id = value?.unit_id ?? '';
                            });
                          },
                          underline: SizedBox.shrink(),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.black, size: 30),
                            iconSize: 30,
                          ),
                          buttonStyleData: ButtonStyleData(
                            height: 40,
                            width: double.infinity,
                          ),
                          // กำหนดคุณสมบัติ dropdown ให้แสดงได้สูงสุด 5 บรรทัด
                          dropdownStyleData: DropdownStyleData(
                            maxHeight:
                                200, // ความสูงสำหรับ 5 บรรทัด (ปรับค่าได้ตามต้องการ)
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: 40, // ความสูงของแต่ละรายการ
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _searchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: _searchController,
                                keyboardType: TextInputType.text,
                                style: GoogleFonts.openSans(
                                    color: Color(0xFF555555), fontSize: 14),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: '$Search...',
                                  hintStyle: GoogleFonts.openSans(
                                      fontSize: 14, color: Color(0xFF555555)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value!.unit_name!
                                  .toLowerCase()
                                  .contains(searchValue.toLowerCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              _searchController.clear();
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          if (used_id != '')
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Amount :',
                      style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF555555)),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.orange,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        _amountController.text,
                        style: GoogleFonts.openSans(
                            fontSize: 14, color: Color(0xFF555555)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'File :',
                    style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF555555)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.orange,
                        width: 1.0,
                      ),
                    ),
                    child: (_image == null)?Icon(Icons.add,size: 35,):Image.file(File(_image!.path)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  XFile? _image; // XFile ที่เก็บภาพที่เลือก
  final ImagePicker _picker = ImagePicker();

  // ฟังก์ชันสำหรับเลือกภาพจากแกลเลอรี่
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  // ฟังก์ชันสำหรับแปลง XFile เป็น Base64
  Future<String> _convertXFileToBase64(XFile imageFile) async {
    // อ่านไฟล์เป็นบิต
    final bytes = await imageFile.readAsBytes();
    // แปลงเป็น Base64
    String base64String = base64Encode(bytes);
    return base64String;
  }

  Widget _elevatedButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(1),
              foregroundColor: Colors.white,
              backgroundColor: Color.fromRGBO(0, 185, 0, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() async {
                isSave = true;
                String base64Image = await _convertXFileToBase64(_image!);
                fileImage = base64Image;
                fetchSaveCashTest();
                // Update
              });
            },
            child: Center(
              child: Text(
                (used_id != '') ? 'Update Cash' : 'Create Cash',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(1),
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                isSave = true;
                clear();
                // Update
              });
            },
            child: Center(
              child: Text(
                'Close',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void clear() {
    use_detail = '';
    quantity = '';
    price = '';
    unit_id = '';
    item_id = '';
    fileImage = '';
  }

  void _expenseR() {
    cash_id;
    expense_used_id;
    need_subject;
    need_description;
    print(cash_id);
    print(expense_used_id);
    print(need_subject);
    print(need_description);
    fetchExpenseCash();
  }

  Future<List<CashData>> fetchCash() async {
    final uri =
        Uri.parse("https://www.origami.life/api/origami/pettyCash/cash.php");
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
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['cash_data'];
      final dataCash = dataJson.map((json) => CashData.fromJson(json)).toList();
      cash_id = dataCash[0].cash_id;
      print(cash_id);
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => CashData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  String cash_id = '';
  String status_id = '';
  Future<List<UsedData>> fetchUsed() async {
    final uri =
        Uri.parse("https://www.origami.life/api/origami/pettyCash/used.php");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'auth_password': widget.employee.auth_password,
        'cash_id': cash_id,
        'status_id': status_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['used_data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => UsedData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  DetailData? detailData;
  Future<void> fetchDetail() async {
    final uri =
        Uri.parse("https://www.origami.life/api/origami/pettyCash/detail.php");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'auth_password': widget.employee.auth_password,
        'cash_id': cash_id,
        'used_id': used_id,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        detailData = jsonResponse['used_data'];
        fetchUnit();
        fetchItem();
        // use_date = '';
        // item_id = '';
        // // use_detail = '';
        // quantity = '';
        // price = '';
        // // unit_id = '';
        // fileImage = '';
      } else {
        throw Exception(
            'Failed to load personal data: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }

  StatusCash? selectedStatus;
  List<StatusCash> statusList = [];
  Future<void> fetchStatus() async {
    final uri =
        Uri.parse("https://www.origami.life/api/origami/pettyCash/status.php");
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
      final List<dynamic> dataJson = jsonResponse['status_data'];
      setState(() {
        statusList = dataJson.map((json) => StatusCash.fromJson(json)).toList();
        // Ensure selectedStatus is set to a valid item if possible
        if (statusList.isNotEmpty && selectedStatus == null) {
          selectedStatus = statusList[0];
        }
      });
    } else {
      throw Exception('Failed to load status data');
    }
  }

  String use_date = '';
  String item_id = '';
  String use_detail = '';
  String quantity = '';
  String price = '';
  String unit_id = '';
  String fileImage = '';
  bool create = false;
  Future<void> fetchSaveCashTest() async {
    print(used_id);
    print(use_detail);
    print(quantity);
    print(price);
    print(unit_id); //
    print(fileImage);
    if(used_id == ''){
      setState(() {
        fetchSaveCash();
      });
    }else{
      if(unit_id == ''){
        unit_id = _usedData[_index].uom_code;
      }else if(item_id == ''){
        item_id = _usedData[_index].item_id;
      }else if(quantity == ''){
        quantity = _usedData[_index].used_quantity;
      }else if(price == ''){
        price = _usedData[_index].used_price;
      }
      setState(() {
        fetchSaveCash();
      });
    }
  }

  Future<void> fetchSaveCash() async {
    final uri =
        Uri.parse("https://www.origami.life/api/origami/pettyCash/save.php");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'auth_password': widget.employee.auth_password,
        'cash_id': cash_id,
        'used_id': used_id,
        'use_date': use_date,
        'item_id': item_id,
        'use_detail': use_detail,
        'quantity': quantity,
        'price': price,
        'unit': unit_id,
        'image': fileImage,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        clear();
      } else {
        throw Exception(
            'Failed to load personal data: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }

  String used_id = '';
  Future<void> fetchDeleteCash() async {
    final uri =
        Uri.parse("https://www.origami.life/api/origami/pettyCash/delete.php");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'auth_password': widget.employee.auth_password,
        'cash_id': cash_id,
        'used_id': used_id,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
      } else {
        throw Exception(
            'Failed to load personal data: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }

  String unitNumber = '';
  String unitName = '';
  UnitData? selectedUnit2;
  List<UnitData> unitList2 = [];
  Future<void> fetchUnit() async {
    final uri = Uri.parse(
        "https://www.origami.life/api/origami/need/unit.php?page=$unitNumber&search=$unitName");
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
      final List<dynamic> dataJson = jsonResponse['unit_data'];
      setState(() {
        unitList2 = dataJson.map((json) => UnitData.fromJson(json)).toList();
        if (unitList2.isNotEmpty && selectedUnit2 == null) {
          selectedUnit2 = unitList2[0];
        }
      });
    } else {
      throw Exception('Failed to load status data');
    }
  }

  String item_number = '';
  String item_name = '';
  ItemData? selectedItem;
  List<ItemData> itemList = [];
  Future<void> fetchItem() async {
    final uri = Uri.parse(
        'https://www.origami.life/api/origami/need/item.php?page=$item_number&search=$item_name&need_type=EP');
    try {
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
        final List<dynamic> dataJson = jsonResponse['item_data'];
        setState(() {
          itemList = dataJson.map((json) => ItemData.fromJson(json)).toList();
          if (itemList.isNotEmpty && selectedItem == null) {
            selectedItem = itemList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  String need_subject = '';
  String need_description = '';
  Future<void> fetchExpenseCash() async {
    final uri =
        Uri.parse("https://www.origami.life/api/origami/pettyCash/expense.php");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'auth_password': widget.employee.auth_password,
        'cash_id': cash_id,
        'used_id': expense_used_id,
        'need_subject': need_subject,
        'need_description': need_description,
      },
    );
    setState(() {
      selectedIds = [];
      expense = true;
    });
    Navigator.pop(context);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
      } else {
        throw Exception(
            'Failed to load personal data: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }
}

class CashData {
  final String cash_id;
  final String cash_name;
  final String cash_no;
  final String cash_amount;
  final String cash_start;
  final String cash_end;
  final String cash_balance;

  CashData({
    required this.cash_id,
    required this.cash_name,
    required this.cash_no,
    required this.cash_amount,
    required this.cash_start,
    required this.cash_end,
    required this.cash_balance,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory CashData.fromJson(Map<String, dynamic> json) {
    return CashData(
      cash_id: json['cash_id'],
      cash_name: json['cash_name'],
      cash_no: json['cash_no'],
      cash_amount: json['cash_amount'],
      cash_start: json['cash_start'],
      cash_end: json['cash_end'],
      cash_balance: json['cash_balance'],
    );
  }
}

class StatusCash {
  final String status_id;
  final String status_name;

  StatusCash({
    required this.status_id,
    required this.status_name,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory StatusCash.fromJson(Map<String, dynamic> json) {
    return StatusCash(
      status_id: json['status_id'],
      status_name: json['status_name'],
    );
  }
}

class UsedData {
  final String used_id;
  final String used_date;
  final String used_description;
  final String item_id;
  final String item_name;
  final String used_quantity;
  final String uom_code;
  final String uom_description;
  final String used_price;
  final String used_amount;
  final String used_status;
  final String can_action;
  final String files_path;
  // bool isSelected;

  UsedData({
    required this.used_id,
    required this.used_date,
    required this.used_description,
    required this.item_id,
    required this.item_name,
    required this.used_quantity,
    required this.uom_code,
    required this.uom_description,
    required this.used_price,
    required this.used_amount,
    required this.used_status,
    required this.can_action,
    required this.files_path,
    // this.isSelected = false,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory UsedData.fromJson(Map<String, dynamic> json) {
    return UsedData(
      used_id: json['used_id'],
      used_date: json['used_date'],
      used_description: json['used_description'],
      item_id: json['item_id'],
      item_name: json['item_name'],
      used_quantity: json['used_quantity'],
      uom_code: json['uom_code'],
      uom_description: json['uom_description'],
      used_price: json['used_price'],
      used_amount: json['used_amount'],
      used_status: json['used_status'],
      can_action: json['can_action'],
      files_path: json['files_path'],
      // isSelected: false, // Initialize as unchecked
    );
  }
}

class DetailData {
  final String used_date;
  final String used_description;
  final String item_id;
  final String item_name;
  final String used_quantity;
  final String uom_code;
  final String uom_description;
  final String used_price;
  final String used_amount;
  final String used_status;
  final String can_action;
  final String files_path;

  DetailData({
    required this.used_date,
    required this.used_description,
    required this.item_id,
    required this.item_name,
    required this.used_quantity,
    required this.uom_code,
    required this.uom_description,
    required this.used_price,
    required this.used_amount,
    required this.used_status,
    required this.can_action,
    required this.files_path,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory DetailData.fromJson(Map<String, dynamic> json) {
    return DetailData(
      used_date: json['used_date'],
      used_description: json['used_description'],
      item_id: json['item_id'],
      item_name: json['item_name'],
      used_quantity: json['used_quantity'],
      uom_code: json['uom_code'],
      uom_description: json['uom_description'],
      used_price: json['used_price'],
      used_amount: json['used_amount'],
      used_status: json['used_status'],
      can_action: json['can_action'],
      files_path: json['files_path'],
    );
  }
}