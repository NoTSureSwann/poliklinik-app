import 'package:poliklinik/models/app_notification.dart';
import 'package:poliklinik/api/api_client.dart';
import 'package:poliklinik/api/api_result.dart';
import 'package:poliklinik/api/endpoint_resolver.dart';
import 'package:poliklinik/core/cqrs/query_handler.dart';
import 'package:poliklinik/core/cqrs/command_handler.dart';

class GetNotificationsQuery {}

class NotificationQueryHandler implements QueryHandler<GetNotificationsQuery, List<AppNotification>> {
  final ApiClient _apiClient;

  NotificationQueryHandler(this._apiClient);

  @override
  Future<ApiResult<List<AppNotification>>> handle(GetNotificationsQuery params) {
    final url = EndpointResolver.resolve(ApiModule.notifications);
    return _apiClient.get<List<AppNotification>>(url, (json) {
      if (json is List) {
        return json.map((e) => AppNotification.fromJson(e)).toList();
      }
      return [];
    });
  }
}

class CreateNotificationCommand {
  final AppNotification notification;
  CreateNotificationCommand(this.notification);
}

class CreateNotificationCommandHandler implements CommandHandler<CreateNotificationCommand, AppNotification> {
  final ApiClient _apiClient;

  CreateNotificationCommandHandler(this._apiClient);

  @override
  Future<ApiResult<AppNotification>> handle(CreateNotificationCommand params) {
    final url = EndpointResolver.resolve(ApiModule.notifications);
    return _apiClient.post<AppNotification>(url, params.notification.toJson(), (json) => AppNotification.fromJson(json));
  }
}

class UpdateNotificationCommand {
  final AppNotification notification;
  UpdateNotificationCommand(this.notification);
}

class UpdateNotificationCommandHandler implements CommandHandler<UpdateNotificationCommand, AppNotification> {
  final ApiClient _apiClient;

  UpdateNotificationCommandHandler(this._apiClient);

  @override
  Future<ApiResult<AppNotification>> handle(UpdateNotificationCommand params) {
    final url = '${EndpointResolver.resolve(ApiModule.notifications)}/${params.notification.id}';
    return _apiClient.put<AppNotification>(url, params.notification.toJson(), (json) => AppNotification.fromJson(json));
  }
}
