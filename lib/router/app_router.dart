import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/features/auth/presentation/pages/log_in_or_sign_up.dart';
import 'package:veegil_pay/features/auth/presentation/pages/login_page.dart';
import 'package:veegil_pay/features/auth/presentation/pages/sign_up_page.dart';
import 'package:veegil_pay/features/auth/presentation/pages/splash_screen.dart';
import 'package:veegil_pay/features/dashboard/presentation/dashboard_page.dart';
import 'package:veegil_pay/features/deposit/presentation/deposit_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),

    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) {
        return const SignUpPage();
      },
    ),

    GoRoute(
      path: '/loginOrSignup',
      name: 'loginOrSignup',
      builder: (context, state) {
        return const LogInOrSignUp();
      },
    ),

    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) {
        return const DashboardPage();
      },
    ),
    GoRoute(
      path: '/deposit',
      name: 'deposit',
      builder: (context, state) {
        return const DepositPage();
      },
    ),
  ],

  errorBuilder: (context, state) {
    return Scaffold(body: Center(child: Text('Page not found: ${state.uri}')));
  },
);
