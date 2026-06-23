import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class NotificationSettingsSection extends StatelessWidget {
  final bool pengingatHaid;
  final bool masaSubur;
  final ValueChanged<bool> onPengingatHaidChanged;
  final ValueChanged<bool> onMasaSuburChanged;

  const NotificationSettingsSection({
    super.key,
    required this.pengingatHaid,
    required this.masaSubur,
    required this.onPengingatHaidChanged,
    required this.onMasaSuburChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.notifications,
              color: AppTheme.statusMedium,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Notifikasi',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.outlineAccent),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A6F3347),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildNotificationToggle(
                title: 'Pengingat Haid (H-2)',
                subtitle: 'Ingatkan saya sebelum siklus tiba',
                value: pengingatHaid,
                onChanged: onPengingatHaidChanged,
                showDivider: true,
              ),
              _buildNotificationToggle(
                title: 'Masa Subur',
                subtitle: 'Update tentang jendela kesuburan',
                value: masaSubur,
                onChanged: onMasaSuburChanged,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: AppTheme.primary,
                inactiveThumbColor: AppTheme.outline,
                inactiveTrackColor: AppTheme.surfaceContainerHighest,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: AppTheme.outlineAccent,
          ),
      ],
    );
  }
}
