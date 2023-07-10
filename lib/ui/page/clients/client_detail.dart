import 'package:flutter/material.dart';

import '../../../data/model/client.dart';
import '../../../data/model/order.dart';
import 'widgets/client_single_order.dart';
import 'widgets/client_orders.dart';

class ClientDetail extends StatefulWidget {
  final Function(bool) callback;
  final Client client;

  const ClientDetail({super.key, required this.callback, required this.client});

  @override
  State<ClientDetail> createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail> {
  bool selectedOrder = false;
  late Order currentOrder;

  void _callback(bool i) {
    setState(() => selectedOrder = i);
  }

  void _currentOrder(Order order) {
    setState(() => currentOrder = order);
  }

  @override
  Widget build(BuildContext context) {
    return selectedOrder
        ? SingleOrder(order: currentOrder, callback: _callback)
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.callback(false);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text(
                        'Clients',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(32),
                        child: _clientDetail(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ClientOrders(
                          client: widget.client.id,
                          callback: _callback,
                          orderPage: _currentOrder,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Widget _clientDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            '${widget.client.firstName} ${widget.client.lastName}',
            style: const TextStyle(fontSize: 30),
          ),
        ),
        Text(
          '${widget.client.email}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          '${widget.client.phoneNumber}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
