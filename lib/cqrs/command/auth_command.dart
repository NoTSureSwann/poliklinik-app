import '../../api/api_client.dart';
import '../../api/api_result.dart';
import '../../config/api_config.dart';

class AuthCommandHandler {
  final ApiClient _apiClient;

  AuthCommandHandler(this._apiClient);

  Future<ApiResult<Map<String, dynamic>>> login(String username, String password) async {
    // Note: MockAPI doesn't have a real login endpoint, but we simulate it.
    // We could either GET users and filter, or POST to a simulated auth endpoint if available.
    // As per instruction, it should be POST Login.
    return _apiClient.post<Map<String, dynamic>>(
      '${ApiConfig.users}/login', // Using a hypothetical login endpoint on MockAPI
      {'username': username, 'password': password},
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> register(Map<String, dynamic> userData) async {
    return _apiClient.post<Map<String, dynamic>>(
      ApiConfig.users,
      userData,
      (json) => json as Map<String, dynamic>,
    );
  }
}
