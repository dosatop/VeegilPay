class WithdrawRequest {
  final String phoneNumber;
  final int amount;

  WithdrawRequest({required this.phoneNumber, required this.amount});

  Map<String, dynamic> toJson() {
    return {"phoneNumber": phoneNumber, "amount": amount};
  }
}
