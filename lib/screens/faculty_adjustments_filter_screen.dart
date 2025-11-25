import 'package:flutter/material.dart';
import 'faculty_adjustments_timetable_screen.dart';

class FacultyAdjustmentsFilterScreen extends StatefulWidget {
  const FacultyAdjustmentsFilterScreen({super.key});

  @override
  State<FacultyAdjustmentsFilterScreen> createState() => _FacultyAdjustmentsFilterScreenState();
}

class _FacultyAdjustmentsFilterScreenState extends State<FacultyAdjustmentsFilterScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCourse;
  String? selectedBranch;
  String? selectedSemester;
  String? selectedYear;
  String? selectedSection;

  final List<String> courses = ['B.Tech', 'M.Tech', 'MBA', 'MCA'];
  
  final List<String> branches = [
    'Computer Science',
    'Electronics',
    'Mechanical',
    'Civil',
    'Electrical',
    'Information Technology',
  ];

  final List<String> semesters = [
    'I Semester',
    'II Semester',
    'III Semester',
    'IV Semester',
    'V Semester',
    'VI Semester',
    'VII Semester',
    'VIII Semester',
  ];

  final List<String> years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  
  final List<String> sections = ['Section A', 'Section B', 'Section C', 'Section D'];

  void _viewTimetable() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FacultyAdjustmentsTimetableScreen(
            course: selectedCourse!,
            branch: selectedBranch!,
            semester: selectedSemester!,
            year: selectedYear!,
            section: selectedSection!,
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
          'Faculty Adjustments',
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
              
              _buildFilterCard([
                const Text(
                  'Select Class Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a1f3a),
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildDropdown('Course', courses, selectedCourse, 
                  (val) => setState(() => selectedCourse = val), isRequired: true),
                const SizedBox(height: 16),
                
                _buildDropdown('Branch', branches, selectedBranch,
                  (val) => setState(() => selectedBranch = val), isRequired: true),
                const SizedBox(height: 16),
                
                _buildDropdown('Year', years, selectedYear,
                  (val) => setState(() => selectedYear = val), isRequired: true),
                const SizedBox(height: 16),
                
                _buildDropdown('Semester', semesters, selectedSemester,
                  (val) => setState(() => selectedSemester = val), isRequired: true),
                const SizedBox(height: 16),
                
                _buildDropdown('Section', sections, selectedSection,
                  (val) => setState(() => selectedSection = val), isRequired: true),
              ]),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _viewTimetable,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf59e0b),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: const Color(0xFFf59e0b).withValues(alpha: 0.4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_calendar_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Edit Timetable',
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
          colors: [Color(0xFFf59e0b), Color(0xFFd97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf59e0b).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Faculty Adjustments',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Modify class schedules',
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

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    void Function(String?) onChanged, {
    bool isRequired = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: isRequired
          ? (value) => value == null ? 'Please select $label' : null
          : null,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
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
          borderSide: const BorderSide(color: Color(0xFFf59e0b), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFef4444), width: 1.5),
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
