class DepositRequest {
  final String phoneNumber;
  final int amount;

  DepositRequest({
    required this.phoneNumber,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      "phoneNumber": phoneNumber,
      "amount": amount,
    };
  }
}