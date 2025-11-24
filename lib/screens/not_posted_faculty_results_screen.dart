import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/not_posted_faculty_models.dart';

class NotPostedFacultyResultsScreen extends StatelessWidget {
  final DateTime date;
  final String? department;

  const NotPostedFacultyResultsScreen({
    super.key,
    required this.date,
    this.department,
  });

  @override
  Widget build(BuildContext context) {
    final faculty = _generateMockData();
    final ScrollController verticalController = ScrollController();
    final ScrollController headerController = ScrollController();
    final ScrollController bodyController = ScrollController();

    // Sync scroll positions
    headerController.addListener(() {
      if (bodyController.hasClients && headerController.hasClients) {
        if (bodyController.offset != headerController.offset) {
          bodyController.jumpTo(headerController.offset);
        }
      }
    });

    bodyController.addListener(() {
      if (headerController.hasClients && bodyController.hasClients) {
        if (headerController.offset != bodyController.offset) {
          headerController.jumpTo(bodyController.offset);
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Not Posted Faculty',
          style: TextStyle(color: Color(0xFF1a1f3a), fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1a1f3a)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Color(0xFFef4444)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading Report...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // College Header
          _buildCollegeHeader(),
          
          // Filter Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Criteria',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a1f3a),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Date', DateFormat('dd MMMM yyyy').format(date)),
                      if (department != null) ...[
                        const SizedBox(height: 8),
                        _buildDetailRow('Department', department!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFef4444).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFef4444).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: Color(0xFFef4444),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${faculty.length} Faculty Not Posted',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFef4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Table with sticky header
          Expanded(
            child: Column(
              children: [
                // Sticky Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SingleChildScrollView(
                    controller: headerController,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 1.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Table(
                        border: TableBorder(
                          verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(60),
                          1: FixedColumnWidth(120),
                          2: FixedColumnWidth(180),
                          3: FixedColumnWidth(140),
                          4: FixedColumnWidth(120),
                          5: FixedColumnWidth(180),
                          6: FixedColumnWidth(120),
                          7: FixedColumnWidth(100),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: const Color(0xFFef4444).withValues(alpha: 0.1),
                            ),
                            children: [
                              _buildHeaderCell('S.No'),
                              _buildHeaderCell('Employee Code'),
                              _buildHeaderCell('Employee Name'),
                              _buildHeaderCell('Period'),
                              _buildHeaderCell('Course'),
                              _buildHeaderCell('Subject'),
                              _buildHeaderCell('Branch'),
                              _buildHeaderCell('Semester'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Scrollable Body
                Expanded(
                  child: Scrollbar(
                    controller: verticalController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: verticalController,
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: SingleChildScrollView(
                          controller: bodyController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: _buildFacultyTableBody(faculty),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollegeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFef4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFef4444).withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Color(0xFFef4444),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your College Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1a1f3a),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Affiliated to University Name',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748b),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFef4444).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Not Posted Faculty Report',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFFef4444),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label :',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1f3a),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFacultyTableBody(List<NotPostedFaculty> faculty) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
          verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        columnWidths: const {
          0: FixedColumnWidth(60),
          1: FixedColumnWidth(120),
          2: FixedColumnWidth(180),
          3: FixedColumnWidth(140),
          4: FixedColumnWidth(120),
          5: FixedColumnWidth(180),
          6: FixedColumnWidth(120),
          7: FixedColumnWidth(100),
        },
        children: faculty.asMap().entries.map((entry) {
          final index = entry.key;
          final fac = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.white : Colors.grey.shade50,
            ),
            children: [
              _buildDataCell('${index + 1}'),
              _buildDataCell(fac.employeeCode, isBold: true),
              _buildDataCell(fac.employeeName, alignment: Alignment.centerLeft),
              _buildDataCell(fac.period, color: const Color(0xFFef4444)),
              _buildDataCell(fac.course),
              _buildDataCell(fac.subject, alignment: Alignment.centerLeft),
              _buildDataCell(fac.branch),
              _buildDataCell(fac.semester),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1a1f3a),
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    Alignment alignment = Alignment.center,
    Color? color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Align(
        alignment: alignment,
        child: Text(
          text,
          textAlign: alignment == Alignment.centerLeft ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? const Color(0xFF1a1f3a),
          ),
        ),
      ),
    );
  }

  List<NotPostedFaculty> _generateMockData() {
    // Generate mock not posted faculty with grouped periods
    final rawData = <Map<String, dynamic>>[];
    final courses = ['B.Tech', 'M.Tech', 'BBA', 'MBA'];
    final subjects = ['Mathematics', 'Physics', 'Chemistry', 'Programming', 'Data Structures'];
    final branches = ['CSE', 'ECE', 'ME', 'CE', 'EEE'];
    final semesters = ['1', '2', '3', '4', '5', '6'];
    
    // Generate raw data with some faculty having multiple periods
    for (int i = 0; i < 20; i++) {
      final empCode = 'EMP${1000 + (i % 8)}'; // Reuse some employee codes
      final empName = 'Faculty ${(i % 8) + 1}';
      final period = '${(i % 8) + 1}';
      
      rawData.add({
        'employeeCode': empCode,
        'employeeName': empName,
        'department': department ?? 'Computer Science',
        'period': period,
        'course': courses[i % courses.length],
        'subject': subjects[i % subjects.length],
        'branch': branches[i % branches.length],
        'semester': semesters[i % semesters.length],
      });
    }
    
    // Group by employee code and combine periods
    final grouped = <String, Map<String, dynamic>>{};
    
    for (var data in rawData) {
      final key = '${data['employeeCode']}_${data['course']}_${data['subject']}_${data['branch']}_${data['semester']}';
      
      if (grouped.containsKey(key)) {
        // Add period to existing entry
        final periods = grouped[key]!['period'].split(', ');
        if (!periods.contains(data['period'])) {
          periods.add(data['period']);
          periods.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
          grouped[key]!['period'] = periods.join(', ');
        }
      } else {
        // Create new entry
        grouped[key] = Map<String, dynamic>.from(data);
      }
    }
    
    // Convert to NotPostedFaculty objects
    final faculty = grouped.values.map((data) {
      return NotPostedFaculty(
        employeeCode: data['employeeCode'],
        employeeName: data['employeeName'],
        department: data['department'],
        period: data['period'],
        course: data['course'],
        subject: data['subject'],
        branch: data['branch'],
        semester: data['semester'],
      );
    }).toList();
    
    // Sort by employee code
    faculty.sort((a, b) => a.employeeCode.compareTo(b.employeeCode));
    
    return faculty;
  }
}
