import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';

class AuthLifecycleObserver extends WidgetsBindingObserver {
  final WidgetRef ref;
  final GoRouter router;

  AuthLifecycleObserver(this.ref, this.router);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAuth();
    }
  }

  Future<void> _checkAuth() async {
    final success = await ref.read(authProvider.notifier).refreshUser();

    if (!success) {
      router.go('/login');
    }
  }
}
