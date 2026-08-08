import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:veegil_pay/features/auth/models/login_info.dart';
import '../constants/storage_keys.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageKeys.authToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: StorageKeys.authToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: StorageKeys.authToken);
  }

  Future<void> saveAccountNumber(String phone) async {
    await _storage.write(key: StorageKeys.userPhone, value: phone);
  }

  Future<String?> getAccountNumber() async {
    return await _storage.read(key: StorageKeys.userPhone);
  }

  Future<void> saveLoginInfo(LoginInfo loginInfo) async {
    await _storage.write(
      key: "login_info",
      value: jsonEncode(loginInfo.toJson()),
    );
  }

  Future<LoginInfo?> getLoginInfo() async {
    final data = await _storage.read(key: "login_info");

    if (data == null) return null;

    return LoginInfo.fromJson(jsonDecode(data));
  }

  Future<void> clearLoginInfo() async {
    await _storage.delete(key: "login_info");
  }

  Future<void> clear() async {
    final balanceVisibility = await getBalanceVisibility();

    await _storage.deleteAll();

    if (balanceVisibility != null) {
      await saveBalanceVisibility(balanceVisibility);
    }
  }

  Future<void> saveBalanceVisibility(bool value) async {
    await _storage.write(key: "balance_visibility", value: value.toString());
  }

  Future<bool?> getBalanceVisibility() async {
    final value = await _storage.read(key: "balance_visibility");

    if (value == null) return null;

    return value == "true";
  }

  Future saveOnboardingSeen() async {
    await _storage.write(key: "hasSeenOnboarding", value: "true");

     await _storage.read(key: "hasSeenOnboarding");

  }

  Future<bool> hasSeenOnboarding() async {
    final value = await _storage.read(key: "hasSeenOnboarding");

    return value == "true";
  }
}
