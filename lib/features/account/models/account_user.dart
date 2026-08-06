class AccountUser {
  final String phoneNumber;
  final String created;

  AccountUser({required this.phoneNumber, required this.created});

  factory AccountUser.fromJson(Map<String, dynamic> json) {
    return AccountUser(
      phoneNumber: json['phoneNumber'] ?? '',
      created: json['created'] ?? '',
    );
  }
}
