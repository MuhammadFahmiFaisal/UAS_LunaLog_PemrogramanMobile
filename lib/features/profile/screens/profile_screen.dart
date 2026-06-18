import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/data/dummy_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildProfileHeader(user),
              const SizedBox(height: 24),
              _buildStatsSection(),
              const SizedBox(height: 24),
              _buildMenuSection(context),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
              const SizedBox(height: 32),
              _buildVersionInfo(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x268B4A5F),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  user.avatarUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.surfaceContainerHighest,
                      child: const Icon(
                        Icons.person,
                        size: 56,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 6,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          user.name,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium,
                size: 14,
                color: AppTheme.primary,
              ),
              SizedBox(width: 4),
              Text(
                'Luna Premium',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    final user = DummyData.currentUser;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'Rata-rata Siklus',
            value: '${user.cycleLength}',
            unit: 'hari',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            label: 'Durasi Haid',
            value: '${user.periodDuration}',
            unit: 'hari',
            showBorderX: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            label: 'Siklus Teratur',
            value: '',
            unit: '',
            icon: Icons.check_circle,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required String unit,
    IconData? icon,
    bool showBorderX = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14A65F70),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
        border: showBorderX
            ? Border.symmetric(
                horizontal: BorderSide(
                  color: AppTheme.outlineVariant.withValues(alpha: 0.3),
                ),
              )
            : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (icon != null)
            Icon(icon, color: AppTheme.primary, size: 24)
          else
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary,
                ),
                children: [
                  TextSpan(text: value),
                  if (unit.isNotEmpty)
                    TextSpan(
                      text: ' $unit',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
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
            icon: Icons.person_outline,
            title: 'Informasi Akun',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.editProfil);
            },
          ),
          const Divider(height: 1, indent: 72, color: AppTheme.outlineVariant),
          _buildMenuItem(
            icon: Icons.notifications_active_outlined,
            title: 'Pengaturan Notifikasi',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
          const Divider(height: 1, indent: 72, color: AppTheme.outlineVariant),
          _buildMenuItem(
            icon: Icons.lock_open_outlined,
            title: 'Metode Keamanan & PIN',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.securityPin);
            },
          ),
          const Divider(height: 1, indent: 72, color: AppTheme.outlineVariant),
          _buildMenuItem(
            icon: Icons.contact_support_outlined,
            title: 'Bantuan & Dukungan',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.helpSupport);
            },
          ),
          const Divider(height: 1, indent: 72, color: AppTheme.outlineVariant),
          _buildMenuItem(
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

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: OutlinedButton(
          onPressed: () => _showLogoutDialog(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.secondary,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            side: const BorderSide(color: AppTheme.secondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 20),
              SizedBox(width: 8),
              Text(
                'Keluar',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Keluar',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: const Text(
              'Keluar',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Text(
      'Versi 2.4.0 (LunaLog Global)',
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        color: AppTheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),
      textAlign: TextAlign.center,
    );
  }
}
