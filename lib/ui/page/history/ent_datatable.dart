import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datamaster/data/model/client.dart';
import 'package:provider/provider.dart';

import '../../../../state/client_provider.dart';
import '../../../state/history_provider.dart';

class EntList extends StatefulWidget {
  const EntList({super.key});

  @override
  State<EntList> createState() => _EntListState();
}

class _EntListState extends State<EntList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final entHist = provider.entHistory;

    final dtSource = UserDataTableSource(
      context: context,
      onRowSelect: (index) => _showDetails(context, entHist[index]),
      entHist: entHist,
      provider: provider,
    );

    return PaginatedDataTable(
      columns: _colGen(),
      header: const Text('Liste des clients'),
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
          label: Text('Type'),
          tooltip: 'Type',
        ),
        DataColumn(
          label: Text('Date création'),
          tooltip: 'Date création',
        ),
        DataColumn(
          label: Text('Date modification'),
          tooltip: 'Date modification',
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
  final List<dynamic> entHist;
  final Function(int index) onRowSelect;
  final HistoryProvider provider;

  UserDataTableSource({
    required this.context,
    required this.entHist,
    required this.onRowSelect,
    required this.provider,
  });

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= entHist.length) {
      return null;
    }
    final ent = entHist[index];

    return DataRow.byIndex(
      index: index, // DONT MISS THIS
      cells: <DataCell>[
        DataCell(Text('${ent.id}')),
        DataCell(Text(_getType(ent.type, ent.state))),
        DataCell(Text('${ent.dcre}')),
        DataCell(Text('${ent.dmaj}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => entHist.length;

  @override
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(Client d) getField, bool ascending) {
    entHist.sort((a, b) {
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
}
