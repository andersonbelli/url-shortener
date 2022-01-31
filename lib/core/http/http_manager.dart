abstract class HttpManager {
  Future<dynamic> get(
    String endpoint,
  );

  // Future<Either<BaseException, Response>> get(
  //   String url,
  // );

  Future<dynamic> post(
    String endpoint,
    dynamic body,
  );

// Future<Either<BaseException, Response>> post(
//   String endpoint,
//   Map<String, dynamic> body,
// );
}
