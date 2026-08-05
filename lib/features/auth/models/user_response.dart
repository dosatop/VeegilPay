import 'user_model.dart';

class UserResponse {
  final UserModel user;

  UserResponse({
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return UserResponse(
      user: UserModel.fromJson(data),
    );
  }
}