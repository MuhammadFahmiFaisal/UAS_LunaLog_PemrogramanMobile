import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/models/models.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await SupabaseService.getUserProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _userProfile == null
                ? const Center(child: Text('Gagal memuat profil atau profil tidak ditemukan.'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        ProfileHeader(user: _userProfile!),
                        const SizedBox(height: 24),
                        ProfileStatsRow(user: _userProfile!),
                        const SizedBox(height: 24),
                        const ProfileMenuSection(),
                        const SizedBox(height: 24),
                        const LogoutButton(),
                        const SizedBox(height: 32),
                        _buildVersionInfo(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
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
