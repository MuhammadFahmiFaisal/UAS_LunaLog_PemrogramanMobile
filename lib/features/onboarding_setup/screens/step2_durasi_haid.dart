import 'package:flutter/material.dart';

class Step2DurasiHaid extends StatefulWidget {
  final int durationDays;
  final ValueChanged<int> onDurationChanged;

  const Step2DurasiHaid({
    super.key,
    required this.durationDays,
    required this.onDurationChanged,
  });

  @override
  State<Step2DurasiHaid> createState() => _Step2DurasiHaidState();
}

class _Step2DurasiHaidState extends State<Step2DurasiHaid> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.durationDays.toDouble();
  }

  @override
  void didUpdateWidget(covariant Step2DurasiHaid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.durationDays != oldWidget.durationDays) {
      _currentValue = widget.durationDays.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

          // Illustration
          _buildIllustration(),
          const SizedBox(height: 40),

          // Question Section
          const Text(
            'Berapa hari rata-rata haidmu berlangsung?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF311119),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Biasanya 3-7 hari',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF524346).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 40),

          // Slider Card
          _buildSliderCard(),
          const SizedBox(height: 32),

          // Info Card
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFD9DF).withValues(alpha: 0.3),
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFF0F1),
          ),
          child: const Icon(
            Icons.calendar_today,
            size: 48,
            color: Color(0xFF6f3347),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7A5649).withValues(alpha: 0.04),
            blurRadius: 40,
            spreadRadius: -12,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          // Value Display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  '${_currentValue.toInt()}',
                  key: ValueKey(_currentValue.toInt()),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 64,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6f3347),
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'hari',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF524346),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              activeTrackColor: const Color(0xFF6f3347),
              inactiveTrackColor: const Color(0xFFFFD9DF),
              thumbColor: const Color(0xFF6f3347),
              overlayColor: const Color(0xFF6f3347).withValues(alpha: 0.1),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 14,
                elevation: 4,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: _currentValue,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() => _currentValue = value);
                widget.onDurationChanged(value.toInt());
              },
            ),
          ),
          const SizedBox(height: 8),

          // Tick Labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF524346),
                ),
              ),
              Text(
                '5',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF524346),
                ),
              ),
              Text(
                '10',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF524346),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
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
            Icons.info_outline,
            color: Color(0xFF6f3347),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Informasi ini membantu LunaLog memprediksi jendela kesuburan dan siklus Anda berikutnya dengan lebih akurat.',
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
}
