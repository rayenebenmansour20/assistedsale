import 'package:flutter/material.dart';
import '../../../../data/model/product.dart';
import '../../../../helper/routes.dart';
import '../product_detail.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  final Function(bool) callback;
  final Function(Product) productPage;

  const ProductItemCard(
      {super.key,
      required this.product,
      required this.callback,
      required this.productPage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback(true);
        productPage(product);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16 / 2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/datamasterlogo.png',
                  image:
                      product.imageUrl ?? 'assets/images/datamasterlogo.png'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.libelle}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${product.categorie}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  '${product.prixVente!.split('.')[0]} DZD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
