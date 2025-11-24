import 'package:flutter/material.dart';
import '../models/attendance_models.dart';
import 'timetable_display_screen.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final _formKey = GlobalKey<FormState>();

  // Filter values
  String? selectedCourse;
  String? selectedYear;
  String? selectedSemester;
  String? selectedBranch;
  String? selectedSection;

  // Static data (can be replaced with API calls)
  final List<String> courses = ['B.Tech', 'M.Tech', 'BBA', 'MBA', 'BCA', 'MCA'];
  final List<String> years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final List<String> semesters = ['Semester 1', 'Semester 2'];
  final Map<String, List<String>> branchesByCourse = {
    'B.Tech': ['CSE', 'ECE', 'ME', 'CE', 'EEE', 'IT', 'AIDS'],
    'M.Tech': ['CSE', 'VLSI', 'Power Systems', 'Structural Engineering'],
    'BBA': ['General', 'Finance', 'Marketing'],
    'MBA': ['General', 'Finance', 'HR', 'Marketing'],
    'BCA': ['General'],
    'MCA': ['General'],
  };
  final List<String> sections = ['A', 'B', 'C', 'D'];

  List<String> availableBranches = [];

  void _handleCourseChange(String? value) {
    setState(() {
      selectedCourse = value;
      selectedBranch = null;
      availableBranches = value != null ? (branchesByCourse[value] ?? []) : [];
    });
  }

  void _viewTimetable() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimetableDisplayScreen(
            course: selectedCourse!,
            year: selectedYear!,
            semester: selectedSemester!,
            branch: selectedBranch!,
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
          'Timetable',
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
                  'Select Timetable Criteria',
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
                  _handleCourseChange,
                  validator: (val) => val == null ? 'Please select a course' : null,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        'Year',
                        years,
                        selectedYear,
                        (val) => setState(() => selectedYear = val),
                        validator: (val) => val == null ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdown(
                        'Semester',
                        semesters,
                        selectedSemester,
                        (val) => setState(() => selectedSemester = val),
                        validator: (val) => val == null ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        'Branch',
                        availableBranches,
                        selectedBranch,
                        (val) => setState(() => selectedBranch = val),
                        enabled: selectedCourse != null && availableBranches.isNotEmpty,
                        validator: (val) => val == null ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdown(
                        'Section',
                        sections,
                        selectedSection,
                        (val) => setState(() => selectedSection = val),
                        validator: (val) => val == null ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
              ]),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _viewTimetable,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06b6d4),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: const Color(0xFF06b6d4).withValues(alpha: 0.4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_view_week_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'View Timetable',
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
          colors: [Color(0xFF06b6d4), Color(0xFF0891b2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06b6d4).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_today_rounded, color: Colors.white, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Class Timetable',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'View weekly schedules for all classes',
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
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.isEmpty
          ? null
          : items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
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
          borderSide: const BorderSide(color: Color(0xFF06b6d4), width: 2),
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
}
