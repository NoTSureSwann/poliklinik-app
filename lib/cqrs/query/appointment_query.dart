import '../../api/api_client.dart';
import '../../api/api_result.dart';
import '../../config/api_config.dart';
import '../../models/janji_temu.dart';

class AppointmentQueryHandler {
  final ApiClient _apiClient;

  AppointmentQueryHandler(this._apiClient);

  Future<ApiResult<List<JanjiTemu>>> getAppointments() async {
    return _apiClient.get<List<JanjiTemu>>(
      ApiConfig.appointments,
      (json) => (json as List).map((e) => JanjiTemu.fromJson(e)).toList(),
    );
  }
}
