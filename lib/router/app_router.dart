import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:veegil_pay/features/auth/presentation/pages/log_in_or_sign_up.dart';
import 'package:veegil_pay/features/auth/presentation/pages/login_page.dart';
import 'package:veegil_pay/features/auth/presentation/pages/sign_up_page.dart';
import 'package:veegil_pay/features/auth/presentation/pages/splash_screen.dart';
import 'package:veegil_pay/features/bills/presentation/bills_page.dart';

import 'package:veegil_pay/features/dashboard/presentation/dashboard_page.dart';
import 'package:veegil_pay/features/deposit/presentation/deposit_page.dart';
import 'package:veegil_pay/features/navigation/main_navigation.dart';
import 'package:veegil_pay/features/profile/presentation/profile_page.dart';
import 'package:veegil_pay/features/transaction/presentation/transaction_page.dart';
import 'package:veegil_pay/features/transfer/presentation/transfer_page.dart';
import 'package:veegil_pay/features/withdraw/presentation/withdraw_page.dart';

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

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigation(navigationShell: navigationShell);
      },

      branches: [
        // HOME
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',

              builder: (context, state) {
                return const DashboardPage();
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transactions',
              name: 'transactions',

              builder: (context, state) {
                return const TransactionHistoryPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) {
                return const ProfilePage();
              },
            ),
          ],
        ),
     
      ],
    ),

    GoRoute(
      path: '/deposit',
      name: 'deposit',
      builder: (context, state) {
        return const DepositPage();
      },
    ),

    GoRoute(
      path: '/withdraw',
      name: 'withdraw',
      builder: (context, state) {
        return const WithdrawPage();
      },
    ),
    GoRoute(
      path: '/bills',
      name: 'bills',
      builder: (context, state) {
        return const BillsPage();
      },
    ),

    GoRoute(
      path: '/transfer',
      name: 'transfer',
      builder: (context, state) {
        return const TransferPage();
      },
    ),
  ],

  errorBuilder: (context, state) {
    return Scaffold(body: Center(child: Text('Page not found: ${state.uri}')));
  },
);
