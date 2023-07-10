import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../state/client_provider.dart';
import '../../../../../state/order_provider.dart';

class ConfirmOrder extends StatefulWidget {
  final int? modeLiv;
  final int? modePrep;
  final Function(int) ticketCallback;

  const ConfirmOrder(
      {super.key, this.modeLiv, this.modePrep, required this.ticketCallback});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  late ClientProvider clientProvider;

  @override
  void initState() {
    clientProvider = Provider.of<ClientProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) => Container(
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: provider.orderLoading
                  ? const CircularProgressIndicator()
                  : provider.orderSuccess
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Votre commande a été effectuée avec succès',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.download),
                              label: const Text('Bon de commande'),
                            ),
                          ],
                        )
                      : const Text(
                          'Votre commande n\'a pas été effectuée. Veuillez réessayer',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                          ),
                        ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.orderSuccess
                          ? {
                              provider.resetOrderState(),
                              widget.ticketCallback(0),
                              Navigator.pop(context)
                            }
                          : Navigator.pop(context);
                    },
                    child: const Text('Terminer'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
