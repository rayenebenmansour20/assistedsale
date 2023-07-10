import 'package:flutter/material.dart';
import 'package:flutter_datamaster/data/model/client.dart';
import 'package:provider/provider.dart';

import '../../../state/history_provider.dart';

class DetList extends StatefulWidget {
  const DetList({super.key});

  @override
  State<DetList> createState() => _DetListState();
}

class _DetListState extends State<DetList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final detHist = provider.detHistory;

    final dtSource = UserDataTableSource(
      context: context,
      onRowSelect: (index) => _showDetails(context, detHist[index]),
      detHist: detHist,
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
          label: Text('Produit'),
          tooltip: 'Produit',
        ),
        DataColumn(
          label: Text('Action'),
          tooltip: 'Action',
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
  final List<dynamic> detHist;
  final Function(int index) onRowSelect;
  final HistoryProvider provider;

  UserDataTableSource({
    required this.context,
    required this.detHist,
    required this.onRowSelect,
    required this.provider,
  });

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= detHist.length) {
      return null;
    }
    final det = detHist[index];

    return DataRow.byIndex(
      index: index, // DONT MISS THIS
      cells: <DataCell>[
        DataCell(Text('${det.id}')),
        DataCell(Text('${det.libelle}')),
        DataCell(Text(_getMotif(det.motif))),
        DataCell(Text('${det.dcre}')),
        DataCell(Text('${det.dmaj}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => detHist.length;

  @override
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(Client d) getField, bool ascending) {
    detHist.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }

  String _getMotif(int? motif) {
    switch (motif) {
      case 1:
        return '+ Vente';
      case 2:
        return '- Vente';
      case 3:
        return '+ Retour';
      case 4:
        return '- Retour';
      default:
        return 'Inconnu';
    }
  }
}
