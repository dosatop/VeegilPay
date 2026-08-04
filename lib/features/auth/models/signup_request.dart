class SignupRequest {
  final String phoneNumber;
  final String password;

  SignupRequest({
    required this.phoneNumber,
    required this.password,
  });


  Map<String, dynamic> toJson() {
    return {
      "phoneNumber": phoneNumber,
      "password": password,
    };
  }
}