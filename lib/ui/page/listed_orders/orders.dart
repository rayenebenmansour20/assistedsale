import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/order.dart';
import '../../../state/order_provider.dart';
import 'widgets/data_table.dart';
import 'widgets/order_detail.dart';
import 'widgets/searchbar.dart';

class LOrders extends StatefulWidget {
  const LOrders({super.key});

  @override
  State<LOrders> createState() => _LOrdersState();
}

class _LOrdersState extends State<LOrders> {
  final _searchController = TextEditingController();
  late OrderProvider orderProvider;
  bool selectedOrder = false;
  late Order currentOrder;
  int _selectedIndex = 0;

  @override
  void initState() {
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.getTickets();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _callback(bool i) {
    setState(() => selectedOrder = i);
  }

  void _currentOrder(Order order) {
    setState(() => currentOrder = order);
  }

  @override
  Widget build(BuildContext context) {
    return selectedOrder
        ? OrderDetail(order: currentOrder, callback: _callback)
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: searchField(
                            _searchController,
                            orderProvider,
                            Colors.grey[100],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            BottomNavigationBar(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              useLegacyColorScheme: false,
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.done_all),
                                  label: 'Tout',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.shopping_cart_rounded),
                                  label: 'Précommandes',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.shopping_bag_rounded),
                                  label: 'Commandes',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.monetization_on_rounded),
                                  label: 'Ventes',
                                ),
                              ],
                              currentIndex: _selectedIndex,
                              onTap: (index) {
                                setState(
                                  () {
                                    _selectedIndex = index;
                                  },
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: OList(
                                      callback: _callback,
                                      orderPage: _currentOrder,
                                      type: _selectedIndex,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
