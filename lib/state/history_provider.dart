import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datamaster/helper/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

import '../data/model/det_hist.dart';
import '../data/model/ent_hist.dart';

class HistoryProvider extends ChangeNotifier {
  List<dynamic> _entHistory = [];
  List<dynamic> _detHistory = [];

  List<dynamic> get entHistory => _entHistory;
  List<dynamic> get detHistory => _detHistory;

  Future<void> getEntHistory() async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint = 'http://51.178.142.70:8008/DMERP/v1/Caisse/HisEntTicket/';

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      List<dynamic> history =
          jsonData.map((json) => EntHist.fromJson(json)).toList();
      _entHistory = history;
      notifyListeners();
      return jsonData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> getDetHistory() async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint = 'http://51.178.142.70:8008/DMERP/v1/Caisse/HisDetTicket/';

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      List<dynamic> history =
          jsonData.map((json) => DetHist.fromJson(json)).toList();
      _detHistory = history;
      notifyListeners();
      return jsonData;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
