import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../imports.dart';
import 'create_project/project_add.dart';
import 'update_project/project_list_edit.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  TextEditingController _searchController = TextEditingController();

  String _search = "";
  @override
  void initState() {
    super.initState();
    if (widget.pageInput == 'project') {
      fetchModelProject();
      _searchController.addListener(() {
        setState(() {
          _search = _searchController.text;
          allModelProject.clear();
          fetchModelProject();
        });
      });
    } else if (widget.pageInput == 'contact') {
      _searchController.addListener(() {
        setState(() {
          _search = _searchController.text;
        });
      });
    } else if (widget.pageInput == 'account') {
      _searchController.addListener(() {
        setState(() {
          _search = _searchController.text;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectAdd(
                employee: widget.employee,
                Authorization: widget.Authorization,
                pageInput: widget.pageInput,
              ),
            ),
          ).then((value) {
            if (widget.pageInput == 'contact') {
            } else {
              setState(() {
                indexStr = 0;
                allModelProject.clear();
                fetchModelProject();
              });
            }
          });
        },
        child: const Icon(
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
        backgroundColor: Color(0xFFFF9900),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                hintText: 'Search...',
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
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Expanded(child: _loading()),
        ],
      ),
    );
  }

  Widget _loading() {
    return FutureBuilder<void>(
      future: (widget.pageInput == 'project') ? fetchModelProject() : null,
      builder: (context, snapshot) {
        final allModel = allModelProject;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFFFF9900),
                ),
                SizedBox(width: 12),
                Text(
                  '$Loading...',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          );
        } else if (allModel.isEmpty) {
          return Center(
            child: Text(
              '$Empty',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          );
        } else {
          return _getContentWidget(allModel);
        }
      },
    );
  }

  Widget _getContentWidget(List<ModelProject> allModel) {
    allModel = allModel.toSet().toList();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
            itemCount: allModel.length + 1,
            itemBuilder: (context, index) {
              final project = allModel[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectListUpdate(
                            employee: widget.employee,
                            Authorization: widget.Authorization,
                            project: project,
                            pageInput: widget.pageInput,
                          ),
                        ),
                      ).then((value) {
                        // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
                        setState(() {
                          indexStr = 0;
                          allModel.clear();
                          fetchModelProject(); // เรียกฟังก์ชันโหลด API ใหม่
                        });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 4, right: 8),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xFFFF9900),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Color(0xFFFF9900),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Text(
                                  project.project_name!.substring(0, 1),
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
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.project_name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                project.project_account,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  int indexItems = 0;
  List<ModelProject> allModelProject = [];
  Future<void> fetchModelProject() async {
    final uri =
        Uri.parse("$host/api/origami/crm/project/get.php?search=$_search");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'index': (_search != '') ? '' : indexItems.toString(),
        'txt_search': _search,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['project_data'];
      int limit = jsonResponse['limit'];
      List<ModelProject> newProjects =
          dataJson.map((json) => ModelProject.fromJson(json)).toList();
      newProjects.toSet().toList();
      // เก็บข้อมูลเก่าและรวมกับข้อมูลใหม่
      allModelProject.addAll(newProjects);

      // เช็คเงื่อนไขตามที่ต้องการ
      // if (_search == '') {
      //   if (limit > indexItems) {
      //     indexItems = indexItems + max;
      //     if (indexItems >= limit) {
      //       indexItems = 0;
      //       _search == '0';
      //     }
      //     await fetchModelProject(); // โหลดข้อมูลใหม่เมื่อ index เปลี่ยน
      //   } else if (limit <= indexItems) {
      //     indexItems = 0;
      //     _search == '0';
      //   }
      // }
    } else {
      throw Exception('Failed to load projects');
    }
  }

  bool isLoading = false;
  int? indexStr = 0;
}

class ModelProject {
  final String project_id;
  final String project_code;
  final String project_name;
  final String project_create;
  final String owner_name;
  final String owner_avatar;
  final String last_activity;
  final String project_account;
  final String project_sale_nonsale;
  final String project_type;
  final String project_status;
  final String project_process;
  final String project_sale_status;
  final String opportunity_line1;
  final String opportunity_line2;
  final String opportunity_line3;
  final String project_category;
  final String project_source;
  final String project_model;
  final String project_pin;
  final String project_display;
  final String can_edit;
  final String can_delete;

  ModelProject({
    required this.project_id,
    required this.project_code,
    required this.project_name,
    required this.project_create,
    required this.owner_name,
    required this.owner_avatar,
    required this.last_activity,
    required this.project_account,
    required this.project_sale_nonsale,
    required this.project_type,
    required this.project_status,
    required this.project_process,
    required this.project_sale_status,
    required this.opportunity_line1,
    required this.opportunity_line2,
    required this.opportunity_line3,
    required this.project_category,
    required this.project_source,
    required this.project_model,
    required this.project_pin,
    required this.project_display,
    required this.can_edit,
    required this.can_delete,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelProject.fromJson(Map<String, dynamic> json) {
    return ModelProject(
      project_id: json['project_id'],
      project_code: json['project_code'],
      project_name: json['project_name'],
      project_create: json['project_create'],
      owner_name: json['owner_name'],
      owner_avatar: json['owner_avatar'],
      last_activity: json['last_activity'],
      project_account: json['project_account'],
      project_sale_nonsale: json['project_sale_nonsale'],
      project_type: json['project_type'],
      project_status: json['project_status'],
      project_process: json['project_process'],
      project_sale_status: json['project_sale_status'],
      opportunity_line1: json['opportunity_line1'],
      opportunity_line2: json['opportunity_line2'],
      opportunity_line3: json['opportunity_line3'],
      project_category: json['project_category'],
      project_source: json['project_source'],
      project_model: json['project_model'],
      project_pin: json['project_pin'],
      project_display: json['project_display'],
      can_edit: json['can_edit'],
      can_delete: json['can_delete'],
    );
  }
}
