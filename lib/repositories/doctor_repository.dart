import 'package:poliklinik/models/dokter.dart';
import 'package:poliklinik/api/api_client.dart';
import 'package:poliklinik/api/api_result.dart';
import 'package:poliklinik/api/endpoint_resolver.dart';
import 'package:poliklinik/core/cqrs/query_handler.dart';
import 'package:poliklinik/core/cqrs/command_handler.dart';

class GetDoctorsQuery {}

class DoctorQueryHandler implements QueryHandler<GetDoctorsQuery, List<Dokter>> {
  final ApiClient _apiClient;

  DoctorQueryHandler(this._apiClient);

  @override
  Future<ApiResult<List<Dokter>>> handle(GetDoctorsQuery params) {
    final url = EndpointResolver.resolve(ApiModule.doctors);
    return _apiClient.get<List<Dokter>>(url, (json) {
      if (json is List) {
        return json.map((e) => Dokter.fromJson(e)).toList();
      }
      return [];
    });
  }
}

class CreateDoctorCommand {
  final Dokter dokter;
  CreateDoctorCommand(this.dokter);
}

class CreateDoctorCommandHandler implements CommandHandler<CreateDoctorCommand, Dokter> {
  final ApiClient _apiClient;

  CreateDoctorCommandHandler(this._apiClient);

  @override
  Future<ApiResult<Dokter>> handle(CreateDoctorCommand params) {
    final url = EndpointResolver.resolve(ApiModule.doctors);
    return _apiClient.post<Dokter>(url, params.dokter.toJson(), (json) => Dokter.fromJson(json));
  }
}

class UpdateDoctorCommand {
  final Dokter dokter;
  UpdateDoctorCommand(this.dokter);
}

class UpdateDoctorCommandHandler implements CommandHandler<UpdateDoctorCommand, Dokter> {
  final ApiClient _apiClient;

  UpdateDoctorCommandHandler(this._apiClient);

  @override
  Future<ApiResult<Dokter>> handle(UpdateDoctorCommand params) {
    final url = '${EndpointResolver.resolve(ApiModule.doctors)}/${params.dokter.id}';
    return _apiClient.put<Dokter>(url, params.dokter.toJson(), (json) => Dokter.fromJson(json));
  }
}
