import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../state/client_provider.dart';
import '../../../../state/order_provider.dart';

class Tickets extends StatefulWidget {
  final Function(int) selectedTicketCallback;

  const Tickets({super.key, required this.selectedTicketCallback});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  int selectedIndex = -1; // Initially no item is selected

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurStyle: BlurStyle.solid,
            blurRadius: 10,
          ),
        ],
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Consumer<OrderProvider>(
        builder: (context, provider, child) => Row(
          children: [
            Container(
              height: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  provider.addEntTicket();
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.orders.length,
                itemBuilder: (context, index) {
                  final order = provider.orders[index];
                  final isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      provider.getTicket(order.id);
                      Timer(const Duration(seconds: 2), () {
                        setState(() {
                          selectedIndex = index;
                        });
                        widget.selectedTicketCallback(order.id);
                      });
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<ClientProvider>(
                            builder: (context, clientProvider, child) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                order.client == null
                                    ? Text(
                                        'Passager',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.blue,
                                          fontSize: 15,
                                        ),
                                      )
                                    : Text(
                                        '${clientProvider.clients.firstWhere((element) => element.id == order.client).firstName} ${clientProvider.clients.firstWhere((element) => element.id == order.client).lastName}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.blue,
                                          fontSize: 15,
                                        ),
                                      ),
                                if (isSelected)
                                  IconButton(
                                    onPressed: () {
                                      provider.deleteEntTicket(order.id);
                                      widget.selectedTicketCallback(0);
                                      setState(() {
                                        selectedIndex = -1;
                                      });
                                    },
                                    icon: const Icon(Icons.cancel_presentation),
                                    color: Colors.white,
                                    iconSize: 20,
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            'Ticket ${order.id}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
