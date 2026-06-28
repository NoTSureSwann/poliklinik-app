import 'package:poliklinik/config/api_config.dart';
import 'package:poliklinik/models/pasien.dart';
import 'api_service.dart';

class PasienService {
  final ApiService _api = ApiService();

  Future<List<Pasien>> getPasien() async {
    final data = await _api.getAll(
      ApiConfig.patients,
    );

    return data.map<Pasien>((e) => Pasien.fromJson(e)).toList();
  }

  Future<void> addPasien(
    Pasien pasien,
  ) async {
    await _api.post(
      ApiConfig.patients,
      pasien.toJson(),
    );
  }

  Future<void> updatePasien(
    Pasien pasien,
  ) async {
    await _api.put(
      "${ApiConfig.patients}/${pasien.id}",
      pasien.toJson(),
    );
  }

  Future<void> deletePasien(
    String id,
  ) async {
    await _api.delete(
      "${ApiConfig.patients}/$id",
    );
  }
}
