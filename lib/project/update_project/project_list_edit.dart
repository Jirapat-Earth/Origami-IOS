import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origami_ios/project/update_project/project_edit.dart';
import 'package:origami_ios/project/update_project/project_other_view/project_other_view.dart';
import '../../../imports.dart';
import '../../activity/edit/activity_edit_now.dart';
import '../../activity/skoop/skoop.dart';
import 'project_activity.dart';
import 'project_skoop.dart';

class ProjectListUpdate extends StatefulWidget {
  const ProjectListUpdate({
    Key? key,
    required this.employee,
    required this.project,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final ModelProject project;
  final String pageInput;
  final String Authorization;
  @override
  _ProjectListUpdateState createState() => _ProjectListUpdateState();
}

class _ProjectListUpdateState extends State<ProjectListUpdate> {
  TextEditingController _searchController = TextEditingController();
  ModelProject? project;
  String _search = "";
  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);
    // _loadMoreAccounts();
    project = widget.project;
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.info,
      title: 'Detail',
    ),
    TabItem(
      icon: Icons.accessibility_new,
      title: 'Activity',
    ),
    TabItem(
      icon: FontAwesomeIcons.podcast,
      title: 'Skoop',
    ),
    TabItem(
      icon: Icons.calendar_month,
      title: 'Calendar',
    ),
    TabItem(
      icon: Icons.more_horiz,
      title: 'Other',
    ),
  ];

  int _selectedIndex = 0;

  String page = "Detail";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Detail";
      } else if (index == 1) {
        page = "Activity";
      } else if (index == 2) {
        page = "Skoop";
      } else if (index == 3) {
        page = "Calendar";
      } else if (index == 4) {
        page = "Other";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${page}',
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
        actions: [],
      ),
      body: _getContentWidget(),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: GoogleFonts.openSans(),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
    );
  }

  // List<GetSkoopDetail> getSkoopDetail = [];
  String skoopDetail = 'Close'; //'Close' or 'Plan'
  Widget _getContentWidget() {
    switch (_selectedIndex) {
      case 0:
        return _ProjectDetail();
      case 1:
        return ActivityScreen(
          employee: widget.employee,
          Authorization: widget.Authorization,
          pageInput: widget.pageInput,
        ); //'Close' or 'Plan'
      case 2:
        return SkoopScreen(
          employee: widget.employee,
          Authorization: widget.Authorization,
          skoopDetail: null,
        );
      case 3:
        return CalendarScreen(
            employee: widget.employee,
            Authorization: widget.Authorization,
            pageInput: widget.pageInput);
      default:
        return ProjectOther(
            employee: widget.employee,
            Authorization: widget.Authorization,
            pageInput: widget.pageInput);
    }
  }

  Widget _ProjectDetail() {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectEdit(
                      employee: widget.employee,
                      Authorization: widget.Authorization,
                      pageInput: widget.pageInput,
                    ),
                  ),
                ).then((value) {
                  // if (widget.pageInput == 'contact') {
                  // } else {
                  //   setState(() {
                  //     indexStr = 0;
                  //     allModelProject.clear();
                  //     fetchModelProjectVoid();
                  //   });
                  // }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 3), // x, y
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Origami',
                        maxLines: 2,
                        style: GoogleFonts.openSans(
                          fontSize: 30,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _subData('Main Contact', project?.owner_name ?? ''),
                      _subData('Company', project?.project_account ?? ''),
                      _subData('Type', project?.project_type ?? ''),
                      Row(
                        children: [
                          Expanded(child: _subData('Date', project?.project_create ?? '')),
                          Expanded(child: _subData('to', project?.last_activity ?? '')),
                        ],
                      ),
                      _subData('Description', project?.project_name ?? ''),
                      _subData('Sale Status', project?.project_sale_status ?? ''),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    fetchDeleteProject();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        Text(
                          'DELETE',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 16)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _subData(String sub, String dataProject) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Row(
          children: [
            Text(
              '$sub : ',
              maxLines: 1,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            Flexible(
              child: Text(
                dataProject,
                maxLines: 1,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchDeleteProject() async {
    final uri = Uri.parse("$host/crm/delete_project.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'idemp': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'projectId': widget.project.project_id,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
