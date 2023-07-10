class Productoutofstock {
  final int id;
  final String? categorie;
  final String? unitVente;
  final String? codeBarre;
  final int? typeCodeBarre;
  final String? libelle;
  final String? prixVente;
  final String? imageUrl;

  // Add other properties as needed

  Productoutofstock(
      {required this.id,
      this.categorie,
      this.unitVente,
      this.codeBarre,
      this.typeCodeBarre,
      this.libelle,
      this.prixVente,
      this.imageUrl
      });

  factory Productoutofstock.fromJson(Map<String, dynamic> json) {
    return Productoutofstock(
      id: json['ID_ROWID'],
      categorie: json['categorie']['CCTLIBCOUR'],
      unitVente: json['unit_vente'],
      codeBarre: json['CPRCODEBARRE'],
      typeCodeBarre: json['CPRTYPECODEBARRE'],
      libelle: json['CPRLIBELLE'],
      prixVente: json['CPRPRIX'],
      imageUrl: json['CPRIMGPR'],
    );
  }
}
