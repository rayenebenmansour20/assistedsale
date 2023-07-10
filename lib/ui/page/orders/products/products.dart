import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../state/order_provider.dart';
import '../../../../state/product_provider.dart';
import '../../products/widgets/filters.dart';
import '../../products/widgets/searchbar.dart';

class ProductsOrders extends StatefulWidget {
  final int? ticket;

  const ProductsOrders({super.key, this.ticket});

  @override
  State<ProductsOrders> createState() => _ProductsOrdersState();
}

class _ProductsOrdersState extends State<ProductsOrders> {
  late ProductProvider productProvider;
  late OrderProvider orderProvider;
  final _searchController = TextEditingController();

  @override
  void initState() {
    print('INIT!');
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    productProvider.fetchProducts(1, searchQuery: _searchController.text);
    productProvider.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: searchField(
                    _searchController, productProvider, Colors.white),
              ),
              const Filters(),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<ProductProvider>(
                builder: (context, provider, child) => ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    String? quantity = '1';
                    return Card(
                      child: ListTile(
                        leading: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/datamasterlogo.png',
                            image: product.imageUrl ??
                                'assets/images/datamasterlogo.png'),
                        title: Text('${product.libelle}'),
                        subtitle: Text('${product.categorie}'),
                        trailing:
                            Text('${product.prixVente.split('.')[0]} DZD'),
                        onTap: () {
                          orderProvider.ticket == null
                              ? Fluttertoast.showToast(
                                  msg: "Veuillez sélectionner un ticket",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0)
                              : AwesomeDialog(
                                  context: context,
                                  width: 580,
                                  dialogType: DialogType.info,
                                  customHeader: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/datamasterlogo.png',
                                    image: product.imageUrl ??
                                        'assets/images/datamasterlogo.png',
                                    height: 320,
                                    width: double.infinity,
                                  ),
                                  animType: AnimType.rightSlide,
                                  body: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${product.libelle}',
                                                  style: const TextStyle(
                                                      fontSize: 26),
                                                ),
                                                Text('${product.categorie}'),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '${product.prixVente.split('.')[0]} DZD',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 16),
                                        child: SpinBox(
                                          min: 1,
                                          max: 100,
                                          value: 1,
                                          onChanged: (value) =>
                                              quantity = value.toString(),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  btnCancelText: 'Annuler',
                                  btnOkText: 'Ajouter',
                                  btnOkColor: Colors.blue,
                                  btnCancelColor: Colors.red,
                                  btnOkOnPress: () {
                                    orderProvider.addDetTicket(
                                        product.id,
                                        widget.ticket!,
                                        product.prixVente,
                                        quantity);
                                    orderProvider.getTickets();
                                  },
                                  btnCancelOnPress: () {},
                                ).show();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
