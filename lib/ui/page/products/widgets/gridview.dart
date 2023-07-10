import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/product.dart';
import '../../../../helper/responsive.dart';
import '../../../../state/product_provider.dart';
import 'product_card.dart';

class GridProducts extends StatelessWidget {
  final Function(bool) callback;
  final Function(Product) productPage;
  const GridProducts(
      {super.key, required this.callback, required this.productPage});
  @override
  Widget build(BuildContext context) {
    // 1
    return Consumer<ProductProvider>(
      builder: (context, provider, child) => GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: provider.products.length,
        itemBuilder: (context, index) {
          final product = provider.products[index];
          return ProductItemCard(
            product: product,
            callback: callback,
            productPage: productPage,
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
      ),
    );
  }
}

int _getCrossAxisCount(BuildContext context) {
  if (isLargeScreen(context)) {
    return 4; // 4 columns for larger screens
  } else if (isMediumScreen(context)) {
    return 3; // 3 columns for medium-sized screens
  } else {
    return 2; // 2 columns for smaller screens
  }
}
