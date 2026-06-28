/// Typed result wrapper returned by [TautulliConnectionAdapter], replacing
/// [Tuple2<T, bool>] from the dartz-era API layer.
///
/// [primaryActive] mirrors the old Tuple2.value2: true when the response came
/// from the server's primary connection address. BLoCs dispatch
/// [SettingsUpdatePrimaryActive] using this value exactly as before.
class ApiResult<T> {
  final T data;
  final bool primaryActive;

  const ApiResult({required this.data, required this.primaryActive});
}
