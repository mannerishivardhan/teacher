import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/attendance_models.dart';

class AttendanceService {
  // TODO: Replace with your actual backend URL
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Fetch available courses from backend
  Future<List<FilterOption>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => FilterOption.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      // Return mock data if backend is not available
      return _getMockCourses();
    }
  }

  // Fetch branches for a specific course
  Future<List<FilterOption>> getBranches(String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/branches?course_id=$courseId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => FilterOption.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      return _getMockBranches(courseId);
    }
  }

  // Fetch subjects for a specific branch
  Future<List<FilterOption>> getSubjects(String branchId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subjects?branch_id=$branchId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => FilterOption.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      return _getMockSubjects(branchId);
    }
  }

  // Fetch attendance records based on filters
  Future<AttendanceResponse> getAttendanceRecords(
      AttendanceFilterRequest filters) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/attendance/records'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filters.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AttendanceResponse.fromJson(data);
      } else {
        throw Exception('Failed to load attendance records');
      }
    } catch (e) {
      // Return mock data if backend is not available
      return _getMockAttendanceRecords();
    }
  }

  // Mock data methods (fallback when backend is not available)
  List<FilterOption> _getMockCourses() {
    return [
      FilterOption(id: 'btech', name: 'B.Tech'),
      FilterOption(id: 'mtech', name: 'M.Tech'),
      FilterOption(id: 'bba', name: 'BBA'),
      FilterOption(id: 'mba', name: 'MBA'),
      FilterOption(id: 'bca', name: 'BCA'),
      FilterOption(id: 'mca', name: 'MCA'),
    ];
  }

  List<FilterOption> _getMockBranches(String courseId) {
    final Map<String, List<FilterOption>> branchesByCourse = {
      'btech': [
        FilterOption(id: 'cse', name: 'CSE'),
        FilterOption(id: 'ece', name: 'ECE'),
        FilterOption(id: 'me', name: 'ME'),
        FilterOption(id: 'ce', name: 'CE'),
        FilterOption(id: 'eee', name: 'EEE'),
        FilterOption(id: 'it', name: 'IT'),
      ],
      'mtech': [
        FilterOption(id: 'cse', name: 'CSE'),
        FilterOption(id: 'vlsi', name: 'VLSI'),
        FilterOption(id: 'power', name: 'Power Systems'),
        FilterOption(id: 'structural', name: 'Structural Engineering'),
      ],
      'bba': [
        FilterOption(id: 'general', name: 'General'),
        FilterOption(id: 'finance', name: 'Finance'),
        FilterOption(id: 'marketing', name: 'Marketing'),
      ],
      'mba': [
        FilterOption(id: 'general', name: 'General'),
        FilterOption(id: 'finance', name: 'Finance'),
        FilterOption(id: 'hr', name: 'HR'),
        FilterOption(id: 'marketing', name: 'Marketing'),
      ],
    };
    return branchesByCourse[courseId] ?? [FilterOption(id: 'general', name: 'General')];
  }

  List<FilterOption> _getMockSubjects(String branchId) {
    final Map<String, List<FilterOption>> subjectsByBranch = {
      'cse': [
        FilterOption(id: 'ds', name: 'Data Structures'),
        FilterOption(id: 'algo', name: 'Algorithms'),
        FilterOption(id: 'dbms', name: 'DBMS'),
        FilterOption(id: 'os', name: 'Operating Systems'),
        FilterOption(id: 'cn', name: 'Computer Networks'),
      ],
      'ece': [
        FilterOption(id: 'de', name: 'Digital Electronics'),
        FilterOption(id: 'ss', name: 'Signals & Systems'),
        FilterOption(id: 'cs', name: 'Communication Systems'),
        FilterOption(id: 'vlsi', name: 'VLSI Design'),
      ],
      'me': [
        FilterOption(id: 'thermo', name: 'Thermodynamics'),
        FilterOption(id: 'fluid', name: 'Fluid Mechanics'),
        FilterOption(id: 'mfg', name: 'Manufacturing Processes'),
        FilterOption(id: 'md', name: 'Machine Design'),
      ],
    };
    return subjectsByBranch[branchId] ??
        [
          FilterOption(id: 'mgmt', name: 'Management'),
          FilterOption(id: 'acc', name: 'Accounting'),
          FilterOption(id: 'mkt', name: 'Marketing'),
          FilterOption(id: 'law', name: 'Business Law'),
        ];
  }

  AttendanceResponse _getMockAttendanceRecords() {
    final students = [
      'Aarav Sharma',
      'Vivaan Patel',
      'Aditya Kumar',
      'Vihaan Singh',
      'Arjun Reddy',
      'Sai Krishna',
      'Reyansh Gupta',
      'Ayaan Khan',
      'Krishna Rao',
      'Ishaan Verma',
      'Shaurya Joshi',
      'Atharv Nair',
      'Advait Desai',
      'Pranav Iyer',
      'Dhruv Menon',
    ];

    final records = students.map((name) {
      final random = name.hashCode % 100;
      final present = 20 + (random % 15);
      final total = 30;
      return AttendanceRecord(
        studentId: 'STU${(students.indexOf(name) + 1).toString().padLeft(4, '0')}',
        studentName: name,
        rollNumber: 'CS${(students.indexOf(name) + 1).toString().padLeft(3, '0')}',
        presentDays: present,
        totalDays: total,
        percentage: (present / total * 100),
      );
    }).toList();

    final avgAttendance = records.map((r) => r.percentage).reduce((a, b) => a + b) / records.length;

    return AttendanceResponse(
      records: records,
      totalStudents: records.length,
      averageAttendance: avgAttendance,
    );
  }
}
