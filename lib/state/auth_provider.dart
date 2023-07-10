import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datamaster/helper/shared_preference_helper.dart';
import 'package:flutter_datamaster/ui/home.dart';
import 'package:flutter_datamaster/ui/page/login.dart';
import 'package:http/http.dart' as http;

import '../data/model/user.dart';
import '../helper/routes.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _resMessage = '';
  User? _loggedUser;
  final String terminal = '18';
  final Dio dio = Dio();

  //Getters
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  User? get loggedUser => _loggedUser;

  //Login function
  void loginUser(
      {required String email,
      required String password,
      BuildContext? context}) async {
    _isLoading = true;
    notifyListeners();
    try {
      http.Response req = await http.post(
        Uri.parse('http://51.178.142.70:8010/DMERP/v1/auth/login/'),
        body: {
          'email': email,
          'password': password,
          'terminal': terminal,
        },
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        _isLoading = false;
        _resMessage = "Bienvenu!";
        notifyListeners();

        getUserData();
        notifyListeners();

        final userId = res['user']['id'];
        final token = res['access_token'];
        final refreshToken = res['refresh_token'];

        SharedPreferenceHelper().saveUserID(userId as int);
        SharedPreferenceHelper().saveToken(token);

        http.Response refreshReq = await http.post(
          Uri.parse('http://51.178.142.70:8010/DMERP/v1/auth/token/refresh/'),
          body: {
            'refresh': refreshToken,
          },
        );
        if (refreshReq.statusCode == 200) {
          final refreshedToken = json.decode(refreshReq.body)['access'];
          SharedPreferenceHelper().saveToken(refreshedToken);
        } else if (refreshReq.statusCode == 401) {
          loginUser(email: email, password: password);
        } else {
          logOut(context!);
        }
        // ignore: use_build_context_synchronously
        PageNavigator(ctx: context).nextPage(page: const Home());
      } else {
        final res = json.decode(req.body);

        _resMessage = res['non_field_errors'];
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Connexion internet non disponible!";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Veillez réessayer!";
      notifyListeners();

      if (kDebugMode) {
        print(":::: $e");
      }
    }
  }

  Future<void> updateUserData({
    required String firstName,
    required String anotherInput,
    required String email,
    required String phoneNumber,
    Uint8List? photoBytes,
    required BuildContext context,
  }) async {
    final token = await SharedPreferenceHelper().getToken();
    dio.options.headers['Authorization'] =
        'Bearer $token'; // Set the authorization header

    var formData = FormData.fromMap({
      'first_name': firstName,
      'username': anotherInput,
      'email': email,
      'phone_number': phoneNumber,
      'MUTETAT': 'true',
    });

    if (photoBytes != null) {
      formData.files.add(
        MapEntry(
          'MUTPHOTOS',
          MultipartFile.fromBytes(
            photoBytes,
            filename: 'user_photo.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    try {
      final response = await dio.put(
        'http://51.178.142.70:8010/DMERP/v1/auth/user/',
        data: formData,
      );

      if (response.statusCode == 200) {
        // handle response...
      } else {
        // handle error...
      }
    } catch (e) {
      // handle error...
    }
  }

  //Logout function
  void logOut(BuildContext context) async {
    SharedPreferenceHelper().clear();

    // ignore: use_build_context_synchronously
    PageNavigator(ctx: context).nextPage(page: const Login());
  }

  void clear() {
    _resMessage = "";
    notifyListeners();
  }

  Future<Map<String, dynamic>> getUserData() async {
    final String? token = await SharedPreferenceHelper().getToken();

    final response = await http.get(
      Uri.parse('http://51.178.142.70:8010/DMERP/v1/auth/user/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final User loggedUser = User.fromJson(data);
      _loggedUser = loggedUser;
      notifyListeners();
      return data;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<bool> openSession() async {
    int? userId = await SharedPreferenceHelper().getUserID();
    String? token = await SharedPreferenceHelper().getToken();

    http.Response sessionResponse = await http.post(
      Uri.parse('http://51.178.142.70:8010/DMERP/v1/Caisse/HisCaisse/'),
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'CHCETAT': '0',
        'CHCSITEID': '1',
        'CHCTERMID': terminal,
        'CHCTINTR': '0',
        'CHCUTLID': userId,
      },
    );

    if (sessionResponse.statusCode == 200 ||
        sessionResponse.statusCode == 201) {
      final res = jsonDecode(sessionResponse.body);
      final sessionid = res['ID_ROWID'].toString();
      SharedPreferenceHelper().saveSessionID(sessionid);
      if (kDebugMode) {
        print("Session opened successfully");
      }
      return true;
    } else {
      if (kDebugMode) {
        print("Failed to open session");
      }
      return false;
    }
  }

  Future<bool> closeSession() async {
    String? token = await SharedPreferenceHelper().getToken();
    String? sessionid = await SharedPreferenceHelper().getSessionID();

    http.Response closeSessionResponse = await http.post(
      Uri.parse(
          'http://51.178.142.70:8010/DMERP/v1/Caisse/MiseEnAttenteSession/'),
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'ID_ROWID': sessionid, // Replace with the correct ID_ROWID value
        'CHCTTR': '0',
      },
    );

    if (closeSessionResponse.statusCode == 200 ||
        closeSessionResponse.statusCode == 201) {
      if (kDebugMode) {
        print("Session closed successfully");
      }
      return true;
    } else {
      if (kDebugMode) {
        print("Failed to close session");
      }
      return false;
    }
  }
}
