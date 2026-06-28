import 'package:poliklinik/config/api_config.dart';
import 'package:poliklinik/models/janji_temu.dart';
import 'api_service.dart';

class JanjiService {
  final ApiService _api = ApiService();

  Future<List<JanjiTemu>> getJanji() async {
    final data = await _api.getAll(
      ApiConfig.appointments,
    );

    return data
        .map<JanjiTemu>(
          (e) => JanjiTemu.fromJson(e),
        )
        .toList();
  }

  Future<void> addJanji(
    JanjiTemu janji,
  ) async {
    await _api.post(
      ApiConfig.appointments,
      janji.toJson(),
    );
  }

  Future<void> updateJanji(
    JanjiTemu janji,
  ) async {
    await _api.put(
      "${ApiConfig.appointments}/${janji.id}",
      janji.toJson(),
    );
  }

  Future<void> deleteJanji(
    String id,
  ) async {
    await _api.delete(
      "${ApiConfig.appointments}/$id",
    );
  }
}
