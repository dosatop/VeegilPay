class LoginInfo {
  final String phoneNumber;
  final String password;
  final bool rememberMe;

  LoginInfo({
    required this.phoneNumber,
    required this.password,
    required this.rememberMe,
  });

  Map<String, dynamic> toJson() {
    return {
      "phoneNumber": phoneNumber,
      "password": password,
      "rememberMe": rememberMe,
    };
  }

  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(
      phoneNumber: json["phoneNumber"],
      password: json["password"],
      rememberMe: json["rememberMe"],
    );
  }
}