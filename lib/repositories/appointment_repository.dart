import 'package:poliklinik/models/janji_temu.dart';
import 'package:poliklinik/api/api_client.dart';
import 'package:poliklinik/api/api_result.dart';
import 'package:poliklinik/api/endpoint_resolver.dart';
import 'package:poliklinik/core/cqrs/query_handler.dart';
import 'package:poliklinik/core/cqrs/command_handler.dart';

class GetAppointmentsQuery {}

class AppointmentQueryHandler implements QueryHandler<GetAppointmentsQuery, List<JanjiTemu>> {
  final ApiClient _apiClient;

  AppointmentQueryHandler(this._apiClient);

  @override
  Future<ApiResult<List<JanjiTemu>>> handle(GetAppointmentsQuery params) {
    final url = EndpointResolver.resolve(ApiModule.appointments);
    return _apiClient.get<List<JanjiTemu>>(url, (json) {
      if (json is List) {
        return json.map((e) => JanjiTemu.fromJson(e)).toList();
      }
      return [];
    });
  }
}

class CreateAppointmentCommand {
  final JanjiTemu appointment;
  CreateAppointmentCommand(this.appointment);
}

class CreateAppointmentCommandHandler implements CommandHandler<CreateAppointmentCommand, JanjiTemu> {
  final ApiClient _apiClient;

  CreateAppointmentCommandHandler(this._apiClient);

  @override
  Future<ApiResult<JanjiTemu>> handle(CreateAppointmentCommand params) {
    final url = EndpointResolver.resolve(ApiModule.appointments);
    return _apiClient.post<JanjiTemu>(url, params.appointment.toJson(), (json) => JanjiTemu.fromJson(json));
  }
}

class UpdateAppointmentCommand {
  final JanjiTemu appointment;
  UpdateAppointmentCommand(this.appointment);
}

class UpdateAppointmentCommandHandler implements CommandHandler<UpdateAppointmentCommand, JanjiTemu> {
  final ApiClient _apiClient;

  UpdateAppointmentCommandHandler(this._apiClient);

  @override
  Future<ApiResult<JanjiTemu>> handle(UpdateAppointmentCommand params) {
    final url = '${EndpointResolver.resolve(ApiModule.appointments)}/${params.appointment.id}';
    return _apiClient.put<JanjiTemu>(url, params.appointment.toJson(), (json) => JanjiTemu.fromJson(json));
  }
}
