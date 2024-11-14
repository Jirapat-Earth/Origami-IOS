import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../imports.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;

class TimeSample extends StatefulWidget {
  const TimeSample(
      {super.key,
      required this.employee,
      this.timeStamp,
      required this.Authorization,
      required this.descriptionTime,
      required this.fetchBranchCallback});
  final Employee employee;
  final GetTimeStampSim? timeStamp;
  final String Authorization;
  final String descriptionTime;
  final Future<void> Function() fetchBranchCallback;
  @override
  _TimeSampleState createState() => _TimeSampleState();
}

class _TimeSampleState extends State<TimeSample> {
  String currentTime = '';
  bool _checkInOut = false;
  Color fillColor = Color.fromRGBO(128, 255, 0, 0).withOpacity(0.2);
  Color strokeColor = Color.fromRGBO(0, 185, 0, 1);
  LatLng _circleCenter =
      LatLng(13.734185, 100.626831); // ตำแหน่งของจุดศูนย์กลางวงกลม
  // double _radius = 40; // รัศมีในหน่วยเมตร
  late GoogleMapController _mapController;
  late Location _location;
  LocationData? _userLocation;

  @override
  void initState() {
    super.initState();
    updateTime();
    _CheckPlatform();
    _location = Location();
    requestLocationPermission();
  }

  void requestLocationPermission() async {
    var status = await permissionHandler.Permission.location.request();
    if (status == permissionHandler.PermissionStatus.granted) {
      _location.onLocationChanged.listen((locationData) {
        setState(() {
          _userLocation = locationData;
          _checkUserInRadius();
        });
      });
    } else {
      print("Permission denied");
    }
  }

  void _checkUserInRadius() {
    if (_userLocation != null) {
      final distance = _calculateDistance(
        double.parse(widget.timeStamp?.branch_lat ?? ''),
        double.parse(widget.timeStamp?.branch_lng ?? ''),
        _userLocation!.latitude!,
        _userLocation!.longitude!,
      );

      setState(() {
        double radius = double.parse(widget.timeStamp?.branch_radius ?? '');
        fillColor = distance > radius
            ? Colors.red.withOpacity(0.2)
            : Color.fromRGBO(128, 255, 0, 0).withOpacity(0.3);
        strokeColor =
            distance > radius ? Colors.red : Color.fromRGBO(0, 185, 0, 1);
        (fillColor == Colors.red.withOpacity(0.2))
            ? _checkInOut = false
            : _checkInOut = true;
      });
      _addInTime = widget.timeStamp?.stamp_in ?? '';
      _addOutTime = widget.timeStamp?.stamp_out ?? '';
      if (_addInTime == '' && _addOutTime == '') {
        stamp_type = '';
      } else if (_addInTime != '' && _addOutTime == '') {
        stamp_type = 'in';
      } else if (_addInTime != '' && _addOutTime != '') {
        stamp_type = 'out';
      }
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000; // รัศมีโลกในหน่วยเมตร
    final dLat = (lat2 - lat1) * (pi / 180);
    final dLon = (lon2 - lon1) * (pi / 180);
    final a = 0.5 -
        cos(dLat) / 2 +
        cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) * (1 - cos(dLon)) / 2;
    return earthRadius * 2 * asin(sqrt(a));
  }

