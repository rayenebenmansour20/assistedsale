import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datamaster/data/model/client.dart';
import 'package:flutter_datamaster/helper/responsive.dart';
import 'package:provider/provider.dart';

import '../../../../state/client_provider.dart';
import 'edit_client.dart';

class CList extends StatefulWidget {
  final Function(bool) callback;
  final Function(Client) clientPage;

  const CList({super.key, required this.callback, required this.clientPage});

  @override
  State<CList> createState() => _CListState();
}

class _CListState extends State<CList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientProvider>();
    final clients = provider.clients;

    final dtSource = UserDataTableSource(
      context: context,
      onRowSelect: (index) => _showDetails(context, clients[index]),
      clients: clients,
      callback: widget.callback,
      clientPage: widget.clientPage,
      provider: provider,
    );

    return PaginatedDataTable(
      columns: _colGen(),
      header: const Text('Liste des clients'),
      source: dtSource,
      rowsPerPage: 6,
    );
  }

  List<DataColumn> _colGen() => <DataColumn>[
        const DataColumn(
          label: Text('ID'),
          tooltip: 'ID',
        ),
        const DataColumn(
          label: Text('Prénom'),
          tooltip: 'Prénom',
        ),
        const DataColumn(
          label: Text('Nom'),
          tooltip: 'Nom',
        ),
        if (isLargeScreen(context))
          const DataColumn(
            label: Text('Téléphone'),
            tooltip: 'Téléphone',
          ),
        const DataColumn(
          label: Text(''),
          tooltip: '',
        ),
      ];

  void _showDetails(BuildContext c, Client data) async =>
      await showDialog<bool>(
        context: c,
        builder: (_) => const Dialog(),
      );
}

class UserDataTableSource extends DataTableSource {
  final BuildContext context;
  final List<dynamic> clients;
  final Function(int index) onRowSelect;
  final Function(bool) callback;
  final Function(Client) clientPage;
  final ClientProvider provider;

  UserDataTableSource({
    required this.context,
    required this.clients,
    required this.onRowSelect,
    required this.callback,
    required this.clientPage,
    required this.provider,
  });

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= clients.length) {
      return null;
    }
    final client = clients[index];

    return DataRow.byIndex(
      index: index, // DONT MISS THIS
      cells: <DataCell>[
        DataCell(Text('${client.id}')),
        DataCell(Text('${client.firstName}')),
        DataCell(Text('${client.lastName}')),
        if (isLargeScreen(context)) DataCell(Text('${client.mobileNumber}')),
        DataCell(
          Row(
            children: [
              IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(Icons.details_rounded),
                onPressed: () {
                  callback(true);
                  clientPage(client);
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
                    body: EditProfil(client: client),
                  ).show();
                },
              ),
              IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                color: Colors.red,
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Supprimer client'),
                        content: const Text(
                            'Etes-vous sur de vouloir supprimer ce client ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              provider.deleteClient(client.id);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Supprimer'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Annuler'),
                          ),
                        ],
                      );
                    },
                  );
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
  int get rowCount => clients.length;

  @override
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(Client d) getField, bool ascending) {
    clients.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }
}
