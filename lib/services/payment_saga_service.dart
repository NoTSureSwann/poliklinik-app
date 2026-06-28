import 'dart:async';

class SagaPaymentResult {
  final bool success;
  final String message;
  SagaPaymentResult(this.success, this.message);
}

/// Implementasi SAGA Pattern dan Atomic Transactions untuk Pembayaran
class PaymentSagaService {
  // In-Memory Ledgers for simulation
  static double balancePasien = 500000;
  static double balanceKlinik = 0;
  
  /// Memproses pembayaran dengan metode SAGA dan Atomic Transaction
  static Future<SagaPaymentResult> processPayment({required double amount}) async {
    print("🔄 [Saga] Memulai Transaksi Atomic (Total: Rp $amount)");
    
    // Step 1: Debit Account A (Pasien)
    bool step1Success = await _debitPasien(amount);
    if (!step1Success) {
      return SagaPaymentResult(false, "Saldo dompet pasien tidak cukup (Simulasi Saldo: Rp $balancePasien). Transaksi dibatalkan.");
    }
    
    // Step 2: Credit Account B (Klinik)
    bool step2Success = await _creditKlinik(amount);
    if (!step2Success) {
      // Compensating Action (Rollback Step 1)
      print("⚠️ [Saga] Step 2 Gagal. Menjalankan Compensating Action...");
      await _rollbackDebitPasien(amount);
      return SagaPaymentResult(false, "Gagal mengkredit sistem klinik. Saldo pasien telah dikembalikan.");
    }
    
    // Step 3: Update Ledger (Buku Besar)
    bool step3Success = await _updateLedger(amount);
    if (!step3Success) {
       // Compensating Action (Rollback Step 1 and 2)
       print("⚠️ [Saga] Step 3 Gagal. Menjalankan Full Rollback...");
       await _rollbackCreditKlinik(amount);
       await _rollbackDebitPasien(amount);
       return SagaPaymentResult(false, "Gagal mencatat ledger. Transaksi dibatalkan sepenuhnya (Rolled back).");
    }
    
    print("✅ [Saga] Transaksi Selesai. Ledger Updated. Saldo Klinik: Rp $balanceKlinik");
    return SagaPaymentResult(true, "Pembayaran berhasil diproses secara atomik!");
  }
  
  // -- Microservices Simulation (Steps) --
  static Future<bool> _debitPasien(double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (balancePasien >= amount) {
      balancePasien -= amount;
      return true;
    }
    return false;
  }
  
  static Future<bool> _creditKlinik(double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    balanceKlinik += amount;
    return true; 
  }
  
  static Future<bool> _updateLedger(double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; 
  }
  
  // -- Compensating Actions (Rollbacks) --
  static Future<void> _rollbackDebitPasien(double amount) async {
    balancePasien += amount;
  }
  static Future<void> _rollbackCreditKlinik(double amount) async {
    balanceKlinik -= amount;
  }
}
