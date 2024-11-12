// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:origami_ios/project/project_add.dart';
// import 'package:origami_ios/project/project_detail.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../login/login.dart';
// import '../language/translate.dart';
//
// class ProjectScreenBack extends StatefulWidget {
//   const ProjectScreenBack({
//     Key? key,
//     required this.employee,
//   }) : super(key: key);
//   final Employee employee;
//
//   @override
//   _ProjectScreenBackState createState() => _ProjectScreenBackState();
// }
//
// class _ProjectScreenBackState extends State<ProjectScreenBack> {
//   TextEditingController _searchController = TextEditingController();
//
//   String _search = "";
//   @override
//   void initState() {
//     super.initState();
//     // _scrollController.addListener(_onScroll);
//     // _loadMoreAccounts();
//     fetchModelProjectVoid();
//   }
//
//   @override
//   void dispose() {
//     // _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         // tooltip: 'Increment',
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => projectAdd(
//                 employee: widget.employee,
//               ),
//             ),
//           );
//         },
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(100),
//             bottomLeft: Radius.circular(100),
//             bottomRight: Radius.circular(100),
//             topLeft: Radius.circular(100),
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: Color(0xFFFF9900),
//       ),
//       body: _loading(),
//     );
//   }
//
//   Widget _loading() {
//     return FutureBuilder<List<ModelProject>>(
//       future: fetchModelProjectVoid(),
//       builder: (context, snapshot) {
//         if (allProjects.isEmpty) {
//           return (loadNew != null)
//               ? Center(
//                   child: Text(
//                     '$Empty',
//                     style: GoogleFonts.openSans(
//                       color: const Color(0xFF555555),
//                     ),
//                   ),
//                 )
//               : Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         color: Color(0xFFFF9900),
//                       ),
//                       SizedBox(width: 12),
//                       Text(
//                         '$Loading...',
//                         style: GoogleFonts.openSans(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF555555),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//         } else {
//           return Container(
//             color: Colors.white,
//             child: _getContentWidget(allProjects),
//           );
//         }
//       },
//     );
//   }
//
//   Widget _getContentWidget(List<ModelProject>? data) {
//     // กรองข้อมูลตามคำค้นหา
//     List<ModelProject> filtered = data!.where((filter) {
//       String searchTerm = _searchController.text.toLowerCase();
//       String fullName = '${filter.project_name}'.toLowerCase();
//       return fullName.contains(searchTerm);
//     }).toList();
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextFormField(
//             controller: _searchController,
//             keyboardType: TextInputType.text,
//             style: GoogleFonts.openSans(
//               color: Color(0xFF555555),
//               fontSize: 14,
//             ),
//             decoration: InputDecoration(
//               isDense: true,
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//               hintText: 'Search...',
//               hintStyle:
//                   GoogleFonts.openSans(fontSize: 14, color: Color(0xFF555555)),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               prefixIcon: Icon(
//                 Icons.search,
//                 color: Color(0xFFFF9900),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Card(
//             elevation: 0,
//             color: Colors.white,
//             // color: Color(0xFFF5F5F5),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: ListView.builder(
//                   itemCount: filtered.length,
//                   itemBuilder: (context, index) {
//                     final project = filtered[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 5),
//                       child: Card(
//                         elevation: 0,
//                         color: Colors.white,
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ProjectView(
//                                   employee: widget.employee,
//                                   project: project,
//                                 ),
//                               ),
//                             ).then((value) {
//                               // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
//                               setState(() {
//                                 fetchModelProjectVoid(); // เรียกฟังก์ชันโหลด API ใหม่
//                               });
//                             });
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             // mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 4, bottom: 4, right: 8),
//                                 child: CircleAvatar(
//                                   radius: 25,
//                                   backgroundColor: Color(0xFFFF9900),
//                                   child: CircleAvatar(
//                                     radius: 24,
//                                     backgroundColor: Color(0xFFFF9900),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(50),
//                                       child: Text(
//                                         project.project_name!.substring(0, 1),
//                                         style: GoogleFonts.openSans(
//                                           fontSize: 24,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '${project.project_name!}',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: GoogleFonts.openSans(
//                                         fontSize: 18,
//                                         color: Color(0xFF555555),
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       project.m_company!,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: GoogleFonts.openSans(
//                                         fontSize: 14,
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   bool isLoading = false;
//   int? indexStr = 0;
//   List<ModelProject> allProjects = [];
//   List<ModelProject> newProjects = [];
//   ModelProject? loadNew;
//   Future<List<ModelProject>> fetchModelProjectVoid() async {
//     final uri = Uri.parse("https://www.origami.life/crm/project.php");
//     final response = await http.post(
//       uri,
//       body: {
//         'comp_id': widget.employee.comp_id,
//         'idemp': widget.employee.emp_id,
//         'user': 'origami',
//         'pass': widget.employee.auth_password,
//         'index': indexStr?.toString() ?? '',
//         'txt_search': '',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);
//       // เข้าถึงข้อมูลในคีย์ 'instructors'
//       final List<dynamic> dataJson = jsonResponse['data'];
//       int max = jsonResponse['max'];
//       int sum = jsonResponse['sum'];
//
//       newProjects =
//           dataJson.map((json) => ModelProject.fromJson(json)).toList();
//
//       // เก็บข้อมูลเก่าและรวมกับข้อมูลใหม่
//       allProjects.addAll(newProjects);
//       loadNew = newProjects[0];
//       // เช็คเงื่อนไขตามที่ต้องการ
//       if (sum == max) {
//         indexStr = (indexStr ?? 0) + 20; // เพิ่ม index ขึ้น 20
//         if ((indexStr ?? 0) >= sum) {
//           indexStr = (indexStr ?? 0) + max;
//         }
//         await fetchModelProjectVoid(); // โหลดข้อมูลใหม่เมื่อ index เปลี่ยน
//       } else if (sum < max) {
//         indexStr = max; // กำหนด index เท่ากับ max เมื่อ sum น้อยกว่า max
//       }
//       return dataJson.map((json) => ModelProject.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load instructors');
//     }
//   }
// }
//
// class ModelProject {
//   String? project_id;
//   String? project_name;
//   String? project_latitude;
//   String? project_longtitude;
//   String? project_start;
//   String? project_end;
//   String? project_all_total;
//   String? m_company;
//   String? project_create_date;
//   String? emp_id;
//   String? project_value;
//   String? project_type_name;
//   String? project_description;
//   String? project_sale_status_name;
//   String? project_oppo_reve;
//   String? comp_id;
//   String? typeIds;
//   String? salestatusIds;
//   String? main_contact;
//   String? cont_id;
//   String? projct_location;
//   String? cus_id;
//
//   ModelProject({
//     this.project_id,
//     this.project_name,
//     this.project_latitude,
//     this.project_longtitude,
//     this.project_start,
//     this.project_end,
//     this.project_all_total,
//     this.m_company,
//     this.project_create_date,
//     this.emp_id,
//     this.project_value,
//     this.project_type_name,
//     this.project_description,
//     this.project_sale_status_name,
//     this.project_oppo_reve,
//     this.comp_id,
//     this.typeIds,
//     this.salestatusIds,
//     this.main_contact,
//     this.cont_id,
//     this.projct_location,
//     this.cus_id,
//   });
//
//   // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
//   factory ModelProject.fromJson(Map<String, dynamic> json) {
//     return ModelProject(
//       project_id: json['project_id'],
//       project_name: json['project_name'],
//       project_latitude: json['project_latitude'],
//       project_longtitude: json['project_longtitude'],
//       project_start: json['project_start'],
//       project_end: json['project_end'],
//       project_all_total: json['project_all_total'],
//       m_company: json['m_company'],
//       project_create_date: json['project_create_date'],
//       emp_id: json['emp_id'],
//       project_value: json['project_value'],
//       project_type_name: json['project_type_name'],
//       project_description: json['project_description'],
//       project_sale_status_name: json['project_sale_status_name'],
//       project_oppo_reve: json['project_oppo_reve'],
//       comp_id: json['comp_id'],
//       typeIds: json['typeIds'],
//       salestatusIds: json['salestatusIds'],
//       main_contact: json['main_contact'],
//       cont_id: json['cont_id'],
//       projct_location: json['projct_location'],
//       cus_id: json['cus_id'],
//     );
//   }
// }
