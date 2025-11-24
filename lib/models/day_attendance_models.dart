// Day attendance statistics models
class BranchAttendanceStats {
  final String branchName;
  final int totalStudents;
  final int presentStudents;
  final int absentStudents;
  final double presentPercentage;
  final double absentPercentage;

  BranchAttendanceStats({
    required this.branchName,
    required this.totalStudents,
    required this.presentStudents,
    required this.absentStudents,
    required this.presentPercentage,
    required this.absentPercentage,
  });

  factory BranchAttendanceStats.fromJson(Map<String, dynamic> json) {
    return BranchAttendanceStats(
      branchName: json['branch_name'] ?? json['branchName'] ?? '',
      totalStudents: json['total_students'] ?? json['totalStudents'] ?? 0,
      presentStudents: json['present_students'] ?? json['presentStudents'] ?? 0,
      absentStudents: json['absent_students'] ?? json['absentStudents'] ?? 0,
      presentPercentage: (json['present_percentage'] ?? json['presentPercentage'] ?? 0.0).toDouble(),
      absentPercentage: (json['absent_percentage'] ?? json['absentPercentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name': branchName,
      'total_students': totalStudents,
      'present_students': presentStudents,
      'absent_students': absentStudents,
      'present_percentage': presentPercentage,
      'absent_percentage': absentPercentage,
    };
  }
}

class DayAttendanceResponse {
  final String date;
  final String course;
  final String year;
  final List<BranchAttendanceStats> branchStats;
  final int totalStudents;
  final int totalPresent;
  final int totalAbsent;

  DayAttendanceResponse({
    required this.date,
    required this.course,
    required this.year,
    required this.branchStats,
    required this.totalStudents,
    required this.totalPresent,
    required this.totalAbsent,
  });

  factory DayAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return DayAttendanceResponse(
      date: json['date'] ?? '',
      course: json['course'] ?? '',
      year: json['year'] ?? '',
      branchStats: (json['branch_stats'] as List?)
              ?.map((e) => BranchAttendanceStats.fromJson(e))
              .toList() ??
          [],
      totalStudents: json['total_students'] ?? json['totalStudents'] ?? 0,
      totalPresent: json['total_present'] ?? json['totalPresent'] ?? 0,
      totalAbsent: json['total_absent'] ?? json['totalAbsent'] ?? 0,
    );
  }
}
