import 'package:flutter/material.dart';
import '../../../../state/product_provider.dart';

Widget searchField(TextEditingController textController,
    ProductProvider provider, Color? color) {
  return Container(
    height: 56,
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: TextField(
      controller: textController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        hintText: 'Rechercher vos produits..',
        fillColor: color,
        filled: true,
        focusColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        suffixIcon: IconButton(
          onPressed: () {
            provider.fetchProducts(1, searchQuery: textController.text);
          },
          icon: const Icon(Icons.search),
        ),
      ),
    ),
  );
}
