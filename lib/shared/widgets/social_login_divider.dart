import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SocialLoginDivider extends StatelessWidget {
  final String text;

  const SocialLoginDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.outline.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
