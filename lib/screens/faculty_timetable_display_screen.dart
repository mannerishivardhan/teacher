import 'package:flutter/material.dart';

class FacultyTimetableDisplayScreen extends StatelessWidget {
  final String course;
  final String branch;
  final String semester;
  final String? employeeId;

  const FacultyTimetableDisplayScreen({
    super.key,
    required this.course,
    required this.branch,
    required this.semester,
    this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    final faculties = _fetchFacultyTimetables();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Faculty Timetables',
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
        child: Column(
          children: [
            _buildFilterSummary(),
            const SizedBox(height: 8),
            ...faculties.map((faculty) => _buildFacultyTimetableCard(faculty)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8b5cf6), Color(0xFF7c3aed)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8b5cf6).withValues(alpha: 0.2),
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
                'Filters Applied',
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

  Widget _buildFacultyTimetableCard(FacultyTimetable faculty) {
    final ScrollController horizontalController = ScrollController();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Faculty Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8b5cf6).withValues(alpha: 0.15),
                  const Color(0xFF8b5cf6).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8b5cf6).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF8b5cf6),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        faculty.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a1f3a),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8b5cf6).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ID: ${faculty.employeeId}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8b5cf6),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            faculty.department,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Timetable
          Scrollbar(
            controller: horizontalController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: horizontalController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildTimetableTable(faculty.schedule),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableTable(Map<String, Map<String, TimetableSlot?>> schedule) {
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
          for (int i = 1; i <= periods.length; i++) i: const FixedColumnWidth(150),
        },
        children: [
          // Header Row - Period Numbers
          TableRow(
            decoration: BoxDecoration(
              color: const Color(0xFF8b5cf6).withValues(alpha: 0.15),
            ),
            children: [
              _buildHeaderCell('Day / Period', isDoubleHeight: true),
              ...periods.map((period) => _buildPeriodHeaderCell(period['number']!)),
            ],
          ),
          // Header Row - Time Slots
          TableRow(
            decoration: BoxDecoration(
              color: const Color(0xFF8b5cf6).withValues(alpha: 0.1),
            ),
            children: [
              Container(),
              ...periods.map((period) => _buildTimeHeaderCell(period['time']!)),
            ],
          ),
          // Day Rows
          ...days.map((day) {
            return TableRow(
              children: [
                _buildDayCell(day),
                ...periods.map((period) {
                  final slot = schedule[day]?[period['time']!];
                  return _buildSlotCell(slot, period['number']! == 'Break');
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
            fontSize: 12,
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
            : const Color(0xFF8b5cf6).withValues(alpha: 0.15),
      ),
      child: Center(
        child: Text(
          isBreak ? 'BREAK' : 'P$periodNumber',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
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
            fontSize: 10,
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
        color: const Color(0xFF8b5cf6).withValues(alpha: 0.05),
      ),
      child: Center(
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1a1f3a),
          ),
        ),
      ),
    );
  }

  Widget _buildSlotCell(TimetableSlot? slot, bool isBreak) {
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
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.orange.shade700,
            ),
          ),
        ),
      );
    }

    if (slot == null) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            'Free',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400,
              fontStyle: FontStyle.italic,
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
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: _getSubjectColor(slot.subject),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (slot.room.isNotEmpty) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.room_rounded,
                  size: 9,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    slot.room,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (slot.section.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              slot.section,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      'Math': const Color(0xFFec4899),
      'Physics': const Color(0xFF14b8a6),
    };

    for (var key in colors.keys) {
      if (subject.toUpperCase().contains(key.toUpperCase())) {
        return colors[key]!;
      }
    }
    return const Color(0xFF64748b);
  }

  // BACKEND-READY: This method simulates an API call
  // In production, replace with actual HTTP request
  List<FacultyTimetable> _fetchFacultyTimetables() {
    // Simulated API call - structure matches what backend would return
    // Future<List<FacultyTimetable>> fetchFromAPI() async {
    //   final response = await http.get(
    //     '/api/faculty/timetables?course=$course&branch=$branch&semester=$semester&employeeId=$employeeId'
    //   );
    //   return (response.data as List).map((json) => FacultyTimetable.fromJson(json)).toList();
    // }

    return _generateMockData();
  }

  List<FacultyTimetable> _generateMockData() {
    final allFaculties = [
      FacultyTimetable(
        employeeId: 'FAC001',
        name: 'Dr. Rajesh Kumar',
        department: 'Computer Science',
        schedule: _generateSchedule('Dr. Rajesh Kumar', 1),
      ),
      FacultyTimetable(
        employeeId: 'FAC002',
        name: 'Prof. Anita Sharma',
        department: 'Computer Science',
        schedule: _generateSchedule('Prof. Anita Sharma', 2),
      ),
      FacultyTimetable(
        employeeId: 'FAC003',
        name: 'Dr. Suresh Patel',
        department: 'Computer Science',
        schedule: _generateSchedule('Dr. Suresh Patel', 3),
      ),
    ];

    // Filter by employeeId if provided
    if (employeeId != null && employeeId!.isNotEmpty) {
      final specificFaculty = allFaculties.firstWhere(
        (f) => f.employeeId.toLowerCase().contains(employeeId!.toLowerCase()),
        orElse: () => allFaculties[0],
      );
      return [specificFaculty, allFaculties[1]];
    }

    // Return first 2 faculties by default
    return allFaculties.take(2).toList();
  }

  Map<String, Map<String, TimetableSlot?>> _generateSchedule(String facultyName, int seed) {
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

    final subjects = ['AI', 'CN', 'COA', 'EDA', 'OE', 'AI Lab', 'CN Lab'];
    final rooms = ['R101', 'R102', 'R103', 'Lab1', 'Lab2'];
    final sections = ['A', 'B', 'C'];

    final Map<String, Map<String, TimetableSlot?>> schedule = {};

    for (var day in days) {
      schedule[day] = {};
      for (var i = 0; i < periods.length; i++) {
        final time = periods[i];
        
        // Lunch break
        if (time == '12:20-1:10') {
          schedule[day]![time] = null;
          continue;
        }

        // Pseudo-random assignment based on seed, day, and period
        final hash = (day.hashCode + i + seed * 100);
        
        // 20% chance of free period
        if (hash % 5 == 0) {
          schedule[day]![time] = null;
          continue;
        }

        // Assign subject
        final subjectIndex = (hash % subjects.length);
        final subject = subjects[subjectIndex];
        final room = rooms[(hash + seed) % rooms.length];
        final section = sections[(hash + seed * 2) % sections.length];

        schedule[day]![time] = TimetableSlot(
          subject: subject,
          room: room,
          course: course,
          branch: branch,
          semester: semester,
          section: 'Sec $section',
        );
      }
    }

    return schedule;
  }
}

