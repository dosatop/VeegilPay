class ApiErrorHandler {
  static String getMessage(dynamic error) {
    // Dio API response errors
    if (error.response != null) {
      final data = error.response.data;

      if (data is Map<String, dynamic>) {
        final code = data["code"];

        switch (code) {
          // AUTH ERRORS
          case "INVALID_CREDENTIALS":
            return "Invalid account number or password";

          case "USER_NOT_FOUND":
          case "ACCOUNT_NOT_FOUND":
            return "Account not found";

          case "ACCOUNT_ALREADY_EXISTS":
            return "Account already exists";

          case "PHONE_NUMBER_ALREADY_EXISTS":
            return "Phone number already registered";

          case "INVALID_PHONE_NUMBER":
            return "Invalid phone number";

          case "INVALID_PASSWORD":
            return "Incorrect password";

          case "WEAK_PASSWORD":
            return "Password is too weak";

          // TRANSFER ERRORS
          case "RECIPIENT_NOT_FOUND":
            return "Recipient account not found";

          case "INSUFFICIENT_FUNDS":
            return "Insufficient balance";

          case "TRANSFER_TO_SELF":
            return "You cannot transfer money to yourself";

          // GENERAL ERRORS
          case "UNAUTHORIZED":
            return "Session expired, please login again";

          case "FORBIDDEN":
            return "You do not have permission to perform this action";

          case "VALIDATION_ERROR":
            return data["message"] ?? "Invalid information provided";

          case "PHONE_TAKEN":
            return "Phone number is already registered";

          case "PASSWORD_INVALID":
            return "Password must be at least 8 characters";

          case "AMOUNT_TOO_LARGE":
            return "Amount exceeds the allowed limit";

          case "AMOUNT_TOO_SMALL":
            return "Amount is below the minimum limit";

          default:
            return data["message"] ?? "Something went wrong";
        }
      }
    }

    // Connection errors
    if (error.message != null) {
      final message = error.message.toString();

      if (message.contains("SocketException")) {
        return "No internet connection";
      }

      if (message.contains("timeout")) {
        return "Request timeout, try again";
      }
    }

    return "Unable to complete request";
  }
}
