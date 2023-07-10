import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../state/product_provider.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int? selectedCategory;
  final priceController = TextEditingController();

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 30,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Consumer<ProductProvider>(
                    builder: (context, provider, child) => Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownMenu(
                            initialSelection: selectedCategory,
                            dropdownMenuEntries: provider.categories,
                            label: const Text('Catégorie'),
                            onSelected: (int? category) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                          TextField(
                            controller: priceController,
                            decoration: const InputDecoration(hintText: 'Prix'),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  child: const Text('Trier'),
                                  onPressed: () {
                                    provider.fetchProducts(1,
                                        categoryFilter: selectedCategory,
                                        priceFilter: priceController.text);
                                    Navigator.pop(context);
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text('Reset'),
                                  onPressed: () {
                                    provider.fetchProducts(1);
                                    Navigator.pop(context);
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  child: const Text(
                                    'Annuler',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: const Text(
            'Filtrer',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
