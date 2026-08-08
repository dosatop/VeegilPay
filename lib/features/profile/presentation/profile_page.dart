import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/confirmation_dialog.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';
import 'package:veegil_pay/features/profile/presentation/overlay_providerd.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              ListTile(
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => const ConfirmationDialog(
                      title: 'Log out?',
                      message:
                          'Are you sure you want to log out of your account?',
                      confirmText: 'Log out',
                      confirmColor: Colors.red,
                    ),
                  );

               
                  if (confirmed != true) return;

                                  await ref.read(authProvider.notifier).logout();

                  if (!context.mounted) return;

                  ref.read(overlayMessageProvider.notifier).state =
                      "Logout Successful";

                  context.go('/loginOrSignup');
                },

                leading: const Icon(Icons.logout, color: Colors.red),

                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),

                contentPadding: const EdgeInsets.only(left: 5),
              ),
            ],
          ),
        ),
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
