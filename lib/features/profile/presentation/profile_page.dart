import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/features/dashboard/provider/dashboard_provider.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final formatter = NumberFormat("#,###");

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                user?.phoneNumber ?? "User",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),

            const SizedBox(height: 30),

            _profileCard(
              icon: Icons.account_balance_wallet_outlined,
              title: "Account Number",
              value: user?.phoneNumber ?? "-",
            ),

            _profileCard(
              icon: Icons.account_balance_outlined,
              title: "Balance",
              value: "₦${formatter.format(user?.balance ?? 0)}.00",
            ),

            const SizedBox(height: 20),

            Text(
              "Settings",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            _menuTile(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () {},
            ),

            _menuTile(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () {},
            ),

            _menuTile(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () {},
            ),

            _menuTile(
              icon: Icons.logout,
              title: "Logout",
              color: Colors.red,
              onTap: () async {
                await ref.read(authProvider.notifier).logout();

                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.grey)),

              const SizedBox(height: 5),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      onTap: onTap,

      leading: Icon(icon, color: color ?? AppColors.primary),

      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColors.black,
          fontWeight: FontWeight.w500,
        ),
      ),

      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

      contentPadding: EdgeInsets.zero,
    );
  }
}
