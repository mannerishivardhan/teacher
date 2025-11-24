import 'package:flutter/material.dart';
import '../models/attendance_models.dart';
import 'shortage_results_screen.dart';

class AttendanceShortageScreen extends StatefulWidget {
  const AttendanceShortageScreen({super.key});

  @override
  State<AttendanceShortageScreen> createState() => _AttendanceShortageScreenState();
}

class _AttendanceShortageScreenState extends State<AttendanceShortageScreen> {
  final _formKey = GlobalKey<FormState>();

  // Filter values
  FilterOption? selectedCourse;
  FilterOption? selectedBranch;
  String? selectedYear;
  String? selectedSemester;
  String? selectedSection;
  FilterOption? selectedSubject;
  double minPercentage = 0;
  double maxPercentage = 75;

  // Dynamic data
  List<FilterOption> courses = [];
  List<FilterOption> branches = [];
  List<FilterOption> subjects = [];
  final List<String> years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  final List<String> sections = ['A', 'B', 'C', 'D'];

  bool isLoadingFilters = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoadingFilters = true);
    
    // Mock data - replace with API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      courses = [
        FilterOption(id: '1', name: 'B.Tech'),
        FilterOption(id: '2', name: 'M.Tech'),
        FilterOption(id: '3', name: 'BBA'),
        FilterOption(id: '4', name: 'MBA'),
      ];
      isLoadingFilters = false;
    });
  }

  Future<void> _loadBranches(String courseId) async {
    setState(() => isLoadingFilters = true);
    
    // Mock data - replace with API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    setState(() {
      branches = [
        FilterOption(id: '1', name: 'CSE'),
        FilterOption(id: '2', name: 'ECE'),
        FilterOption(id: '3', name: 'ME'),
        FilterOption(id: '4', name: 'CE'),
        FilterOption(id: '5', name: 'EEE'),
        FilterOption(id: '6', name: 'IT'),
        FilterOption(id: '7', name: 'AIDS'),
      ];
      isLoadingFilters = false;
    });
  }

  Future<void> _loadSubjects(String branchId) async {
    setState(() => isLoadingFilters = true);
    
    // Mock data - replace with API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    setState(() {
      subjects = [
        FilterOption(id: '1', name: 'All Subjects'),
        FilterOption(id: '2', name: 'Artificial Intelligence'),
        FilterOption(id: '3', name: 'Computer Networks'),
        FilterOption(id: '4', name: 'Computer Organization'),
        FilterOption(id: '5', name: 'Data Structures'),
      ];
      isLoadingFilters = false;
    });
  }

  void _checkShortage() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShortageResultsScreen(
            courseName: selectedCourse?.name,
            branchName: selectedBranch?.name,
            year: selectedYear,
            semester: selectedSemester,
            section: selectedSection,
            subjectName: selectedSubject?.name,
            minPercentage: minPercentage,
            maxPercentage: maxPercentage,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Attendance Shortage',
          style: TextStyle(color: Color(0xFF1a1f3a), fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1a1f3a)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              
              // Percentage Range Filter
              _buildFilterCard([
                const Text(
                  'Percentage Range',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a1f3a),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPercentageSlider(),
              ]),
              
              const SizedBox(height: 16),
              
              // Academic Filters
              _buildFilterCard([
                const Text(
                  'Academic Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a1f3a),
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  'Course',
                  courses,
                  selectedCourse,
                  (val) {
                    setState(() {
                      selectedCourse = val;
                      selectedBranch = null;
                      selectedSubject = null;
                      branches = [];
                      subjects = [];
                    });
                    if (val != null) _loadBranches(val.id);
                  },
                  validator: (val) => val == null ? 'Please select a course' : null,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        'Branch',
                        branches,
                        selectedBranch,
                        (val) {
                          setState(() {
                            selectedBranch = val;
                            selectedSubject = null;
                            subjects = [];
                          });
                          if (val != null) _loadSubjects(val.id);
                        },
                        enabled: branches.isNotEmpty,
                        validator: (val) => val == null ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStringDropdown(
                        'Year',
                        years,
                        selectedYear,
                        (val) => setState(() => selectedYear = val),
                        validator: (val) => val == null ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildStringDropdown(
                        'Semester',
                        semesters,
                        selectedSemester,
                        (val) => setState(() => selectedSemester = val),
                        validator: (val) => val == null ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStringDropdown(
                        'Section',
                        sections,
                        selectedSection,
                        (val) => setState(() => selectedSection = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  'Subject (Optional)',
                  subjects,
                  selectedSubject,
                  (val) => setState(() => selectedSubject = val),
                  enabled: subjects.isNotEmpty,
                ),
              ]),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _checkShortage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFef4444),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: const Color(0xFFef4444).withValues(alpha: 0.4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Check Shortage',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFef4444), Color(0xFFdc2626)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFef4444).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shortage Check',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Find students with low attendance',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildPercentageSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Min: ${minPercentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1f3a),
              ),
            ),
            Text(
              'Max: ${maxPercentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1f3a),
              ),
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(minPercentage, maxPercentage),
          min: 0,
          max: 100,
          divisions: 20,
          activeColor: const Color(0xFFef4444),
          inactiveColor: const Color(0xFFef4444).withValues(alpha: 0.2),
          labels: RangeLabels(
            '${minPercentage.toStringAsFixed(0)}%',
            '${maxPercentage.toStringAsFixed(0)}%',
          ),
          onChanged: (values) {
            setState(() {
              minPercentage = values.start;
              maxPercentage = values.end;
            });
          },
        ),
        Text(
          'Students with attendance between ${minPercentage.toStringAsFixed(0)}% and ${maxPercentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<FilterOption> items,
    FilterOption? value,
    void Function(FilterOption?) onChanged, {
    bool enabled = true,
    String? Function(FilterOption?)? validator,
  }) {
    return DropdownButtonFormField<FilterOption>(
      value: value,
      items: items.isEmpty
          ? null
          : items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item.name,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFef4444), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFef4444), width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFef4444), width: 2),
        ),
        filled: true,
        fillColor: enabled ? const Color(0xFFF8FAFC) : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      isExpanded: true,
    );
  }

  Widget _buildStringDropdown(
    String label,
    List<String> items,
    String? value,
    void Function(String?) onChanged, {
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFef4444), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFef4444), width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFef4444), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      isExpanded: true,
    );
  }
}
