import 'package:poliklinik/models/obat.dart';
import 'package:poliklinik/api/api_client.dart';
import 'package:poliklinik/api/api_result.dart';
import 'package:poliklinik/api/endpoint_resolver.dart';
import 'package:poliklinik/core/cqrs/query_handler.dart';

class GetMedicinesQuery {}

class MedicineQueryHandler implements QueryHandler<GetMedicinesQuery, List<Obat>> {
  final ApiClient _apiClient;

  MedicineQueryHandler(this._apiClient);

  @override
  Future<ApiResult<List<Obat>>> handle(GetMedicinesQuery params) {
    final url = EndpointResolver.resolve(ApiModule.obat);
    return _apiClient.get<List<Obat>>(url, (json) {
      if (json is List) {
        return json.map((e) => Obat.fromJson(e)).toList();
      }
      return [];
    });
  }
}
