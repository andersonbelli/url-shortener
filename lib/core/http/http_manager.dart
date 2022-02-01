abstract class HttpManager {
  Future<dynamic> get(
    String endpoint,
  );

  Future<dynamic> post(
    String endpoint,
    dynamic body,
  );
}
