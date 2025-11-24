import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance_models.dart';
import '../services/attendance_service.dart';
import 'attendance_result_screen.dart';

class AttendanceTrackingScreen extends StatefulWidget {
  const AttendanceTrackingScreen({super.key});

  @override
  State<AttendanceTrackingScreen> createState() =>
      _AttendanceTrackingScreenState();
}

class _AttendanceTrackingScreenState extends State<AttendanceTrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  final AttendanceService _attendanceService = AttendanceService();

  // Filter state variables
  FilterOption? selectedCourse;
  String? selectedSemester;
  FilterOption? selectedBranch;
  String? selectedSection;
  FilterOption? selectedSubject;
  DateTime? startDate;
  DateTime? endDate;
  String selectedMonthFilter = 'current'; // current, last, custom

  // Dynamic data from backend
  List<FilterOption> courses = [];
  List<FilterOption> branches = [];
  List<FilterOption> subjects = [];
  final List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  final List<String> sections = ['A', 'B', 'C', 'D'];

  // Loading and error states
  bool isLoading = false;
  bool isLoadingFilters = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _loadCourses();
  }

  void _initializeDates() {
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = now;
  }

  // Load courses from backend
  Future<void> _loadCourses() async {
    setState(() {
      isLoadingFilters = true;
      errorMessage = null;
    });

    try {
      final loadedCourses = await _attendanceService.getCourses();
      setState(() {
        courses = loadedCourses;
        isLoadingFilters = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load courses: $e';
        isLoadingFilters = false;
      });
    }
  }

  // Load branches when course is selected
  Future<void> _loadBranches(String courseId) async {
    setState(() {
      isLoadingFilters = true;
    });

    try {
      final loadedBranches = await _attendanceService.getBranches(courseId);
      setState(() {
        branches = loadedBranches;
        isLoadingFilters = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load branches: $e';
        isLoadingFilters = false;
      });
    }
  }

  // Load subjects when branch is selected
  Future<void> _loadSubjects(String branchId) async {
    setState(() {
      isLoadingFilters = true;
    });

    try {
      final loadedSubjects = await _attendanceService.getSubjects(branchId);
      setState(() {
        subjects = loadedSubjects;
        isLoadingFilters = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load subjects: $e';
        isLoadingFilters = false;
      });
    }
  }

  void _handleCourseChange(FilterOption? value) {
    setState(() {
      selectedCourse = value;
      selectedBranch = null;
      selectedSubject = null;
      branches = [];
      subjects = [];
    });

    if (value != null) {
      _loadBranches(value.id);
    }
  }

  void _handleBranchChange(FilterOption? value) {
    setState(() {
      selectedBranch = value;
      selectedSubject = null;
      subjects = [];
    });

    if (value != null) {
      _loadSubjects(value.id);
    }
  }

  void _handleMonthFilterChange(String filter) {
    setState(() {
      selectedMonthFilter = filter;
      final now = DateTime.now();
      
      if (filter == 'current') {
        startDate = DateTime(now.year, now.month, 1);
        endDate = now;
      } else if (filter == 'last') {
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        startDate = lastMonth;
        endDate = DateTime(now.year, now.month, 0);
      }
    });
  }

  Future<void> _submitFilters() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      try {
        final filterRequest = AttendanceFilterRequest(
          courseId: selectedCourse?.id,
          semester: selectedSemester,
          branchId: selectedBranch?.id,
          section: selectedSection,
          subjectId: selectedSubject?.id,
          startDate: startDate,
          endDate: endDate,
        );

        final response = await _attendanceService.getAttendanceRecords(filterRequest);
        
        setState(() {
          isLoading = false;
        });

        // Navigate to result screen
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendanceResultScreen(
                attendanceRecords: response.records,
                courseName: selectedCourse?.name,
                semester: selectedSemester,
                branchName: selectedBranch?.name,
                section: selectedSection,
                subjectName: selectedSubject?.name,
              ),
            ),
          );
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Failed to load attendance records: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10b981),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1a1f3a),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
        selectedMonthFilter = 'custom';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Attendance Tracking',
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
              _buildFilterHeader(),
              const SizedBox(height: 20),
              
              // Error Message
              if (errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Filter Options
              _buildFilterCard([
                const Text(
                  'Filter Criteria',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a1f3a),
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildDynamicDropdown(
                  'Course',
                  courses,
                  selectedCourse,
                  _handleCourseChange,
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  'Semester',
                  semesters,
                  selectedSemester,
                  (val) => setState(() => selectedSemester = val),
                ),
                const SizedBox(height: 16),
                
                _buildDynamicDropdown(
                  'Branch',
                  branches,
                  selectedBranch,
                  _handleBranchChange,
                  enabled: selectedCourse != null && branches.isNotEmpty,
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  'Section',
                  sections,
                  selectedSection,
                  (val) => setState(() => selectedSection = val),
                ),
                const SizedBox(height: 16),
                
                _buildDynamicDropdown(
                  'Subject',
                  subjects,
                  selectedSubject,
                  (val) => setState(() => selectedSubject = val),
                  enabled: selectedBranch != null && subjects.isNotEmpty,
                ),
                const SizedBox(height: 20),
                
                // Date Range Section
                const Text(
                  'Date Range',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1f3a),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Month Quick Filters
                Row(
                  children: [
                    _buildMonthChip('Current Month', 'current'),
                    const SizedBox(width: 8),
                    _buildMonthChip('Last Month', 'last'),
                    const SizedBox(width: 8),
                    _buildMonthChip('Custom', 'custom'),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Date Pickers
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePicker(
                        'Start Date',
                        startDate,
                        () => _selectDate(context, true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDatePicker(
                        'End Date',
                        endDate,
                        () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),
              ]),

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: isLoading || isLoadingFilters ? null : _submitFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10b981),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: const Color(0xFF10b981).withValues(alpha: 0.4),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else
                      const Icon(Icons.search_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      isLoading ? 'Loading...' : 'Track Attendance',
                      style: const TextStyle(
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

  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10b981), Color(0xFF06b6d4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10b981).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.how_to_reg_rounded, color: Colors.white, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance Tracking',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track student attendance with comprehensive filters',
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

  // Dropdown for dynamic FilterOption data
  Widget _buildDynamicDropdown(
    String label,
    List<FilterOption> items,
    FilterOption? value,
    void Function(FilterOption?) onChanged, {
    bool enabled = true,
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
          borderSide: const BorderSide(color: Color(0xFF10b981), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
        filled: true,
        fillColor: enabled ? const Color(0xFFF8FAFC) : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        suffixIcon: isLoadingFilters
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      isExpanded: true,
    );
  }

  // Dropdown for static String data
  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    void Function(String?) onChanged, {
    bool enabled = true,
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
          borderSide: const BorderSide(color: Color(0xFF10b981), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
        filled: true,
        fillColor: enabled ? const Color(0xFFF8FAFC) : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      isExpanded: true,
    );
  }

  Widget _buildMonthChip(String label, String value) {
    final isSelected = selectedMonthFilter == value;
    return Expanded(
      child: InkWell(
        onTap: () => _handleMonthFilterChange(value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF10b981) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF10b981) : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date != null ? DateFormat('dd MMM yyyy').format(date) : 'Select',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1f3a),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
