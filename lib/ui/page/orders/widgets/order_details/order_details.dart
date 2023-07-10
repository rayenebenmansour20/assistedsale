import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datamaster/ui/page/orders/widgets/order_details/clients.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/client.dart';
import '../../../../../data/model/order.dart';
import '../../../../../data/model/product_order.dart';
import '../../../../../state/auth_provider.dart';
import '../../../../../state/client_provider.dart';
import '../../../../../state/order_provider.dart';
import 'order_dialog.dart';

class OrderDetails extends StatefulWidget {
  final int? ticket;
  final Function(int) ticketCallback;

  const OrderDetails({super.key, this.ticket, required this.ticketCallback});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late AuthenticationProvider authProvider;
  bool _sale = false;
  Client? currentClient;

  void _clientCallback(Client client) {
    setState(() {
      currentClient = client;
    });
  }

  @override
  void initState() {
    authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    authProvider.getUserData();
    if (authProvider.loggedUser!.type == 'fournisseur') {
      _sale = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.ticket == null || widget.ticket == 0
          ? const Center(
              child: Text('Aucun ticket sélectionner'),
            )
          : Consumer<OrderProvider>(
              builder: (context, provider, child) => Container(
                height: 360,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Consumer<ClientProvider>(
                        builder: (context, clientProvider, child) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            provider.ticket!.client == null
                                ? const Text(
                                    'Client Passager',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    '${clientProvider.clients.firstWhere((element) => element.id == provider.ticket!.client).lastName}, ${clientProvider.clients.firstWhere((element) => element.id == provider.ticket!.client).firstName}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  width: 580,
                                  dialogType: DialogType.noHeader,
                                  animType: AnimType.bottomSlide,
                                  body: ClientsDialog(
                                    clientCallback: _clientCallback,
                                    orderProvider: provider,
                                  ),
                                ).show();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.ticket!.products!.length,
                        itemBuilder: (BuildContext context, int index) {
                          Order? ticket = provider.ticket;
                          List<dynamic>? products = ticket!.products!
                              .map((json) => ProductOrder.fromJson(json))
                              .toList();
                          final product = products[index];
                          return Card(
                            child: ListTile(
                              leading: Text(
                                '${product.libelle.substring(0, 10)}...',
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${product.quantite.split('.')[0]} x '),
                                  Text('${product.prix.split('.')[0]} DZD'),
                                  Row(
                                    children: [
                                      Quantity(product: product),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red[400],
                                        ),
                                        onPressed: () {
                                          provider.deleteDetTicket(
                                              product.id, provider.ticket!);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total: ',
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            '${provider.ticket!.total} DZD',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Vente
                    Row(
                      children: [
                        if (_sale)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                provider.ticket!.products!.isEmpty
                                    ? Fluttertoast.showToast(
                                        msg: "Veuillez remplir votre ticket",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.SNACKBAR,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        fontSize: 16.0)
                                    : AwesomeDialog(
                                        context: context,
                                        width: 580,
                                        isDense: true,
                                        showCloseIcon: true,
                                        dialogType: DialogType.noHeader,
                                        animType: AnimType.scale,
                                        body: CheckoutDialog(
                                          ticketCallback: widget.ticketCallback,
                                          currentClient: currentClient,
                                          sale: true,
                                        ),
                                      ).show();
                              },
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blueGrey),
                              ),
                              child: const Text('Vendre'),
                            ),
                          ),
                        if (_sale)
                          const SizedBox(
                            width: 16,
                          ),

                        //Order Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              provider.ticket!.products!.isEmpty
                                  ? Fluttertoast.showToast(
                                      msg: "Veuillez remplir votre ticket",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      fontSize: 16.0)
                                  : AwesomeDialog(
                                      context: context,
                                      width: 580,
                                      isDense: true,
                                      showCloseIcon: true,
                                      dialogType: DialogType.noHeader,
                                      animType: AnimType.scale,
                                      body: CheckoutDialog(
                                        ticketCallback: widget.ticketCallback,
                                        sale: false,
                                      ),
                                    ).show();
                            },
                            child: const Text('Commander'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class OrderBody extends StatefulWidget {
  final Order? order;

  const OrderBody({super.key, this.order});

  @override
  State<OrderBody> createState() => _OrderBodyState();
}

class _OrderBodyState extends State<OrderBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.order!.products!
                .map((json) => ProductOrder.fromJson(json))
                .toList()
                .length,
            itemBuilder: (BuildContext context, int index) {
              ProductOrder product = widget.order!.products!
                  .map((json) => ProductOrder.fromJson(json))
                  .toList()[index];
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(product.libelle!),
                        const SizedBox(width: 16),
                        Text('x${product.quantite!.split('.')[0]}'),
                      ],
                    ),
                    Text(
                        '${double.tryParse(product.prix ?? '0')! * double.tryParse(product.quantite ?? '0')!} DZD'),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total: ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  '${widget.order!.total} DZD',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Quantity extends StatefulWidget {
  final ProductOrder product;

  const Quantity({super.key, required this.product});

  @override
  State<Quantity> createState() => _QunatityState();
}

class _QunatityState extends State<Quantity> {
  late OrderProvider orderProvider;

  late String quantity;

  @override
  void initState() {
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(
          onPressed: () {
            AwesomeDialog(
              context: context,
              width: 580,
              dialogType: DialogType.noHeader,
              animType: AnimType.rightSlide,
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  const Text(
                    'Modifier la quantité',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.product.libelle}',
                              style: const TextStyle(fontSize: 26),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: SpinBox(
                      min: 1,
                      max: 100,
                      value: widget.product.quantite!.split('.')[0] == '0'
                          ? 1
                          : double.tryParse(widget.product.quantite!)!,
                      onChanged: (value) => quantity = value.toStringAsFixed(0),
                    ),
                  ),
                ]),
              ),
              btnCancelText: 'Annuler',
              btnOkText: 'Modifier',
              btnOkColor: Colors.blue,
              btnCancelColor: Colors.red,
              btnOkOnPress: () {
                orderProvider.updateDetTicket(widget.product, quantity);
              },
              btnCancelOnPress: () {},
            ).show();
          },
          icon: const Icon(Icons.mode_edit_outline))
    ]);
  }
}
