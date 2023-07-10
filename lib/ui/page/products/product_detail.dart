import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../../../data/model/order.dart';
import '../../../data/model/product.dart';
import '../../../state/order_provider.dart';

class ProductDetail extends StatelessWidget {
  final Function(bool) callback;
  final Product product;

  const ProductDetail(
      {super.key, required this.callback, required this.product});

  @override
  Widget build(BuildContext context) {
    String quantity = '1';
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      callback(false);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    'Produits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _productImage(),
                    ),
                    Expanded(
                      child: _productDetail(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Expanded(
                        child: SpinBox(
                          min: 1,
                          max: 100,
                          value: 1,
                          onChanged: (value) => quantity = value.toString(),
                        ),
                      ),
                    ),
                    Text(
                      '${product.prixVente!.split('.')[0]} DZD',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      width: 580,
                      dialogType: DialogType.noHeader,
                      animType: AnimType.bottomSlide,
                      body: Consumer<OrderProvider>(
                        builder: (context, orderProvider, child) => Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      orderProvider.addEntTicket();
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Nouveau Ticket'),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              height: 400,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: orderProvider.orders.length,
                                itemBuilder: (context, index) {
                                  final Order order =
                                      orderProvider.orders[index];
                                  return ListTile(
                                    title: Text('Ticket ${order.id}'),
                                    onTap: () {
                                      orderProvider.addDetTicket(
                                          product.id,
                                          order.id,
                                          product.prixVente,
                                          quantity);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).show();
                  },
                  child: const Text(
                    'Ajouter à un ticket',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _productImage() {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/datamasterlogo.png',
      image: product.imageUrl ?? 'assets/images/datamasterlogo.png',
      height: 320,
      width: double.infinity,
    );
  }

  Widget _productDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            '${product.libelle}',
            style: const TextStyle(fontSize: 30),
          ),
        ),
        Text(
          '${product.categorie}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        BarcodeWidget(
          barcode: Barcode.ean13(),
          data: '${product.codeBarre}',
          height: 80,
          width: 220,
        ),
      ],
    );
  }
}
