import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datamaster/data/model/productoutofstock.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/product.dart';
import '../data/model/top_product.dart';
import '../helper/shared_preference_helper.dart';

class ProductProvider with ChangeNotifier {
  int _count = 1;
  final int _pageSize = 12;
  List<dynamic> _products = [];
  List<dynamic> _stock = [];
  List<dynamic> _topsold = [];
  List<dynamic> _outstock = [];
  List<DropdownMenuEntry<int>> _categories = [];
  String filters = '';
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  List<dynamic> get products => _products;
  List<dynamic> get stock => _stock;
  List<dynamic> get outstock => _outstock;
  List<dynamic> get topsold => _topsold;
  List<DropdownMenuEntry<int>> get categories => _categories;
  int get count => _count;
  int get pageSize => _pageSize;

  Future<Map<String, dynamic>> fetchProducts(int page,
      {String? searchQuery, int? categoryFilter, String? priceFilter}) async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint =
        'http://51.178.142.70:8010/DMERP/v1/Caisse/Produits/?page=$page&page_size=$_pageSize';

    //Check search field
    if (searchQuery != null && searchQuery.isNotEmpty) {
      endpoint += '&search=$searchQuery';
    }

    //Check category filter field
    if (categoryFilter != null && !endpoint.contains('CPRCATEGID')) {
      filters += '&CPRCATEGID=$categoryFilter';
    }

    //Check price filter field
    if (priceFilter != null &&
        priceFilter.isNotEmpty &&
        !endpoint.contains('CPRPRIX')) {
      filters += '&CPRPRIX=$priceFilter';
    }

    endpoint += filters;

    print(endpoint);

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final List<dynamic> products =
          jsonData['results'].map((json) => Product.fromJson(json)).toList();
      _products = products;
      _count = (jsonData['count'] / _pageSize).ceil(); // Calculate total pages
      notifyListeners();
      return jsonData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> getStock(int page) async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint =
        'http://51.178.142.70:8008/DMERP/v1/Caisse/Produits/?ordering=-CPRQTEINIT&page=$page&page_size=$_pageSize';

    print(endpoint);

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final List<dynamic> products =
          jsonData['results'].map((json) => Product.fromJson(json)).toList();
      _stock = products;
      _count = (jsonData['count'] / _pageSize).ceil(); // Calculate total pages
      notifyListeners();
      return jsonData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<dynamic>> getCategories() async {
    SharedPreferences value = await _pref;
    String token = value.getString('token')!;

    String endpoint = 'http://51.178.142.70:8010/DMERP/v1/Caisse/Categories/';

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final List<DropdownMenuEntry<int>> categories =
          jsonData.map<DropdownMenuEntry<int>>((dynamic item) {
        final int id = item['ID_ROWID'] as int;
        final String label = item['CCTLIBLONG'] as String;
        return DropdownMenuEntry<int>(
          value: id,
          label: label,
        );
      }).toList();
      _categories = categories;
      notifyListeners();
      return jsonData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> fetchProductsoutofstock(int page) async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint =
        'http://51.178.142.70:8010/DMERP/v1/Caisse/Produits/?page=$page&page_size=6&CPRINDVALIDE=1&ordering=-ID_ROWID&CPRINDRUP=true';
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final List<dynamic> productsoutofstock =
          jsonData['results'].map((json) => Product.fromJson(json)).toList();
      _outstock = productsoutofstock;
      notifyListeners();
      _count = (jsonData['count'] / _pageSize).ceil(); // Calculate total pages
      notifyListeners();
      return jsonData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<dynamic>> fetchTopSellingProducts() async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint =
        'http://51.178.142.70:8008/DMERP/v1/Caisse/TopVendu/?date_gte=2021-03-15&date_lte=2023-06-12&page=1&page_size=6';

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final List<dynamic> products =
          jsonData['results'].map((json) => TopProduct.fromJson(json)).toList();
      _topsold = products;
      notifyListeners();
      return products;
    } else {
      throw Exception('Failed to load top selling products');
    }
  }
}
