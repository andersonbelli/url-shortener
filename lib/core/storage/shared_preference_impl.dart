import 'package:shared_preferences/shared_preferences.dart';
import 'package:teststudy/core/storage/storage_factory.dart';

class SharedPreferenceImpl extends StorageFactory {
  @override
  Future<bool> save(String key, String value) async =>
      (await SharedPreferences.getInstance()).setString(key, value);

  @override
  Future<String> load(String key) async =>
      (await SharedPreferences.getInstance()).getString(key) ?? "";
}
