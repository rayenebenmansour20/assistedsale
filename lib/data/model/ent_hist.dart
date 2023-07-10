class EntHist {
  final int? id;
  int? type;
  int? state;
  String? dcre;
  String? dmaj;

  EntHist({
    this.id,
    this.type,
    this.state,
    this.dcre,
    this.dmaj,
  });

  factory EntHist.fromJson(Map<String, dynamic> json) {
    return EntHist(
      id: json['CHETTICKETID'] ?? 0,
      type: json['CHETTYPTCK'],
      state: json['CHETETAT'],
      dcre: json['DCRE'],
      dmaj: json['DMAJ'],
    );
  }
}
