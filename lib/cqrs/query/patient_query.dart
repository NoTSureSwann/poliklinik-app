import '../../api/api_client.dart';
import '../../api/api_result.dart';
import '../../config/api_config.dart';
import '../../models/pasien.dart';

class PatientQueryHandler {
  final ApiClient _apiClient;

  PatientQueryHandler(this._apiClient);

  Future<ApiResult<List<Pasien>>> getPatients() async {
    return _apiClient.get<List<Pasien>>(
      ApiConfig.patients,
      (json) => (json as List).map((e) => Pasien.fromJson(e)).toList(),
    );
  }
}
