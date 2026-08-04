import 'package:flutter/material.dart';
import 'package:veegil_pay/core/theme/app_theme.dart';
import 'router/app_router.dart';

class VeegilPayApp extends StatelessWidget {
  const VeegilPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
    );
  }
}