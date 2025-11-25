import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/not_posted_faculty_models.dart';

class NotPostedFacultyResultsScreen extends StatefulWidget {
  final DateTime date;
  final String? department;

  const NotPostedFacultyResultsScreen({
    super.key,
    required this.date,
    this.department,
  });

  @override
  State<NotPostedFacultyResultsScreen> createState() =>
      _NotPostedFacultyResultsScreenState();
}

class _NotPostedFacultyResultsScreenState
    extends State<NotPostedFacultyResultsScreen> {
  late Future<List<GroupedFacultyData>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchNotPostedFaculty();
  }

  // BACKEND INTEGRATION POINT
  Future<List<GroupedFacultyData>> _fetchNotPostedFaculty() async {
    // TODO: Replace with actual API call
    // final filter = NotPostedFacultyFilter(
    //   date: widget.date,
    //   department: widget.department,
    // );
    // final response = await http.get(
    //   Uri.https('your-api.com', '/api/faculty/not-posted', filter.toQueryParams()),
    // );
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = jsonDecode(response.body);
    //   final records = data.map((json) => NotPostedRecord.fromJson(json)).toList();
    //   return _groupByFaculty(records);
    // }

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock data
    final records = _generateMockData();
    return _groupByFaculty(records);
  }

  List<NotPostedRecord> _generateMockData() {
    // Mock data - replace with actual API
    return [
      NotPostedRecord(
        employeeCode: 'FAC001',
        employeeName: 'Dr. Rajesh Kumar',
        period: 'Period 1 (9:00-9:50)',
        subject: 'AI',
        course: 'B.Tech',
        branch: 'CSE',
        semester: 'III Semester',
        year: '2nd Year',
        section: 'A',
      ),
      NotPostedRecord(
        employeeCode: 'FAC001',
        employeeName: 'Dr. Rajesh Kumar',
        period: 'Period 3 (10:40-11:30)',
        subject: 'ML',
        course: 'B.Tech',
        branch: 'CSE',
        semester: 'V Semester',
        year: '3rd Year',
        section: 'B',
      ),
      NotPostedRecord(
        employeeCode: 'FAC001',
        employeeName: 'Dr. Rajesh Kumar',
        period: 'Period 5 (1:10-2:00)',
        subject: 'AI',
        course: 'B.Tech',
        branch: 'CSE',
        semester: 'III Semester',
        year: '2nd Year',
        section: 'C',
      ),
      NotPostedRecord(
        employeeCode: 'FAC002',
        employeeName: 'Prof. Anita Sharma',
        period: 'Period 2 (9:50-10:40)',
        subject: 'CN',
        course: 'B.Tech',
        branch: 'ECE',
        semester: 'IV Semester',
        year: '2nd Year',
        section: 'A',
      ),
      NotPostedRecord(
        employeeCode: 'FAC002',
        employeeName: 'Prof. Anita Sharma',
        period: 'Period 4 (11:30-12:20)',
        subject: 'OS',
        course: 'B.Tech',
        branch: 'CSE',
        semester: 'VI Semester',
        year: '3rd Year',
        section: 'B',
      ),
      NotPostedRecord(
        employeeCode: 'FAC003',
        employeeName: 'Dr. Suresh Patel',
        period: 'Period 1 (9:00-9:50)',
        subject: 'DBMS',
        course: 'B.Tech',
        branch: 'IT',
        semester: 'V Semester',
        year: '3rd Year',
        section: 'A',
      ),
    ];
  }

  // Group records by faculty
  List<GroupedFacultyData> _groupByFaculty(List<NotPostedRecord> records) {
    final Map<String, List<NotPostedRecord>> groupedMap = {};

    for (var record in records) {
      if (!groupedMap.containsKey(record.employeeCode)) {
        groupedMap[record.employeeCode] = [];
      }
      groupedMap[record.employeeCode]!.add(record);
    }

    final grouped = groupedMap.entries.map((entry) {
      final firstRecord = entry.value.first;
      final group = GroupedFacultyData(
        employeeCode: entry.key,
        employeeName: firstRecord.employeeName,
        records: entry.value,
      );
      group.sortRecords(); // Sort by period
      return group;
    }).toList();

    // Sort by employee name
    grouped.sort((a, b) => a.employeeName.compareTo(b.employeeName));

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Not Posted Faculty',
          style:
              TextStyle(color: Color(0xFF1a1f3a), fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1a1f3a)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: FutureBuilder<List<GroupedFacultyData>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFef4444)),
                  SizedBox(height: 16),
                  Text(
                    'Loading data...',
                    style: TextStyle(fontSize: 14, color: Color(0xFF64748b)),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 64, color: Color(0xFFef4444)),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 14, color: Color(0xFFef4444)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dataFuture = _fetchNotPostedFaculty();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFef4444),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 64, color: Color(0xFF10b981)),
                  const SizedBox(height: 16),
                  const Text(
                    'All faculty have posted attendance!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10b981),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(widget.date)}',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF64748b)),
                  ),
                ],
              ),
            );
          }

          final groupedData = snapshot.data!;

          return Column(
            children: [
              _buildSummaryHeader(groupedData),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupedData.length,
                  itemBuilder: (context, index) {
                    return _buildFacultyCard(groupedData[index], index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryHeader(List<GroupedFacultyData> data) {
    final totalRecords = data.fold(0, (sum, group) => sum + group.records.length);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFef4444), Color(0xFFdc2626)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFef4444).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.warning_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Not Posted Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.length} Faculty • $totalRecords Periods • ${DateFormat('dd MMM yyyy').format(widget.date)}',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacultyCard(GroupedFacultyData group, int groupIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFef4444).withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Faculty Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFef4444).withValues(alpha: 0.1),
                  const Color(0xFFef4444).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFef4444).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFFef4444),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.employeeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a1f3a),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Code: ${group.employeeCode}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFef4444),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${group.records.length} Periods',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Records Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 36,
              dataRowMaxHeight: 48,
              columnSpacing: 24,
              horizontalMargin: 16,
              headingRowColor: WidgetStateProperty.all(
                const Color(0xFFF8FAFC),
              ),
              columns: const [
                DataColumn(label: Text('S.No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Period', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Course', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Branch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Semester', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('Year', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: group.records.asMap().entries.map((entry) {
                final idx = entry.key;
                final record = entry.value;
                return DataRow(
                  cells: [
                    DataCell(Text('${idx + 1}', style: const TextStyle(fontSize: 12))),
                    DataCell(Text(record.period, style: const TextStyle(fontSize: 12))),
                    DataCell(Text(record.subject, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                    DataCell(Text(record.course, style: const TextStyle(fontSize: 12))),
                    DataCell(Text(record.branch, style: const TextStyle(fontSize: 12))),
                    DataCell(Text(record.semester, style: const TextStyle(fontSize: 12))),
                    DataCell(Text(record.year ?? '-', style: const TextStyle(fontSize: 12))),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
