class Product {
  final int id;
  final String? categorie;
  final double? stock;
  final String? unitVente;
  final String? codeBarre;
  final int? typeCodeBarre;
  final String? libelle;
  final String? prixVente;
  final String? imageUrl;
  final String? qt;
  final String? minstock;

  Product({
    required this.id,
    this.categorie,
    this.stock,
    this.unitVente,
    this.codeBarre,
    this.typeCodeBarre,
    this.libelle,
    this.prixVente,
    this.imageUrl,
    this.qt,
    this.minstock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ID_ROWID'],
      categorie: json['categorie']['CCTLIBCOUR'],
      unitVente: json['unit_vente'],
      stock: json['stock'],
      codeBarre: json['CPRCODEBARRE'],
      typeCodeBarre: json['CPRTYPECODEBARRE'],
      libelle: json['CPRLIBELLE'],
      prixVente: json['CPRPRIX'],
      imageUrl: json['CPRIMGPR'],
      qt: json['CPRQTEINIT'],
      minstock: json['CPRMINSTOCK'],
    );
  }
}
