import 'package:poliklinik/config/api_config.dart';
import 'package:poliklinik/models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<List<User>> getUsers() async {
    final data = await _api.getAll(
      ApiConfig.users,
    );

    return data
        .map<User>(
          (e) => User.fromJson(e),
        )
        .toList();
  }

  Future<void> register(User user) async {
    await _api.post(
      ApiConfig.users,
      user.toJson(),
    );
  }

  Future<User?> login(String email, String password) async {
    final users = await getUsers();

    try {
      return users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (_) {
      return null;
    }
  }
}
