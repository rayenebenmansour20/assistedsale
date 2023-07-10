import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  Future<bool> saveToken(String token) async {
    return (await SharedPreferences.getInstance()).setString('token', token);
  }

  Future<String?> getToken() async {
    String? token = (await SharedPreferences.getInstance()).getString('token');
    if (token == null) return null;
    return token;
  }

  Future<bool> saveUserID(int userID) async {
    return (await SharedPreferences.getInstance()).setInt('userID', userID);
  }

  Future<int?> getUserID() async {
    int? userID = (await SharedPreferences.getInstance()).getInt('userID');
    if (userID == null) return null;
    return userID;
  }

  Future<bool> saveSessionID(String sessionID) async {
    return (await SharedPreferences.getInstance())
        .setString('sessionID', sessionID);
  }

  Future<String?> getSessionID() async {
    String? sessionID =
        (await SharedPreferences.getInstance()).getString('sessionID');
    if (sessionID == null) return null;
    return sessionID;
  }

  Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