  // void requestLocationPermission() async {
  //   // ขอสิทธิ์การเข้าถึงตำแหน่งจาก permission_handler
  //   permissionHandler.PermissionStatus status =
  //       await permissionHandler.Permission.location.request();
  //
  //   if (status == permissionHandler.PermissionStatus.granted) {
  //     // ถ้าผู้ใช้อนุญาตให้เข้าถึงตำแหน่ง
  //     _location.onLocationChanged.listen((locationData) {
  //       setState(() {
  //         _userLocation = locationData;
  //         _checkUserInRadius();
  //       });
  //     });
  //   } else {
  //     // ถ้าผู้ใช้ไม่อนุญาตหรือถูกปฏิเสธสิทธิ์
  //     print("Permission denied");
  //   }
  // }
  //
  // void _checkUserInRadius() {
  //   if (_userLocation != null) {
  //     final distance = _calculateDistance(
  //       _circleCenter.latitude,
  //       _circleCenter.longitude,
  //       _userLocation!.latitude!,
  //       _userLocation!.longitude!,
  //     );
  //
  //     // เปลี่ยนสีวงกลมเป็นสีแดงถ้าอยู่นอกเขตรัศมี
  //     setState(() {
  //       fillColor =
  //           distance >= double.parse(widget.timeStamp?.branch_radius ?? '')
  //               ? Colors.red.withOpacity(0.2)
  //               : Color.fromRGBO(128, 255, 0, 0).withOpacity(0.3);
  //       strokeColor =
  //           distance >= double.parse(widget.timeStamp?.branch_radius ?? '')
  //               ? Colors.red
  //               : Color.fromRGBO(0, 185, 0, 1);
  //     });
  //     _addInTime = widget.timeStamp?.stamp_in ?? '';
  //     _addOutTime = widget.timeStamp?.stamp_out ?? '';
  //     print('1123 ,$fillColor');
  //   }
  // }
  //
  // double _calculateDistance(
  //     double lat1, double lon1, double lat2, double lon2) {
  //   const earthRadius = 6371000; // รัศมีโลกในหน่วยเมตร
  //   final dLat = (lat2 - lat1) * (3.141592653589793 / 180);
  //   final dLon = (lon2 - lon1) * (3.141592653589793 / 180);
  //   final a = 0.5 -
  //       cos(dLat) / 2 +
  //       cos(lat1 * (3.141592653589793 / 180)) *
  //           cos(lat2 * (3.141592653589793 / 180)) *
  //           (1 - cos(dLon)) /
  //           2;
  //   return earthRadius * 2 * asin(sqrt(a));
  // }

  // ฟังก์ชันนี้จะถูกเรียกเมื่อกดปุ่ม Next เพื่อเปลี่ยนตำแหน่งวงกลม
  // void _changeCirclePosition() {
  //   setState(() {
  //     // เปลี่ยนตำแหน่งศูนย์กลางวงกลม (ตัวอย่างเปลี่ยนไปที่ตำแหน่งใหม่)
  //     latDouble = double.parse(widget.timeStamp?.branch_lat??'');
  //     lngDouble = double.parse(widget.timeStamp?.branch_lat??'');
  //     _circleCenter = LatLng(latDouble,lngDouble); // ตำแหน่งใหม่ (ตัวอย่าง)
  //     _checkUserInRadius(); // เรียกใช้เพื่ออัปเดตการตรวจสอบ
  //   });
  // }

  String latitude = '';
  String longitude = '';

  // @override
  // void initState() {
  //   super.initState();
  //   updateTime();
  //   fetchGetTimeStampSim();
  //   _addFixedCircle(); // เพิ่มวงกลมเมื่อตอนเริ่มต้น
  //   _startTrackingUserLocation(); // เริ่มติดตามตำแหน่งผู้ใช้
  //   Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());
  //   checkPlatform();
  // }

  // CheckPlatform Android หรือ IOS
  String _checkPlatform = '';
  void _CheckPlatform() {
    if (Platform.isAndroid) {
      // โค้ดสำหรับ Android
      _checkPlatform = 'Android';
      print("Running on Android");
    } else if (Platform.isIOS) {
      // โค้ดสำหรับ iOS
      _checkPlatform = 'IOS';
      print("Running on iOS");
    }
  }

  @override
  void dispose() {
    // _positionStreamSubscription
    //     .cancel(); // ยกเลิกการติดตามเมื่อ widget ถูก dispose
    super.dispose();
  }

