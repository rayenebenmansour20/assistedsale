import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../data/model/client.dart';
import '../../../state/client_provider.dart';
import '../clients/widgets/list.dart';

class TopReferals extends StatefulWidget {
  const TopReferals({Key? key}) : super(key: key);

  @override
  State<TopReferals> createState() => _TopReferalsState();
}

class _TopReferalsState extends State<TopReferals> {
  int _currentPage = 0;
  final int _perPage = 30;

  ClientProvider getClientProvider(BuildContext context) {
    return Provider.of<ClientProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getClientProvider(context).fetchClients().then((clients) {
        if (mounted) {
          setState(() {
            clientData = clients.map((json) => Client.fromJson(json)).toList();
          });
        }
      });
    });
  }

  List<Client> getPaginatedData() {
    final int startingIndex = _currentPage * _perPage;
    final int endingIndex = startingIndex + _perPage;
    return clientData.sublist(
        startingIndex, endingIndex.clamp(0, clientData.length));
  }

  @override
  Widget build(BuildContext context) {
    final List<Client> paginatedData = getPaginatedData();
    final int totalPages = (clientData.length / _perPage).ceil();
    final bool canGoForward = paginatedData.length == _perPage;
    return Container(
      height: 350,
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Produits en faible quantité',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _currentPage == 0
                        ? null
                        : () {
                            setState(() {
                              _currentPage--;
                            });
                          },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: _currentPage == 0
                          ? textColor.withOpacity(0.5)
                          : textColor,
                    ),
                  ),
                  Text(
                    '${_currentPage + 1} / $totalPages',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: !canGoForward
                        ? null
                        : () {
                            setState(() {
                              _currentPage++;
                            });
                          },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: !canGoForward
                          ? textColor.withOpacity(0.5)
                          : textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: appPadding,
          ),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Count')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text(''))
                ],
                rows: paginatedData.map<DataRow>((info) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              /*child: Image.asset(
                      info.svgSrc!,
                      width: 12,
                      height: 12,
                    ),*/
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          info.firstName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${info.id!}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${info.id!}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${info.id!}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
