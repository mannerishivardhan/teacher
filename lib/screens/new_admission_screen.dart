import 'package:flutter/material.dart';

class NewAdmissionScreen extends StatefulWidget {
  const NewAdmissionScreen({super.key});

  @override
  State<NewAdmissionScreen> createState() => _NewAdmissionScreenState();
}

class _NewAdmissionScreenState extends State<NewAdmissionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _dobController = TextEditingController();
  final _admissionDateController = TextEditingController();

  // Form Values
  String? _gender;
  String? _scholarship;
  String? _physicallyHandicapped;
  String? _hostlerDayScholar;
  String? _bloodGroup;

  @override
  void dispose() {
    _dobController.dispose();
    _admissionDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6366f1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1a1f3a),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'New Admission',
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
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader('Personal Details'),
              const SizedBox(height: 16),
              
              // Basic Info Card
              _buildFormCard([
                _buildTextField('Roll No'),
                _buildTextField('Student Name'),
                _buildDropdown(
                  'Gender',
                  ['Male', 'Female', 'Other'],
                  _gender,
                  (val) => setState(() => _gender = val),
                ),
                _buildTextField('Course'),
                _buildTextField('Branch'),
                _buildTextField('Semester'),
              ]),

              const SizedBox(height: 16),

              // Dates & Admission Info
              _buildFormCard([
                _buildDatePicker('Date Of Birth', _dobController),
                _buildDatePicker('Date Of Admission', _admissionDateController),
                _buildTextField('Admission No'),
                _buildTextField('Admission Type'),
              ]),

              const SizedBox(height: 16),

              // Personal & Contact
              _buildFormCard([
                _buildTextField('Religion'),
                _buildTextField('Nationality'),
                _buildTextField('Mother Tongue'),
                _buildTextField('Land Line No', keyboardType: TextInputType.phone),
                _buildTextField('Student Mobile No', keyboardType: TextInputType.phone),
                _buildTextField('Email', keyboardType: TextInputType.emailAddress),
              ]),

              const SizedBox(height: 16),

              // Academic & Official
              _buildFormCard([
                _buildTextField('Entrance Type/Rank'),
                _buildTextField('Hall Ticket No'),
                _buildTextField('Seat Type'),
                _buildTextField('Category'),
                _buildDropdown(
                  'Scholarship',
                  ['Yes', 'No'],
                  _scholarship,
                  (val) => setState(() => _scholarship = val),
                ),
                _buildTextField('Last Attended Institution'),
              ]),

              const SizedBox(height: 16),

              // Additional Details
              _buildFormCard([
                _buildDropdown(
                  'Blood Group',
                  ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                  _bloodGroup,
                  (val) => setState(() => _bloodGroup = val),
                ),
                _buildTextField('Distance From Res. To College (km)', keyboardType: TextInputType.number),
                _buildTextField('Student Bank A/C No.'),
                _buildTextField('Ration Card No.'),
                _buildTextField('Adhaar Card No.'),
                _buildDropdown(
                  'Physically Handicapped',
                  ['Yes', 'No'],
                  _physicallyHandicapped,
                  (val) => setState(() => _physicallyHandicapped = val),
                ),
                _buildTextField('Identification Marks', maxLines: 2),
                _buildTextField('Remarks', maxLines: 3),
                _buildDropdown(
                  'Hostler/Dayscholar',
                  ['Hostler', 'Dayscholar'],
                  _hostlerDayScholar,
                  (val) => setState(() => _hostlerDayScholar = val),
                ),
              ]),

              const SizedBox(height: 16),

              // Parent Details
              _buildSectionHeader('Parent Details'),
              const SizedBox(height: 16),
              
              _buildFormCard([
                const Text('Father Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1a1f3a))),
                _buildTextField('Father Name'),
                _buildTextField('Father Occupation'),
                _buildTextField('Father Mobile No', keyboardType: TextInputType.phone),
                const Divider(height: 32),
                const Text('Mother Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1a1f3a))),
                _buildTextField('Mother Name'),
                _buildTextField('Mother Occupation'),
                _buildTextField('Mother Mobile No', keyboardType: TextInputType.phone),
                const Divider(height: 32),
                const Text('Guardian Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1a1f3a))),
                _buildTextField('Guardian Name'),
                _buildTextField('Guardian Occupation'),
                _buildTextField('Guardian Mobile No', keyboardType: TextInputType.phone),
              ]),

              const SizedBox(height: 16),

              // Photo Upload
              _buildFormCard([
                const Text(
                  'Student Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748b),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Photo upload feature coming soon')),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_rounded, size: 40, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            'Student photo not available\nClick here to upload',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Draft Saved')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF6366f1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 16, color: Color(0xFF6366f1)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366f1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF6366f1), width: 4),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1a1f3a),
          ),
        ),
        subtitle: const Text('Please fill in all the required details carefully'),
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        children: children.expand((widget) => [widget, const SizedBox(height: 20)]).toList()
          ..removeLast(),
      ),
    );
  }

  Widget _buildTextField(String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6366f1), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6366f1), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
    );
  }

  Widget _buildDatePicker(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6366f1), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
      ),
    );
  }
}
