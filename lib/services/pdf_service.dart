import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:poliklinik/models/rekam_medis.dart';
import 'package:poliklinik/models/pasien.dart';
import 'package:poliklinik/models/dokter.dart';
import 'package:poliklinik/models/pembayaran.dart';

class PdfService {
  static Future<void> printRekamMedis(
      RekamMedis rekam, Pasien? pasien, Dokter? dokter) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'POLI-KLINIK ENTERPRISE',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Struk Rekam Medis Pasien',
                  style: pw.TextStyle(fontSize: 18),
                ),
              ),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),
              _buildRow('ID Rekam Medis', rekam.id ?? '-'),
              _buildRow('Tanggal Periksa', rekam.tanggal),
              pw.SizedBox(height: 10),
              pw.Text('Data Pasien', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              _buildRow('Nama Pasien', pasien?.nama ?? 'Tidak diketahui'),
              _buildRow('No. Telepon', pasien?.telepon ?? '-'),
              pw.SizedBox(height: 10),
              pw.Text('Data Dokter', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              _buildRow('Nama Dokter', dokter?.nama ?? 'Tidak diketahui'),
              _buildRow('Spesialis', dokter?.spesialis ?? '-'),
              pw.SizedBox(height: 20),
              pw.Text('Rincian Medis', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildRow('Keluhan', rekam.keluhan),
                    _buildRow('Diagnosa', rekam.diagnosa),
                    _buildRow('Tindakan', rekam.tindakan),
                    _buildRow('Obat', rekam.obat),
                    _buildRow('Catatan Dokter', rekam.catatanDokter),
                  ],
                ),
              ),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Dicetak secara otomatis oleh sistem'),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> printReceipt(Pembayaran pembayaran) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('CareHub', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text('Struk Pembayaran Klinik', style: pw.TextStyle(fontSize: 12)),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('ID Tagihan:'),
                pw.Text(pembayaran.id ?? '-'),
              ]),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Pasien:'),
                pw.Text(pembayaran.pasienNama),
              ]),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 1, borderStyle: pw.BorderStyle.dashed),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Biaya Dokter:'),
                pw.Text('Rp ${pembayaran.biayaDokter}'),
              ]),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Biaya Obat:'),
                pw.Text('Rp ${pembayaran.biayaObat}'),
              ]),
              pw.Divider(thickness: 1, borderStyle: pw.BorderStyle.dashed),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('TOTAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Rp ${pembayaran.totalBiaya}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ]),
              pw.SizedBox(height: 20),
              pw.Text('STATUS: LUNAS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Terima Kasih', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              pw.Text('Semoga lekas sembuh!'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static pw.Widget _buildRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(label,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Text(': '),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }
}
