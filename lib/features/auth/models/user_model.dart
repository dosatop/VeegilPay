
class UserModel {
  final String phoneNumber;
  final double balance;
  final String created;

  UserModel({
    required this.phoneNumber,
    required this.balance,
    required this.created,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json['phoneNumber'],
      balance: (json['balance'] as num).toDouble(),
      created: json['created'],
    );
  }
}