import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';

class MainNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigation({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,

        onTap: (index) {
          navigationShell.goBranch(
            index,

            initialLocation: index == navigationShell.currentIndex,
          );
        },

        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: "Transactions",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.home),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
