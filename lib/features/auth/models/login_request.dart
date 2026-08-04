class LogInRequest {
  final String phoneNumber;
  final String password;

  LogInRequest({
    required this.phoneNumber,
    required this.password,
  });


  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }
}