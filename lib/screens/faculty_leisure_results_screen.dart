import 'package:flutter/material.dart';

class FacultyLeisureResultsScreen extends StatelessWidget {
  final String course;
  final String branch;
  final String semester;
  final String? employeeId;

  const FacultyLeisureResultsScreen({
    super.key,
    required this.course,
    required this.branch,
    required this.semester,
    this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    final leisureData = _generateTimetableData();
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalController = ScrollController();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Faculty Leisure Timetable',
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
      body: Column(
        children: [
          _buildFilterSummary(),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildTimetableTable(leisureData),
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

  Widget _buildFilterSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF06b6d4), Color(0xFF0891b2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06b6d4).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.filter_list_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Applied Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('Course: $course'),
              _buildFilterChip('Branch: $branch'),
              _buildFilterChip('Semester: $semester'),
              if (employeeId != null && employeeId!.isNotEmpty)
                _buildFilterChip('Employee ID: $employeeId'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimetableTable(Map<String, Map<String, List<String>>> data) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final periods = [
      {'number': '1', 'time': '9:00-9:50'},
      {'number': '2', 'time': '9:50-10:40'},
      {'number': '3', 'time': '10:40-11:30'},
      {'number': '4', 'time': '11:30-12:20'},
      {'number': 'Break', 'time': '12:20-1:10'},
      {'number': '5', 'time': '1:10-2:00'},
      {'number': '6', 'time': '2:00-2:50'},
      {'number': '7', 'time': '2:50-3:40'},
      {'number': '8', 'time': '3:40-4:30'},
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Table(
        border: TableBorder.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        columnWidths: {
          0: const FixedColumnWidth(100),
          for (int i = 1; i <= periods.length; i++) i: const FixedColumnWidth(160),
        },
        children: [
          // Header Row 1 - Period Numbers
          TableRow(
            decoration: BoxDecoration(
              color: const Color(0xFF06b6d4).withValues(alpha: 0.15),
            ),
            children: [
              _buildHeaderCell('Day / Period', isDoubleHeight: true),
              ...periods.map((period) => _buildPeriodHeaderCell(period['number']!)),
            ],
          ),
          // Header Row 2 - Time Slots
          TableRow(
            decoration: BoxDecoration(
              color: const Color(0xFF06b6d4).withValues(alpha: 0.1),
            ),
            children: [
              Container(), // Empty cell for day column
              ...periods.map((period) => _buildTimeHeaderCell(period['time']!)),
            ],
          ),
          // Day Rows
          ...days.map((day) {
            return TableRow(
              children: [
                _buildDayCell(day),
                ...periods.map((period) {
                  final facultyList = data[day]?[period['time']!] ?? [];
                  return _buildLeisureCell(facultyList, period['number']! == 'Break');
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {bool isDoubleHeight = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isDoubleHeight ? 20 : 10,
        horizontal: 8,
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1a1f3a),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodHeaderCell(String periodNumber) {
    final isBreak = periodNumber == 'Break';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: isBreak 
            ? Colors.orange.shade100 
            : const Color(0xFF06b6d4).withValues(alpha: 0.15),
      ),
      child: Center(
        child: Text(
          isBreak ? 'BREAK' : 'Period $periodNumber',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isBreak ? Colors.orange.shade900 : const Color(0xFF1a1f3a),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeHeaderCell(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Center(
        child: Text(
          time,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(String day) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF06b6d4).withValues(alpha: 0.05),
      ),
      child: Center(
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1a1f3a),
          ),
        ),
      ),
    );
  }

  Widget _buildLeisureCell(List<String> facultyList, bool isBreak) {
    if (isBreak) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
        ),
        child: Center(
          child: Text(
            'BREAK',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.orange.shade700,
            ),
          ),
        ),
      );
    }

    if (facultyList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            '-',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      );
    }

    // Faculty are free during this period - show them
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF06b6d4).withValues(alpha: 0.15),
        border: Border.all(
          color: const Color(0xFF06b6d4).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (facultyList.length == 1) ...[
            Row(
              children: [
                Icon(
                  Icons.person_rounded,
                  size: 12,
                  color: const Color(0xFF06b6d4),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    facultyList[0],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF06b6d4),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06b6d4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${facultyList.length}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Faculty',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF06b6d4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...facultyList.take(2).map((faculty) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '• $faculty',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )),
            if (facultyList.length > 2)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '+ ${facultyList.length - 2} more',
                  style: TextStyle(
                    fontSize: 9,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Map<String, Map<String, List<String>>> _generateTimetableData() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final periods = [
      '9:00-9:50',
      '9:50-10:40',
      '10:40-11:30',
      '11:30-12:20',
      '12:20-1:10',
      '1:10-2:00',
      '2:00-2:50',
      '2:50-3:40',
      '3:40-4:30',
    ];

    // Mock faculty data
    final allFaculty = [
      'Dr. Rajesh Kumar',
      'Prof. Anita Sharma',
      'Dr. Suresh Patel',
      'Mrs. Priya Reddy',
      'Dr. Amit Verma',
      'Prof. Sneha Iyer',
    ];

    // Filter by employeeId if provided
    List<String> facultyToShow = allFaculty;
    if (employeeId != null && employeeId!.isNotEmpty) {
      // In real implementation, filter based on actual employee ID
      // For mock, we'll just show first 2 faculty
      facultyToShow = allFaculty.take(2).toList();
    }

    // Generate mock leisure data
    final Map<String, Map<String, List<String>>> timetable = {};

    for (var day in days) {
      timetable[day] = {};
      for (var i = 0; i < periods.length; i++) {
        final time = periods[i];
        
        // Skip break time
        if (time == '12:20-1:10') {
          timetable[day]![time] = [];
          continue;
        }

        // Randomly assign faculty to leisure slots
        final List<String> leisureFaculty = [];
        for (var faculty in facultyToShow) {
          // Use hash-based pseudo-random to assign leisure periods
          final hash = (day.hashCode + time.hashCode + faculty.hashCode);
          if (hash % 3 == 0) {  // Roughly 33% chance of being free
            leisureFaculty.add(faculty);
          }
        }
        
        timetable[day]![time] = leisureFaculty;
      }
    }

    return timetable;
  }
}
