import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/model/order.dart';
import '../data/model/payment.dart';
import '../data/model/product_order.dart';
import '../helper/shared_preference_helper.dart';

class OrderProvider extends ChangeNotifier {
  List<dynamic> _orders = [];
  List<dynamic> _allorders = [];
  List<dynamic> _clientOrders = [];
  List<int> _stats = [];
  Order? _ticket;
  bool _orderLoading = false;
  bool _orderSuccess = false;

  List<dynamic> get orders => _orders;
  List<dynamic> get allorders => _allorders;
  List<dynamic> get clientOrders => _clientOrders;
  List<int> get stats => _stats;
  Order? get ticket => _ticket;
  bool get orderLoading => _orderLoading;
  bool get orderSuccess => _orderSuccess;

  Future<List<dynamic>> getTickets({String? searchQuery}) async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint = 'http://51.178.142.70:8010/DMERP/v1/Caisse/EntTicket/';

    //Check search field
    if (searchQuery != null && searchQuery.isNotEmpty) {
      endpoint += '?search=$searchQuery';
    }

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final List<dynamic> orders =
          jsonData.map((json) => Order.fromJson(json)).toList();
      _allorders = orders;
      notifyListeners();
      final List<dynamic> filteredOrders =
          orders.where((order) => order.state == 0).toList();
      _orders = filteredOrders;
      notifyListeners();
      List<dynamic> preorders =
          _allorders.where((element) => element.type == 3).toList();
      notifyListeners();
      List<dynamic> preparingOrders =
          _allorders.where((element) => element.state == 3).toList();
      notifyListeners();
      List<dynamic> preparedOrders =
          _allorders.where((element) => element.state == 4).toList();
      notifyListeners();
      _stats = [
        _orders.length,
        preorders.length,
        preparingOrders.length,
        preparedOrders.length,
      ];
      notifyListeners();
      return _orders;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<dynamic>> getOrdersByClient(int? id) async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint = 'http://51.178.142.70:8010/DMERP/v1/Caisse/EntTicket/';

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final List<dynamic> orders =
          jsonData.map((json) => Order.fromJson(json)).toList();
      _clientOrders = orders.where((order) => order.client == id).toList();
      notifyListeners();
      return _clientOrders;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> getTicket(int? id) async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint =
        'http://51.178.142.70:8010/DMERP/v1/Caisse/EntTicket/$id/';

