import 'package:flutter/material.dart';

class AdmissionReportResultScreen extends StatelessWidget {
  final String? year;
  final String? course;
  final String? branch;
  final String? section;
  final String? rollNo;
  final DateTime? admissionDate;
  final String? gender;
  final String? seatType;
  final String? caste;

  const AdmissionReportResultScreen({
    super.key,
    this.year,
    this.course,
    this.branch,
    this.section,
    this.rollNo,
    this.admissionDate,
    this.gender,
    this.seatType,
    this.caste,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic data generation based on filters
    final List<Map<String, String>> reportData = List.generate(
      20,
      (index) {
        // Use filter values if present, otherwise generate random/default
        final currentGender = (gender != null && gender != 'All') 
            ? gender! 
            : (index % 2 == 0 ? 'Male' : 'Female');
            
        final currentCaste = (caste != null && caste != 'All') 
            ? caste! 
            : 'OC';
            
        final currentSeatType = (seatType != null && seatType != 'All') 
            ? seatType! 
            : 'Convener';

        final currentCourse = (course != null && course != 'All') 
            ? course! 
            : 'B.Tech';

        final currentBranch = (branch != null && branch != 'All') 
            ? branch! 
            : 'CSE';

        final currentYear = (year != null && year != 'All') 
            ? year! 
            : '1st Year';

        return {
        'Sl.No': '${index + 1}',
        'Roll.No': rollNo?.isNotEmpty == true ? '$rollNo-${index + 1}' : '2023$currentBranch${100 + index}',
        'Admission.No': 'ADM${2023000 + index}',
        'Student Name': 'Student ${index + 1}',
        'Gender': currentGender,
        'Blood Group': 'O+',
        'Date Of Birth': '2005-01-15',
        'Category': 'General',
        'Caste': currentCaste,
        'Nationality': 'Indian',
        'Religion': 'Hindu',
        'Mother Tongue': 'Telugu',
        'Identification Marks': 'Mole on right cheek',
        'Entrance Type': 'EAMCET',
        'Hallticket Number': '230510${1000 + index}',
        'Rank': '${1500 + index * 10}',
        'Joining Date': admissionDate != null 
            ? "${admissionDate!.day}/${admissionDate!.month}/${admissionDate!.year}" 
            : '2023-08-01',
        'Seat Type': currentSeatType,
        'Admission Type': 'Regular',
        'Mobile No.': '98765432${10 + index}',
        'ScholarShip': 'Yes',
        'Email': 'student${index + 1}@example.com',
        'Distance From Residence': '15 km',
        'Bank A/C No.': '1234567890$index',
        'Ration Card No.': 'WAP123456$index',
        'Adhar Card No.': '1234 5678 901$index',
        'PHC': 'No',
        'Permanent Address': 'H.No 1-23, Street $index, City',
        'Correspondence Address': 'H.No 1-23, Street $index, City',
        'SSC Hall Ticket.No': '190510$index',
        'SSC Board': 'SSC',
        'SSC Year Of Pass': '2021',
        'SSC Marks': '580',
        'SSC %': '9.8',
        'SSC Institution': 'ZPHS School',
        'SSC Grade Points': '9.8',
        'Inter Hall Ticket.No': '210510$index',
        'Inter Board': 'BIE',
        'Inter Year Of Pass': '2023',
        'Inter Marks': '980',
        'Inter %': '98.0',
        'Inter Institution': 'Narayana Junior College',
        'Inter Grade Points': 'A',
        'Diploma Hall Ticket.No': '-',
        'Diploma Board': '-',
        'Diploma Year Of Pass': '-',
        'Diploma Marks': '-',
        'Diploma %': '-',
        'Diploma Institution': '-',
        'Degree Hall Ticket.No': '-',
        'Degree Board': '-',
        'Degree Year Of Pass': '-',
        'Degree Marks': '-',
        'Degree %': '-',
        'Degree Institution': '-',
        'Father Name': 'Father ${index + 1}',
        'Father Occupation': 'Employee',
        'Annucal Income': '100000',
        'Father Mobile.No': '98765432${20 + index}',
        'Mother Name': 'Mother ${index + 1}',
        'Mother Occupation': 'Housewife',
        'Mother Mobile': '98765432${30 + index}',
        'Course': currentCourse,
        'Year': currentYear,
      };
      },
    );

    final columns = [
      'Sl.No', 'Roll.No', 'Admission.No', 'Student Name', 'Gender', 'Blood Group', 'Date Of Birth', 
      'Category', 'Caste', 'Nationality', 'Religion', 'Mother Tongue', 'Identification Marks', 
      'Entrance Type', 'Hallticket Number', 'Rank', 'Joining Date', 'Seat Type', 'Admission Type', 
      'Mobile No.', 'ScholarShip', 'Email', 'Distance From Residence', 'Bank A/C No.', 'Ration Card No.', 
      'Adhar Card No.', 'PHC', 'Permanent Address', 'Correspondence Address', 'SSC Hall Ticket.No', 
      'SSC Board', 'SSC Year Of Pass', 'SSC Marks', 'SSC %', 'SSC Institution', 'SSC Grade Points', 
      'Inter Hall Ticket.No', 'Inter Board', 'Inter Year Of Pass', 'Inter Marks', 'Inter %', 
      'Inter Institution', 'Inter Grade Points', 'Diploma Hall Ticket.No', 'Diploma Board', 
      'Diploma Year Of Pass', 'Diploma Marks', 'Diploma %', 'Diploma Institution', 'Degree Hall Ticket.No', 
      'Degree Board', 'Degree Year Of Pass', 'Degree Marks', 'Degree %', 'Degree Institution', 
      'Father Name', 'Father Occupation', 'Annucal Income', 'Father Mobile.No', 'Mother Name', 
      'Mother Occupation', 'Mother Mobile', 'Course', 'Year'
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Generated Report',
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
      body: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            notificationPredicate: (notification) => notification.depth == 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                dataRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.primary.withValues(alpha: 0.08);
                  }
                  return null;
                }),
                columns: columns.map((col) => DataColumn(
                  label: Text(
                    col,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1f3a),
                    ),
                  ),
                )).toList(),
                rows: reportData.map((row) {
                  return DataRow(
                    cells: columns.map((col) => DataCell(
                      Text(
                        row[col] ?? '-',
                        style: const TextStyle(fontSize: 13),
                      ),
                    )).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
