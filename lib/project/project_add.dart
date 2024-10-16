import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import '../language/translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../map_page/locationGoogleMap.dart';

class projectAdd extends StatefulWidget {
  const projectAdd({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _projectAddState createState() => _projectAddState();
}

class _projectAddState extends State<projectAdd> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _projectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก

  @override
  void initState() {
    super.initState();
    showDate();
    _codeController.addListener(() {
      // _search = _codeController.text;
      print("Current text: ${_codeController.text}");
    });
    _projectController.addListener(() {
      // _search = _projectController.text;
      print("Current text: ${_projectController.text}");
    });
    _descriptionController.addListener(() {
      // _search = _descriptionController.text;
      print("Current text: ${_descriptionController.text}");
    });
    _contactController.addListener(() {
      // _search = _contactController.text;
      print("Current text: ${_contactController.text}");
    });
  }

  String currentTime = '';
  TimeOfDay selectedTime = TimeOfDay(hour: 7, minute: 15);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
      });
    }
  }

  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  void showDate() {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    showlastDay = formatter.format(_selectedDateEnd);
  }

  Future<void> _requestDateEnd(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.teal,
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.teal,
            ),
            dialogBackgroundColor: Colors.teal[50],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarDatePicker(
                  initialDate: _selectedDateEnd,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDateEnd = newDate;
                      DateFormat formatter = DateFormat('dd/MM/yyyy');
                      showlastDay = formatter.format(_selectedDateEnd);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Add Project',
            style: GoogleFonts.openSans(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Text(
                  'DONE',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16)
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textBody('Project Name', _projectController, true),
                _dropdownBody('Type'),
                _textBody('Code', _codeController, true),
                _textBody('Default Contact', _contactController, true),
                _dropdownBody('Status'),
                _dropdownBody('Sale Status'),
                _textBody('Description', _descriptionController, true),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationGoogleMap(
                            latLng: (LatLng? value) {
                              setState(() {
                                _selectedLocation = value;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: _textBody('Location', _codeController, false)),
                _dateBody('Start Date'),
                SizedBox(height: 8),
                _dateBody('End Date'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textBody(
      String title, TextEditingController textController, bool _isTrue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          minLines: (textController == _descriptionController) ? 3 : 1,
          maxLines: null,
          enabled: (_isTrue == true) ? true : false,
          controller: textController,
          keyboardType: TextInputType.text,
          style: GoogleFonts.openSans(color: Color(0xFF555555), fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: (_selectedLocation == null || _isTrue == true)?'':'${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
            hintStyle:
                GoogleFonts.openSans(fontSize: 14, color: Color(0xFF555555)),
            suffixIcon: Container(
              alignment: Alignment.centerRight,
              width: 10,
              child: Center(
                child: IconButton(
                    onPressed: () {},
                    icon: Icon((_isTrue == true) ? null : Icons.location_on),
                    color: Colors.orange,
                    iconSize: 18),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.orange, // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
                width: 1,
              ),
            ),
            filled: true, // เปิดการใช้สีพื้นหลัง
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange, // ขอบสีส้มตอนที่โฟกัส
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _dateBody(String _nemedate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _nemedate,
          maxLines: 1,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.orange,
              width: 1.0,
            ),
          ),
          child: InkWell(
            onTap: () {
              _requestDateEnd(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    showlastDay,
                    style: GoogleFonts.openSans(
                        fontSize: 14, color: Color(0xFF555555)),
                  ),
                  Spacer(),
                  Icon(
                    Icons.calendar_month,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownBody(
    String title
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.orange,
              width: 1.0,
            ),
          ),
          child: DropdownButton2<TitleDown>(
            isExpanded: true,
            hint: Text(
              title,
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: titleDown
                .map((TitleDown item) => DropdownMenuItem<TitleDown>(
                      value: item,
                      child: Text(
                        item.status_name,
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
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down, color: Color(0xFF555555), size: 30),
              iconSize: 30,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight:
                  200, // Height for displaying up to 5 lines (adjust as needed)
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40, // Height for each menu item
            ),
            // dropdownSearchData: DropdownSearchData(
            //   searchController: _searchController,
            //   searchInnerWidgetHeight: 50,
            //   searchInnerWidget: Padding(
            //     padding: const EdgeInsets.all(8),
            //     child: TextFormField(
            //       controller: _searchController,
            //       keyboardType: TextInputType.text,
            //       style: GoogleFonts.openSans(
            //           color: Color(0xFF555555), fontSize: 14),
            //       decoration: InputDecoration(
            //         isDense: true,
            //         contentPadding: const EdgeInsets.symmetric(
            //           horizontal: 10,
            //           vertical: 8,
            //         ),
            //         hintText: '$Search...',
            //         hintStyle: GoogleFonts.openSans(
            //             fontSize: 14, color: Color(0xFF555555)),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //       ),
            //     ),
            //   ),
            //   searchMatchFn: (item, searchValue) {
            //     return item.value!.item_name!
            //         .toLowerCase()
            //         .contains(searchValue.toLowerCase());
            //   },
            // ),
            // onMenuStateChange: (isOpen) {
            //   if (!isOpen) {
            //     _searchController
            //         .clear(); // Clear the search field when the menu closes
            //   }
            // },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  TitleDown? selectedItem;
  List<TitleDown> titleDown = [
    TitleDown(status_id: '001', status_name: 'Trandar'),
    TitleDown(status_id: '002', status_name: 'Origami'),
    TitleDown(status_id: '003', status_name: 'Application'),
    TitleDown(status_id: '004', status_name: 'Website'),
  ];
}

class TitleDown {
  String status_id;
  String status_name;

  TitleDown({
    required this.status_id,
    required this.status_name,
  });
}
