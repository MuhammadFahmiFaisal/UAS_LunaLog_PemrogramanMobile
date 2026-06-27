import 'package:flutter/material.dart';

class Step4PilihTujuan extends StatefulWidget {
  final String? selectedGoal;
  final ValueChanged<String> onGoalSelected;

  const Step4PilihTujuan({
    super.key,
    required this.selectedGoal,
    required this.onGoalSelected,
  });

  @override
  State<Step4PilihTujuan> createState() => _Step4PilihTujuanState();
}

class _Step4PilihTujuanState extends State<Step4PilihTujuan> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Title Section
            const Text(
              'Apa tujuan utamamu menggunakan LunaLog?',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF311119),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pilih tujuan yang paling sesuai agar kami dapat memberikan pengalaman yang personal untukmu.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF524346).withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Option Cards
            _buildOptionCard(
              id: 'pantau_siklus',
              icon: Icons.calendar_today,
              title: 'Pantau Siklus',
              description: 'Lacak periode, gejala, dan prediksi masa subur bulananmu.',
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              id: 'promil',
              icon: Icons.child_care,
              title: 'Promil',
              description: 'Optimalkan peluang kehamilan dengan pelacakan masa subur intensif.',
            ),

            const SizedBox(height: 32),

            // Quote
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Text(
              '"Setiap langkah kecil membawamu lebih dekat pada kesejahteraan diri."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF7A5649).withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
    );
  }

  Widget _buildOptionCard({
    required String id,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isSelected = widget.selectedGoal == id;

    return GestureDetector(
      onTap: () => widget.onGoalSelected(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF0F1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6f3347)
                : const Color(0xFFD6C1C5).withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA65F70).withValues(alpha: isSelected ? 0.08 : 0.04),
              blurRadius: 20,
              spreadRadius: -4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF6f3347)
                    : const Color(0xFFFFE9EB),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF6f3347),
                size: 24,
              ),
            ),
            const SizedBox(width: 20),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF311119),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF524346).withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Radio Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF6f3347) : const Color(0xFFD6C1C5),
                  width: 2,
                ),
              ),
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isSelected ? 1.0 : 0.0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF6f3347),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
