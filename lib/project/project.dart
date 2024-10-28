import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origami_ios/project/view/project_detail.dart';
import '../../../imports.dart';
import 'create_project/project_add.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;

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
      // fetchModelProjectVoid();
    } else if(widget.pageInput == 'contact'){

    }
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text;
        allModelProject.clear();
        fetchModelProjectVoid();
      });

      print("Current text: ${_searchController.text}");
    });
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
              builder: (context) => projectAdd(
                employee: widget.employee,
                pageInput: widget.pageInput,
              ),
            ),
          ).then((value) {
            if (widget.pageInput == 'contact') {
            } else {
              setState(() {
                indexStr = 0;
                allModelProject.clear();
                fetchModelProjectVoid();
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
        backgroundColor: Colors.orange,
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
                  color: Colors.orange,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange, // ขอบสีส้มตอนที่โฟกัส
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
      future: (widget.pageInput == 'project') ? fetchModelProjectVoid() : null,
      builder: (context, snapshot) {
        final allModel = allModelProject;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.orange,
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
            itemCount: allModel.length+1,
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
                          builder: (context) => ProjectView(
                            employee: widget.employee,
                            project: project,
                            pageInput: widget.pageInput,
                          ),
                        ),
                      ).then((value) {
                        // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
                        setState(() {
                          indexStr = 0;
                          allModel.clear();
                          fetchModelProjectVoid(); // เรียกฟังก์ชันโหลด API ใหม่
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
                            backgroundColor: Colors.orange,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.orange,
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
                                '${project.project_name!}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                project.m_company!,
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
  Future<void> fetchModelProjectVoid() async {
    final uri = Uri.parse("https://www.origami.life/crm/project.php");
    final response = await http.post(
      uri,
      body: {
        'comp_id': widget.employee.comp_id,
        'idemp': widget.employee.emp_id,
        'user': 'origami',
        'pass': widget.employee.auth_password,
        'index': (_search != '') ? '0' : indexItems.toString(),
        'txt_search': _search,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'];
      int max = jsonResponse['max'];
      int sum = jsonResponse['sum'];
      List<ModelProject> newProjects =
          dataJson.map((json) => ModelProject.fromJson(json)).toList();
      newProjects.toSet().toList();
      // เก็บข้อมูลเก่าและรวมกับข้อมูลใหม่
      allModelProject.addAll(newProjects);

      // เช็คเงื่อนไขตามที่ต้องการ
      // if (_search == '') {
      //   if (sum > indexItems) {
      //     indexItems = indexItems + max;
      //     if (indexItems >= sum) {
      //       indexItems = 0;
      //       _search == '0';
      //     }
      //     await fetchModelProjectVoid(); // โหลดข้อมูลใหม่เมื่อ index เปลี่ยน
      //   } else if (sum <= indexItems) {
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
  String? project_id;
  String? project_name;
  String? project_latitude;
  String? project_longtitude;
  String? project_start;
  String? project_end;
  String? project_all_total;
  String? m_company;
  String? project_create_date;
  String? emp_id;
  String? project_value;
  String? project_type_name;
  String? project_description;
  String? project_sale_status_name;
  String? project_oppo_reve;
  String? comp_id;
  String? typeIds;
  String? salestatusIds;
  String? main_contact;
  String? cont_id;
  String? projct_location;
  String? cus_id;

  ModelProject({
    this.project_id,
    this.project_name,
    this.project_latitude,
    this.project_longtitude,
    this.project_start,
    this.project_end,
    this.project_all_total,
    this.m_company,
    this.project_create_date,
    this.emp_id,
    this.project_value,
    this.project_type_name,
    this.project_description,
    this.project_sale_status_name,
    this.project_oppo_reve,
    this.comp_id,
    this.typeIds,
    this.salestatusIds,
    this.main_contact,
    this.cont_id,
    this.projct_location,
    this.cus_id,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelProject.fromJson(Map<String, dynamic> json) {
    return ModelProject(
      project_id: json['project_id'],
      project_name: json['project_name'],
      project_latitude: json['project_latitude'],
      project_longtitude: json['project_longtitude'],
      project_start: json['project_start'],
      project_end: json['project_end'],
      project_all_total: json['project_all_total'],
      m_company: json['m_company'],
      project_create_date: json['project_create_date'],
      emp_id: json['emp_id'],
      project_value: json['project_value'],
      project_type_name: json['project_type_name'],
      project_description: json['project_description'],
      project_sale_status_name: json['project_sale_status_name'],
      project_oppo_reve: json['project_oppo_reve'],
      comp_id: json['comp_id'],
      typeIds: json['typeIds'],
      salestatusIds: json['salestatusIds'],
      main_contact: json['main_contact'],
      cont_id: json['cont_id'],
      projct_location: json['projct_location'],
      cus_id: json['cus_id'],
    );
  }
}
