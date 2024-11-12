// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import '../../../imports.dart';
//
// class ProjectActivity extends StatefulWidget {
//   const ProjectActivity({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _ProjectActivityState createState() => _ProjectActivityState();
// }
//
// class _ProjectActivityState extends State<ProjectActivity> {
//   TextEditingController _searchController = TextEditingController();
//   ModelProject? project;
//   String _search = "";
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(() {
//       _search = _searchController.text;
//       print("Current text: ${_searchController.text}");
//     });
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
//       backgroundColor: Colors.white,
//       body: _getContentWidget(),
//     );
//   }
//
//   Widget _getContentWidget() {
//     return Column(
//       children: [
//         Container(
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//               controller: _searchController,
//               keyboardType: TextInputType.text,
//               style: GoogleFonts.openSans(
//                 color: Color(0xFF555555),
//                 fontSize: 14,
//               ),
//               decoration: InputDecoration(
//                 isDense: true,
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//                 hintText: 'Search...',
//                 hintStyle: GoogleFonts.openSans(
//                     fontSize: 14, color: Color(0xFF555555)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: Color(0xFFFF9900),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
//                     width: 1.0,
//                   ),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
//                     width: 1.0,
//                   ),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return Column(
//                   children: [
//                     Card(
//                       color: Colors.white,
//                       elevation: 0,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: InkWell(
//                           onTap: () {},
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 5),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 CircleAvatar(
//                                   radius: 25,
//                                   backgroundColor: Colors.grey,
//                                   child: CircleAvatar(
//                                     radius: 24,
//                                     backgroundColor: Colors.white,
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(50),
//                                       child: Image.network(
//                                         'https://www.origami.life/uploads/employee/5/employee/19777.jpg?v=1729754401',
//                                         fit: BoxFit.fill,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Title ${index + 1}',
//                                         maxLines: 1,
//                                         style: GoogleFonts.openSans(
//                                           fontSize: 14,
//                                           color: Color(0xFFFF9900),
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       Text(
//                                         'SubTitile',
//                                         maxLines: 1,
//                                         style: GoogleFonts.openSans(
//                                           fontSize: 12,
//                                           color: Color(0xFF555555),
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         '2024/10/28 - 2025/10/31',
//                                         maxLines: 1,
//                                         style: GoogleFonts.openSans(
//                                           fontSize: 12,
//                                           color: Colors.grey,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         'Type: Test Project 2',
//                                         maxLines: 1,
//                                         style: GoogleFonts.openSans(
//                                           fontSize: 12,
//                                           color: Colors.grey,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8,right: 8),
//                       child: Divider(),
//                     )
//                   ],
//                 );
//               }),
//         ),
//       ],
//     );
//   }
//
// }
