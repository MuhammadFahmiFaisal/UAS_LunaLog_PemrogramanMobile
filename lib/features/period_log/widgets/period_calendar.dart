import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class PeriodCalendar extends StatefulWidget {
  final List<Period> periods;
  final Function(int day, DateTime currentMonth) onDayTap;

  const PeriodCalendar({
    super.key,
    required this.periods,
    required this.onDayTap,
  });

  @override
  State<PeriodCalendar> createState() => _PeriodCalendarState();
}

class _PeriodCalendarState extends State<PeriodCalendar> {
  DateTime _currentMonth = DateTime.now();

  int get _averageCycleLength {
    if (widget.periods.length >= 2) {
      final sortedPeriods = List<Period>.from(widget.periods)
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
      int totalCycleLength = 0;
      for (int i = 1; i < sortedPeriods.length; i++) {
        totalCycleLength += sortedPeriods[i].startDate
            .difference(sortedPeriods[i - 1].startDate)
            .inDays;
      }
      return (totalCycleLength / (sortedPeriods.length - 1)).round();
    }
    return 28;
  }

  Map<String, bool> get _periodDayMap {
    final map = <String, bool>{};
    for (final period in widget.periods) {
      if (period.endDate == null) continue;
      DateTime current = period.startDate;
      while (!current.isAfter(period.endDate!)) {
        final key = '${current.year}-${current.month}-${current.day}';
        map[key] = true;
        current = current.add(const Duration(days: 1));
      }
    }
    return map;
  }

  Map<String, bool> get _fertileDayMap {
    final map = <String, bool>{};
    if (widget.periods.isEmpty) return map;
    final avgCycle = _averageCycleLength;
    for (final period in widget.periods) {
      final expectedNextPeriod = period.startDate.add(Duration(days: avgCycle));
      for (int i = 16; i >= 12; i--) {
        final fertileDay = expectedNextPeriod.subtract(Duration(days: i));
        final key = '${fertileDay.year}-${fertileDay.month}-${fertileDay.day}';
        map[key] = true;
      }
    }
    return map;
  }

  Map<String, bool> get _pmsDayMap {
    final map = <String, bool>{};
    if (widget.periods.isEmpty) return map;
    final avgCycle = _averageCycleLength;
    for (final period in widget.periods) {
      final expectedNextPeriod = period.startDate.add(Duration(days: avgCycle));
      for (int i = 7; i >= 1; i--) {
        final pmsDay = expectedNextPeriod.subtract(Duration(days: i));
        final key = '${pmsDay.year}-${pmsDay.month}-${pmsDay.day}';
        map[key] = true;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          _buildMonthNavigation(),
          const SizedBox(height: 20),
          _buildWeekdayHeaders(),
          const SizedBox(height: 12),
          _buildCalendarGrid(),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month - 1,
              );
            });
          },
          icon: const Icon(Icons.chevron_left, color: AppTheme.onSurfaceVariant),
        ),
        Text(
          _getMonthName(_currentMonth.month),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month + 1,
              );
            });
          },
          icon: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = ['SN', 'SL', 'RB', 'KM', 'JM', 'SB', 'MG'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return SizedBox(
          width: 36,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.outline,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    final firstDayWeekday = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    ).weekday;

    final days = <Widget>[];
    
    // Previous month padding
    final prevMonth = DateTime(_currentMonth.year, _currentMonth.month, 0);
    for (int i = firstDayWeekday - 1; i > 0; i--) {
      days.add(
        SizedBox(
          width: 36,
          height: 36,
          child: Text(
            '${prevMonth.day - i + 1}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppTheme.outline.withValues(alpha: 0.4),
            ),
          ),
        ),
      );
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      final dateKey = '${_currentMonth.year}-${_currentMonth.month}-$day';
      final isPeriodDay = _periodDayMap[dateKey] ?? false;
      final isFertileDay = _fertileDayMap[dateKey] ?? false;
      final isPmsDay = _pmsDayMap[dateKey] ?? false;
      days.add(_buildDayCell(day, isPeriodDay, isFertileDay, isPmsDay));
    }

    // Next month padding
    final remainingCells = 42 - days.length;
    for (int i = 1; i <= remainingCells; i++) {
      days.add(
        SizedBox(
          width: 36,
          height: 36,
          child: Text(
            '$i',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppTheme.outline.withValues(alpha: 0.4),
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 0,
      runSpacing: 12,
      children: days,
    );
  }

  Widget _buildDayCell(int day, bool isPeriodDay, bool isFertileDay, bool isPmsDay) {
    Color? bgColor;
    Color textColor = AppTheme.onSurface;
    bool isBold = false;

    if (isPeriodDay) {
      bgColor = AppTheme.statusHeavy;
      textColor = AppTheme.surfaceWhite;
      isBold = true;
    } else if (isFertileDay) {
      bgColor = AppTheme.calendarFertile;
      textColor = AppTheme.surfaceWhite;
      isBold = true;
    } else if (isPmsDay) {
      bgColor = AppTheme.calendarPms;
      textColor = AppTheme.onSurface;
      isBold = true;
    }

    return GestureDetector(
      onTap: () {
        widget.onDayTap(day, _currentMonth);
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(color: AppTheme.statusHeavy, label: 'Haid'),
          const SizedBox(width: 24),
          _buildLegendItem(color: AppTheme.calendarFertile, label: 'Masa Subur'),
          const SizedBox(width: 24),
          _buildLegendItem(color: AppTheme.calendarPms, label: 'PMS'),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${months[month - 1]} ${_currentMonth.year}';
  }
}
