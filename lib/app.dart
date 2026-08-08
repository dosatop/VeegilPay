import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veegil_pay/core/theme/app_theme.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';
import 'router/app_router.dart';

class VeegilPayApp extends ConsumerStatefulWidget {
  final bool hasSeenOnboarding;

  const VeegilPayApp({super.key, required this.hasSeenOnboarding});

  @override
  ConsumerState<VeegilPayApp> createState() => _VeegilPayAppState();
}

class _VeegilPayAppState extends ConsumerState<VeegilPayApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(authProvider.notifier).refreshUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter(widget.hasSeenOnboarding),
      theme: AppTheme.lightTheme,
    );
  }
}
