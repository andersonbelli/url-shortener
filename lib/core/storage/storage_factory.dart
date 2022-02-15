abstract class StorageFactory {
  // Value = ID; Key = ShortenedUrlModel.toJson;
  Future<bool> save(String key, String value);
  Future<String> load(String key);
}