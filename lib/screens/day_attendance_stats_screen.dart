import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/day_attendance_models.dart';

class DayAttendanceStatsScreen extends StatelessWidget {
  final String course;
  final String year;
  final DateTime date;

  const DayAttendanceStatsScreen({
    super.key,
    required this.course,
    required this.year,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final stats = _generateMockStats();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Attendance Statistics',
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
        child: Column(
          children: [
            // Info Header
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
                  _buildInfoChip('Date', DateFormat('dd MMM yyyy').format(date)),
                  _buildInfoChip('Course', course),
                  _buildInfoChip('Year', year),
                ],
              ),
            ),

            // Overall Summary Cards
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Students',
                      stats.totalStudents.toString(),
                      Icons.people_rounded,
                      const Color(0xFF06b6d4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Present',
                      stats.totalPresent.toString(),
                      Icons.check_circle_rounded,
                      const Color(0xFF10b981),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Absent',
                      stats.totalAbsent.toString(),
                      Icons.cancel_rounded,
                      const Color(0xFFef4444),
                    ),
                  ),
                ],
              ),
            ),

            // Branch-wise Statistics Table
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Branch-wise Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1f3a),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatsTable(stats.branchStats),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
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

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTable(List<BranchAttendanceStats> branchStats) {
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
              color: const Color(0xFF10b981).withValues(alpha: 0.1),
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
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell('Branch'),
                    _buildHeaderCell('Total'),
                    _buildHeaderCell('Present'),
                    _buildHeaderCell('Absent'),
                    _buildHeaderCell('Present %'),
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
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(1.5),
            },
            children: branchStats.asMap().entries.map((entry) {
              final index = entry.key;
              final stat = entry.value;
              return TableRow(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.white : Colors.grey.shade50,
                ),
                children: [
                  _buildDataCell(stat.branchName, alignment: Alignment.centerLeft, isBold: true),
                  _buildDataCell(stat.totalStudents.toString()),
                  _buildDataCell(
                    stat.presentStudents.toString(),
                    color: const Color(0xFF10b981),
                  ),
                  _buildDataCell(
                    stat.absentStudents.toString(),
                    color: const Color(0xFFef4444),
                  ),
                  _buildPercentageCell(stat.presentPercentage),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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

  Widget _buildPercentageCell(double percentage) {
    final color = percentage >= 75 ? const Color(0xFF10b981) : const Color(0xFFef4444);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  DayAttendanceResponse _generateMockStats() {
    // Generate mock branch-wise statistics
    final branches = ['CSE', 'ECE', 'ME', 'CE', 'EEE', 'IT', 'AIDS'];
    
    final branchStats = branches.map((branch) {
      final total = 60 + (branch.hashCode % 40);
      final present = (total * (0.7 + (branch.hashCode % 25) / 100)).round();
      final absent = total - present;
      
      return BranchAttendanceStats(
        branchName: branch,
        totalStudents: total,
        presentStudents: present,
        absentStudents: absent,
        presentPercentage: (present / total * 100),
        absentPercentage: (absent / total * 100),
      );
    }).toList();

    final totalStudents = branchStats.fold(0, (sum, stat) => sum + stat.totalStudents);
    final totalPresent = branchStats.fold(0, (sum, stat) => sum + stat.presentStudents);
    final totalAbsent = branchStats.fold(0, (sum, stat) => sum + stat.absentStudents);

    return DayAttendanceResponse(
      date: DateFormat('yyyy-MM-dd').format(date),
      course: course,
      year: year,
      branchStats: branchStats,
      totalStudents: totalStudents,
      totalPresent: totalPresent,
      totalAbsent: totalAbsent,
    );
  }
}
