import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/services/pdf_report_service.dart';

class ExportSection extends StatefulWidget {
  final UserProfile profile;
  final List<DailyLog> logs;

  const ExportSection({
    super.key,
    required this.profile,
    required this.logs,
  });

  @override
  State<ExportSection> createState() => _ExportSectionState();
}

class _ExportSectionState extends State<ExportSection> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: AppTheme.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ekspor Data',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dapatkan file PDF komprehensif yang dirancang khusus untuk konsultasi dengan dokter Anda.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppTheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isExporting
                  ? null
                  : () async {
                      setState(() => _isExporting = true);
                      try {
                        await PdfReportService.generateAndPrintReport(
                          profile: widget.profile,
                          logs: widget.logs,
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal mengekspor PDF: $e'),
                            backgroundColor: AppTheme.error,
                          ),
                        );
                      } finally {
                        if (mounted) setState(() => _isExporting = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 4,
                shadowColor: AppTheme.primary.withValues(alpha: 0.3),
              ),
              child: _isExporting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Ekspor Laporan PDF',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
