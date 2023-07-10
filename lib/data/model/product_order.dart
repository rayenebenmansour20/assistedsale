class ProductOrder {
  final int? id;
  final int product;
  final int? order;
  final String? libelle;
  String? quantite;
  final String? poids;
  final String? prix;

  ProductOrder({
    this.id,
    required this.product,
    required this.order,
    this.libelle,
    this.quantite,
    this.prix,
    this.poids,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      id: json['ID_ROWID'] ?? 0,
      product: json['CDTPRDCID'],
      order: json['CDTENTTICKID'],
      libelle: json['libelle'] ?? '',
      quantite: json['CDTQTE'],
      poids: json['CDTPDS'],
      prix: json['CDTPRIXTTC'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_ROWID': id,
        'CDTPRDCID': product,
        'CDTENTTICKID': order,
        'CDTQTE': quantite,
        'CDTPDS': poids,
        'CDTPRIXTTC': prix,
      };
}
