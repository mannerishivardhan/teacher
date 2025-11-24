// Model for attendance record
class AttendanceRecord {
  final String studentId;
  final String studentName;
  final String rollNumber;
  final int presentDays;
  final int totalDays;
  final double percentage;

  AttendanceRecord({
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.presentDays,
    required this.totalDays,
    required this.percentage,
  });

  // Factory constructor to create from JSON (backend response)
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      studentId: json['student_id'] ?? json['studentId'] ?? '',
      studentName: json['student_name'] ?? json['studentName'] ?? '',
      rollNumber: json['roll_number'] ?? json['rollNumber'] ?? '',
      presentDays: json['present_days'] ?? json['presentDays'] ?? 0,
      totalDays: json['total_days'] ?? json['totalDays'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
    );
  }

  // Convert to JSON for sending to backend
  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'roll_number': rollNumber,
      'present_days': presentDays,
      'total_days': totalDays,
      'percentage': percentage,
    };
  }
}

// Model for filter options
class FilterOption {
  final String id;
  final String name;

  FilterOption({
    required this.id,
    required this.name,
  });

  factory FilterOption.fromJson(Map<String, dynamic> json) {
    return FilterOption(
      id: json['id'] ?? json['value'] ?? '',
      name: json['name'] ?? json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// Model for attendance filter request
class AttendanceFilterRequest {
  final String? courseId;
  final String? semester;
  final String? branchId;
  final String? section;
  final String? subjectId;
  final DateTime? startDate;
  final DateTime? endDate;

  AttendanceFilterRequest({
    this.courseId,
    this.semester,
    this.branchId,
    this.section,
    this.subjectId,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'semester': semester,
      'branch_id': branchId,
      'section': section,
      'subject_id': subjectId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }
}

// Model for attendance response
class AttendanceResponse {
  final List<AttendanceRecord> records;
  final int totalStudents;
  final double averageAttendance;

  AttendanceResponse({
    required this.records,
    required this.totalStudents,
    required this.averageAttendance,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      records: (json['records'] as List?)
              ?.map((record) => AttendanceRecord.fromJson(record))
              .toList() ??
          [],
      totalStudents: json['total_students'] ?? json['totalStudents'] ?? 0,
      averageAttendance:
          (json['average_attendance'] ?? json['averageAttendance'] ?? 0.0)
              .toDouble(),
    );
  }
}
