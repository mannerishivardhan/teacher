// Attendance shortage models
class ShortageStudent {
  final String rollNumber;
  final String studentName;
  final String course;
  final String branch;
  final String year;
  final String semester;
  final String section;
  final String? subject;
  final double attendancePercentage;
  final int classesHeld;
  final int classesAttended;
  final int classesShort;

  ShortageStudent({
    required this.rollNumber,
    required this.studentName,
    required this.course,
    required this.branch,
    required this.year,
    required this.semester,
    required this.section,
    this.subject,
    required this.attendancePercentage,
    required this.classesHeld,
    required this.classesAttended,
    required this.classesShort,
  });

  factory ShortageStudent.fromJson(Map<String, dynamic> json) {
    return ShortageStudent(
      rollNumber: json['roll_number'] ?? json['rollNumber'] ?? '',
      studentName: json['student_name'] ?? json['studentName'] ?? '',
      course: json['course'] ?? '',
      branch: json['branch'] ?? '',
      year: json['year'] ?? '',
      semester: json['semester'] ?? '',
      section: json['section'] ?? '',
      subject: json['subject'],
      attendancePercentage: (json['attendance_percentage'] ?? json['attendancePercentage'] ?? 0.0).toDouble(),
      classesHeld: json['classes_held'] ?? json['classesHeld'] ?? 0,
      classesAttended: json['classes_attended'] ?? json['classesAttended'] ?? 0,
      classesShort: json['classes_short'] ?? json['classesShort'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roll_number': rollNumber,
      'student_name': studentName,
      'course': course,
      'branch': branch,
      'year': year,
      'semester': semester,
      'section': section,
      'subject': subject,
      'attendance_percentage': attendancePercentage,
      'classes_held': classesHeld,
      'classes_attended': classesAttended,
      'classes_short': classesShort,
    };
  }
}

class ShortageFilterRequest {
  final String? courseId;
  final String? branchId;
  final String? year;
  final String? semester;
  final String? section;
  final String? subjectId;
  final double minPercentage;
  final double maxPercentage;

  ShortageFilterRequest({
    this.courseId,
    this.branchId,
    this.year,
    this.semester,
    this.section,
    this.subjectId,
    required this.minPercentage,
    required this.maxPercentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'branch_id': branchId,
      'year': year,
      'semester': semester,
      'section': section,
      'subject_id': subjectId,
      'min_percentage': minPercentage,
      'max_percentage': maxPercentage,
    };
  }
}
