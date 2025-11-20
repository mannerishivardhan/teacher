import 'package:flutter/material.dart';
import 'new_admission_screen.dart';
import 'admission_report_screen.dart';
import 'college_strength_screen.dart';
import 'detain_rejoin_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedIndex = 0;

  final List<MenuItem> _menuItems = [
    MenuItem(title: 'Admissions', icon: Icons.school),
    MenuItem(title: 'Academics', icon: Icons.menu_book),
    MenuItem(title: 'Faculty', icon: Icons.people),
    MenuItem(title: 'Employee', icon: Icons.badge),
    MenuItem(title: 'Library', icon: Icons.local_library),
    MenuItem(title: 'Hostel', icon: Icons.hotel),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('College Management'),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade200,
                  Colors.grey.shade100,
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Menu Bar
          _buildMenuBar(),
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          return _buildMenuItem(index);
        },
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    final isSelected = _selectedIndex == index;
    final item = _menuItems[index];

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: 0.4 + (value * 0.6),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6366f1).withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6366f1).withValues(alpha: 0.3)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: isSelected
                        ? const Color(0xFF6366f1)
                        : const Color(0xFF64748b),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF6366f1)
                          : const Color(0xFF64748b),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Show admissions features when Admissions is selected
    if (_selectedIndex == 0) {
      return _buildAdmissionsContent();
    }
    
    // Show academics features when Academics is selected
    if (_selectedIndex == 1) {
      return _buildAcademicsContent();
    }
    
    // Show faculty features when Faculty is selected
    if (_selectedIndex == 2) {
      return _buildFacultyContent();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          _buildHeroSection(),
          const SizedBox(height: 40),
          // Feature Cards
          // _buildFeatureCards(),
        ],
      ),
    );
  }

  Widget _buildAdmissionsContent() {
    final admissionFeatures = [
      AdmissionFeature(
        title: 'New Admission',
        description: 'Register new students',
        icon: Icons.person_add_rounded,
        color: const Color(0xFF6366f1),
      ),
      AdmissionFeature(
        title: 'Admission Report',
        description: 'View statistics & reports',
        icon: Icons.assessment_rounded,
        color: const Color(0xFF8b5cf6),
      ),
      AdmissionFeature(
        title: 'College Strength',
        description: 'Monitor enrollment',
        icon: Icons.groups_rounded,
        color: const Color(0xFF06b6d4),
      ),
      AdmissionFeature(
        title: 'Detain/Rejoin',
        description: 'Manage detained students',
        icon: Icons.warning_rounded,
        color: const Color(0xFFf59e0b),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF8FAFC),
            Colors.white,
            const Color(0xFFF1F5F9),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            FadeTransition(
              opacity: _animationController,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366f1).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Admissions',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1a1f3a),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage student admissions and enrollment',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            // Feature Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate number of columns based on available width
                int crossAxisCount = 4;
                if (constraints.maxWidth < 1200) crossAxisCount = 3;
                if (constraints.maxWidth < 900) crossAxisCount = 2;
                if (constraints.maxWidth < 600) crossAxisCount = 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: admissionFeatures.length,
                  itemBuilder: (context, index) {
                    return _buildAdmissionFeatureCard(
                      admissionFeatures[index],
                      index,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicsContent() {
    final academicFeatures = [
      AdmissionFeature(
        title: 'Attendance',
        description: 'Mark and track student attendance',
        icon: Icons.how_to_reg_rounded,
        color: const Color(0xFF10b981),
      ),
      AdmissionFeature(
        title: 'Timetable',
        description: 'Manage class schedules',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFF6366f1),
      ),
      AdmissionFeature(
        title: 'Daily Absentees',
        description: 'View daily absent students',
        icon: Icons.person_off_rounded,
        color: const Color(0xFFef4444),
      ),
      AdmissionFeature(
        title: 'Day Attendance',
        description: 'Check day-wise attendance',
        icon: Icons.today_rounded,
        color: const Color(0xFF8b5cf6),
      ),
      AdmissionFeature(
        title: 'Shortage Check',
        description: 'Monitor attendance shortage',
        icon: Icons.warning_amber_rounded,
        color: const Color(0xFFf59e0b),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF8FAFC),
            Colors.white,
            const Color(0xFFF1F5F9),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            FadeTransition(
              opacity: _animationController,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10b981), Color(0xFF06b6d4)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10b981).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Academics',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1a1f3a),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage attendance and academic schedules',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            // Feature Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate number of columns based on available width
                int crossAxisCount = 4;
                if (constraints.maxWidth < 1200) crossAxisCount = 3;
                if (constraints.maxWidth < 900) crossAxisCount = 2;
                if (constraints.maxWidth < 600) crossAxisCount = 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: academicFeatures.length,
                  itemBuilder: (context, index) {
                    return _buildAdmissionFeatureCard(
                      academicFeatures[index],
                      index,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacultyContent() {
    final facultyFeatures = [
      AdmissionFeature(
        title: 'Faculty Leisure',
        description: 'Track faculty free periods',
        icon: Icons.free_breakfast_rounded,
        color: const Color(0xFF06b6d4),
      ),
      AdmissionFeature(
        title: 'Faculty Timetable',
        description: 'Manage faculty schedules',
        icon: Icons.schedule_rounded,
        color: const Color(0xFF8b5cf6),
      ),
      AdmissionFeature(
        title: 'Faculty Adjustments',
        description: 'Handle schedule changes',
        icon: Icons.swap_horiz_rounded,
        color: const Color(0xFFf59e0b),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF8FAFC),
            Colors.white,
            const Color(0xFFF1F5F9),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            FadeTransition(
              opacity: _animationController,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8b5cf6), Color(0xFF06b6d4)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8b5cf6).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.people_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Faculty',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1a1f3a),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage faculty schedules and adjustments',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            // Feature Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate number of columns based on available width
                int crossAxisCount = 4;
                if (constraints.maxWidth < 1200) crossAxisCount = 3;
                if (constraints.maxWidth < 900) crossAxisCount = 2;
                if (constraints.maxWidth < 600) crossAxisCount = 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: facultyFeatures.length,
                  itemBuilder: (context, index) {
                    return _buildAdmissionFeatureCard(
                      facultyFeatures[index],
                      index,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdmissionFeatureCard(AdmissionFeature feature, int index) {
    final delay = index * 0.1;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.2 + delay,
          0.7 + delay,
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              0.2 + delay,
              0.7 + delay,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.9),
                ],
              ),
              border: Border.all(
                color: feature.color.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: feature.color.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (feature.title == 'New Admission') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewAdmissionScreen(),
                        ),
                      );
                    } else if (feature.title == 'Admission Report') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdmissionReportScreen(),
                        ),
                      );
                    } else if (feature.title == 'College Strength') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CollegeStrengthScreen(),
                        ),
                      );
                    } else if (feature.title == 'Detain/Rejoin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetainRejoinScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${feature.title}...'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: feature.color,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  splashColor: feature.color.withValues(alpha: 0.1),
                  highlightColor: feature.color.withValues(alpha: 0.05),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          feature.color.withValues(alpha: 0.02),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon Container with enhanced design
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                feature.color.withValues(alpha: 0.15),
                                feature.color.withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: feature.color.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            feature.icon,
                            size: 28,
                            color: feature.color,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Title
                        Text(
                          feature.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1a1f3a),
                            height: 1.2,
                            letterSpacing: -0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        // Description
                        Text(
                          feature.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366f1),
                Color(0xFF8b5cf6),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366f1).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'College Management System',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Streamline your institution\'s operations with our comprehensive management platform',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem({required this.title, required this.icon});
}

class AdmissionFeature {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  AdmissionFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
