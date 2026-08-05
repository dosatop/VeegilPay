import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/overlay_pill.dart';
import 'package:veegil_pay/features/dashboard/provider/dashboard_provider.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  bool showBalance = true;
  final formatter = NumberFormat("#,###");
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();

        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
          _lastBackPressed = now;

          showOverlayPill(context, "Press back again to exit");
        } else {
          SystemNavigator.pop();
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        user?.phoneNumber ?? "",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () => context.go("/profile"),
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.person, color: AppColors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // BALANCE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Available Balance",
                      style: TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          showBalance
                              ? "₦${formatter.format(user?.balance ?? 0)}.00"
                              : "******",

                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            setState(() {
                              showBalance = !showBalance;
                            });
                          },

                          icon: Icon(
                            showBalance
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: user?.phoneNumber ?? ""),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account number copied"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Account Number: ${user?.phoneNumber ?? ""}",
                            style: const TextStyle(color: Colors.white70),
                          ),

                          const SizedBox(width: 8),

                          const Icon(
                            Icons.copy,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Quick Actions",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    context,
                    Icons.send,
                    "Send",
                    () => context.push("/transfer"),
                  ),

                  _actionButton(
                    context,
                    Icons.add_circle,
                    "Fund",
                    () => context.push('/deposit'),
                  ),

                  _actionButton(
                    context,
                    Icons.payment,
                    "Bills",
                    () => context.push('/bills'),
                  ),

                  _actionButton(
                    context,
                    Icons.wallet,
                    "Withdraw",
                    () => context.push('/withdraw'),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      final shell = StatefulNavigationShell.of(context);
                      shell.goBranch(1);
                    },
                    child: const Text(
                      "See all",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _transactionPreview(
                      icon: Icons.arrow_upward,
                      title: "Transfer Out",
                      date: "Today",
                      amount: "-₦5,000",
                      color: Colors.red,
                    ),

                    const Divider(),

                    _transactionPreview(
                      icon: Icons.arrow_downward,
                      title: "Transfer In",
                      date: "Yesterday",
                      amount: "+₦25,000",
                      color: Colors.green,
                    ),

                    const Divider(),

                    _transactionPreview(
                      icon: Icons.account_balance_wallet,
                      title: "Deposit",
                      date: "Aug 4",
                      amount: "+₦50,000",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,

            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(height: 8),

          Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _transactionPreview({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required Color color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, color: color),
      ),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

      subtitle: Text(date),

      trailing: Text(
        amount,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _serviceCard(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 30),

          const SizedBox(height: 10),

          Text(title),
        ],
      ),
    );
  }
}
