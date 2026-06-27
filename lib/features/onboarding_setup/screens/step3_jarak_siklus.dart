import 'package:flutter/material.dart';

class Step3JarakSiklus extends StatefulWidget {
  final int cycleLength;
  final ValueChanged<int> onCycleLengthChanged;

  const Step3JarakSiklus({
    super.key,
    required this.cycleLength,
    required this.onCycleLengthChanged,
  });

  @override
  State<Step3JarakSiklus> createState() => _Step3JarakSiklusState();
}

class _Step3JarakSiklusState extends State<Step3JarakSiklus> {
  late ScrollController _scrollController;
  late int _selectedValue;
  final double _itemHeight = 64.0;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.cycleLength;
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToValue(_selectedValue, animate: false);
    });
  }

  @override
  void didUpdateWidget(covariant Step3JarakSiklus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cycleLength != oldWidget.cycleLength) {
      _selectedValue = widget.cycleLength;
      _scrollToValue(_selectedValue, animate: false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToValue(int value, {bool animate = true}) {
    // Offset so the selected value appears centered in the highlight band
    final targetIndex = value - 15;
    final targetOffset = (targetIndex - 2) * _itemHeight;
    if (animate) {
      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      );
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    // The highlight band is at position 2 from the top of the viewport
    final centerIndex = (offset / _itemHeight).round() + 2;
    final newValue = (centerIndex + 15).clamp(15, 45);

    if (newValue != _selectedValue) {
      setState(() => _selectedValue = newValue);
      widget.onCycleLengthChanged(newValue);
    }
  }

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
              'Berapa lama jarak antar siklusmu?',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6f3347),
                letterSpacing: -0.01,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF524346).withValues(alpha: 0.8),
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text:
                        'Dihitung dari hari pertama haid sampai hari pertama haid berikutnya. ',
                  ),
                  TextSpan(
                    text: 'Rata-rata 28 hari.',
                    style: TextStyle(
                      color: const Color(0xFF6f3347),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Number Picker
            _buildNumberPicker(),
            const SizedBox(height: 24),

          // Info Card
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildNumberPicker() {
    return Center(
      child: SizedBox(
        height: _itemHeight * 5,
        width: 200,
        child: Stack(
          children: [
            // Selection Highlight
            Positioned(
              top: _itemHeight * 2,
              left: 0,
              right: 0,
              height: _itemHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFBE3EA)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B4A5F).withValues(alpha: 0.04),
                      blurRadius: 20,
                      spreadRadius: -4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      'HARI',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6f3347).withValues(alpha: 0.6),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Gradient Overlays
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _itemHeight * 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFFFF8F7),
                      const Color(0xFFFFF8F7).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: _itemHeight * 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFFFF8F7).withValues(alpha: 0.0),
                      const Color(0xFFFFF8F7),
                    ],
                  ),
                ),
              ),
            ),

            // Scrollable List
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                _onScroll();
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemExtent: _itemHeight,
                padding: EdgeInsets.zero,
                itemCount: 31, // 15 to 45
                itemBuilder: (context, index) {
                  final value = index + 15;
                  final isSelected = value == _selectedValue;

                  return Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isSelected ? 32 : 28,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFF6f3347)
                            : const Color(0xFF524346).withValues(alpha: 0.3),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _scrollToValue(value);
                        },
                        child: Center(
                          child: Text('$value', textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4A5F).withValues(alpha: 0.04),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFFBE3EA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFF0F1),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Color(0xFF6f3347),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kenapa ini penting?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6f3347),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Data ini membantu LunaLog memprediksi masa subur dan hari pertama haid berikutnya dengan lebih akurat.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF524346).withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
