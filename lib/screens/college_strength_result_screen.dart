import 'package:flutter/material.dart';

class CollegeStrengthResultScreen extends StatelessWidget {
  final String? seatType;
  final String? casteCategory;
  final String? yearOfStudy;
  final String? studentType;

  const CollegeStrengthResultScreen({
    super.key,
    this.seatType,
    this.casteCategory,
    this.yearOfStudy,
    this.studentType,
  });

  @override
  Widget build(BuildContext context) {
    // Mock dynamic data generation based on filters
    // In a real app, this would come from a backend or database
    final int baseCount = (yearOfStudy == 'All' || yearOfStudy == null) ? 400 : 100;
    final double multiplier = (seatType == 'All' || seatType == null) ? 1.0 : 0.25;
    
    final int boysStrength = (baseCount * multiplier * 0.6).round();
    final int girlsStrength = (baseCount * multiplier * 0.4).round();
    
    final int boysBus = (boysStrength * 0.4).round();
    final int girlsBus = (girlsStrength * 0.45).round();
    
    final int boysHostel = (boysStrength * 0.3).round();
    final int girlsHostel = (girlsStrength * 0.35).round();
    
    final int boysOwn = boysStrength - boysBus - boysHostel;
    final int girlsOwn = girlsStrength - girlsBus - girlsHostel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Strength Report',
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
            icon: const Icon(Icons.print_rounded, color: Color(0xFF06b6d4)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Printing Report...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Report Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    'COLLEGE STRENGTH',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1f3a),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'FOR THE ACADEMIC YEAR 2025 - 2026',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (yearOfStudy != null && yearOfStudy != 'All') ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF06b6d4).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Filter: $yearOfStudy',
                        style: const TextStyle(
                          color: Color(0xFF0891b2),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Data Table
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(const Color(0xFF06b6d4)),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 60,
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('PARTICULARS')),
                    DataColumn(label: Text('BOYS', textAlign: TextAlign.center)),
                    DataColumn(label: Text('GIRLS', textAlign: TextAlign.center)),
                    DataColumn(label: Text('TOTAL', textAlign: TextAlign.center)),
                  ],
                  rows: [
                    _buildDataRow(
                      'COLLEGE STRENGTH',
                      boysStrength,
                      girlsStrength,
                      isHeader: true,
                    ),
                    _buildDataRow(
                      'BUS TRANSPORTATION',
                      boysBus,
                      girlsBus,
                    ),
                    _buildDataRow(
                      'HOSTEL',
                      boysHostel,
                      girlsHostel,
                    ),
                    _buildDataRow(
                      'OWN TRANSPORTATION',
                      boysOwn,
                      girlsOwn,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String title, int boys, int girls, {bool isHeader = false}) {
    return DataRow(
      color: isHeader ? WidgetStateProperty.all(const Color(0xFFF0F9FF)) : null,
      cells: [
        DataCell(
          Text(
            title,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
              color: isHeader ? const Color(0xFF0891b2) : const Color(0xFF1a1f3a),
              fontSize: 15,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '$boys',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '$girls',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${boys + girls}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isHeader ? const Color(0xFF0891b2) : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
