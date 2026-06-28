import 'package:poliklinik/api/api_result.dart';

abstract class QueryHandler<TParams, TResult> {
  Future<ApiResult<TResult>> handle(TParams params);
}
