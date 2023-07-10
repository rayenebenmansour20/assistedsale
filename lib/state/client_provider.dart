import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/client.dart';
import '../helper/shared_preference_helper.dart';

class ClientProvider with ChangeNotifier {
  List<dynamic> _clients = [];
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  List<dynamic> get clients => _clients;

  Future<List<dynamic>> fetchClients({String? searchQuery}) async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint =
        'http://51.178.142.70:8010/DMERP/v1/Caisse/Client/?page=1';

    //Check search field
    if (searchQuery != null && searchQuery.isNotEmpty) {
      endpoint += '&search=$searchQuery';
    }

    print(endpoint);

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final List<dynamic> clients =
          jsonData.map((json) => Client.fromJson(json)).toList();
      _clients = clients;
      notifyListeners();
      return jsonData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<String?> addClient(Client client) async {
    SharedPreferences prefs = await _pref;
    String token = prefs.getString('token')!;
    final response = await http.post(
      Uri.parse('http://51.178.142.70:8010/DMERP/v1/Caisse/Client/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(client),
    );

    if (response.statusCode == 200) {
      fetchClients();
      notifyListeners();
      return null;
    } else {
      final dynamic jsonData = jsonDecode(response.body);
      String errorMessage = jsonData['detail'];
      return errorMessage;
    }
  }

  Future<String?> updateClient(Client client) async {
    SharedPreferences prefs = await _pref;
    String token = prefs.getString('token')!;
    http.Response? response;

    try {
      response = await http.put(
        Uri.parse(
            'http://51.178.142.70:8010/DMERP/v1/Caisse/Client/${client.id}/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(client.toJson()),
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        Client updatedClient = Client.fromJson(jsonData);
        int index = _clients.indexWhere((c) => c.id == updatedClient.id);
        _clients[index] = updatedClient;
        notifyListeners();
        print('Client updated');
        return null;
      } else {
        final dynamic jsonData = jsonDecode(response.body);
        String errorMessage = jsonData['detail'];
        print('Client not updated');
        return errorMessage;
      }
    } catch (error) {
      print('Request failed with error: $error');
      print(response?.body);
    }

    return null;
  }

  Future<String?> deleteClient(int id) async {
    SharedPreferences prefs = await _pref;
    String token = prefs.getString('token')!;
    http.Response? response;

    try {
      response = await http.delete(
        Uri.parse('http://51.178.142.70:8010/DMERP/v1/Caisse/Client/$id/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        _clients.removeWhere((client) => client.id == id);
        notifyListeners();
        fetchClients();
        notifyListeners();
        print('Client deleted');
        return null;
      } else {
        final dynamic jsonData = jsonDecode(response.body);
        String errorMessage = jsonData['detail'];
        print('Client not deleted');
        return errorMessage;
      }
    } catch (error) {
      print('Request failed with error: $error');
      print(response?.body);
    }

    return null;
  }
}
