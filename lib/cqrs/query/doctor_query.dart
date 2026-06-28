import '../../api/api_client.dart';
import '../../api/api_result.dart';
import '../../config/api_config.dart';
import '../../models/dokter.dart';

class DoctorQueryHandler {
  final ApiClient _apiClient;

  DoctorQueryHandler(this._apiClient);

  Future<ApiResult<List<Dokter>>> getDoctors() async {
    return _apiClient.get<List<Dokter>>(
      ApiConfig.doctors,
      (json) => (json as List).map((e) => Dokter.fromJson(e)).toList(),
    );
  }
}
