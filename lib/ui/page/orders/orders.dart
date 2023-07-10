import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../state/product_provider.dart';
import '../../../state/order_provider.dart';
import '../../../state/client_provider.dart';
import 'products/products.dart';
import 'widgets/order_details/order_details.dart';
import 'widgets/tickets.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late ProductProvider productProvider;
  late OrderProvider orderProvider;
  late ClientProvider clientProvider;

  final _searchController = TextEditingController();
  int? selectedTicket;

  void _selectedTicketCallback(int ticket) {
    setState(() {
      selectedTicket = ticket;
    });
  }

  @override
  void initState() {
    print('INIT!');
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    clientProvider = Provider.of<ClientProvider>(context, listen: false);
    orderProvider.getTickets();
    productProvider.fetchProducts(1, searchQuery: _searchController.text);
    productProvider.getCategories();
    clientProvider.fetchClients();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  //Products
                  Expanded(
                    child: ProductsOrders(
                      ticket: selectedTicket,
                    ),
                  ),
                  //Checkout
                  Expanded(
                    child: OrderDetails(
                      ticket: selectedTicket,
                      ticketCallback: _selectedTicketCallback,
                    ),
                  ),
                ],
              ),
            ),
            Tickets(
              selectedTicketCallback: _selectedTicketCallback,
            ),
          ],
        ),
      ),
    );
  }
}
