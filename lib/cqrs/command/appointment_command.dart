import '../../api/api_client.dart';
import '../../api/api_result.dart';
import '../../config/api_config.dart';
import '../../models/janji_temu.dart';

class AppointmentCommandHandler {
  final ApiClient _apiClient;

  AppointmentCommandHandler(this._apiClient);

  Future<ApiResult<JanjiTemu>> createAppointment(Map<String, dynamic> data) async {
    return _apiClient.post<JanjiTemu>(
      ApiConfig.appointments,
      data,
      (json) => JanjiTemu.fromJson(json),
    );
  }

  Future<ApiResult<JanjiTemu>> updateAppointment(String id, Map<String, dynamic> data) async {
    return _apiClient.put<JanjiTemu>(
      '${ApiConfig.appointments}/$id',
      data,
      (json) => JanjiTemu.fromJson(json),
    );
  }

  Future<ApiResult<void>> deleteAppointment(String id) async {
    return _apiClient.delete('${ApiConfig.appointments}/$id');
  }
}
