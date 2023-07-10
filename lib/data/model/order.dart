class Order {
  final int? id;
  String? user;
  List<dynamic>? products;
  int? type;
  int? state;
  String? total;
  int? client;
  String? dateOpr;
  String? datePreparation;
  String? dateFinPreparation;
  String? dateRecup;
  String? heureRecup;
  int? modeLiv;
  String? adresseLiv;

  Order({
    this.id,
    this.products,
    this.user,
    this.type,
    this.state,
    this.total,
    this.client,
    this.dateOpr,
    this.datePreparation,
    this.dateFinPreparation,
    this.dateRecup,
    this.heureRecup,
    this.modeLiv,
    this.adresseLiv,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['ID_ROWID'] ?? 0,
      user: json['utilisateur'] ?? '',
      products: json['detail'],
      type: json['CETTYPTCK'],
      state: json['CETETAT'],
      total: json['CETMTOPR'] ?? '0',
      client: json['CETCLIENTID'],
      dateOpr: json['CETDATOPR'],
      datePreparation: json['CETHRDEBPREP'],
      dateFinPreparation: json['CETHRFINPREP'],
      dateRecup: json['CETDATERECUP'],
      heureRecup: json['CETHEURERECUP'],
      modeLiv: json['CETMODELIV'],
      adresseLiv: json['CETADRESSLIV'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_ROWID': id,
        'utilisateur': user,
        'CETTYPTCK': type,
        'CETETAT': state,
        'CETMTOPR': total,
        'CETCLIENTID': client,
        'CETHRDEBPREP': datePreparation,
        'CETHRFINPREP': dateFinPreparation,
        'CETDATERECUP': dateRecup,
        'CETHEURERECUP': heureRecup,
        'CETMODELIV': modeLiv,
        'CETADRESSLIV': adresseLiv,
      };
}
