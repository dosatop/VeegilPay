class LoginInfo {
  final String phoneNumber;

  LoginInfo({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {"phoneNumber": phoneNumber};
  }

  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(phoneNumber: json["phoneNumber"]);
  }
}
