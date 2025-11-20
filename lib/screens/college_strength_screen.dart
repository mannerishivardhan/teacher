import 'package:flutter/material.dart';

class CollegeStrengthScreen extends StatefulWidget {
  const CollegeStrengthScreen({super.key});

  @override
  State<CollegeStrengthScreen> createState() => _CollegeStrengthScreenState();
}

class _CollegeStrengthScreenState extends State<CollegeStrengthScreen> {
  final _formKey = GlobalKey<FormState>();

  // Filter Values
  String? _seatType;
  String? _casteCategory;
  String? _yearOfStudy;
  String? _studentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'College Strength',
          style: TextStyle(color: Color(0xFF1a1f3a), fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1a1f3a)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFilterHeader(),
              const SizedBox(height: 20),
              
              // Filter Options
              _buildFilterCard([
                const Text(
                  'Filter Criteria',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a1f3a),
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  'Seat Type',
                  ['Convener', 'Management', 'Spot', 'All'],
                  _seatType,
                  (val) => setState(() => _seatType = val),
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  'Caste Category',
                  ['OC', 'BC-A', 'BC-B', 'BC-C', 'BC-D', 'SC', 'ST', 'All'],
                  _casteCategory,
                  (val) => setState(() => _casteCategory = val),
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  'Year of Study',
                  ['1st Year', '2nd Year', '3rd Year', '4th Year', 'All'],
                  _yearOfStudy,
                  (val) => setState(() => _yearOfStudy = val),
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  'Student Type',
                  ['Dayscholar', 'Hosteler', 'All'],
                  _studentType,
                  (val) => setState(() => _studentType = val),
                ),
              ]),

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Calculating Strength...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06b6d4), // Cyan accent for strength
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: const Color(0xFF06b6d4).withValues(alpha: 0.4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Show Strength',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF06b6d4), Color(0xFF3b82f6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06b6d4).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.groups_rounded, color: Colors.white, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'College Strength',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'View student strength statistics based on filters',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF06b6d4), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      isExpanded: true,
    );
  }
}
