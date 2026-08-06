class DirectoryUser {
  final String phoneNumber;

  final String created;

  DirectoryUser({required this.phoneNumber, required this.created});

  factory DirectoryUser.fromJson(Map<String, dynamic> json) {
    return DirectoryUser(
      phoneNumber: json['phoneNumber'] ?? '',
      created: json['created'] ?? '',
    );
  }
}
