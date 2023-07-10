import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/client.dart';
import '../../../state/client_provider.dart';
import 'client_detail.dart';
import 'widgets/add_client.dart';
import 'widgets/data_table.dart';
import 'widgets/searchbar.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final _searchController = TextEditingController();
  late ClientProvider clientProvider;
  bool selectedClient = false;
  late Client currentClient;

  @override
  void initState() {
    clientProvider = Provider.of<ClientProvider>(context, listen: false);
    clientProvider.fetchClients();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _callback(bool i) {
    setState(() => selectedClient = i);
  }

  void _currentClient(Client client) {
    setState(() => currentClient = client);
  }

  @override
  Widget build(BuildContext context) {
    return selectedClient
        ? ClientDetail(client: currentClient, callback: _callback)
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: searchField(_searchController, clientProvider,
                              Colors.grey[100]),
                        ),
                        AddClient(),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CList(
                                        callback: _callback,
                                        clientPage: _currentClient,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
