import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:origami_ios/activity/signature_page/signature_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login.dart';
import '../language/translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:signature/signature.dart';
import 'activity.dart';
import 'activity_edit_now.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class activityEdit extends StatefulWidget {
  const activityEdit({
    Key? key,
    required this.employee,
    required this.activity,
  }) : super(key: key);
  final Employee employee;
  final ModelActivity activity;

  @override
  _activityEditState createState() => _activityEditState();
}

class _activityEditState extends State<activityEdit> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _telController = TextEditingController();

  ModelActivity? activity;
  @override
  void initState() {
    super.initState();
    activity = widget.activity;
    showDate();
    _nameController.addListener(() {
      // _search = _nameController.text;
    });
    _telController.addListener(() {
      // _search = _telController.text;
    });
    updateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());
  }

  String currentTime = '';
  void updateTime() {
    final now = DateTime.now();
    setState(() {
      currentTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  void showDate() {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    showlastDay = formatter.format(_selectedDateEnd);
  }

  List<TabItem> tabItems = [
    TabItem(
      icon: FontAwesomeIcons.child,
      title: 'Activity',
    ),
    TabItem(
      icon: FontAwesomeIcons.images,
      title: 'Photo',
    ),
    TabItem(
      icon: FontAwesomeIcons.clock,
      title: 'Time',
    ),
    TabItem(
      icon: FontAwesomeIcons.pen,
      title: 'Signature',
    ),
  ];

  int _selectedIndex = 0;

  // String page = "course";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _bodySwitch() {
    switch (_selectedIndex) {
      case 0:
        return _activity();
      case 1:
        return _activityImage();
      case 2:
        return _activityTime();
      case 3:
        return _activityLyzen();
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(
            'ERROR!',
            style: GoogleFonts.openSans(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
    }
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
          (activity!.activity_status == 'close')
              ? Container()
              : InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => activityEditNow(
                          employee: widget.employee,
                          activity: widget.activity,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'EDIT',
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
      bottomNavigationBar: BottomBarDefault(
        items: tabItems,
        iconSize: 18,
        animated: true,
        titleStyle: GoogleFonts.openSans(),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Colors.orange,
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.white,
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircleAvatar(
                      radius: 57,
                      backgroundColor: Colors.grey.shade400,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            widget.employee.emp_avatar ?? '',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _bodySwitch(),
          ],
        ),
      ),
    );
  }

  Widget _textBody(
      String title, String _dataObject, IconData icon, Color CIcon) {
    return Row(
      children: [
        Icon(
          icon,
          color: CIcon,
          size: 28,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _dataObject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textBodyBack(
      String title, String _dataObject, IconData icon, Color CIcon) {
    return Row(
      children: [
        Icon(
          icon,
          color: CIcon,
          size: 25,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _dataObject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Color(0xFF555555),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activity() {
    return Column(
      children: [
        Column(
          children: [
            Text(
              widget.employee.emp_name ?? '',
              maxLines: 1,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${activity!.activity_start_date} ${activity!.time_start} - ${activity!.activity_end_date} ${activity!.time_end}',
              maxLines: 1,
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Status : ',
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (activity!.activity_status == 'close')
                      ? '${activity!.activity_status}'
                      : 'plan',
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: (activity!.activity_status == 'close')
                        ? Colors.orange
                        : Colors.blue.shade300,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textBody('SUBJECT', activity?.activity_project_name ?? '',
                      Icons.abc, Colors.transparent),
                  _textBody('DESCRIPTION', activity?.activity_description ?? '',
                      Icons.abc, Colors.transparent),
                  _textBody('TYPE', 'Website & Applictation', Icons.pie_chart,
                      Color(0xFF555555)),
                  _textBody('PROJECT', activity?.projectname ?? '',
                      Icons.insert_drive_file, Color(0xFF555555)),
                  _textBody('CONTACT', 'Allable Team', Icons.account_circle,
                      Color(0xFF555555)),
                  _textBody('ACCOUNT', activity?.activity_location ?? '',
                      Icons.apartment, Color(0xFF555555)),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textBodyBack(
                      'PLACE',
                      (activity!.activity_place_type == 'in')
                          ? 'Indoor'
                          : 'Outdoor',
                      Icons.abc,
                      Colors.transparent),
                  _textBodyBack('ACTIVITY STATUS', 'Complete', Icons.abc,
                      Colors.transparent),
                  _textBodyBack(
                      'PRIORITY', 'Normal', Icons.abc, Colors.transparent),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activityImage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Text(
                widget.employee.emp_name ?? '',
                maxLines: 1,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${activity!.activity_start_date} ${activity!.time_start} - ${activity!.activity_end_date} ${activity!.time_end}',
                maxLines: 1,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'PHOTO',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _showImagePhoto(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityTime() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text(
            '$currentTime น.',
            style: GoogleFonts.openSans(
              fontSize: 55,
              color: Color(0xFF555555),
              // fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _textBody('SUBJECT', activity?.activity_project_name ?? '',
                    Icons.description, Colors.grey),
                _textBody('ACCOUNT', activity?.activity_location ?? '',
                    Icons.apartment, Colors.grey),
                Row(
                  children: [
                    Icon(
                      Icons.input_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'In',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      (_addInTime == '') ? '-' : _addInTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.input_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Out',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      (_addOutTime == '') ? '-' : _addOutTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          if (activity!.activity_status != 'close')
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_addInTime == '') {
                    _addInTime =
                        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
                  } else {
                    _addOutTime =
                        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
                  }
                });
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF555555),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Stamp',
                      style: GoogleFonts.openSans(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
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

  String _addInTime = '';
  String _addOutTime = '';

  Widget _activityLyzen() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Text(
                widget.employee.emp_name ?? '',
                maxLines: 1,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${activity!.activity_start_date} ${activity!.time_start} - ${activity!.activity_end_date} ${activity!.time_end}',
                maxLines: 1,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.openSans(
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    hintText: '',
                    hintStyle: GoogleFonts.openSans(
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true, // เปิดการใช้สีพื้นหลัง
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // ขอบสีส้มตอนที่โฟกัส
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Tel',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: _dropdownBody()),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _telController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.openSans(
                            color: Color(0xFF555555), fontSize: 14),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          hintText: '',
                          hintStyle: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF555555)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true, // เปิดการใช้สีพื้นหลัง
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Signature',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _showSignatureImage(),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<String> _addImage = [];

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _addImage.add(_image!.path);
      });
    }
  }

  Widget _showImagePhoto() {
    return _addImage.isNotEmpty
        ? InkWell(
            onTap: () => _pickImage(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: _addImage.length,
                        shrinkWrap: true, // ทำให้ GridView มีขนาดพอดีกับเนื้อหา
                        physics:
                            NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ GridView
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // ตั้งค่าให้มี 2 รูปต่อ 1 แถว
                          crossAxisSpacing: 2, // ระยะห่างระหว่างรูปแนวนอน
                          mainAxisSpacing: 2, // ระยะห่างระหว่างรูปแนวตั้ง
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(_addImage[index]),
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap:(){},
                                      child: Stack(
                                        children: [
                                          Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.white,
                                          ),
                                          Icon(
                                            Icons.cancel,
                                            color: Colors.red,
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
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here to select an image.',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.orange.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () => _pickImage(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here to select an image.',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.orange.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Uint8List? _signatureImage; // สำหรับเก็บภาพลายเซ็น

  Widget _showSignatureImage() {
    return _signatureImage != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(
                  _signatureImage!,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignaturePage(
                    signatureImage: (Uint8List? value) {
                      setState(() {
                        _signatureImage = value;
                      });
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here for signature.',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.orange.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _dropdownBody() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: DropdownButton2<TitleDown>(
        isExpanded: true,
        hint: Text(
          '+66',
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
    );
  }

  TitleDown? selectedItem;
  List<TitleDown> titleDown = [
    TitleDown(status_id: '001', status_name: 'TH +66'),
    TitleDown(status_id: '002', status_name: 'AF +93'),
    TitleDown(status_id: '003', status_name: 'AX +358'),
    TitleDown(status_id: '004', status_name: 'AI +1'),
  ];
}
