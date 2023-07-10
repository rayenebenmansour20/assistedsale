import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/product.dart';
import '../../../../state/product_provider.dart';

class ListProducts extends StatelessWidget {
  final Function(bool) callback;
  final Function(Product) productPage;

  const ListProducts(
      {super.key, required this.callback, required this.productPage});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: provider.products.length,
        itemBuilder: (context, index) {
          final product = provider.products[index];
          return Card(
            child: ListTile(
              // 4
              leading: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/datamasterlogo.png',
                  image:
                      product.imageUrl ?? 'assets/images/datamasterlogo.png'),
              title: Text('${product.libelle}'),
              subtitle: Text('${product.categorie}'),
              trailing: Text('${product.prixVente!.split('.')[0]} DZD'),
              onTap: () {
                callback(true);
                productPage(product);
              },
            ),
          );
        },
      ),
    );
  }
}
