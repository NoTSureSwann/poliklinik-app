import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/models/pembayaran.dart';
import 'package:poliklinik/services/payment_saga_service.dart';
import 'package:poliklinik/services/pdf_service.dart';
import 'package:poliklinik/core/architecture/rate_limiter.dart';
import 'package:poliklinik/core/architecture/event_bus.dart';

class PembayaranValidasiPage extends StatefulWidget {
  final Pembayaran pembayaran;

  const PembayaranValidasiPage({super.key, required this.pembayaran});

  @override
  State<PembayaranValidasiPage> createState() => _PembayaranValidasiPageState();
}

class _PembayaranValidasiPageState extends State<PembayaranValidasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validasi Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Nama Pasien'),
              subtitle: Text(widget.pembayaran.pasienNama),
            ),
            ListTile(
              title: const Text('ID Rekam Medis'),
              subtitle: Text(widget.pembayaran.rekamId),
            ),
            const Divider(),
            ListTile(
              title: const Text('Biaya Jasa Dokter'),
              trailing: Text('Rp ${widget.pembayaran.biayaDokter}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: const Text('Biaya Obat-obatan'),
              trailing: Text('Rp ${widget.pembayaran.biayaObat}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(thickness: 2),
            ListTile(
              title: const Text('Total Tagihan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Text(
                'Rp ${widget.pembayaran.totalBiaya}', 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const Text('Bayar via QRIS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  QrImageView(
                    data: 'QRIS-PAY-${widget.pembayaran.id}-${widget.pembayaran.totalBiaya}',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
              widget.pembayaran.statusValidasi == 'Lunas'
                  ? ElevatedButton.icon(
                      icon: const Icon(Icons.print),
                      label: const Text('Cetak Struk'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {
                        await PdfService.printReceipt(widget.pembayaran);
                      },
                    )
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      label: const Text('Bayar Sekarang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        UIArchitectureLimiter.throttle('bayar_${widget.pembayaran.id}', () async {
                          // Show loading
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(child: CircularProgressIndicator()),
                          );

                          // Process with Saga Pattern
                          final result = await PaymentSagaService.processPayment(amount: widget.pembayaran.totalBiaya.toDouble());
                          
                          // Hide loading
                          if (context.mounted) Navigator.pop(context);

                          if (result.success) {
                            setState(() {
                              widget.pembayaran.statusValidasi = 'Lunas';
                            });

                            if (context.mounted) {
                              await context.read<DataProvider>().updatePembayaran(widget.pembayaran);
                              eventBus.publish(AppEvent('PaymentSuccess', widget.pembayaran.id));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message), backgroundColor: Colors.green));
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message), backgroundColor: Colors.red));
                            }
                          }
                        });
                      },
                    ),
          ],
        ),
      ),
    );
  }
}
