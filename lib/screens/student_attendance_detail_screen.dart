import 'package:flutter/material.dart';
import '../models/attendance_models.dart';

class StudentAttendanceDetailScreen extends StatelessWidget {
  final AttendanceRecord student;
  final String? courseName;
  final String? semester;
  final String? branchName;

  const StudentAttendanceDetailScreen({
    super.key,
    required this.student,
    this.courseName,
    this.semester,
    this.branchName,
  });

  @override
  Widget build(BuildContext context) {
    // Generate mock subject-wise attendance data
    final subjectAttendance = _generateSubjectAttendance();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Attendance Report',
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
            icon: const Icon(Icons.download_rounded, color: Color(0xFF10b981)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading Report...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo placeholder
            _buildHeader(),
            const SizedBox(height: 24),
            
            // Student Details
            _buildStudentDetails(),
            const SizedBox(height: 24),
            
            // Subject-wise Attendance Table
            _buildAttendanceTable(subjectAttendance),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Logo placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Color(0xFF10b981),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VISHNU INSTITUTE OF TECHNOLOGY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1a1f3a),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Approved By AICTE, Affiliated to JNTUK, KAKINADA',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'VISHNUPUR, BHIMAVARAM',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'ATTENDANCE REPORT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a1f3a),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('RollNo', student.rollNumber),
          const SizedBox(height: 12),
          _buildDetailRow('Student Name', student.studentName),
          const SizedBox(height: 12),
          _buildDetailRow('Course', courseName ?? 'B.Tech'),
          const SizedBox(height: 12),
          _buildDetailRow('Branch', branchName ?? 'AIDS'),
          const SizedBox(height: 12),
          _buildDetailRow('Semester', semester ?? '3/4 Semester-I'),
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1f3a),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTable(List<SubjectAttendance> subjects) {
    final totalHeld = subjects.fold(0, (sum, item) => sum + item.held);
    final totalAttend = subjects.fold(0, (sum, item) => sum + item.attend);
    final totalPercentage = totalHeld > 0 ? (totalAttend / totalHeld * 100) : 0.0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
                verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell('Sl.No.'),
                    _buildHeaderCell('Subject'),
                    _buildHeaderCell('Held'),
                    _buildHeaderCell('Attend'),
                    _buildHeaderCell('%'),
                  ],
                ),
              ],
            ),
          ),
          // Table Body
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
              verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(1.5),
            },
            children: [
              ...subjects.asMap().entries.map((entry) {
                final index = entry.key;
                final subject = entry.value;
                return TableRow(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.white : Colors.grey.shade50,
                  ),
                  children: [
                    _buildDataCell('${index + 1}'),
                    _buildDataCell(subject.name, alignment: Alignment.centerLeft),
                    _buildDataCell('${subject.held}'),
                    _buildDataCell('${subject.attend}'),
                    _buildDataCell(
                      '${subject.percentage.toStringAsFixed(2)}',
                      color: subject.percentage < 75 ? const Color(0xFFef4444) : const Color(0xFF10b981),
                    ),
                  ],
                );
              }),
              // Total Row
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                children: [
                  _buildDataCell('', isBold: true),
                  _buildDataCell('TOTAL', alignment: Alignment.centerRight, isBold: true),
                  _buildDataCell('$totalHeld', isBold: true),
                  _buildDataCell('$totalAttend', isBold: true),
                  _buildDataCell(
                    totalPercentage.toStringAsFixed(2),
                    isBold: true,
                    color: totalPercentage < 75 ? const Color(0xFFef4444) : const Color(0xFF10b981),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
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
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? const Color(0xFF1a1f3a),
          ),
        ),
      ),
    );
  }

  List<SubjectAttendance> _generateSubjectAttendance() {
    // Generate mock subject-wise attendance based on overall percentage
    final subjects = [
      'AI',
      'CN',
      'COA',
      'EDA',
      'OE',
      'AI Lab',
      'CN Lab',
      'FS Lab',
      'Tin Lab',
      'MNRS',
    ];

    return subjects.map((subject) {
      final held = 40 + (subject.hashCode % 50);
      final baseAttend = (held * student.percentage / 100).round();
      final variance = (subject.hashCode % 10) - 5;
      final attend = (baseAttend + variance).clamp(0, held);
      
      return SubjectAttendance(
        name: subject,
        held: held,
        attend: attend,
        percentage: held > 0 ? (attend / held * 100) : 0.0,
      );
    }).toList();
  }
}

class SubjectAttendance {
  final String name;
  final int held;
  final int attend;
  final double percentage;

  SubjectAttendance({
    required this.name,
    required this.held,
    required this.attend,
    required this.percentage,
  });
}
