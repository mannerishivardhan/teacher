import 'package:flutter/material.dart';
import '../models/shortage_models.dart';

class ShortageResultsScreen extends StatelessWidget {
  final String? courseName;
  final String? branchName;
  final String? year;
  final String? semester;
  final String? section;
  final String? subjectName;
  final double minPercentage;
  final double maxPercentage;

  const ShortageResultsScreen({
    super.key,
    this.courseName,
    this.branchName,
    this.year,
    this.semester,
    this.section,
    this.subjectName,
    required this.minPercentage,
    required this.maxPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final students = _generateMockData();
    final ScrollController verticalController = ScrollController();
    final ScrollController headerController = ScrollController();
    final ScrollController bodyController = ScrollController();

    // Sync scroll positions
    void syncScrollControllers() {
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
    }

    syncScrollControllers();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Shortage Students',
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
          // Student Details Header
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
                      if (courseName != null)
                        _buildDetailRow('Course', courseName!),
                      if (courseName != null && branchName != null)
                        const SizedBox(height: 8),
                      if (branchName != null)
                        _buildDetailRow('Branch', branchName!),
                      if (branchName != null && year != null)
                        const SizedBox(height: 8),
                      if (year != null)
                        _buildDetailRow('Year', year!),
                      if (year != null && semester != null)
                        const SizedBox(height: 8),
                      if (semester != null)
                        _buildDetailRow('Semester', semester!),
                      if (semester != null && section != null)
                        const SizedBox(height: 8),
                      if (section != null)
                        _buildDetailRow('Section', section!),
                      if (section != null && subjectName != null)
                        const SizedBox(height: 8),
                      if (subjectName != null)
                        _buildDetailRow('Subject', subjectName!),
                      const SizedBox(height: 8),
                      _buildDetailRow('Attendance Range', '${minPercentage.toStringAsFixed(0)}% - ${maxPercentage.toStringAsFixed(0)}%'),
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
                        '${students.length} Students with Shortage',
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
                          2: FixedColumnWidth(200),
                          3: FixedColumnWidth(120),
                          4: FixedColumnWidth(120),
                          5: FixedColumnWidth(140),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: const Color(0xFFef4444).withValues(alpha: 0.1),
                            ),
                            children: [
                              _buildHeaderCell('S.No'),
                              _buildHeaderCell('Roll No'),
                              _buildHeaderCell('Student Name'),
                              _buildHeaderCell('Held'),
                              _buildHeaderCell('Attended'),
                              _buildHeaderCell('Attendance %'),
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
                          child: _buildShortageTableBody(students),
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

  Widget _buildShortageTableBody(List<ShortageStudent> students) {
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
          2: FixedColumnWidth(200),
          3: FixedColumnWidth(120),
          4: FixedColumnWidth(120),
          5: FixedColumnWidth(140),
        },
        children: students.asMap().entries.map((entry) {
          final index = entry.key;
          final student = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.white : Colors.grey.shade50,
            ),
            children: [
              _buildDataCell('${index + 1}'),
              _buildDataCell(student.rollNumber, isBold: true),
              _buildDataCell(student.studentName, alignment: Alignment.centerLeft),
              _buildDataCell(student.classesHeld.toString()),
              _buildDataCell(student.classesAttended.toString(), color: const Color(0xFF10b981)),
              _buildPercentageCell(student.attendancePercentage),
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

  Widget _buildPercentageCell(double percentage) {
    final color = percentage >= 75 
        ? const Color(0xFF10b981) 
        : percentage >= 65 
            ? const Color(0xFFf59e0b) 
            : const Color(0xFFef4444);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  List<ShortageStudent> _generateMockData() {
    // Generate mock shortage students
    final students = <ShortageStudent>[];
    
    for (int i = 0; i < 15; i++) {
      final held = 80 + (i * 3);
      final percentage = minPercentage + ((maxPercentage - minPercentage) * (i / 15));
      final attended = (held * percentage / 100).round();
      final short = held - attended;
      
      students.add(ShortageStudent(
        rollNumber: '23${branchName ?? 'CSE'}${1000 + i}',
        studentName: 'Student ${i + 1}',
        course: courseName ?? 'B.Tech',
        branch: branchName ?? 'CSE',
        year: year ?? '2nd Year',
        semester: semester ?? '3',
        section: section ?? 'A',
        subject: subjectName,
        attendancePercentage: percentage,
        classesHeld: held,
        classesAttended: attended,
        classesShort: short,
      ));
    }
    
    return students;
  }
}
