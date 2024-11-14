import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../imports.dart';
import '../create_project/project_add.dart';

class ProjectEdit extends StatefulWidget {
  const ProjectEdit({
    Key? key,
    required this.employee, required this.pageInput, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _ProjectEditState createState() => _ProjectEditState();
}

class _ProjectEditState extends State<ProjectEdit> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _projectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  String _search = '';
  @override
  void initState() {
    super.initState();
    showDate();
    _fatchApi();
    _codeController.addListener(() {
      print("Current text: ${_codeController.text}");
    });
    _projectController.addListener(() {
      print("Current text: ${_projectController.text}");
    });
    _descriptionController.addListener(() {
      print("Current text: ${_descriptionController.text}");
    });
    _contactController.addListener(() {
      print("Current text: ${_contactController.text}");
    });
    _searchController.addListener(() {
      _search = _searchController.text;
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
              primary: Color(0xFFFF9900),
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
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Detail',
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
                _textBody('Project', _projectController, true),
                _DropdownContact('Contact'),
                _DropdownAccount('Account'),
                _DropdownSale('Sale/Non Sale'),//0,1 => Sale Project , Non Sale Project
                _DropdownModel('Project Model'),//0,1 => internal , external
                _textBody('Cost Value', _projectController, true),
                _DropdownSource('Source'),
                _textBody('Description', _descriptionController, true),
                Row(
                  children: [
                    Expanded(child: _DropdownType('Type')),
                    SizedBox(width: 8),
                    Expanded(child: _textBody('Code', _codeController, true)),
                  ],
                ),
                _DropdownCategory('Categories'),
                _DateBody('Start Date'),
                SizedBox(height: 8),
                _DateBody('End Date'),
                _DropdownProcess('Project Process'),
                _DropdownSubStatus('Sub Status'),
                _DropdownPriority('Project Priority'),
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
                    child: _textBody('Location', _locationController, false)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _DropdownContact(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<ContactData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: contactList
                .map((item) => DropdownMenuItem<ContactData>(
              value: item,
              child: Text(
                item.contact_name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedContact,
            onChanged: (value) {
              setState(() {
                selectedContact = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                    filled: true,
                    fillColor: Colors.white,
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
                return item.value!.contact_name!
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
  Widget _DropdownAccount(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<AccountData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: AccountList
                .map((item) => DropdownMenuItem<AccountData>(
              value: item,
              child: Text(
                item.account_name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedAccount,
            onChanged: (value) {
              setState(() {
                selectedAccount = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                    filled: true,
                    fillColor: Colors.white,
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
                return item.value!.account_name!
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
  Widget _DropdownType(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<TypeData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: TypeList
                .map((item) => DropdownMenuItem<TypeData>(
              value: item,
              child: Text(
                item.type_name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedType,
            onChanged: (value) {
              setState(() {
                selectedType = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                    filled: true,
                    fillColor: Colors.white,
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
                return item.value!.type_name
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
  Widget _DropdownSource(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<SourceData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: SourceList
                .map((item) => DropdownMenuItem<SourceData>(
              value: item,
              child: Text(
                item.source_name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedSource,
            onChanged: (value) {
              setState(() {
                selectedSource = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                    filled: true,
                    fillColor: Colors.white,
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
                return item.value!.source_name
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
  Widget _DropdownCategory(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<CategoryData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: CategoryList
                .map((item) => DropdownMenuItem<CategoryData>(
              value: item,
              child: Text(
                item.categories_name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedCategory,
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                    filled: true,
                    fillColor: Colors.white,
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
                return item.value!.categories_name
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
  Widget _DropdownProcess(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<ProcessData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: ProcessList
                .map((item) => DropdownMenuItem<ProcessData>(
              value: item,
              child: Text(
                item.process_name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedProcess,
            onChanged: (value) {
              setState(() {
                selectedProcess = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                    filled: true,
                    fillColor: Colors.white,
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
                return item.value!.process_name
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
  Widget _DropdownPriority(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<PriorityData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: PriorityList
                .map((item) => DropdownMenuItem<PriorityData>(
              value: item,
              child: Text(
                item.priority_name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedPriority,
            onChanged: (value) {
              setState(() {
                selectedPriority = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                    filled: true,
                    fillColor: Colors.white,
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
                return item.value!.priority_name
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
  Widget _DropdownSubStatus(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<SubStatusData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: SubStatusList
                .map((item) => DropdownMenuItem<SubStatusData>(
              value: item,
              child: Text(
                item.sub_status_name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedSubStatus,
            onChanged: (value) {
              setState(() {
                selectedSubStatus = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                    filled: true,
                    fillColor: Colors.white,
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
                return item.value!.sub_status_name
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

  Widget _DropdownSale(String title) {
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
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<SaleData>(
            isExpanded: true,
            hint: Text(
              'Select Sale',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: SaleDataList
                .map((item) => DropdownMenuItem<SaleData>(
              value: item,
              child: Text(
                item.sale_name,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedSaleData,
            onChanged: (value) {
              setState(() {
                selectedSaleData = value;
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                return item.value!.sale_name
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

  Widget _DropdownModel(String title) {
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
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<ProjectModelData>(
            isExpanded: true,
            hint: Text(
              'Select Model',
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: ProjectModelList
                .map((item) => DropdownMenuItem<ProjectModelData>(
              value: item,
              child: Text(
                item.project_model_name,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedProjectModel,
            onChanged: (value) {
              setState(() {
                selectedProjectModel = value;
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
                return item.value!.project_model_name
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

  ProjectModelData? selectedProjectModel;
  List<ProjectModelData> ProjectModelList = [
    ProjectModelData(project_model_id: '0', project_model_name: 'Sale Project'),
    ProjectModelData(project_model_id: '1', project_model_name: 'Non Sale Project'),
  ];

  SaleData? selectedSaleData;
  List<SaleData> SaleDataList = [
    SaleData(sale_id: '0', sale_name: 'internal'),
    SaleData(sale_id: '1', sale_name: 'external'),
  ];

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
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: (_selectedLocation == null || _isTrue == true)
                ? ''
                : '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
            hintStyle:
            GoogleFonts.openSans(fontSize: 14, color: Color(0xFF555555)),
            suffixIcon: Container(
              alignment: Alignment.centerRight,
              width: 10,
              child: Center(
                child: IconButton(
                    onPressed: () {},
                    icon:
                    Icon((title != 'Location') ? null : Icons.location_on),
                    color: Color(0xFFFF9900),
                    iconSize: 18),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF9900),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xFFFF9900), // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
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

  Widget _DateBody(String _nemedate) {
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
              color: Color(0xFFFF9900),
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
                    color: Color(0xFFFF9900),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _fatchApi(){
    _fetchContact();
    _fetchAccount();
    _fetchType();
    _fetchSource();
    _fetchCategory();
    _fetchProcess();
    _fetchPriority();
    _fetchSubStatus();
  }

  ContactData? selectedContact;
  List<ContactData> contactList = [];
  Future<void> _fetchContact() async {
    final uri = Uri.parse(
        '$host/api/origami/need/contact.php?page=&search=$_search');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['contact_data'];
        setState(() {
          contactList =
              dataJson.map((json) => ContactData.fromJson(json)).toList();
          if (contactList.isNotEmpty && selectedContact == null) {
            selectedContact = contactList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  AccountData? selectedAccount;
  List<AccountData> AccountList = [];
  Future<void> _fetchAccount() async {
    final uri = Uri.parse(
        '$host/api/origami/need/account.php?page=&search=$_search');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['account_data'];
        setState(() {
          AccountList =
              dataJson.map((json) => AccountData.fromJson(json)).toList();
          if (AccountList.isNotEmpty && selectedAccount == null) {
            selectedAccount = AccountList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  TypeData? selectedType;
  List<TypeData> TypeList = [];
  Future<void> _fetchType() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/type.php?search=$_search');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index':'',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['type_data'];
        setState(() {
          TypeList =
              dataJson.map((json) => TypeData.fromJson(json)).toList();
          if (TypeList.isNotEmpty && selectedType == null) {
            selectedType = TypeList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  SourceData? selectedSource;
  List<SourceData> SourceList = [];
  Future<void> _fetchSource() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/source.php?search=$_search');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index':''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['source_data'];
        setState(() {
          SourceList =
              dataJson.map((json) => SourceData.fromJson(json)).toList();
          if (SourceList.isNotEmpty && selectedSource == null) {
            selectedSource = SourceList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  CategoryData? selectedCategory;
  List<CategoryData> CategoryList = [];
  Future<void> _fetchCategory() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/category.php?search=$_search');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index':''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['categories_data'];
        setState(() {
          CategoryList =
              dataJson.map((json) => CategoryData.fromJson(json)).toList();
          if (CategoryList.isNotEmpty && selectedCategory == null) {
            selectedCategory = CategoryList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  ProcessData? selectedProcess;
  List<ProcessData> ProcessList = [];
  Future<void> _fetchProcess() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/process.php?search=$_search');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index':''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['process_data'];
        setState(() {
          ProcessList =
              dataJson.map((json) => ProcessData.fromJson(json)).toList();
          if (ProcessList.isNotEmpty && selectedProcess == null) {
            selectedProcess = ProcessList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  PriorityData? selectedPriority;
  List<PriorityData> PriorityList = [];
  Future<void> _fetchPriority() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/priority.php?search=$_search');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index':''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['priority_data'];
        setState(() {
          PriorityList =
              dataJson.map((json) => PriorityData.fromJson(json)).toList();
          if (PriorityList.isNotEmpty && selectedPriority == null) {
            selectedPriority = PriorityList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  SubStatusData? selectedSubStatus;
  List<SubStatusData> SubStatusList = [];
  Future<void> _fetchSubStatus() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/substatus.php?search=$_search');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index':''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['sub_status_data'];
        setState(() {
          SubStatusList =
              dataJson.map((json) => SubStatusData.fromJson(json)).toList();
          if (SubStatusList.isNotEmpty && selectedSubStatus == null) {
            selectedSubStatus = SubStatusList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

}