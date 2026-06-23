import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/services/supabase_service.dart';

class LogHarianScreen extends StatefulWidget {
  const LogHarianScreen({super.key});

  @override
  State<LogHarianScreen> createState() => _LogHarianScreenState();
}

class _LogHarianScreenState extends State<LogHarianScreen> {
  String? _selectedFlow;
  final Set<String> _selectedSymptoms = {};
  String? _selectedMood;
  bool _isSexualActive = false;
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _flowOptions = [
    {'label': 'Ringan', 'icon': Icons.water_drop_outlined},
    {'label': 'Sedang', 'icon': Icons.water_drop},
    {'label': 'Deras', 'icon': Icons.water_drop},
    {'label': 'Sangat Deras', 'icon': Icons.water_drop},
  ];

  final List<Map<String, dynamic>> _symptomOptions = [
    {'key': 'kram', 'label': 'Kram Parah', 'icon': Icons.sick_outlined},
    {'key': 'pusing', 'label': 'Pusing', 'icon': Icons.psychology_outlined},
    {'key': 'payudara', 'label': 'Payudara Sensitif', 'icon': Icons.favorite_outline},
    {'key': 'jerawat', 'label': 'Jerawat', 'icon': Icons.face_outlined},
  ];

  final List<Map<String, dynamic>> _moodOptions = [
    {'key': 'tenang', 'emoji': '😌', 'label': 'Tenang'},
    {'key': 'senang', 'emoji': '😊', 'label': 'Senang'},
    {'key': 'cemas', 'emoji': '😰', 'label': 'Cemas'},
    {'key': 'sedih', 'emoji': '😢', 'label': 'Sedih'},
  ];

  // Mapping string UI → enum FlowLevel
  FlowLevel _mapFlow(String? flow) {
    switch (flow) {
      case 'Ringan': return FlowLevel.light;
      case 'Sedang': return FlowLevel.medium;
      case 'Deras':
      case 'Sangat Deras': return FlowLevel.heavy;
      default: return FlowLevel.none;
    }
  }

  // Mapping string UI → enum Mood
  Mood? _mapMood(String? mood) {
    switch (mood) {
      case 'tenang': return Mood.calm;
      case 'senang': return Mood.happy;
      case 'cemas': return Mood.anxious;
      case 'sedih': return Mood.sad;
      default: return null;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  Future<void> _handleSave() async {
    if (_selectedFlow == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Pilih volume darah terlebih dahulu',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final profile = await SupabaseService.getUserProfile();
      if (profile == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi habis, silakan login kembali'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final log = DailyLog(
        id: '',
        date: DateTime.now(),
        flow: _mapFlow(_selectedFlow),
        symptoms: _selectedSymptoms.toList(),
        mood: _mapMood(_selectedMood),
        sexualActivity: _isSexualActive,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await SupabaseService.addDailyLog(log);

      if (!mounted) return;

      // Sistem Trigger Gejala -> Tips Solusi
      String? tipMessage;
      if (_selectedSymptoms.contains('kram')) {
        tipMessage = '💡 Tips: Minum air hangat atau tempelkan kompres perut untuk meredakan kram parah.';
      } else if (_selectedSymptoms.contains('pusing')) {
        tipMessage = '💡 Tips: Pastikan Anda istirahat cukup dan tetap terhidrasi hari ini.';
      }

      if (tipMessage != null) {
        // Tampilkan dialog khusus
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Catatan Tersimpan',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            content: Text(
              tipMessage!,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                height: 1.4,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Oke, Terima Kasih', style: TextStyle(color: AppTheme.primary)),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Log harian berhasil disimpan',
              style: TextStyle(fontFamily: 'Inter'),
            ),
            backgroundColor: AppTheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Log Harian',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateHeader(),
                  const SizedBox(height: 24),
                  _buildFlowSection(),
                  const SizedBox(height: 24),
                  _buildSymptomsSection(),
                  const SizedBox(height: 24),
                  _buildMoodSection(),
                  const SizedBox(height: 24),
                  _buildNotesSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildBottomSaveButton(),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hari Ini',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.outline,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getFormattedDate(),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
        const Icon(
          Icons.calendar_month,
          color: AppTheme.statusMedium,
          size: 40,
        ),
      ],
    );
  }

  Widget _buildFlowSection() {
    return _buildFormSection(
      title: 'Volume Darah',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _flowOptions.map((option) {
          final isSelected = _selectedFlow == option['label'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFlow = option['label'];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                option['label'],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSymptomsSection() {
    return _buildFormSection(
      title: 'Gejala Fisik',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: _symptomOptions.length,
        itemBuilder: (context, index) {
          final symptom = _symptomOptions[index];
          final isSelected = _selectedSymptoms.contains(symptom['key']);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedSymptoms.remove(symptom['key']);
                } else {
                  _selectedSymptoms.add(symptom['key']);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    symptom['icon'],
                    color: isSelected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    symptom['label'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoodSection() {
    return _buildFormSection(
      title: 'Mood & Aktivitas',
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: _moodOptions.length,
            itemBuilder: (context, index) {
              final mood = _moodOptions[index];
              final isSelected = _selectedMood == mood['key'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = mood['key'];
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mood['emoji'],
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mood['label'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.favorite_outline, color: AppTheme.secondary, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Aktivitas Seksual',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _isSexualActive,
                  onChanged: (value) {
                    setState(() {
                      _isSexualActive = value;
                    });
                  },
                  activeThumbColor: AppTheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return _buildFormSection(
      title: 'Catatan Tambahan',
      child: TextField(
        controller: _notesController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Tuliskan perasaan atau gejala lain di sini...',
          hintStyle: const TextStyle(color: AppTheme.outline),
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
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildFormSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineAccent),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildBottomSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite.withValues(alpha: 0.8),
        border: const Border(
          top: BorderSide(color: AppTheme.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.onPrimary,
              disabledBackgroundColor: AppTheme.primary.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
              shadowColor: AppTheme.primary.withValues(alpha: 0.3),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.onPrimary),
                    ),
                  )
                : const Text(
                    'Simpan Log',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
