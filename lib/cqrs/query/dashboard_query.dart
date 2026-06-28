import '../../api/api_client.dart';
import '../../api/api_result.dart';
import '../../config/api_config.dart';

class DashboardQueryHandler {
  final ApiClient _apiClient;

  DashboardQueryHandler(this._apiClient);

  Future<ApiResult<Map<String, dynamic>>> getDashboardStatistics() async {
    return _apiClient.get<Map<String, dynamic>>(
      ApiConfig.dashboards,
      (json) => json is List ? (json.isNotEmpty ? json.first : {}) : json as Map<String, dynamic>,
    );
  }
}
