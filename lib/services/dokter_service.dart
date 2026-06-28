import 'package:poliklinik/config/api_config.dart';
import 'package:poliklinik/models/dokter.dart';
import 'api_service.dart';

class DokterService {
  final ApiService _api = ApiService();

  Future<List<Dokter>> getDokter() async {
    final data = await _api.getAll(
      ApiConfig.doctors,
    );

    return data.map<Dokter>((e) => Dokter.fromJson(e)).toList();
  }

  Future<void> addDokter(
    Dokter dokter,
  ) async {
    await _api.post(
      ApiConfig.doctors,
      dokter.toJson(),
    );
  }

  Future<void> updateDokter(
    Dokter dokter,
  ) async {
    await _api.put(
      "${ApiConfig.doctors}/${dokter.id}",
      dokter.toJson(),
    );
  }

  Future<void> deleteDokter(
    String id,
  ) async {
    await _api.delete(
      "${ApiConfig.doctors}/$id",
    );
  }
}
