import 'package:flutter/material.dart';

class DetainRejoinScreen extends StatefulWidget {
  const DetainRejoinScreen({super.key});

  @override
  State<DetainRejoinScreen> createState() => _DetainRejoinScreenState();
}

class _DetainRejoinScreenState extends State<DetainRejoinScreen> {
  final _formKey = GlobalKey<FormState>();

  // Filter Values
  String _actionType = 'Detain'; // Detain or Rejoin
  String? _course;
  bool _byAttendance = false;
  bool _byCredits = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Detain / Rejoin',
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
              _buildHeader(),
              const SizedBox(height: 20),
              
              // Action Type Selection
              _buildCard([
                const Text(
                  'Select Action',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a1f3a),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionTypeCard(
                        'Detain',
                        Icons.block_rounded,
                        Colors.red,
                        _actionType == 'Detain',
                        () => setState(() => _actionType = 'Detain'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionTypeCard(
                        'Rejoin',
                        Icons.replay_rounded,
                        Colors.green,
                        _actionType == 'Rejoin',
                        () => setState(() => _actionType = 'Rejoin'),
                      ),
                    ),
                  ],
                ),
              ]),

              const SizedBox(height: 16),

              // Filter Options
              _buildCard([
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
                  'Course',
                  ['B.Tech', 'M.Tech', 'MBA', 'BBA'],
                  _course,
                  (val) => setState(() => _course = val),
                ),
                
                const SizedBox(height: 24),
                const Text(
                  'Criteria',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748b),
                  ),
                ),
                const SizedBox(height: 12),
                
                _buildCheckboxTile(
                  'By Attendance',
                  'Filter students with low attendance',
                  _byAttendance,
                  (val) => setState(() => _byAttendance = val ?? false),
                ),
                const SizedBox(height: 12),
                _buildCheckboxTile(
                  'By Credits',
                  'Filter students with insufficient credits',
                  _byCredits,
                  (val) => setState(() => _byCredits = val ?? false),
                ),
              ]),

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (!_byAttendance && !_byCredits) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one criteria (Attendance or Credits)'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Processing ${_actionType} Request...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf59e0b), // Amber accent
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: const Color(0xFFf59e0b).withValues(alpha: 0.4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Proceed',
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf59e0b), Color(0xFFd97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf59e0b).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Status',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Detain or Rejoin students based on academic performance',
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

  Widget _buildCard(List<Widget> children) {
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

  Widget _buildActionTypeCard(String title, IconData icon, Color color, bool isSelected, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade400,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
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
          borderSide: const BorderSide(color: Color(0xFFf59e0b), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      isExpanded: true,
    );
  }

  Widget _buildCheckboxTile(String title, String subtitle, bool value, void Function(bool?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: value ? const Color(0xFFf59e0b) : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: value ? const Color(0xFFf59e0b).withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: value ? const Color(0xFF1a1f3a) : Colors.grey.shade700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
        activeColor: const Color(0xFFf59e0b),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}
