class User {
  int? id;
  String? profilePicture;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  bool? isActive;
  String? type;

  User({
    this.id,
    this.profilePicture,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.type,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      profilePicture: json['MUTPHOTOS'],
      username: json['username'] ?? '',
      firstName: json['CEFPRENOM'] ?? '',
      lastName: json['CEFNOM'] ?? '',
      email: json['CEFEMAIL'] ?? '',
      type: json['MUTPROFID']['MPRLIBLONG'],
      isActive: json['is_active'],
    );
  }
}
