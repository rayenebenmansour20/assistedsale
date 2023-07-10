import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/product_provider.dart';

class OutOfStock extends StatefulWidget {
  const OutOfStock({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<OutOfStock> createState() => _OutOfStockState();
}

class _OutOfStockState extends State<OutOfStock> {
  int currentPage = 1;

  late ProductProvider productProvider;
  final _searchController = TextEditingController();

  @override
  void initState() {
    print('INIT!');
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProductsoutofstock(
      currentPage,
    );
    productProvider.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Produits en rupture',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                //Pagination
                Consumer<ProductProvider>(
                  builder: (context, provider, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: currentPage == 1
                            ? null
                            : () {
                                setState(() {
                                  currentPage--;
                                  productProvider.fetchProducts(currentPage,
                                      searchQuery: _searchController.text);
                                });
                              },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: currentPage == 1
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.black,
                        ),
                      ),
                      Text(
                        '$currentPage / ${provider.count}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: currentPage == provider.count
                            ? null
                            : () {
                                setState(() {
                                  currentPage++;
                                  productProvider.fetchProducts(currentPage,
                                      searchQuery: _searchController.text);
                                });
                              },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: currentPage == provider.count
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) => ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: provider.outstock.length,
                itemBuilder: (context, index) {
                  final product = provider.outstock[index];
                  return Card(
                    color: Colors.grey[100],
                    child: ListTile(
                      // 4
                      leading: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/datamasterlogo.png',
                          image: product.imageUrl ??
                              'assets/images/datamasterlogo.png'),
                      title: Text('${product.libelle}'),
                      subtitle: Text('${product.categorie}'),
                      trailing: Text('${product.prixVente!.split('.')[0]} DZD'),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
