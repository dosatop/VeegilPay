import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veegil_pay/core/storage/secure_storage_service.dart';
import 'package:veegil_pay/features/auth/provider/saved_login_provider.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final storage = SecureStorageService();

  final hasSeenOnboarding = await storage.hasSeenOnboarding();

  final container = ProviderContainer();

  await container.read(savedLoginProvider.notifier).loadSavedLogin();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: VeegilPayApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
}
