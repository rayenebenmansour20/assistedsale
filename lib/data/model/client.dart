class Client {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? mobileNumber;
  String? address;
  int? postalCode;
  String? city;
  String? countryIndicator;
  String? identCard;
  bool indic;
  int type;

  Client({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.mobileNumber,
    this.address,
    this.postalCode,
    this.city,
    this.countryIndicator,
    required this.indic,
    required this.type,
    this.identCard,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['ID_ROWID'] ?? 0,
      firstName: json['CEFPRENOM'] ?? '',
      lastName: json['CEFNOM'] ?? '',
      email: json['CEFEMAIL'] ?? '',
      phoneNumber: json['CEFTELFIX'] ?? '',
      mobileNumber: json['CEFTELMOB'],
      address: json['CEFADRESSE'],
      postalCode: json['CEFPOSTAL'],
      city: json['CEFVILLE'],
      countryIndicator: json['CEFINDICPAYS'],
      indic: json['CEFINDFID'],
      type: json['CEFETTARIFID'],
      identCard: json['CEFIDCARTE'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_ROWID': id,
        'CEFPRENOM': firstName,
        'CEFNOM': lastName,
        'CEFEMAIL': email,
        'CEFTELFIX': phoneNumber,
        'CEFTELMOB': mobileNumber,
        'CEFADRESSE': address,
        'CEFPOSTAL': postalCode,
        'CEFVILLE': city,
        'CEFINDICPAYS': countryIndicator,
        'CEFINDFID': indic,
        'CEFETTARIFID': type,
        'CEFIDCARTE': identCard,
      };
}
