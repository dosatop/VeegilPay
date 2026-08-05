class TransactionModel {
  final String id;
  final String type;
  final int amount;
  final String phoneNumber;
  final String? counterparty;
  final int balance;
  final String? note;
  final DateTime created;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.phoneNumber,
    required this.counterparty,
    required this.balance,
    required this.note,
    required this.created,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',

      type: json['type'] ?? '',

      amount: (json['amount'] ?? 0).toInt(),

      phoneNumber: json['phoneNumber'] ?? '',

      counterparty: json['counterparty'],

      balance: (json['balance'] ?? 0).toInt(),

      note: json['note'],

      created: DateTime.parse(json['created']),
    );
  }
}
