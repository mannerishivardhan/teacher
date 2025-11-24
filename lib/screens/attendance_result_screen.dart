import 'package:flutter/material.dart';
import '../models/attendance_models.dart';
import 'student_attendance_detail_screen.dart';

class AttendanceResultScreen extends StatelessWidget {
  final List<AttendanceRecord> attendanceRecords;
  final String? courseName;
  final String? semester;
  final String? branchName;
  final String? section;
  final String? subjectName;

  const AttendanceResultScreen({
    super.key,
    required this.attendanceRecords,
    this.courseName,
    this.semester,
    this.branchName,
    this.section,
    this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalController = ScrollController();

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
      body: Column(
        children: [
          // Filter Summary
          if (courseName != null || semester != null || branchName != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF10b981).withValues(alpha: 0.05),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (courseName != null)
                    _buildFilterChip('Course', courseName!),
                  if (semester != null)
                    _buildFilterChip('Semester', semester!),
                  if (branchName != null)
                    _buildFilterChip('Branch', branchName!),
                  if (section != null)
                    _buildFilterChip('Section', section!),
                  if (subjectName != null)
                    _buildFilterChip('Subject', subjectName!),
                ],
              ),
            ),
          
          // Table
          Expanded(
            child: Scrollbar(
              controller: verticalController,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: verticalController,
                scrollDirection: Axis.vertical,
                child: Scrollbar(
                  controller: horizontalController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  notificationPredicate: (notification) => notification.depth == 1,
                  child: SingleChildScrollView(
                    controller: horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFF10b981).withValues(alpha: 0.1),
                      ),
                      headingRowHeight: 56,
                      dataRowMinHeight: 52,
                      dataRowMaxHeight: 52,
                      columnSpacing: 40,
                      horizontalMargin: 24,
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'S.No',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1a1f3a),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Roll No',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1a1f3a),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Student Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1a1f3a),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Attendance %',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1a1f3a),
                            ),
                          ),
                          numeric: true,
                        ),
                      ],
                      rows: List.generate(attendanceRecords.length, (index) {
                        final record = attendanceRecords[index];
                        final isLowAttendance = record.percentage < 75;
                        final color = isLowAttendance
                            ? const Color(0xFFef4444)
                            : const Color(0xFF10b981);

                        return DataRow(
                          color: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (index.isEven) {
                                return Colors.grey.shade50;
                              }
                              return null;
                            },
                          ),
                          cells: [
                            DataCell(
                              Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1a1f3a),
                                ),
                              ),
                            ),
                            DataCell(
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentAttendanceDetailScreen(
                                        student: record,
                                        courseName: courseName,
                                        semester: semester,
                                        branchName: branchName,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  record.rollNumber,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF10b981),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.studentName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1a1f3a),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: color.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  '${record.percentage.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF10b981).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF10b981).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10b981),
            ),
          ),
        ],
      ),
    );
  }
}
