sealed class ApiResult<T> {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  final String message;
  const ApiFailure(this.message);
}

class ApiNetworkError<T> extends ApiResult<T> {
  final String message;
  const ApiNetworkError([this.message = "Network connection failed"]);
}

class ApiTimeout<T> extends ApiResult<T> {
  final String message;
  const ApiTimeout([this.message = "Connection timeout"]);
}

class ApiNotFound<T> extends ApiResult<T> {
  final String message;
  const ApiNotFound([this.message = "Resource not found (404)"]);
}

class ApiServerError<T> extends ApiResult<T> {
  final String message;
  const ApiServerError([this.message = "Internal Server Error (500)"]);
}

class ApiValidationError<T> extends ApiResult<T> {
  final Map<String, dynamic> errors;
  final String message;
  const ApiValidationError(this.errors, [this.message = "Validation Error"]);
}
