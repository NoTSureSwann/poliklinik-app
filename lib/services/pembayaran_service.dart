import 'package:poliklinik/config/api_config.dart';
import 'package:poliklinik/models/pembayaran.dart';
import 'api_service.dart';

class PembayaranService {
  final ApiService _api = ApiService();

  Future<List<Pembayaran>> getPembayaran() async {
    final data = await _api.getAll(ApiConfig.pembayaran);
    return data.map<Pembayaran>((e) => Pembayaran.fromJson(e)).toList();
  }

  Future<void> addPembayaran(Pembayaran pembayaran) async {
    await _api.post(ApiConfig.pembayaran, pembayaran.toJson());
  }

  Future<void> updatePembayaran(Pembayaran pembayaran) async {
    await _api.put("${ApiConfig.pembayaran}/${pembayaran.id}", pembayaran.toJson());
  }

  Future<void> deletePembayaran(String id) async {
    await _api.delete("${ApiConfig.pembayaran}/$id");
  }
}
