import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/services/supabase_service.dart';

class EditProfilScreen extends StatefulWidget {
  const EditProfilScreen({super.key});

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  int _cycleLength = 28;
  int _periodLength = 5;
  bool _predictCycle = true;
  bool _isLoading = true;
  bool _isSaving = false;

  UserProfile? _profile;
  File? _pickedImageFile;      // file lokal yang baru dipilih user
  String? _currentAvatarUrl;  // URL dari Supabase (sudah ada)

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await SupabaseService.getUserProfile();
      if (mounted && profile != null) {
        setState(() {
          _profile = profile;
          _nameController.text = profile.name;
          _emailController.text = profile.email;
          _currentAvatarUrl = profile.avatarUrl;
          _cycleLength = profile.cycleLength;
          _periodLength = profile.periodDuration;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_camera, color: AppTheme.primary),
              title: const Text('Ambil dari Kamera',
                  style: TextStyle(fontFamily: 'Inter')),
              onTap: () async {
                Navigator.pop(ctx);
                final picked =
                    await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                if (picked != null && mounted) {
                  setState(() => _pickedImageFile = File(picked.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.primary),
              title: const Text('Pilih dari Galeri',
                  style: TextStyle(fontFamily: 'Inter')),
              onTap: () async {
                Navigator.pop(ctx);
                final picked =
                    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                if (picked != null && mounted) {
                  setState(() => _pickedImageFile = File(picked.path));
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty) {
      _showSnack('Nama tidak boleh kosong', isError: true);
      return;
    }
    if (_emailController.text.trim().isEmpty ||
        !_emailController.text.contains('@')) {
      _showSnack('Email tidak valid', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    try {
      String? avatarUrl = _currentAvatarUrl;

      // Upload foto baru jika user memilih gambar
      if (_pickedImageFile != null) {
        avatarUrl = await SupabaseService.uploadAvatar(_pickedImageFile!);
      }

      final updatedProfile = _profile!.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        avatarUrl: avatarUrl,
        cycleLength: _cycleLength,
        periodDuration: _periodLength,
      );

      await SupabaseService.updateUserProfile(updatedProfile);

      if (!mounted) return;
      _showSnack('Profil berhasil diperbarui');
      Navigator.pop(context, true); // true = ada perubahan
    } catch (e) {
      if (!mounted) return;
      _showSnack('Gagal menyimpan: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Inter')),
        backgroundColor: isError ? AppTheme.error : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primary))
            : Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildAvatarSection(),
                          const SizedBox(height: 24),
                          _buildFormSection(),
                          const SizedBox(height: 24),
                          _buildCycleSettingsSection(),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            color: AppTheme.primary,
          ),
          const Expanded(
            child: Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            color: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x268B4A5F),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _pickedImageFile != null
                      // Tampilkan gambar yang baru dipilih
                      ? Image.file(_pickedImageFile!, fit: BoxFit.cover)
                      // Tampilkan avatar dari Supabase atau fallback ikon
                      : (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty
                          ? Image.network(
                              _currentAvatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _avatarFallback(),
                            )
                          : _avatarFallback()),
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
                  child: const Icon(Icons.photo_camera, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _nameController.text.isNotEmpty ? _nameController.text : '-',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Ketuk foto untuk mengubah gambar profil',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: AppTheme.surfaceContainerHighest,
      child: const Icon(Icons.person, size: 56, color: AppTheme.onSurfaceVariant),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: 'Full Name',
          controller: _nameController,
          icon: Icons.person_outline,
          hintText: 'Masukkan nama',
          onChanged: (_) => setState(() {}), // update nama di avatar section
        ),
        const SizedBox(height: 12),
        _buildInputField(
          label: 'Email Address',
          controller: _emailController,
          icon: Icons.mail_outline,
          hintText: 'Masukkan email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _buildInputField(
          label: 'Phone Number',
          controller: _phoneController,
          icon: Icons.phone_outlined,
          hintText: '+62 (555) 000-0000',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: AppTheme.onSurfaceVariant,
            ),
            prefixIcon: Icon(icon, color: AppTheme.onSurfaceVariant, size: 20),
            filled: true,
            fillColor: AppTheme.surfaceWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: AppTheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildCycleSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F8B4A5F), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, color: AppTheme.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Pengaturan Siklus',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStepper(
                  label: 'Panjang Siklus',
                  value: _cycleLength,
                  unit: 'Hari',
                  onDecrement: () => setState(() { if (_cycleLength > 21) _cycleLength--; }),
                  onIncrement: () => setState(() { if (_cycleLength < 45) _cycleLength++; }),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStepper(
                  label: 'Durasi Haid',
                  value: _periodLength,
                  unit: 'Hari',
                  onDecrement: () => setState(() { if (_periodLength > 1) _periodLength--; }),
                  onIncrement: () => setState(() { if (_periodLength < 10) _periodLength++; }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.outlineVariant, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Prediksi Siklus Berikutnya',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: AppTheme.onSurface),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Prediksi berdasarkan data siklus Anda',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _predictCycle,
                  onChanged: (v) => setState(() => _predictCycle = v),
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppTheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper({
    required String label,
    required int value,
    required String unit,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onDecrement,
                child: Container(
                  width: 32, height: 32,
                  decoration: const BoxDecoration(
                    color: AppTheme.secondaryContainer, shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, color: AppTheme.primary, size: 18),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$value',
                style: const TextStyle(
                  fontFamily: 'Inter', fontSize: 28,
                  fontWeight: FontWeight.w600, color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onIncrement,
                child: Container(
                  width: 32, height: 32,
                  decoration: const BoxDecoration(
                    color: AppTheme.secondaryContainer, shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: AppTheme.primary, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(unit, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppTheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              elevation: 4,
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Simpan Perubahan',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
