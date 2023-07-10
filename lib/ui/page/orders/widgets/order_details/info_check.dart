import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/client.dart';
import '../../../../../data/model/product_order.dart';
import '../../../../../state/order_provider.dart';

class OrderBody extends StatefulWidget {
  final VoidCallback goToNextStep;
  final Client? client;
  final bool isSale;
  final int? modeLiv;
  final int? modePrep;

  const OrderBody({
    super.key,
    required this.goToNextStep,
    this.client,
    required this.isSale,
    this.modeLiv,
    this.modePrep,
  });

  @override
  State<OrderBody> createState() => _OrderBodyState();
}

class _OrderBodyState extends State<OrderBody> {
  late OrderProvider orderProvider;

  @override
  void initState() {
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vérification des informations du ticket',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              if (widget.client == null)
                const Text('Client Passager')
              else
                Text('${widget.client!.firstName} ${widget.client!.lastName}'),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: orderProvider.ticket!.products!
                    .map((json) => ProductOrder.fromJson(json))
                    .toList()
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  ProductOrder product = orderProvider.ticket!.products!
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
            ],
          ),
          Column(
            children: [
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
                      '${orderProvider.ticket!.total} DZD',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              widget.isSale
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              orderProvider.addOrder(
                                  0, widget.modePrep, widget.modeLiv);
                              widget.goToNextStep();
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blueGrey)),
                            child: const Text('Vente'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              orderProvider.addOrder(
                                  3, widget.modePrep, widget.modeLiv);
                              widget.goToNextStep();
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blueGrey)),
                            child: const Text('Précommande'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              orderProvider.addOrder(
                                  2, widget.modePrep, widget.modeLiv);
                              widget.goToNextStep();
                            },
                            child: const Text('Commande'),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
