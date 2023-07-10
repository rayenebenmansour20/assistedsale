import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../data/model/order.dart';
import 'pdf.dart';

class Receipt extends StatelessWidget {
  final Order? order;
  final Function(bool) selectedTicket;

  const Receipt({super.key, required this.order, required this.selectedTicket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            selectedTicket(false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: PdfPreview(
        build: (context) => makePdf(order!),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
      ),
    );
  }
}
