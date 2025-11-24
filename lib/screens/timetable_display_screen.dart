import 'package:flutter/material.dart';

class TimetableDisplayScreen extends StatelessWidget {
  final String course;
  final String year;
  final String semester;
  final String branch;
  final String section;

  const TimetableDisplayScreen({
    super.key,
    required this.course,
    required this.year,
    required this.semester,
    required this.branch,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final timetableData = _generateTimetableData();
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Class Timetable',
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
            icon: const Icon(Icons.download_rounded, color: Color(0xFF06b6d4)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading Timetable...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Class Info Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF06b6d4).withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildInfoChip('Course', course),
                _buildInfoChip('Year', year),
                _buildInfoChip('Semester', semester),
                _buildInfoChip('Branch', branch),
                _buildInfoChip('Section', section),
              ],
            ),
          ),
          
          // Timetable Table
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
                      child: _buildTimetableTable(timetableData),
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

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF06b6d4).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF06b6d4).withValues(alpha: 0.3),
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
              color: Color(0xFF06b6d4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableTable(Map<String, Map<String, TimetableSlot>> data) {
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
                  final slot = data[day]?[period['time']!];
                  return _buildSlotCell(slot);
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

  Widget _buildSlotCell(TimetableSlot? slot) {
    if (slot == null || slot.subject == 'Break') {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: slot?.subject == 'Break' 
              ? Colors.orange.shade50 
              : Colors.white,
        ),
        child: Center(
          child: Text(
            slot?.subject ?? '-',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: slot?.subject == 'Break' 
                  ? Colors.orange.shade700 
                  : Colors.grey.shade400,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getSubjectColor(slot.subject).withValues(alpha: 0.1),
        border: Border.all(
          color: _getSubjectColor(slot.subject).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            slot.subject,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _getSubjectColor(slot.subject),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            slot.faculty,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (slot.room.isNotEmpty) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.room_rounded,
                  size: 10,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    slot.room,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    final colors = {
      'AI': const Color(0xFF8b5cf6),
      'CN': const Color(0xFF10b981),
      'COA': const Color(0xFFf59e0b),
      'EDA': const Color(0xFFef4444),
      'OE': const Color(0xFF06b6d4),
      'Lab': const Color(0xFF6366f1),
    };

    for (var key in colors.keys) {
      if (subject.contains(key)) {
        return colors[key]!;
      }
    }
    return const Color(0xFF64748b);
  }

  Map<String, Map<String, TimetableSlot>> _generateTimetableData() {
    // Generate mock timetable data
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final periods = [
      '9:00-9:50',
      '9:50-10:40',
      '10:40-11:30',
      '11:30-12:20',
      '12:20-1:10', // Lunch break
      '1:10-2:00',
      '2:00-2:50',
      '2:50-3:40',
      '3:40-4:30',
    ];

    final subjects = ['AI', 'CN', 'COA', 'EDA', 'OE', 'AI Lab', 'CN Lab'];
    final faculties = ['Dr. Smith', 'Prof. Johnson', 'Dr. Williams', 'Prof. Brown', 'Dr. Davis'];
    final rooms = ['R101', 'R102', 'R103', 'Lab1', 'Lab2', 'Lab3'];

    final Map<String, Map<String, TimetableSlot>> timetable = {};

    for (var day in days) {
      timetable[day] = {};
      for (var i = 0; i < periods.length; i++) {
        final time = periods[i];
        
        // Lunch break
        if (time == '12:20-1:10') {
          timetable[day]![time] = TimetableSlot(
            subject: 'Break',
            faculty: '',
            room: '',
          );
          continue;
        }

        // Labs in afternoon
        if (i >= 5 && day != 'Saturday') {
          final labSubject = subjects[5 + (day.hashCode % 2)];
          timetable[day]![time] = TimetableSlot(
            subject: labSubject,
            faculty: faculties[(day.hashCode + i) % faculties.length],
            room: rooms[3 + (i % 3)],
          );
        } else {
          // Regular classes
          timetable[day]![time] = TimetableSlot(
            subject: subjects[(day.hashCode + i) % 5],
            faculty: faculties[(day.hashCode + i) % faculties.length],
            room: rooms[i % 3],
          );
        }
      }
    }

    return timetable;
  }
}

class TimetableSlot {
  final String subject;
  final String faculty;
  final String room;

  TimetableSlot({
    required this.subject,
    required this.faculty,
    required this.room,
  });
}
