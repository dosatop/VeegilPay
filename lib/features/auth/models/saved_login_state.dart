class SavedLoginState {
  final String? phoneNumber;
  final bool isLoading;

  const SavedLoginState({this.phoneNumber, this.isLoading = true});

  SavedLoginState copyWith({String? phoneNumber, bool? isLoading}) {
    return SavedLoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
