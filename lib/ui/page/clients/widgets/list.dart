import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/client.dart';
import '../../../../state/client_provider.dart';

class ClientsList extends StatefulWidget {
  const ClientsList({super.key});

  @override
  State<ClientsList> createState() => _ClientsListState();
}

class _ClientsListState extends State<ClientsList> {
  int _currentPage = 0;

  final int _perPage = 30;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController tarifprodController = TextEditingController();
  final TextEditingController identcardController = TextEditingController();

  ClientProvider getClientProvider(BuildContext context) {
    return Provider.of<ClientProvider>(context, listen: false);
  }

  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Client'),
          content: const Text('Are you sure you want to delete this client?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Client'),
          content: const Text('Edit client details here.'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform edit action here
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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

  void showClientDetails(Client client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Client Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('First Name: ${client.firstName}'),
              Text('Last Name: ${client.lastName}'),
              Text('Email: ${client.email}'),
              Text('Phone Number: ${client.phoneNumber}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
      height: 700,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Clients',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
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
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.black,
                    ),
                  ),
                  Text(
                    '${_currentPage + 1} / $totalPages',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // Header Row
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Prénom')),
                  DataColumn(label: Text(''))
                ],
                rows: paginatedData.map<DataRow>((info) {
                  return DataRow(
                    cells: [
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            showClientDetails(info);
                          },
                          child: Row(
                            children: [
                              Text(
                                '${info.id!}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          info.lastName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            showClientDetails(info);
                          },
                          child: Text(
                            info.firstName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () async {
                                // Assuming 'clientId' is the id of the client to delete
                                String? error =
                                    await Provider.of<ClientProvider>(context,
                                            listen: false)
                                        .deleteClient(info.id!);

                                if (error == null) {
                                  print("Client deleted successfully");
                                } else {
                                  print("Failed to delete client: $error");
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.blueAccent, // Icon to edit
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      insetPadding: const EdgeInsets.all(
                                          20), // Add some padding to reduce the dialog size
                                      child: FractionallySizedBox(
                                        widthFactor: 0.4,
                                        heightFactor: 0.65,
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start, // Align title to the left
                                            children: [
                                              const Text(
                                                'Modifier ce client',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 16),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text('Nom'),
                                                          const SizedBox(
                                                              height: 8),
                                                          TextFormField(
                                                            controller:
                                                                lastNameController,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  'Saisissez le nom',
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text('Prénom'),
                                                          const SizedBox(
                                                              height: 8),
                                                          TextFormField(
                                                            controller:
                                                                firstNameController,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  'Saisissez le prénom',
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text('Email'),
                                                          const SizedBox(
                                                              height: 8),
                                                          TextFormField(
                                                            controller:
                                                                emailController,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  "Saisissez lemail",
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                              'N° de téléphone'),
                                                          const SizedBox(
                                                              height: 8),
                                                          TextFormField(
                                                            controller:
                                                                phoneNumberController,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  "Saisissez le numéro de téléphone",
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text('Tarif'),
                                                          const SizedBox(
                                                              height: 8),
                                                          MultiSelectFormField(
                                                            title: const Text(
                                                                'Choisissez un tarif'),
                                                            dataSource: const [
                                                              {
                                                                'display':
                                                                    'VIP',
                                                                'value': '1'
                                                              },
                                                              {
                                                                'display':
                                                                    'Passager',
                                                                'value': '2'
                                                              },
                                                              {
                                                                'display':
                                                                    'Normal',
                                                                'value': '3'
                                                              },
                                                            ],
                                                            textField:
                                                                'display',
                                                            valueField: 'value',
                                                            okButtonLabel: 'OK',
                                                            cancelButtonLabel:
                                                                'Annuler',
                                                            //hintText: 'Select inputs',
                                                            initialValue: const [], // set initial value here
                                                            onSaved: (value) {
                                                              // Handle selected inputs
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                              'N° de carte fidelité'),
                                                          const SizedBox(
                                                              height: 8),
                                                          TextFormField(
                                                            controller:
                                                                identcardController,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  "Saisissez le numéro",
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              // ... Keep the existing input fields and SizedBoxes ...
                                              const SizedBox(height: 16),
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: ElevatedButton(
                                                        onPressed: () {},
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .blue),
                                                        ),
                                                        child: const Text(
                                                            'Valider'),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: 16 * 2),
                                                    Expanded(
                                                      flex:
                                                          1, // Increase space between the buttons
                                                      child: OutlinedButton(
                                                        onPressed: () {
                                                          // Handle white button tap
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Annuler'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              color: Colors.blueAccent, // Icon to view data
                              onPressed: () {
                                // Implement your viewing logic here
                              },
                            ),
                          ],
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

List<Client> clientData = [];
