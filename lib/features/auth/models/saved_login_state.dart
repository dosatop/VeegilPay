class SavedLoginState {
  final String? phoneNumber;

  const SavedLoginState({
    this.phoneNumber,
  });

  SavedLoginState copyWith({
    String? phoneNumber,
  }) {
    return SavedLoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}