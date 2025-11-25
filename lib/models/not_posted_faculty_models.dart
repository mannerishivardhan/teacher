// Backend-ready data models for Not Posted Faculty

class NotPostedFacultyFilter {
  final DateTime date;
  final String? department;

  NotPostedFacultyFilter({
    required this.date,
    this.department,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'date': date.toIso8601String(),
      if (department != null && department!.isNotEmpty) 'department': department,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'department': department,
    };
  }
}

class NotPostedRecord {
  final String employeeCode;
  final String employeeName;
  final String period;
  final String subject;
  final String course;
  final String branch;
  final String semester;
  final String? year;
  final String? section;

  NotPostedRecord({
    required this.employeeCode,
    required this.employeeName,
    required this.period,
    required this.subject,
    required this.course,
    required this.branch,
    required this.semester,
    this.year,
    this.section,
  });

  factory NotPostedRecord.fromJson(Map<String, dynamic> json) {
    return NotPostedRecord(
      employeeCode: json['employee_code'],
      employeeName: json['employee_name'],
      period: json['period'],
      subject: json['subject'],
      course: json['course'],
      branch: json['branch'],
      semester: json['semester'],
      year: json['year'],
      section: json['section'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_code': employeeCode,
      'employee_name': employeeName,
      'period': period,
      'subject': subject,
      'course': course,
      'branch': branch,
      'semester': semester,
      'year': year,
      'section': section,
    };
  }
}

// Grouped faculty data class for display
class GroupedFacultyData {
  final String employeeCode;
  final String employeeName;
  final List<NotPostedRecord> records;

  GroupedFacultyData({
    required this.employeeCode,
    required this.employeeName,
    required this.records,
  });

  // Sort records by period number
  void sortRecords() {
    records.sort((a, b) {
      // Extract numeric part from period (e.g., "Period 1" -> 1)
      int getPeriodNumber(String period) {
        final match = RegExp(r'\d+').firstMatch(period);
        return match != null ? int.parse(match.group(0)!) : 0;
      }
      return getPeriodNumber(a.period).compareTo(getPeriodNumber(b.period));
    });
  }
}
