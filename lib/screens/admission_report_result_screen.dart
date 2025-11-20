import 'package:flutter/material.dart';

class AdmissionReportResultScreen extends StatelessWidget {
  const AdmissionReportResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data generation
    final List<Map<String, String>> reportData = List.generate(
      20,
      (index) => {
        'Sl.No': '${index + 1}',
        'Roll.No': '2023CSE${100 + index}',
        'Admission.No': 'ADM${2023000 + index}',
        'Student Name': 'Student ${index + 1}',
        'Gender': index % 2 == 0 ? 'Male' : 'Female',
        'Blood Group': 'O+',
        'Date Of Birth': '2005-01-15',
        'Category': 'General',
        'Caste': 'OC',
        'Nationality': 'Indian',
        'Religion': 'Hindu',
        'Mother Tongue': 'Telugu',
        'Identification Marks': 'Mole on right cheek',
        'Entrance Type': 'EAMCET',
        'Hallticket Number': '230510${1000 + index}',
        'Rank': '${1500 + index * 10}',
        'Joining Date': '2023-08-01',
        'Seat Type': 'Convener',
        'Admission Type': 'Regular',
        'Mobile No.': '98765432${10 + index}',
        'ScholarShip': 'Yes',
        'Email': 'student${index + 1}@example.com',
        'Distance From Residence': '15 km',
        'Bank A/C No.': '1234567890${index}',
        'Ration Card No.': 'WAP123456${index}',
        'Adhar Card No.': '1234 5678 901${index}',
        'PHC': 'No',
        'Permanent Address': 'H.No 1-23, Street ${index}, City',
        'Correspondence Address': 'H.No 1-23, Street ${index}, City',
        'SSC Hall Ticket.No': '190510${index}',
        'SSC Board': 'SSC',
        'SSC Year Of Pass': '2021',
        'SSC Marks': '580',
        'SSC %': '9.8',
        'SSC Institution': 'ZPHS School',
        'SSC Grade Points': '9.8',
        'Inter Hall Ticket.No': '210510${index}',
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
      'Mother Occupation', 'Mother Mobile'
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
                    return Theme.of(context).colorScheme.primary.withOpacity(0.08);
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
