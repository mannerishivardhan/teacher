// Timetable models for dynamic data
class TimetableEntry {
  final String day;
  final String time;
  final String subject;
  final String faculty;
  final String room;

  TimetableEntry({
    required this.day,
    required this.time,
    required this.subject,
    required this.faculty,
    required this.room,
  });

  factory TimetableEntry.fromJson(Map<String, dynamic> json) {
    return TimetableEntry(
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      subject: json['subject'] ?? '',
      faculty: json['faculty'] ?? '',
      room: json['room'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'time': time,
      'subject': subject,
      'faculty': faculty,
      'room': room,
    };
  }
}

class Timetable {
  final String course;
  final String year;
  final String semester;
  final String branch;
  final String section;
  final List<TimetableEntry> entries;

  Timetable({
    required this.course,
    required this.year,
    required this.semester,
    required this.branch,
    required this.section,
    required this.entries,
  });

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      course: json['course'] ?? '',
      year: json['year'] ?? '',
      semester: json['semester'] ?? '',
      branch: json['branch'] ?? '',
      section: json['section'] ?? '',
      entries: (json['entries'] as List?)
              ?.map((e) => TimetableEntry.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course': course,
      'year': year,
      'semester': semester,
      'branch': branch,
      'section': section,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }
}
