import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/order.dart';
import '../../../../state/order_provider.dart';

class ClientOrders extends StatefulWidget {
  final int? client;
  final Function(bool) callback;
  final Function(Order) orderPage;

  const ClientOrders(
      {super.key,
      this.client,
      required this.callback,
      required this.orderPage});

  @override
  State<ClientOrders> createState() => _ClientOrdersState();
}

class _ClientOrdersState extends State<ClientOrders> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    provider.getOrdersByClient(widget.client);
    final orders = provider.clientOrders;

    final dtSource = UserDataTableSource(
      onRowSelect: (index) => _showDetails(context, orders[index]),
      orders: orders,
      callback: widget.callback,
      orderPage: widget.orderPage,
    );

    return PaginatedDataTable(
      columns: _colGen(),
      header: const Text('Liste des commandes'),
      source: dtSource,
      rowsPerPage: 3,
    );
  }

  List<DataColumn> _colGen() => const <DataColumn>[
        DataColumn(
          label: Text('ID'),
          tooltip: 'ID',
        ),
        DataColumn(
          label: Text('Type'),
          tooltip: 'Type',
        ),
        DataColumn(
          label: Text('Etat'),
          tooltip: 'Etat',
        ),
        DataColumn(
          label: Text(''),
          tooltip: '',
        ),
      ];

  void _showDetails(BuildContext c, Order data) async => await showDialog<bool>(
        context: c,
        builder: (_) => const Dialog(),
      );
}

class UserDataTableSource extends DataTableSource {
  final List<dynamic> orders;
  final Function(int index) onRowSelect;
  final Function(bool) callback;
  final Function(Order) orderPage;

  UserDataTableSource({
    required this.orders,
    required this.onRowSelect,
    required this.callback,
    required this.orderPage,
  });

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= orders.length) {
      return null;
    }
    final Order order = orders[index];

    return DataRow.byIndex(
      index: index, // DONT MISS THIS
      cells: <DataCell>[
        DataCell(Text('${order.id}')),
        DataCell(Text(_getType(order.type, order.state))),
        DataCell(_getIcon(order.state)),
        DataCell(
          Row(
            children: [
              IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(Icons.details_rounded),
                onPressed: () {
                  callback(true);
                  orderPage(order);
                },
              ),
              IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                color: Colors.blue,
                icon: const Icon(Icons.edit_note_rounded),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders.length;

  @override
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(Order d) getField, bool ascending) {
    orders.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }

  String _getType(int? type, int? state) {
    switch (type) {
      case 0:
        return 'Vente';
      case 2:
        if (state == 0) return 'Ticket';
        return 'Commande';
      case 3:
        return 'Précommande';
      default:
        return 'Inconnu';
    }
  }

  Icon _getIcon(int? state) {
    switch (state) {
      case 0:
        return const Icon(
          Icons.shopping_cart_rounded,
          color: Colors.blue,
        );
      case 1:
        return const Icon(
          Icons.shopping_cart_checkout_rounded,
          color: Colors.green,
        );
      case 3:
        return const Icon(
          Icons.autorenew_rounded,
          color: Colors.amber,
        );
      case 4:
        return const Icon(
          Icons.check,
          color: Colors.green,
        );
      default:
        return const Icon(Icons.question_mark);
    }
  }
}
