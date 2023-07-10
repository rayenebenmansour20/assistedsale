import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datamaster/data/model/order.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/client.dart';
import '../../../../state/client_provider.dart';
import '../../../../state/order_provider.dart';

class OList extends StatefulWidget {
  final Function(bool) callback;
  final Function(Order) orderPage;
  final int type;

  const OList(
      {super.key,
      required this.callback,
      required this.orderPage,
      required this.type});

  @override
  State<OList> createState() => _OListState();
}

class _OListState extends State<OList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final cprovider = context.watch<ClientProvider>();
    cprovider.fetchClients();
    late List<dynamic> orders;
    switch (widget.type) {
      case 0:
        orders = provider.allorders;
        break;
      case 1:
        orders =
            provider.allorders.where((element) => element.type == 3).toList();
        break;
      case 2:
        orders =
            provider.allorders.where((element) => element.type == 2).toList();
        break;
      case 3:
        orders =
            provider.allorders.where((element) => element.type == 1).toList();
        break;
    }

    final dtSource = UserDataTableSource(
      context: context,
      onRowSelect: (index) => _showDetails(context, orders[index]),
      orders: orders,
      callback: widget.callback,
      orderPage: widget.orderPage,
      provider: provider,
      cprovider: cprovider,
    );

    return PaginatedDataTable(
      columns: _colGen(),
      header: const Text('Liste des commandes'),
      source: dtSource,
      rowsPerPage: 6,
    );
  }

  List<DataColumn> _colGen() => const <DataColumn>[
        DataColumn(
          label: Text('ID'),
          tooltip: 'ID',
        ),
        DataColumn(
          label: Text('Client'),
          tooltip: 'Client',
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
  final BuildContext context;
  final List<dynamic> orders;
  final Function(int index) onRowSelect;
  final Function(bool) callback;
  final Function(Order) orderPage;
  final OrderProvider provider;
  final ClientProvider cprovider;

  UserDataTableSource({
    required this.context,
    required this.orders,
    required this.onRowSelect,
    required this.callback,
    required this.orderPage,
    required this.provider,
    required this.cprovider,
  });

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= orders.length) {
      return null;
    }
    final Order order = orders[index];
    late Client client;
    if (order.client != null) {
      client =
          cprovider.clients.firstWhere((element) => element.id == order.client);
    }

    return DataRow.byIndex(
      index: index, // DONT MISS THIS
      cells: <DataCell>[
        DataCell(
          Text('${order.id}'),
        ),
        if (order.client == null)
          const DataCell(
            Text('Passager'),
          )
        else
          DataCell(
            Text('${client.firstName!.substring(0, 1)} ${client.lastName}'),
          ),
        DataCell(
          Text(
            _getType(order.type, order.state),
          ),
        ),
        DataCell(
          _getIcon(order.state),
        ),
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
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    width: 500,
                    isDense: true,
                    showCloseIcon: true,
                    dialogType: DialogType.noHeader,
                    animType: AnimType.scale,
                    body: Column(
                      children: [
                        Text('Votre commande est ${_getState(order.state)}'),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                    btnOk: _getButton(order),
                  ).show();
                },
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

  Widget? _getButton(Order order) {
    if (order.type == 3) {
      return ElevatedButton(
        onPressed: () {
          provider.updateOrder(order, type: 2);
          Navigator.pop(context);
        },
        child: const Text('Commander'),
      );
    }
    if (order.state == 3) {
      return ElevatedButton(
        onPressed: () {
          provider.updateOrder(order, state: 4);
          Navigator.pop(context);
        },
        child: const Text('Commande prête'),
      );
    }
    return null;
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
