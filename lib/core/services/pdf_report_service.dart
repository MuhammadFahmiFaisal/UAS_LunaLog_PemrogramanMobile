import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/models.dart';
import 'package:intl/intl.dart';

class PdfReportService {
  static Future<void> generateAndPrintReport({
    required UserProfile profile,
    required List<DailyLog> logs,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(profile),
            pw.SizedBox(height: 20),
            _buildSummary(profile, logs),
            pw.SizedBox(height: 20),
            _buildLogTable(logs),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_LunaLog_${profile.name}.pdf',
    );
  }

  static pw.Widget _buildHeader(UserProfile profile) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Laporan Kesehatan Menstruasi (LunaLog)',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#8B4A5F'),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Nama: ${profile.name}', style: const pw.TextStyle(fontSize: 14)),
        pw.Text('Email: ${profile.email}', style: const pw.TextStyle(fontSize: 14)),
        pw.Text('Tanggal Cetak: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 14)),
        pw.Divider(color: PdfColor.fromHex('#D6C1C5')),
      ],
    );
  }

  static pw.Widget _buildSummary(UserProfile profile, List<DailyLog> logs) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#FFF8F7'),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColor.fromHex('#FFD9DF')),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Rata-rata Siklus', '${profile.cycleLength} Hari'),
          _buildSummaryItem('Durasi Haid', '${profile.periodDuration} Hari'),
          _buildSummaryItem('Total Catatan', '${logs.length} Hari'),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#8B4A5F'))),
      ],
    );
  }

  static pw.Widget _buildLogTable(List<DailyLog> logs) {
    if (logs.isEmpty) {
      return pw.Text('Tidak ada catatan harian di bulan ini.', style: const pw.TextStyle(fontSize: 12));
    }

    final sortedLogs = List<DailyLog>.from(logs)..sort((a, b) => b.date.compareTo(a.date));

    return pw.TableHelper.fromTextArray(
      headers: ['Tanggal', 'Mood', 'Fisik', 'Aliran'],
      data: sortedLogs.map((log) {
        return [
          DateFormat('dd/MM/yyyy').format(log.date),
          log.mood == null ? '-' : log.mood!.name,
          log.symptoms.isEmpty ? '-' : log.symptoms.join(', '),
          log.flow == FlowLevel.none ? '-' : log.flow.name,
        ];
      }).toList(),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#8B4A5F'),
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey300,
            width: .5,
          ),
        ),
      ),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }
}
