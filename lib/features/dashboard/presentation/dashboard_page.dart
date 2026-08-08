import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/overlay_pill.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';
import 'package:veegil_pay/features/dashboard/provider/dashboard_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/features/transaction/model/transaction_model.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_history_provider.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final formatter = NumberFormat("#,###");
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userProvider);
    final isBalanceVisible = ref.watch(balanceVisibilityProvider);
    final transactions = ref.watch(transactionHistoryProvider);
    final transactionList = transactions.value ?? [];

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
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(authProvider.notifier).refreshUser();

            await ref.read(transactionHistoryProvider.notifier).refresh();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            isBalanceVisible
                                ? "₦${formatter.format(user?.balance ?? 0)}.00"
                                : "******",

                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              ref
                                  .read(balanceVisibilityProvider.notifier)
                                  .toggle();
                            },

                            icon: Icon(
                              isBalanceVisible
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
                      "Transfer",
                      () => context.push("/transfer"),
                    ),

                    _actionButton(
                      context,
                      Icons.add_circle,
                      "Deposit",
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
                      Icons.arrow_circle_down_outlined,
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
                  child: SizedBox(
                    height: 350,
                    child: transactionList.isEmpty
                        ? const Center(
                            child: Text(
                              "No transactions yet",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: transactionList.take(5).length,
                            itemBuilder: (context, index) {
                              final transaction = transactionList[index];

                              return Column(
                                children: [
                                  _transactionPreview(
                                    icon: getTransactionIcon(transaction),
                                    title: getTitle(transaction),
                                    date: transaction.created.toString(),
                                    amount: transaction.amount.toString(),
                                    color: getTransactionColor(transaction),
                                  ),

                                  if (index !=
                                      transactionList.take(5).length - 1)
                                    const Divider(),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
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
        "₦${formatter.format(int.tryParse(amount.toString()) ?? 0)}.00",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  String getTitle(TransactionModel transaction) {
    if (transaction.type == "credit") {
      if (transaction.counterparty != null) {
        return "Incoming Transfer";
      }

      return "Deposit";
    }

    if (transaction.type == "debit") {
      if (transaction.counterparty != null) {
        return "Outgoing Transfer";
      }

      return "Withdrawal";
    }

    return "Transaction";
  }

  IconData getTransactionIcon(TransactionModel transaction) {
    final title = getTitle(transaction);

    switch (title) {
      case "Deposit":
        return Icons.add_circle_outline;

      case "Withdrawal":
        return Icons.remove_circle_outline;

      case "Incoming Transfer":
        return Icons.arrow_downward_rounded;

      case "Outgoing Transfer":
        return Icons.arrow_upward_rounded;

      default:
        return Icons.list_alt_rounded;
    }
  }

  Color getTransactionColor(TransactionModel transaction) {
    final title = getTitle(transaction);

    switch (title) {
      case "Deposit":
        return Colors.orange;

      case "Withdrawal":
        return Colors.red;

      case "Transfer Received":
        return Colors.green;

      case "Transfer Sent":
        return Colors.redAccent;

      default:
        return Colors.grey;
    }
  }
}