    if (id != null) {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        final Order ticket = Order.fromJson(jsonData);
        _ticket = ticket;
        updateTotal(id);
        notifyListeners();
      } else {
        throw Exception('Failed to load user data');
      }
    }
  }

  Future<void> addEntTicket() async {
    String? token = await SharedPreferenceHelper().getToken();

    Order ticket = Order(type: 2, state: 0);

    String endpoint = 'http://51.178.142.70:8010/DMERP/v1/Caisse/EntTicket/';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        ticket.toJson(),
      ),
    );
    if (response.statusCode == 201) {
      getTickets();
      notifyListeners();
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> deleteEntTicket(int? id) async {
    String? token = await SharedPreferenceHelper().getToken();

    String endpoint = 'http://51.178.142.70:8010/DMERP/v1/Caisse/EntTicket/$id';

    final response = await http.delete(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 204) {
      getTickets();
      notifyListeners();
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> addDetTicket(
      int productId, int? ticketId, String? prix, String? quantite) async {
    String? token = await SharedPreferenceHelper().getToken();

    try {
      String endpoint = 'http://51.178.142.70:8010/DMERP/v1/Caisse/DetTicket/';

      ProductOrder detTicket = ProductOrder(
          product: productId, order: ticketId, prix: prix, quantite: quantite);

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(detTicket.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        getTickets();
        getTicket(ticketId);
        notifyListeners();
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('ERROR!');
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Connexion internet non disponible!");
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        print(":::: $e");
      }
    }
  }

  Future<void> updateDetTicket(ProductOrder product, String? quantite) async {
    String? token = await SharedPreferenceHelper().getToken();

    product.quantite = quantite;

    try {
      String endpoint =
          'http://51.178.142.70:8010/DMERP/v1/Caisse/DetTicket/${product.id}/';

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        getTickets();
        notifyListeners();
        getTicket(product.order);
        notifyListeners();
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('ERROR!');
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Connexion internet non disponible!");
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        print(":::: $e");
      }
    }
  }

  Future<void> deleteDetTicket(int id, Order order) async {
    String? token = await SharedPreferenceHelper().getToken();
    try {
      String endpoint =
          'http://51.178.142.70:8010/DMERP/v1/Caisse/DetTicket/$id/';

      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 204) {
        getTickets();
        notifyListeners();
        getTicket(order.id);
        notifyListeners();
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('ERROR!');
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Connexion internet non disponible!");
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        print(":::: $e");
      }
    }
  }

  Future<void> updateTotal(int id) async {
    String? token = await SharedPreferenceHelper().getToken();

    double total = 0;

    for (ProductOrder product in _ticket!.products!
        .map((json) => ProductOrder.fromJson(json))
        .toList()) {
      total += double.parse(product.prix!) * double.parse(product.quantite!);
    }

    if (_ticket!.products!
        .map((json) => ProductOrder.fromJson(json))
        .toList()
        .isEmpty) {
      total = 0;
    }

    _ticket!.total = total.toString();

    try {
      String endpoint =
          'http://51.178.142.70:8010/DMERP/v1/Caisse/EntTicket/$id/';

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          _ticket!.toJson(),
        ),
      );
      if (response.statusCode == 204) {
        getTickets();
        notifyListeners();
        getTicket(_ticket!.id);
        notifyListeners();
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('ERROR!');
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Connexion internet non disponible!");
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        print(":::: $e");
      }
    }
  }

  Future<void> updateClient(int? clientId) async {
    String? token = await SharedPreferenceHelper().getToken();

    try {
      String endpoint =
          'http://51.178.142.70:8010/DMERP/v1/Caisse/EntTicket/${_ticket!.id}/';

      _ticket!.client = clientId;

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(_ticket!.toJson()),
      );
      if (response.statusCode == 200) {
        getTickets();
        notifyListeners();
        getTicket(_ticket!.id);
        notifyListeners();
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('ERROR!');
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Connexion internet non disponible!");
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        print(":::: $e");
      }
    }
  }

  //Order & Preorder
  Future<void> addOrder(int? type, int? state, int? modeLiv,
      {String? adresseLiv}) async {
    String? token = await SharedPreferenceHelper().getToken();

    _ticket!.type = type;
    _ticket!.state = state;
    _ticket!.modeLiv = modeLiv;
    _ticket!.adresseLiv = adresseLiv;
    _orderLoading = true;

    try {
      String endpoint =
          'http://51.178.142.70:8010/DMERP/v1/Caisse/EntTicket/${_ticket!.id}/';

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          _ticket!.toJson(),
        ),
      );
      if (response.statusCode == 200) {
        getTickets();
        notifyListeners();
        _orderLoading = false;
        notifyListeners();
        _orderSuccess = true;
        notifyListeners();
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('ERROR!');
        }
        notifyListeners();
        _orderLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Connexion internet non disponible!");
        _orderLoading = false;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        print(":::: $e");
      }
      _orderLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrder(Order? order, {int? type, int? state}) async {
    String? token = await SharedPreferenceHelper().getToken();

    if (state != null) order!.state = state;
    if (type != null) order!.type = type;

    try {
      String endpoint =
          'http://51.178.142.70:8010/DMERP/v1/Caisse/EntTicket/${order!.id}/';

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          order.toJson(),
        ),
      );
      if (response.statusCode == 200) {
        getTickets();
        notifyListeners();
        _orderLoading = false;
        notifyListeners();
        _orderSuccess = true;
        notifyListeners();
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('ERROR!');
        }
        notifyListeners();
        _orderLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Connexion internet non disponible!");
        _orderLoading = false;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        print(":::: $e");
      }
      _orderLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPayment(int? type, int? state, String? sum,
      {String? partialSum}) async {
    String? token = await SharedPreferenceHelper().getToken();

    try {
      String endpoint = 'http://51.178.142.70:8010/DMERP/v1/Caisse/Versement/';

      final Payment payment = Payment(
          type: type,
          state: state,
          paid: sum,
          toBePaid: partialSum,
          ticket: _ticket!.id);

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(payment.toJson()),
      );
      print(response.statusCode);
      print(payment.ticket);
      if (response.statusCode == 200 || response.statusCode == 201) {
        getTickets();
        notifyListeners();
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('ERROR!');
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Connexion internet non disponible!");
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        print(":::: $e");
      }
    }
  }

  Future<void> resetOrderState() async {
    _orderLoading = false;
    _orderSuccess = false;
  }
}
