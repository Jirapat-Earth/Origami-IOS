import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:origami_ios/activity/skoop/skoop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import '../language/translate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../map_page/locationGoogleMap.dart';
import 'activity.dart';

class activityEditNow extends StatefulWidget {
  const activityEditNow({
    Key? key,
    required this.employee,
    required this.activity,
  }) : super(key: key);
  final Employee employee;
  final ModelActivity activity;

  @override
  _activityEditNowState createState() => _activityEditNowState();
}

class _activityEditNowState extends State<activityEditNow> {
  TextEditingController _typeController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก

  int isSkoop = 0;
  String project = '';
  String contact = '';
  String account = '';
  String plance = '';
  String status = '';
  String priority = '';
  double cost = 0;

  @override
  void initState() {
    super.initState();
    showDate();
    _getdataUpdate(widget.activity);
    _typeController.addListener(() {
      // _search = _typeController.text;
      print("Current text: ${_typeController.text}");
    });
    _subjectController.addListener(() {
      // _search = _subjectController.text;
      print("Current text: ${_subjectController.text}");
    });
    _descriptionController.addListener(() {
      // _search = _descriptionController.text;
      print("Current text: ${_descriptionController.text}");
    });
    _costController.addListener(() {
      // _search = _costController.text;
      print("Current text: ${_costController.text}");
    });
    _searchController.addListener(() {
      // _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  Future<void> _getdataUpdate(ModelActivity activity) async {
    _subjectController.text = activity.activity_project_name ?? '';
    _descriptionController.text = activity.activity_description ?? '';
    project = activity.activity_project_name ?? '';
    contact = activity.activity_project_name ?? '';
    account = activity.activity_project_name ?? '';
    plance = activity.activity_project_name ?? '';
    status = activity.activity_project_name ?? '';
    priority = activity.activity_project_name ?? '';
    cost = activity.activity_project_name as double;
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

  Future<void> _calendar(BuildContext context) async {
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
            '',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey,
                      BlendMode
                          .saturation, // ใช้ BlendMode.saturation สำหรับ Grayscale
                    ),
                    child: Image.network(
                      'https://greenville.com.ng/wp-content/uploads/2017/06/busienss1.jpg',
                      fit: BoxFit.cover,
                      height: 60,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dropdownBody('Type'),
                        _textBody('Subject', _subjectController),
                        _textBody('Description', _descriptionController),
                        Row(
                          children: [
                            Expanded(
                              child: _dateBody('Start Date'),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _timeBody('Start Time', context),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _dateBody('End Date'),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _timeBody('End Time', context),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 18),
                            Container(
                              color: Colors.grey,
                              height: 2,
                              width: double.infinity,
                            ),
                            SizedBox(height: 18),
                          ],
                        ),
                        _dropdownBody('Project'),
                        _dropdownBody('Contact'),
                        _dropdownBody('Account'),
                        _dropdownBody('Plance'),
                        _dropdownBody('Status'),
                        _dropdownBody('Priority'),
                        _locationGM(),
                        Text(
                          'Cost',
                          maxLines: 1,
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _costController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.openSans(
                              color: Color(0xFF555555), fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            hintText: '0.00',
                            hintStyle: GoogleFonts.openSans(
                                fontSize: 14, color: Color(0xFF555555)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            filled: true, // เปิดการใช้สีพื้นหลัง
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors
                                    .orange, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
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
                        Column(
                          children: [
                            SizedBox(height: 16),
                            Container(
                              color: Colors.grey,
                              height: 16,
                              width: double.infinity,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                        Text(
                          'Other Contact',
                          maxLines: 1,
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: List.generate(7, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4, right: 8),
                                          child: CircleAvatar(
                                            radius: 17,
                                            backgroundColor: Colors.grey,
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.white,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                  widget.employee
                                                          .emp_avatar ??
                                                      '',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
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
                                                'Name Creatr Activity',
                                                maxLines: 1,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                'ACRM',
                                                maxLines: 1,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 12,
                                                  color: Color(0xFF555555),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Divider(
                                                  color:
                                                      Colors.grey.shade300),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              barrierColor: Colors.black87,
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              builder: (BuildContext context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.8, // 80% height
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Sheet content background
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                  ),
                                  child: Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: _searchController,
                                            keyboardType: TextInputType.text,
                                            style: GoogleFonts.openSans(
                                                color: Color(0xFF555555),
                                                fontSize: 14),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 12),
                                              hintText: 'Search',
                                              hintStyle: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                  color: Color(0xFF555555)),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: Colors.orange,
                                              ),
                                              enabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors
                                                      .orange, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors
                                                      .orange, // ขอบสีส้มตอนที่โฟกัส
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15),
                                            child: ListView.builder(
                                                itemCount: 7,
                                                itemBuilder:
                                                    (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          // mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 4,
                                                                      bottom:
                                                                          4,
                                                                      right:
                                                                          8),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 17,
                                                                backgroundColor:
                                                                    Colors
                                                                        .grey,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 16,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50),
                                                                    child: Image
                                                                        .network(
                                                                      widget.employee.emp_avatar ??
                                                                          '',
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Name Creatr Activity',
                                                                    maxLines:
                                                                        1,
                                                                    style: GoogleFonts
                                                                        .openSans(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .orange,
                                                                      fontWeight:
                                                                          FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'ACRM',
                                                                    maxLines:
                                                                        1,
                                                                    style: GoogleFonts
                                                                        .openSans(
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xFF555555),
                                                                      fontWeight:
                                                                          FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                // _dropdownBody('รายชื่อผู้ติดต่อ');
                              },
                            );
                          },
                          // FractionallySizedBox(
                          //   // heightFactor: 0.8,
                          child: Text(
                            'Add Other Contact',
                            maxLines: 1,
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Container(
            color: Colors.grey,
            height: 1,
            width: double.infinity,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SkoopScreen(
                                isSkoop: (int value) {
                                  setState(() {
                                    isSkoop = value;
                                  });
                                },
                              ),
                      ),
                    );
                  },
                  child: _gestureDetector(
                      'Skoop', Icons.wifi_tethering, Color(0xFF00C789)),
                ),
              ),
              if(isSkoop == 1)
              Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {},
                    child: _gestureDetector(
                        'Close', Icons.close, Color(0xFF53C507))),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {},
                  child: _gestureDetector(
                      'Delete', Icons.delete_outline_outlined, Colors.red),
                ),
              ),
            ],
          ),
          SizedBox(height: 8)
        ],
      ),
    );
  }

  Widget _gestureDetector(String text, IconData icon, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
        ),
        SizedBox(width: 8),
        Text(
          text,
          maxLines: 2,
          style: GoogleFonts.openSans(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _textBody(String title, TextEditingController textController) {
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
          controller: textController,
          keyboardType: TextInputType.text,
          style: GoogleFonts.openSans(color: Color(0xFF555555), fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: '',
            hintStyle:
                GoogleFonts.openSans(fontSize: 14, color: Color(0xFF555555)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
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
    return Expanded(
      child: Column(
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
                _calendar(context);
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
                      color: Color(0xFF555555),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBody(String _nemeTime, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _nemeTime,
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
              onTap: () => _selectTime(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      selectedTime.format(context),
                      style: GoogleFonts.openSans(
                          fontSize: 14, color: Color(0xFF555555)),
                    ),
                    Spacer(),
                    Icon(
                      Icons.access_time_outlined,
                      color: Color(0xFF555555),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownBody(String title) {
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
              icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
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
                return item.value!.status_name!
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
        SizedBox(height: 8),
      ],
    );
  }

  Widget _locationGM() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Lication',
          maxLines: 1,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => LocationGoogleMap(
            //       latLng: (LatLng? value) {
            //         setState(() {
            //           _selectedLocation = value;
            //         });
            //       },
            //     ),
            //   ),
            // );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.orange,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    (_selectedLocation == null)
                        ? ''
                        : '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                    maxLines: 1,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
                Icon(Icons.location_on, color: Color(0xFF555555), size: 20),
              ],
            ),
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