  void updateTime() {
    final now = DateTime.now();
    setState(() {
      currentTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF9900),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '$currentTime น.',
                      style: GoogleFonts.openSans(
                        fontSize: 70,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          "${widget.descriptionTime} (${widget.timeStamp?.branch_name ?? ''})",
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Input : ',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            (_addInTime != '') ? _addInTime : '-',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Output : ',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            (_addOutTime != '') ? _addOutTime : '-',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 3,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _circleCenter, // เครื่องหมายจุลภาคตรงนี้
                  zoom: 18,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                circles: {
                  Circle(
                    circleId: CircleId("trackingCircle"),
                    center: LatLng(
                        double.parse(widget.timeStamp?.branch_lat ?? ''),
                        double.parse(widget.timeStamp?.branch_lng ?? '')),
                    radius: double.parse(widget.timeStamp?.branch_radius ?? ''),
                    fillColor: fillColor,
                    strokeColor: strokeColor,
                    strokeWidth: 2,
                  ),
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                rotateGesturesEnabled: false, // ปิดการหมุนแผนที่
                scrollGesturesEnabled: true, // เปิดให้เลื่อนแผนที่ได้
                tiltGesturesEnabled: false, // ปิดการเอียงมุมมอง
                zoomGesturesEnabled: true, // ให้ผู้ใช้สามารถซูมเข้าออกได้
              )),
          Expanded(
            flex: 2,
            child: _stampImageNew(),
          ),
        ],
      ),
    );
  }

  Widget _stampImageNew() {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Center(
          child: GestureDetector(
            onTap: () => _pickImage(ImageSource.camera),
            child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/stamp/stamp_button_in.png')),
          ),
        ),
        Expanded(flex:2,child: SizedBox()),
        Center(
          child: GestureDetector(
            onTap: () => _pickImage(ImageSource.camera),
            child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/stamp/stamp_button_out.png')),
          ),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _stampImageOld() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (stamp_type == 'out' || _checkInOut == false)
          GestureDetector(
            child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/stamp/stamp_button_disable.png')),
          )
        else if (stamp_type == '' && _checkInOut == true)
          GestureDetector(
            onTap: () => _pickImage(ImageSource.camera),
            child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/stamp/stamp_button_in.png')),
          )
        else if (stamp_type == 'in' && _checkInOut == true)
          GestureDetector(
            onTap: () => _pickImage(ImageSource.camera),
            child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/stamp/stamp_button_out.png')),
          )
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  String _addInTime = '';
  String _addOutTime = '';

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = path.join(
          directory.path,
          'my_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        print('Image path: $filePath');

        // แปลงเป็น base64
        File file = File(image.path);
        List<int> imageBytes = await file.readAsBytes();
        String base64String = base64Encode(imageBytes);
        print('Base64 String: $base64String');

        // เก็บ base64 image ไว้ใน state
        setState(() {
          _base64Image = base64String;
          latitude = '${_userLocation!.latitude}';
          longitude = '${_userLocation!.longitude}';
          if (_addInTime == '') {
            stamp_type = 'in';
            _addInTime =
            "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
          } else {
            stamp_type = 'out';
            _addOutTime =
            "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
          }
        });
        // เรียก callback จาก widget
        await widget.fetchBranchCallback();
        _showDialog();
        _fetchStamp();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/success.gif',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '$Cancel',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String stamp_type = 'out';
  Future<void> _fetchStamp2() async {
    print('${stamp_type}');
    print('${latitude}');
    print('${longitude}');
    print('${_checkPlatform}');
    print('${_base64Image}');
  }

  String check_Stamp_In = '';
  String check_Stamp_Out = '';
  Future<void> _fetchStamp() async {
    final uri =
        Uri.parse('$host/api/origami/time/stamp.php');
        // Uri.parse('$host/api/origami/time/stamp123.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'stamp_type': stamp_type, //in,out
          'activity_id': '',
          'branch_id': widget.timeStamp?.branch_id ?? '',
          'latitude': latitude,
          'longitude': longitude,
          'device': _checkPlatform,
          'photo': _base64Image,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          check_Stamp_In = jsonResponse['stamp_in'];
          check_Stamp_Out = jsonResponse['stamp_out'];
        });
        print('$jsonResponse');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class GetTimeStampSim {
  final String branch_id;
  final String branch_lat;
  final String branch_lng;
  final String branch_name;
  final String branch_radius;
  final String branch_fixed;
  final String branch_default;
  final String stamp_in;
  final String stamp_out;

  GetTimeStampSim({
    required this.branch_id,
    required this.branch_lat,
    required this.branch_lng,
    required this.branch_name,
    required this.branch_radius,
    required this.branch_fixed,
    required this.branch_default,
    required this.stamp_in,
    required this.stamp_out,
  });

  factory GetTimeStampSim.fromJson(Map<String, dynamic> json) {
    return GetTimeStampSim(
      branch_id: json['branch_id'],
      branch_lat: json['branch_lat'],
      branch_lng: json['branch_lng'],
      branch_name: json['branch_name'],
      branch_radius: json['branch_radius'],
      branch_fixed: json['branch_fixed'],
      branch_default: json['branch_default'],
      stamp_in: json['stamp_in'],
      stamp_out: json['stamp_out'],
    );
  }
}
