import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final Map<String, List<dynamic>> _fallbackDb = {};
  static bool _isFallbackInitialized = false;

  // Set ini ke TRUE agar data selalu reset (ephemeral) saat app restart / hot reload.
  static const bool _forceLocalEphemeral = true;

  // --- ENTERPRISE PATTERNS ---
  // 1. Circuit Breaker
  static int _failureCount = 0;
  static bool _circuitOpen = false;
  static DateTime? _circuitOpenedAt;

  // 2. Simple Cache
  static final Map<String, dynamic> _cache = {};
  static final Map<String, DateTime> _cacheTime = {};
  static const Duration _cacheTtl = Duration(seconds: 30);

  bool _isCircuitOpen() {
    if (_forceLocalEphemeral) return true; // Selalu gunakan fallback lokal
    if (_circuitOpen) {
      if (_circuitOpenedAt != null && DateTime.now().difference(_circuitOpenedAt!) > const Duration(minutes: 1)) {
        _circuitOpen = false;
        _failureCount = 0;
        print("⚡ [CircuitBreaker] State: HALF-OPEN.");
        return false;
      }
      return true;
    }
    return false;
  }

  void _recordFailure() {
    if (_forceLocalEphemeral) return;
    _failureCount++;
    if (_failureCount >= 3 && !_circuitOpen) {
      _circuitOpen = true;
      _circuitOpenedAt = DateTime.now();
      print("🚨 [CircuitBreaker] State: OPEN. Beralih ke Local Fallback.");
    }
  }

  void _invalidateCache(String endpoint) {
    if (_forceLocalEphemeral) return;
    _cache.removeWhere((key, value) => key.contains(endpoint));
    _cacheTime.removeWhere((key, value) => key.contains(endpoint));
  }
  // -----------------------------

  String _getEndpoint(String url) {
    final endpoints = ['users', 'patients', 'doctors', 'appointments', 'medical_records', 'reports', 'obat', 'pembayaran', 'polis'];
    for (var ep in endpoints) {
      if (url.contains('/$ep')) return ep;
    }
    return 'unknown';
  }

  Future<void> _initFallback() async {
    if (_isFallbackInitialized) return;
    try {
      _fallbackDb['users'] = [
        {'id': '1', 'name': 'Admin Utama', 'role': 'admin', 'email': 'admin', 'password': 'admin'},
        {'id': '2', 'name': 'Budi Pasien', 'role': 'pasien', 'email': 'pasien', 'password': 'pasien'},
        {'id': '3', 'name': 'Dr. Andi', 'role': 'dokter', 'email': 'dokter', 'password': 'dokter'},
      ];
      _fallbackDb['patients'] = [
        {'id': '2', 'nama': 'Budi Pasien', 'no_rm': 'RM-001', 'jk': 'Laki-laki', 'alamat': 'Jl. Sehat', 'telepon': '08123456789'},
        {'id': 'p2', 'nama': 'Siti Aminah', 'no_rm': 'RM-002', 'jk': 'Perempuan', 'alamat': 'Jl. Bahagia', 'telepon': '08123456790'},
      ];
      _fallbackDb['doctors'] = [
        {'id': '3', 'nama': 'Dr. Andi', 'spesialis': 'Umum', 'str': 'STR-1234', 'jadwal': 'Senin-Jumat', 'biaya': 50000},
        {'id': 'd2', 'nama': 'Dr. Budi', 'spesialis': 'Gigi', 'str': 'STR-1235', 'jadwal': 'Senin-Rabu', 'biaya': 75000},
        {'id': 'd3', 'nama': 'Dr. Citra', 'spesialis': 'Anak', 'str': 'STR-1236', 'jadwal': 'Kamis-Sabtu', 'biaya': 60000},
      ];
      _fallbackDb['appointments'] = [];
      _fallbackDb['medical_records'] = [];
      _fallbackDb['obat'] = [
        {'id': 'o1', 'nama': 'Paracetamol', 'kategori': 'Obat Bebas', 'harga': 5000, 'stok': 100},
        {'id': 'o2', 'nama': 'Amoxicillin', 'kategori': 'Antibiotik', 'harga': 15000, 'stok': 50},
      ];
      _fallbackDb['polis'] = [
        {'id': 'poli1', 'nama': 'Umum', 'deskripsi': 'Poli Umum'},
        {'id': 'poli2', 'nama': 'Gigi', 'deskripsi': 'Poli Gigi'},
        {'id': 'poli3', 'nama': 'Anak', 'deskripsi': 'Poli Anak'},
      ];
      _fallbackDb['pembayaran'] = [];
      _isFallbackInitialized = true;
      print("💽 [Fallback] In-Memory Ephemeral Database Initialized! Data resetted to default.");
    } catch (e) {
      print("Error init fallback: $e");
    }
  }

  Future<List<dynamic>> getAll(String url) async {
    final ep = _getEndpoint(url);

    if (!_forceLocalEphemeral) {
      if (_cache.containsKey(url) && DateTime.now().difference(_cacheTime[url]!) < _cacheTtl) {
        return _cache[url];
      }

      if (!_isCircuitOpen()) {
        try {
          final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
          if (response.statusCode == 200) {
            _failureCount = 0;
            final data = jsonDecode(response.body);
            _cache[url] = data;
            _cacheTime[url] = DateTime.now();
            return data;
          }
        } catch (e) {
          _recordFailure();
        }
      }
    }

    // Fallback / Ephemeral Execution
    await _initFallback();
    return _fallbackDb[ep] ?? [];
  }

  Future<dynamic> getById(String url) async {
    final ep = _getEndpoint(url);
    final id = url.split('/').last;

    if (!_forceLocalEphemeral) {
      if (_cache.containsKey(url) && DateTime.now().difference(_cacheTime[url]!) < _cacheTtl) {
        return _cache[url];
      }

      if (!_isCircuitOpen()) {
        try {
          final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
          if (response.statusCode == 200) {
            _failureCount = 0;
            final data = jsonDecode(response.body);
            _cache[url] = data;
            _cacheTime[url] = DateTime.now();
            return data;
          }
        } catch (e) {
          _recordFailure();
        }
      }
    }

    await _initFallback();
    final items = _fallbackDb[ep] ?? [];
    return items.firstWhere((item) => item['id'] == id, orElse: () => throw Exception('Not found'));
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    final ep = _getEndpoint(url);

    if (!_forceLocalEphemeral) {
      _invalidateCache(ep);
      if (!_isCircuitOpen()) {
        try {
          final response = await http.post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          ).timeout(const Duration(seconds: 3));
          if (response.statusCode == 200 || response.statusCode == 201) {
            _failureCount = 0;
            return jsonDecode(response.body);
          }
        } catch (e) {
          _recordFailure();
        }
      }
    }

    await _initFallback();
    final newItem = Map<String, dynamic>.from(body);
    newItem['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    if (_fallbackDb[ep] == null) _fallbackDb[ep] = [];
    _fallbackDb[ep]!.add(newItem);
    return newItem;
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    final ep = _getEndpoint(url);

    if (!_forceLocalEphemeral) {
      _invalidateCache(ep);
      if (!_isCircuitOpen()) {
        try {
          final response = await http.put(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          ).timeout(const Duration(seconds: 3));
          if (response.statusCode == 200) {
            _failureCount = 0;
            return jsonDecode(response.body);
          }
        } catch (e) {
          _recordFailure();
        }
      }
    }

    await _initFallback();
    final id = url.split('/').last;
    final items = _fallbackDb[ep] ?? [];
    final index = items.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      final updatedItem = Map<String, dynamic>.from(items[index])..addAll(body);
      updatedItem['id'] = id;
      items[index] = updatedItem;
      return updatedItem;
    }
    throw Exception('Item not found in fallback');
  }

  Future<void> delete(String url) async {
    final ep = _getEndpoint(url);

    if (!_forceLocalEphemeral) {
      _invalidateCache(ep);
      if (!_isCircuitOpen()) {
        try {
          final response = await http.delete(Uri.parse(url)).timeout(const Duration(seconds: 3));
          if (response.statusCode == 200 || response.statusCode == 204) {
            _failureCount = 0;
            return;
          }
        } catch (e) {
          _recordFailure();
        }
      }
    }

    await _initFallback();
    final id = url.split('/').last;
    final items = _fallbackDb[ep] ?? [];
    items.removeWhere((item) => item['id'] == id);
  }
}
