// Not posted faculty models
class NotPostedFaculty {
  final String employeeCode;
  final String employeeName;
  final String department;
  final String period;
  final String course;
  final String subject;
  final String branch;
  final String semester;

  NotPostedFaculty({
    required this.employeeCode,
    required this.employeeName,
    required this.department,
    required this.period,
    required this.course,
    required this.subject,
    required this.branch,
    required this.semester,
  });

  factory NotPostedFaculty.fromJson(Map<String, dynamic> json) {
    return NotPostedFaculty(
      employeeCode: json['employee_code'] ?? json['employeeCode'] ?? '',
      employeeName: json['employee_name'] ?? json['employeeName'] ?? '',
      department: json['department'] ?? '',
      period: json['period'] ?? '',
      course: json['course'] ?? '',
      subject: json['subject'] ?? '',
      branch: json['branch'] ?? '',
      semester: json['semester'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_code': employeeCode,
      'employee_name': employeeName,
      'department': department,
      'period': period,
      'course': course,
      'subject': subject,
      'branch': branch,
      'semester': semester,
    };
  }
}
