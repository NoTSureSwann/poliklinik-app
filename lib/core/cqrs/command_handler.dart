import 'package:poliklinik/api/api_result.dart';

abstract class CommandHandler<TParams, TResult> {
  Future<ApiResult<TResult>> handle(TParams params);
}
