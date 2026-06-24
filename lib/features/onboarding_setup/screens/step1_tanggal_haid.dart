import 'package:flutter/material.dart';

class Step1TanggalHaid extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const Step1TanggalHaid({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<Step1TanggalHaid> createState() => _Step1TanggalHaidState();
}

class _Step1TanggalHaidState extends State<Step1TanggalHaid> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.selectedDate ?? DateTime.now();
  }

  @override
  void didUpdateWidget(covariant Step1TanggalHaid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null && widget.selectedDate != oldWidget.selectedDate) {
      _focusedMonth = widget.selectedDate!;
    }
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Title Section
          const Text(
            'Kapan tanggal haid terakhirmu?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF311119),
              letterSpacing: -0.01,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Informasi ini membantu kami memprediksi siklusmu dengan lebih akurat.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF524346).withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 32),

          // Calendar Widget
          _buildCalendar(),
          const SizedBox(height: 24),

          // Tip Card
          _buildTipCard(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4A5F).withValues(alpha: 0.04),
            blurRadius: 40,
            spreadRadius: -10,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = constraints.maxWidth / 7;
          return Column(
            children: [
              // Month Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getMonthName(_focusedMonth.month),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF311119),
                    ),
                  ),
                  Row(
                    children: [
                      _buildNavButton(
                        icon: Icons.chevron_left,
                        onTap: _previousMonth,
                      ),
                      const SizedBox(width: 8),
                      _buildNavButton(
                        icon: Icons.chevron_right,
                        onTap: _nextMonth,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Day Headers
              Row(
                children: ['M', 'S', 'S', 'R', 'K', 'J', 'S'].map((day) {
                  return SizedBox(
                    width: cellWidth,
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF847376),
                          letterSpacing: 0.05,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Calendar Grid
              _buildCalendarGrid(cellWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFF0F1),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF524346),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(double cellWidth) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final firstWeekday = firstDay.weekday;

    final days = <Widget>[];

    // Previous month days
    final prevMonthLastDay = DateTime(_focusedMonth.year, _focusedMonth.month, 0).day;
    for (int i = firstWeekday - 1; i > 0; i--) {
      final day = prevMonthLastDay - i + 1;
      days.add(_buildDayCell(day, cellWidth: cellWidth, isCurrentMonth: false));
    }

    // Current month days
    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final isSelected = widget.selectedDate != null &&
          date.year == widget.selectedDate!.year &&
          date.month == widget.selectedDate!.month &&
          date.day == widget.selectedDate!.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;

      days.add(_buildDayCell(
        day,
        cellWidth: cellWidth,
        isCurrentMonth: true,
        isSelected: isSelected,
        isToday: isToday,
        onTap: () => widget.onDateSelected(date),
      ));
    }

    // Next month days to fill 6 rows
    final remainingCells = (7 - (days.length % 7)) % 7;
    for (int day = 1; day <= remainingCells; day++) {
      days.add(_buildDayCell(day, cellWidth: cellWidth, isCurrentMonth: false));
    }

    return Wrap(
      children: days,
    );
  }

  Widget _buildDayCell(
    int day, {
    required double cellWidth,
    required bool isCurrentMonth,
    bool isSelected = false,
    bool isToday = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isCurrentMonth ? onTap : null,
      child: SizedBox(
        width: cellWidth,
        height: 40,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF6f3347) : null,
              border: isToday && !isSelected
                  ? Border.all(color: const Color(0xFF6f3347), width: 1.5)
                  : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: isToday || isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : isCurrentMonth
                          ? const Color(0xFF311119)
                          : const Color(0xFFD6C1C5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD6C1C5).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: Color(0xFF6f3347),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hari pertama pendarahan hebat adalah awal dari siklus menstruasimu. Jika lupa, kamu bisa mengisi perkiraan tanggalnya.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF524346).withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const names = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return names[month - 1];
  }
}
