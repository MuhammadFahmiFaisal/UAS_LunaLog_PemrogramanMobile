import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14A65F70),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context: context,
            icon: Icons.person_outline,
            title: 'Informasi Akun',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.editProfil);
            },
          ),
          const Divider(height: 1, indent: 72, color: AppTheme.outlineVariant),
          _buildMenuItem(
            context: context,
            icon: Icons.notifications_active_outlined,
            title: 'Pengaturan Notifikasi',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
          const Divider(height: 1, indent: 72, color: AppTheme.outlineVariant),
          _buildMenuItem(
            context: context,
            icon: Icons.lock_open_outlined,
            title: 'Metode Keamanan & PIN',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.securityPin);
            },
          ),
          const Divider(height: 1, indent: 72, color: AppTheme.outlineVariant),
          _buildMenuItem(
            context: context,
            icon: Icons.contact_support_outlined,
            title: 'Bantuan & Dukungan',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.helpSupport);
            },
          ),
          const Divider(height: 1, indent: 72, color: AppTheme.outlineVariant),
          _buildMenuItem(
            context: context,
            icon: Icons.info_outline,
            title: 'Tentang LunaLog',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'LunaLog',
                applicationVersion: '2.4.0',
                applicationIcon: const Icon(
                  Icons.favorite,
                  color: AppTheme.primary,
                  size: 32,
                ),
                children: const [
                  Text(
                    'LunaLog adalah aplikasi jurnal kesehatan menstruasi yang membantu Anda memahami siklus dan menjaga kesehatan reproduksi.',
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppTheme.surfaceContainerLow,
        highlightColor: AppTheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