// BACKEND-READY DATA MODELS
// These classes match the structure that would come from a REST API

class FacultyTimetable {
  final String employeeId;
  final String name;
  final String department;
  final Map<String, Map<String, TimetableSlot?>> schedule;

  FacultyTimetable({
    required this.employeeId,
    required this.name,
    required this.department,
    required this.schedule,
  });

  // JSON serialization methods for backend integration
  factory FacultyTimetable.fromJson(Map<String, dynamic> json) {
    final scheduleData = json['schedule'] as Map<String, dynamic>;
    final Map<String, Map<String, TimetableSlot?>> schedule = {};
    
    scheduleData.forEach((day, periods) {
      schedule[day] = {};
      (periods as Map<String, dynamic>).forEach((time, slot) {
        schedule[day]![time] = slot != null ? TimetableSlot.fromJson(slot) : null;
      });
    });

    return FacultyTimetable(
      employeeId: json['employeeId'],
      name: json['name'],
      department: json['department'],
      schedule: schedule,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> scheduleJson = {};
    schedule.forEach((day, periods) {
      scheduleJson[day] = {};
      periods.forEach((time, slot) {
        scheduleJson[day][time] = slot?.toJson();
      });
    });

    return {
      'employeeId': employeeId,
      'name': name,
      'department': department,
      'schedule': scheduleJson,
    };
  }
}

class TimetableSlot {
  final String subject;
  final String room;
  final String course;
  final String branch;
  final String semester;
  final String section;

  TimetableSlot({
    required this.subject,
    required this.room,
    required this.course,
    required this.branch,
    required this.semester,
    required this.section,
  });

  // JSON serialization for backend integration
  factory TimetableSlot.fromJson(Map<String, dynamic> json) {
    return TimetableSlot(
      subject: json['subject'],
      room: json['room'],
      course: json['course'],
      branch: json['branch'],
      semester: json['semester'],
      section: json['section'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'room': room,
      'course': course,
      'branch': branch,
      'semester': semester,
      'section': section,
    };
  }
}
