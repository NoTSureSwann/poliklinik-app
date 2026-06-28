import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';
import 'package:intl/intl.dart';

class PembayaranDashboardWidget extends StatelessWidget {
  const PembayaranDashboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // Mock Data
    final String idRekamMedis = 'AUTO-1782367959578';
    final double biayaDokter = 50000;
    final double biayaObat = 25000;
    final double totalTagihan = biayaDokter + biayaObat;

    return Center(
      child: Container(
        width: 350,
        margin: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: AppColors.border, width: 8), // Simulate phone bezel
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Bar Simulation
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                  const SizedBox(width: 16),
                  Text(
                    'Validasi Pembayaran',
                    style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID Rekam Medis', style: AppTextStyle.body2),
                  const SizedBox(height: 4),
                  Text(
                    idRekamMedis,
                    style: AppTextStyle.body2.copyWith(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  
                  // Bill Breakdown
                  _buildBillRow('Biaya Jasa Dokter', currencyFormatter.format(biayaDokter)),
                  const SizedBox(height: 12),
                  _buildBillRow('Biaya Obat-obatan', currencyFormatter.format(biayaObat)),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: AppColors.border),
                  ),
                  
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Tagihan',
                        style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currencyFormatter.format(totalTagihan),
                        style: AppTextStyle.heading3.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // QRIS Section
                  Center(
                    child: Column(
                      children: [
                        Text('Bayar via QRIS', style: AppTextStyle.body2.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: QrImageView(
                            data: idRekamMedis,
                            version: QrVersions.auto,
                            size: 150.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Button
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pembayaran berhasil divalidasi!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50), // Green like in image
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Bayar Sekarang',
                          style: AppTextStyle.body1.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.body2),
        Text(amount, style: AppTextStyle.body2.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
