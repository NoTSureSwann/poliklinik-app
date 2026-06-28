import 'package:poliklinik/config/api_config.dart';
import 'package:poliklinik/models/laporan.dart';
import 'api_service.dart';

class LaporanService {
  final ApiService _api = ApiService();

  Future<List<Laporan>> getLaporan() async {
    final data = await _api.getAll(
      ApiConfig.reports,
    );

    return data
        .map<Laporan>(
          (e) => Laporan.fromJson(e),
        )
        .toList();
  }

  Future<void> addLaporan(
    Laporan laporan,
  ) async {
    await _api.post(
      ApiConfig.reports,
      laporan.toJson(),
    );
  }
}
