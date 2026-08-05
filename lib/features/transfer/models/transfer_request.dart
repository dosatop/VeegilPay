class TransferRequest {
  final String phoneNumber;
  final int amount;

  TransferRequest({required this.phoneNumber, required this.amount});

  Map<String, dynamic> toJson() {
    return {"phoneNumber": phoneNumber, "amount": amount};
  }
}
