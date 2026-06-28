import 'package:poliklinik/config/api_config.dart';
import 'package:poliklinik/models/rekam_medis.dart';
import 'api_service.dart';

class RekamService {
  final ApiService _api = ApiService();

  Future<List<RekamMedis>> getRekam() async {
    final data = await _api.getAll(
      ApiConfig.medicalRecords,
    );

    return data
        .map<RekamMedis>(
          (e) => RekamMedis.fromJson(e),
        )
        .toList();
  }

  Future<void> addRekam(
    RekamMedis rekam,
  ) async {
    await _api.post(
      ApiConfig.medicalRecords,
      rekam.toJson(),
    );
  }

  Future<void> updateRekam(
    RekamMedis rekam,
  ) async {
    await _api.put(
      "${ApiConfig.medicalRecords}/${rekam.id}",
      rekam.toJson(),
    );
  }

  Future<void> deleteRekam(
    String id,
  ) async {
    await _api.delete(
      "${ApiConfig.medicalRecords}/$id",
    );
  }
}
