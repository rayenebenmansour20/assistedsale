class DetHist {
  final int? id;
  String? libelle;
  int? motif;
  String? dcre;
  String? dmaj;

  DetHist({
    this.id,
    this.libelle,
    this.motif,
    this.dcre,
    this.dmaj,
  });

  factory DetHist.fromJson(Map<String, dynamic> json) {
    return DetHist(
      id: json['CHETTICKETID'] ?? 0,
      libelle: json['libelle_produit'],
      motif: json['CHDTMOTIF'],
      dcre: json['DCRE'],
      dmaj: json['DMAJ'],
    );
  }
}
