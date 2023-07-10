class Payment {
  int? id;
  String? paid;
  String? toBePaid;
  int? type;
  int? state;
  int? ticket;

  Payment({
    this.id,
    this.paid,
    this.toBePaid,
    this.type,
    this.state,
    this.ticket,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['ID_ROWID'] ?? 0,
      paid: json['CVTMVERS'],
      toBePaid: json['CVTMAVERS'],
      type: json['CVTTYPE'],
      state: json['CVTETAT'],
      ticket: json['CVTTCKID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'CVTMVERS': paid,
        'CVTMAVERS': toBePaid,
        'CVTTYPE': type,
        'CVTETAT': state,
        'CVTTCKID': ticket,
      };
}
