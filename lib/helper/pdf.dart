import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../data/model/order.dart';
import '../data/model/product_order.dart';

Future<Uint8List> makePdf(Order order) async {
  final font = await PdfGoogleFonts.openSansBold();
  final pdf = Document();

  pdf.addPage(
    Page(
      pageFormat: PdfPageFormat.roll80,
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              child: Text(
                'FamilyPrice',
                style: TextStyle(font: font, fontSize: 22),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(20),
            ),
            SizedBox(height: 50),
            Text(
              '${_getType(order.type!)} ${order.id}',
              style: TextStyle(font: font),
            ),
            Text(
              '${order.dateOpr!.substring(0, 9)}  ${order.dateOpr!.substring(11, 19)}',
              style: TextStyle(font: font),
            ),
            SizedBox(height: 20),
            if (order.client == null)
              Text(
                "Client Passager",
                style: TextStyle(font: font),
              )
            else
              Text(
                '${order.client}',
                style: TextStyle(font: font),
              ),
            if (order.adresseLiv != null)
              Text(
                '${order.adresseLiv}',
                style: TextStyle(font: font),
              ),
            SizedBox(height: 50),
            paddedText('Produits :', font),
            ...order.products!
                .map((json) => ProductOrder.fromJson(json))
                .toList()
                .map(
                  (product) => Row(
                    children: [
                      paddedText('${product.quantite!.split('.')[0]}x', font),
                      Container(
                        width: 120,
                        child: paddedText(product.libelle!, font),
                      ),
                      paddedText('${product.prix!.split('.')[0]} DZD', font),
                    ],
                  ),
                ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                paddedText("Total: ", font),
                paddedText('${order.total!.split('.')[0]} DZD', font),
              ],
            ),
            SizedBox(height: 50),
            paddedText(
                "Veuillez garder ce reçu en cas de réclamation ou retour",
                font),
            Divider(borderStyle: BorderStyle.dashed),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'DATAMASTER 2023',
                  style: TextStyle(
                    font: font,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
  return pdf.save();
}

Widget paddedText(
  final String text,
  final Font font, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(font: font),
        maxLines: 2,
        overflow: TextOverflow.clip,
      ),
    );

String _getType(int type) {
  switch (type) {
    case 0:
      return 'Ticket';
    case 2:
      return 'Commande';
    case 3:
      return 'Précommande';
    default:
      return 'Commande';
  }
}
