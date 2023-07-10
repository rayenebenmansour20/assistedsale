import 'package:flutter/material.dart';

import '../../../../data/model/order.dart';

class SingleOrder extends StatelessWidget {
  final Function(bool) callback;
  final Order order;

  const SingleOrder({super.key, required this.callback, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    callback(false);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Text(
                  'Client',
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
                  child: _orderDetail(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _orderDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            '${order.id}',
            style: const TextStyle(fontSize: 30),
          ),
        ),
        Text(
          '${order.client}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          'Type: ${order.type} Etat: ${order.state} ',
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
