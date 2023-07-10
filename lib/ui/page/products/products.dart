import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/product.dart';
import '../../../state/product_provider.dart';
import 'product_detail.dart';
import 'widgets/filters.dart';
import 'widgets/gridview.dart';
import 'widgets/listview.dart';
import 'widgets/searchbar.dart';

class Products extends StatefulWidget {
  const Products({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool _switchView = true;
  int currentPage = 1;
  bool selectedProduct = false;
  late Product currentProduct;

  void _callback(bool i) {
    setState(() => selectedProduct = i);
  }

  void _currentProduct(Product product) {
    setState(() => currentProduct = product);
  }

  late ProductProvider productProvider;
  final _searchController = TextEditingController();

  @override
  void initState() {
    print('INIT!');
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts(currentPage,
        searchQuery: _searchController.text);
    productProvider.getCategories();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      selectedProduct
          ? ProductDetail(
              product: currentProduct,
              callback: _callback,
            )
          : Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      //Search
                      Expanded(
                        child: searchField(_searchController, productProvider,
                            Colors.grey[100]),
                      ),
                      const Filters(),
                    ]),
                    Container(
                      height: 452,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
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
                                  'Produits',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: ToggleButtons(
                                      isSelected: [_switchView, !_switchView],
                                      borderColor: Colors.blue,
                                      borderRadius: BorderRadius.circular(4),
                                      onPressed: (int index) {
                                        setState(() {
                                          _switchView = index == 0;
                                        });
                                      },
                                      children: const [
                                        Icon(Icons.view_list_rounded),
                                        Icon(Icons.dashboard),
                                      ]),
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
                                                  productProvider.fetchProducts(
                                                      currentPage,
                                                      searchQuery:
                                                          _searchController
                                                              .text);
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
                                                  productProvider.fetchProducts(
                                                      currentPage,
                                                      searchQuery:
                                                          _searchController
                                                              .text);
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
                            child: SingleChildScrollView(
                              child: _switchView
                                  ? ListProducts(
                                      callback: _callback,
                                      productPage: _currentProduct,
                                    )
                                  : GridProducts(
                                      callback: _callback,
                                      productPage: _currentProduct,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    ]);
  }
}
