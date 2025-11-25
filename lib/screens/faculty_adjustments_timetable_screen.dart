import 'package:flutter/material.dart';

class FacultyAdjustmentsTimetableScreen extends StatefulWidget {
  final String course;
  final String branch;
  final String semester;
  final String year;
  final String section;

  const FacultyAdjustmentsTimetableScreen({
    super.key,
    required this.course,
    required this.branch,
    required this.semester,
    required this.year,
    required this.section,
  });

  @override
  State<FacultyAdjustmentsTimetableScreen> createState() =>
      _FacultyAdjustmentsTimetableScreenState();
}

class _FacultyAdjustmentsTimetableScreenState
    extends State<FacultyAdjustmentsTimetableScreen> {
  late Map<String, Map<String, EditableTimetableSlot?>> timetableData;
  bool hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    timetableData = _generateInitialData();
  }

  void _editCell(String day, String time, EditableTimetableSlot? currentSlot) {
    showDialog(
      context: context,
      builder: (context) => _EditCellDialog(
        day: day,
        time: time,
        currentSlot: currentSlot,
        onSave: (newSlot) {
          setState(() {
            timetableData[day]![time] = newSlot;
            hasUnsavedChanges = true;
          });
        },
      ),
    );
  }

  void _saveAllChanges() {
    // TODO: Implement backend save
    // Example API call:
    // await http.post('/api/timetable/save', body: jsonEncode(timetableData));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Timetable changes saved successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF10b981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    
    setState(() {
      // Reset modified flags after successful save
      timetableData.forEach((day, periods) {
        periods.forEach((time, slot) {
          if (slot != null) {
            slot.isModified = false;
          }
        });
      });
      hasUnsavedChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalController = ScrollController();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Edit Timetable',
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
          if (hasUnsavedChanges)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: _saveAllChanges,
                icon: const Icon(Icons.save_rounded, color: Color(0xFF10b981)),
                label: const Text(
                  'Save All',
                  style: TextStyle(
                    color: Color(0xFF10b981),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSummary(),
          _buildInstructions(),
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
                      child: _buildTimetableTable(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (hasUnsavedChanges) _buildSaveButton(),
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
          colors: [Color(0xFFf59e0b), Color(0xFFd97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf59e0b).withValues(alpha: 0.2),
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
              Icon(Icons.class_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Class Details',
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
              _buildFilterChip('${widget.course}'),
              _buildFilterChip('${widget.branch}'),
              _buildFilterChip('${widget.year}'),
              _buildFilterChip('${widget.semester}'),
              _buildFilterChip('${widget.section}'),
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

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF06b6d4).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF06b6d4).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF06b6d4), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tap any cell to edit. Modified cells will be highlighted.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableTable() {
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
        border: TableBorder.all(color: Colors.grey.shade300, width: 1),
        columnWidths: {
          0: const FixedColumnWidth(100),
          for (int i = 1; i <= periods.length; i++) i: const FixedColumnWidth(150),
        },
        children: [
          // Header Row - Period Numbers
          TableRow(
            decoration: BoxDecoration(
              color: const Color(0xFFf59e0b).withValues(alpha: 0.15),
            ),
            children: [
              _buildHeaderCell('Day / Period', isDoubleHeight: true),
              ...periods.map((p) => _buildPeriodHeaderCell(p['number']!)),
            ],
          ),
          // Header Row - Time Slots
          TableRow(
            decoration: BoxDecoration(
              color: const Color(0xFFf59e0b).withValues(alpha: 0.1),
            ),
            children: [
              Container(),
              ...periods.map((p) => _buildTimeHeaderCell(p['time']!)),
            ],
          ),
          // Day Rows
          ...days.map((day) {
            return TableRow(
              children: [
                _buildDayCell(day),
                ...periods.map((period) {
                  final slot = timetableData[day]?[period['time']!];
                  final isBreak = period['number']! == 'Break';
                  return _buildEditableCell(day, period['time']!, slot, isBreak);
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
            : const Color(0xFFf59e0b).withValues(alpha: 0.15),
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
        color: const Color(0xFFf59e0b).withValues(alpha: 0.05),
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

  Widget _buildEditableCell(String day, String time, EditableTimetableSlot? slot, bool isBreak) {
    if (isBreak) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.orange.shade50),
        child: Center(
          child: Text(
            'BREAK',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.orange.shade700,
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => _editCell(day, time, slot),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: slot?.isModified == true
              ? const Color(0xFF10b981).withValues(alpha: 0.1)
              : (slot == null ? Colors.white : const Color(0xFF06b6d4).withValues(alpha: 0.05)),
          border: slot?.isModified == true
              ? Border.all(color: const Color(0xFF10b981), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (slot == null) ...[
              Center(
                child: Icon(
                  Icons.add_circle_outline,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Tap to add',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ] else ...[
              if (slot.isModified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'EDITED',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (slot.isModified) const SizedBox(height: 4),
              Text(
                slot.subject,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a1f3a),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                slot.faculty,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (slot.room.isNotEmpty) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.room_rounded, size: 9, color: Colors.grey.shade600),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        slot.room,
                        style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _saveAllChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10b981),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Save All Changes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, Map<String, EditableTimetableSlot?>> _generateInitialData() {
    // Mock data - replace with API call
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final periods = [
      '9:00-9:50', '9:50-10:40', '10:40-11:30', '11:30-12:20',
      '12:20-1:10', '1:10-2:00', '2:00-2:50', '2:50-3:40', '3:40-4:30',
    ];

    final subjects = ['AI', 'CN', 'COA', 'EDA', 'OE', 'AI Lab', 'CN Lab'];
    final faculties = ['Dr. Smith', 'Prof. Johnson', 'Dr. Williams', 'Prof. Brown'];
    final rooms = ['R101', 'R102', 'R103', 'Lab1', 'Lab2'];

    final Map<String, Map<String, EditableTimetableSlot?>> data = {};

    for (var day in days) {
      data[day] = {};
      for (var i = 0; i < periods.length; i++) {
        final time = periods[i];
        
        if (time == '12:20-1:10') {
          data[day]![time] = null; // Break
          continue;
        }

        final hash = day.hashCode + i;
        if (hash % 5 == 0) {
          data[day]![time] = null; // Free period
        } else {
          data[day]![time] = EditableTimetableSlot(
            subject: subjects[hash % subjects.length],
            faculty: faculties[hash % faculties.length],
            room: rooms[hash % rooms.length],
          );
        }
      }
    }

    return data;
  }
}

// Edit Dialog Widget
class _EditCellDialog extends StatefulWidget {
  final String day;
  final String time;
  final EditableTimetableSlot? currentSlot;
  final Function(EditableTimetableSlot?) onSave;

  const _EditCellDialog({
    required this.day,
    required this.time,
    required this.currentSlot,
    required this.onSave,
  });

  @override
  State<_EditCellDialog> createState() => _EditCellDialogState();
}

class _EditCellDialogState extends State<_EditCellDialog> {
  late TextEditingController subjectController;
  late TextEditingController facultyController;
  late TextEditingController roomController;

  @override
  void initState() {
    super.initState();
    subjectController = TextEditingController(text: widget.currentSlot?.subject ?? '');
    facultyController = TextEditingController(text: widget.currentSlot?.faculty ?? '');
    roomController = TextEditingController(text: widget.currentSlot?.room ?? '');
  }

  @override
  void dispose() {
    subjectController.dispose();
    facultyController.dispose();
    roomController.dispose();
    super.dispose();
  }

  void _save() {
    if (subjectController.text.isEmpty) {
      // If subject is empty, mark as free period
      widget.onSave(null);
    } else {
      widget.onSave(EditableTimetableSlot(
        subject: subjectController.text,
        faculty: facultyController.text,
        room: roomController.text,
        isModified: true,
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Edit Slot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            '${widget.day} - ${widget.time}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                hintText: 'Leave empty for free period',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.book_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: facultyController,
              decoration: InputDecoration(
                labelText: 'Faculty',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.person_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: roomController,
              decoration: InputDecoration(
                labelText: 'Room',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.meeting_room_rounded, size: 20),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10b981),
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Data Model
class EditableTimetableSlot {
  String subject;
  String faculty;
  String room;
  bool isModified;

  EditableTimetableSlot({
    required this.subject,
    required this.faculty,
    required this.room,
    this.isModified = false,
  });
}
