import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/order.dart';
import '../../../../helper/invoice.dart';

class OrderDetail extends StatefulWidget {
  final Function(bool) callback;
  final Order order;

  const OrderDetail({super.key, required this.callback, required this.order});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool _selectedTicket = false;

  void _selectReceipt(bool s) {
    setState(() {
      _selectedTicket = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _selectedTicket
        ? Receipt(
            order: widget.order,
            selectedTicket: _selectReceipt,
          )
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
                        'Commandes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 300,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _orderDetail(),
                        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_getType(widget.order.type)} ${widget.order.id}',
              style: const TextStyle(fontSize: 32),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _selectReceipt(true);
              },
              icon: const Icon(Icons.receipt_rounded),
              label: const Text('Consulter le reçu'),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'Date: ${widget.order.dateOpr}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Etat: ${_getState(widget.order.state)} ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  String _getType(int? type) {
    switch (type) {
      case 0:
        return 'Vente';
      case 2:
        return 'Commande';
      case 3:
        return 'Précommande';
      default:
        return 'Inconnu';
    }
  }

  String _getState(int? state) {
    switch (state) {
      case 0:
        return 'en attente';
      case 1:
        return 'soldé';
      case 3:
        return 'en préparation';
      case 4:
        return 'prête';
      default:
        return 'Inconnu';
    }
  }
}
