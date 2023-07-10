import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/product_provider.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  int currentPage = 1;
  late ProductProvider productProvider;

  @override
  void initState() {
    print('INIT!');
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.getStock(currentPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: 540,
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
                      'Stock de produits',
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
                                      productProvider.getStock(
                                        currentPage,
                                      );
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
                                      productProvider.getStock(
                                        currentPage,
                                      );
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
                  child: Consumer<ProductProvider>(
                    builder: (context, provider, child) => ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: provider.stock.length,
                      itemBuilder: (context, index) {
                        final product = provider.stock[index];
                        return Card(
                          child: ListTile(
                            title: Text('${product.libelle}'),
                            subtitle: Text('${product.categorie}'),
                            trailing: Text(
                                '${product.minstock!.split('.')[0]}/${product.qt!.split('.')[0]}'),
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
