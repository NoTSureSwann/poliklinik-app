import 'dart:async';
import 'package:flutter/foundation.dart';

/// Implementasi Rate Limiter dan UI Load Balancer sederhana
class UIArchitectureLimiter {
  static final Map<String, Timer> _debouncers = {};
  static final Map<String, DateTime> _throttlers = {};

  /// Menahan eksekusi fungsi hingga aksi berhenti selama waktu tertentu (Debounce)
  static void debounce(String tag, VoidCallback action, {Duration duration = const Duration(milliseconds: 500)}) {
    if (_debouncers.containsKey(tag)) {
      _debouncers[tag]!.cancel();
    }
    _debouncers[tag] = Timer(duration, action);
  }

  /// Membatasi eksekusi fungsi hanya sekali per durasi (Throttle / Rate Limiting).
  /// Sangat cocok digunakan untuk menghindari dobel klik pada tombol pembayaran/submit.
  static void throttle(String tag, VoidCallback action, {Duration duration = const Duration(seconds: 2)}) {
    final now = DateTime.now();
    if (_throttlers.containsKey(tag)) {
      final lastAction = _throttlers[tag]!;
      if (now.difference(lastAction) < duration) {
        debugPrint("ðŸ›‘ [RateLimiter] Aksi '$tag' di-throttle. Menunggu cooldown.");
        return;
      }
    }
    _throttlers[tag] = now;
    action();
  }

  /// UI Load Balancer (Chunking Simulation)
  /// Membagi tugas berat iterasi ke dalam blok event loop agar UI thread (60fps) tidak mengalami drop frame.
  static Future<void> distributeLoad<T>(List<T> items, void Function(T) processChunk) async {
    for (var i = 0; i < items.length; i++) {
      // Memberikan ruang nafas pada UI thread setiap 10 iterasi
      if (i % 10 == 0) {
        await Future.delayed(Duration.zero);
      }
      processChunk(items[i]);
    }
  }
}
