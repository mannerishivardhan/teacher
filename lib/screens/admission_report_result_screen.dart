import 'package:flutter/material.dart';
import '../models/admission_report_models.dart';

class AdmissionReportResultScreen extends StatefulWidget {
  final AdmissionReportFilter filter;

  const AdmissionReportResultScreen({
    super.key,
    required this.filter,
  });

  @override
  State<AdmissionReportResultScreen> createState() =>
      _AdmissionReportResultScreenState();
}

class _AdmissionReportResultScreenState
    extends State<AdmissionReportResultScreen> {
  late Future<List<AdmissionRecord>> _reportDataFuture;

  @override
  void initState() {
    super.initState();
    _reportDataFuture = _fetchAdmissionReport();
  }

  // BACKEND INTEGRATION POINT
  // Replace this method with actual HTTP API call
  Future<List<AdmissionRecord>> _fetchAdmissionReport() async {
    // TODO: Replace with actual API call
    // Example implementation:
    // final queryParams = widget.filter.toQueryParams();
    // final response = await http.get(
    //   Uri.https('your-api-domain.com', '/api/admission/report', queryParams),
    // );
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = jsonDecode(response.body);
    //   return data.map((json) => AdmissionRecord.fromJson(json)).toList();
    // } else {
    //   throw Exception('Failed to load admission report');
    // }

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock data (replace with actual API response)
    return _generateMockData();
  }

  List<AdmissionRecord> _generateMockData() {
    // This is mock data - in production, this will be replaced by API response
    return List.generate(20, (index) {
      return AdmissionRecord(
        id: index + 1,
        rollNo: widget.filter.rollNo?.isNotEmpty == true
            ? '${widget.filter.rollNo}-${index + 1}'
            : '2023${widget.filter.branch ?? 'CSE'}${100 + index}',
        admissionNo: 'ADM${2023000 + index}',
        studentName: 'Student ${index + 1}',
        gender: widget.filter.gender ?? (index % 2 == 0 ? 'Male' : 'Female'),
        bloodGroup: 'O+',
        dateOfBirth: DateTime(2005, 1, 15),
        category: 'General',
        caste: widget.filter.caste ?? 'OC',
        nationality: 'Indian',
        religion: 'Hindu',
        motherTongue: 'Telugu',
        identificationMarks: 'Mole on right cheek',
        entranceType: 'EAMCET',
        hallticketNumber: '230510${1000 + index}',
        rank: '${1500 + index * 10}',
        joiningDate: widget.filter.admissionDate ?? DateTime(2023, 8, 1),
        seatType: widget.filter.seatType ?? 'Convener',
        admissionType: 'Regular',
        mobileNo: '98765432${10 + index}',
        scholarship: true,
        email: 'student${index + 1}@example.com',
        distanceFromResidence: '15 km',
        bankAccountNo: '1234567890$index',
        rationCardNo: 'WAP123456$index',
        aadharCardNo: '1234 5678 901$index',
        phc: false,
        permanentAddress: 'H.No 1-23, Street $index, City',
        correspondenceAddress: 'H.No 1-23, Street $index, City',
        sscHallTicketNo: '190510$index',
        sscBoard: 'SSC',
        sscYearOfPass: '2021',
        sscMarks: '580',
        sscPercentage: '9.8',
        sscInstitution: 'ZPHS School',
        sscGradePoints: '9.8',
        interHallTicketNo: '210510$index',
        interBoard: 'BIE',
        interYearOfPass: '2023',
        interMarks: '980',
        interPercentage: '98.0',
        interInstitution: 'Narayana Junior College',
        interGradePoints: 'A',
        fatherName: 'Father ${index + 1}',
        fatherOccupation: 'Employee',
        annualIncome: '100000',
        fatherMobileNo: '98765432${20 + index}',
        motherName: 'Mother ${index + 1}',
        motherOccupation: 'Housewife',
        motherMobile: '98765432${30 + index}',
        course: widget.filter.course ?? 'B.Tech',
        year: widget.filter.year ?? '2023-24',
        branch: widget.filter.branch,
        section: widget.filter.section,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Generated Report',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Color(0xFF8b5cf6)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading Report...')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AdmissionRecord>>(
        future: _reportDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF8b5cf6),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading admission records...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748b),
                    ),
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
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFFef4444),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFef4444),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _reportDataFuture = _fetchAdmissionReport();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8b5cf6),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Color(0xFF94a3b8),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No records found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748b),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try adjusting your filters',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94a3b8),
                    ),
                  ),
                ],
              ),
            );
          }

          final records = snapshot.data!;
          final columns = _getTableColumns();

          return Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                notificationPredicate: (notification) =>
                    notification.depth == 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    dataRowColor:
                        WidgetStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(0xFF8b5cf6).withValues(alpha: 0.08);
                      }
                      return null;
                    }),
                    columns: columns
                        .map((col) => DataColumn(
                              label: Text(
                                col,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1a1f3a),
                                ),
                              ),
                            ))
                        .toList(),
                    rows: records.map((record) {
                      final displayMap = record.toDisplayMap();
                      return DataRow(
                        cells: columns
                            .map((col) => DataCell(
                                  Text(
                                    displayMap[col] ?? '-',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ))
                            .toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _getTableColumns() {
    return [
      'Roll.No',
      'Admission.No',
      'Student Name',
      'Gender',
      'Blood Group',
      'Date Of Birth',
      'Category',
      'Caste',
      'Nationality',
      'Religion',
      'Mother Tongue',
      'Identification Marks',
      'Entrance Type',
      'Hallticket Number',
      'Rank',
      'Joining Date',
      'Seat Type',
      'Admission Type',
      'Mobile No.',
      'ScholarShip',
      'Email',
      'Distance From Residence',
      'Bank A/C No.',
      'Ration Card No.',
      'Adhar Card No.',
      'PHC',
      'Permanent Address',
      'Correspondence Address',
      'SSC Hall Ticket.No',
      'SSC Board',
      'SSC Year Of Pass',
      'SSC Marks',
      'SSC %',
      'SSC Institution',
      'SSC Grade Points',
      'Inter Hall Ticket.No',
      'Inter Board',
      'Inter Year Of Pass',
      'Inter Marks',
      'Inter %',
      'Inter Institution',
      'Inter Grade Points',
      'Diploma Hall Ticket.No',
      'Diploma Board',
      'Diploma Year Of Pass',
      'Diploma Marks',
      'Diploma %',
      'Diploma Institution',
      'Degree Hall Ticket.No',
      'Degree Board',
      'Degree Year Of Pass',
      'Degree Marks',
      'Degree %',
      'Degree Institution',
      'Father Name',
      'Father Occupation',
      'Annucal Income',
      'Father Mobile.No',
      'Mother Name',
      'Mother Occupation',
      'Mother Mobile',
      'Course',
      'Year',
      'Branch',
      'Section',
    ];
  }
}
