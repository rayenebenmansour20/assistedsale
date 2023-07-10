import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datamaster/data/model/client.dart';
import 'package:flutter_datamaster/state/order_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../state/client_provider.dart';
import '../../../clients/widgets/add_client.dart';

class ClientsDialog extends StatefulWidget {
  final OrderProvider? orderProvider;
  final Function(Client) clientCallback;

  const ClientsDialog(
      {super.key, this.orderProvider, required this.clientCallback});

  @override
  State<ClientsDialog> createState() => _ClientsDialogState();
}

class _ClientsDialogState extends State<ClientsDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddClient(),
        ListTile(
          title: const Text('Client Passager'),
          onTap: () {
            widget.orderProvider!.updateClient(null);
            Navigator.pop(context);
          },
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          height: 400,
          child: Consumer<ClientProvider>(
            builder: (context, clientProvider, child) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: clientProvider.clients.length,
                itemBuilder: (context, index) {
                  final Client client = clientProvider.clients[index];
                  return ListTile(
                    title: Text('${client.firstName}, ${client.lastName}'),
                    onTap: () {
                      widget.orderProvider!.updateClient(client.id);
                      widget.clientCallback(client);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
