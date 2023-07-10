class ProductCategory {
  final int id;
  final int? nombreProduits;
  final String? libelle;
  final String? imageUrl;

  ProductCategory(
      {required this.id, this.nombreProduits, this.libelle, this.imageUrl});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['ID_ROWID'],
      nombreProduits: json['nombre_produits'],
      libelle: json['CCTLIBLONG'],
      imageUrl: json['CCTIMAGE'],
    );
  }
}
