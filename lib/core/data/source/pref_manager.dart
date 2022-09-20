import 'package:shared_preferences/shared_preferences.dart';

import '../../di/app_component.dart';
import '../../session/session_manager.dart';

class PrefManager {

  final SharedPreferences _sharedPrefs;
  PrefManager(this._sharedPrefs);

  void saveString(String key, String? value) {
    _sharedPrefs.setString(key, value ?? "");
  }

  void saveInt(String key, int? value) {
    _sharedPrefs.setInt(key, value ?? 0);
  }

  void saveBoolean(String key, bool value) {
    _sharedPrefs.setBool(key, value);
  }

  void saveDouble(String key, double? value) {
    _sharedPrefs.setDouble(key, value ?? 0.0);
  }

  String? getStringValue(String key) {
    String? value = _sharedPrefs.getString(key);
    return value;
  }

  int? getIntValue(String key) {
    int? value = _sharedPrefs.getInt(key) ?? 0;
    return value;
  }

  bool getBoolValue(String key) {
    bool? value = _sharedPrefs.getBool(key) ?? false;
    return value;
  }

  double? getDoubleValue(String key) {
    double? value = _sharedPrefs.getDouble(key);
    return value;
  }

  Future<bool> removeKey(String key) async {
    return await _sharedPrefs.remove(key);
  }

  // void logOut() {
  //   var session = locator<SessionManager>();
  //   var tempCompanyCode = session.companyCode;
  //   var tempSentRequest = session.getSentVerifyRequest(tempCompanyCode.toString());
  //   _sharedPrefs.clear();
  //   _sharedPrefs.setBool(tempCompanyCode.toString(), tempSentRequest);
  // }
}
