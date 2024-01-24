class Result<T> {
  T? value;
  bool isSuccess;
  String? error;

  Result.success(this.value)
    : isSuccess = true;

  Result.failure(this.error)
    : isSuccess = false,
      value = null;
}