import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/transaction_shimmer.dart';
import 'package:veegil_pay/features/transaction/model/transaction_model.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_history_provider.dart';

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  ConsumerState<TransactionHistoryPage> createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState
    extends ConsumerState<TransactionHistoryPage> {
  String selectedFilter = "All";

  final List<String> filters = [
    "All",
    "Deposit",
    "Withdrawal",
    "Incomimg Transfer",
    "Outgoing Transfer",
  ];

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionHistoryProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Transaction History"),

          actions: [
            IconButton(
              icon: Icon(Icons.analytics_outlined),

              onPressed: () {
                context.push("/transaction-overview");
              },
            ),
          ],
        ),

        body: transactions.when(
          loading: () => const TransactionShimmer(),

          error: (error, stack) => Center(child: Text(error.toString())),

          data: (items) {
            final filtered = filterTransactions(items);

            return Column(
              children: [
                const SizedBox(height: 12),

                SizedBox(
                  height: 45,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    itemCount: filters.length,

                    itemBuilder: (context, index) {
                      final filter = filters[index];

                      final selected = selectedFilter == filter;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),

                          margin: const EdgeInsets.only(right: 10),

                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : Colors.grey.shade100,

                            borderRadius: BorderRadius.circular(14),

                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Icon(
                                getFilterIcon(filter),

                                size: 16,

                                color: selected
                                    ? Colors.white
                                    : getFilterColor(filter),
                              ),

                              const SizedBox(width: 6),

                              Text(
                                filter,

                                style: TextStyle(
                                  fontSize: 13,

                                  fontWeight: FontWeight.w600,

                                  color: selected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text("No transactions found"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),

                          itemCount: filtered.length,

                          itemBuilder: (context, index) {
                            final transaction = filtered[index];

                            final isIncoming = transaction.type == "credit";

                            final isTransfer = transaction.counterparty != null;

                            return Card(
                              elevation: 0,

                              color: Colors.white,

                              margin: const EdgeInsets.only(bottom: 12),

                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isIncoming
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,

                                  child: Icon(
                                    isTransfer
                                        ? Icons.swap_horiz
                                        : isIncoming
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,

                                    color: isIncoming
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),

                                title: Text(
                                  getTitle(transaction),

                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                subtitle: Text(
                                  DateFormat.yMMMd().format(
                                    transaction.created,
                                  ),
                                ),

                                trailing: Text(
                                  "${isIncoming ? '+' : '-'}₦${NumberFormat("#,###").format(transaction.amount)}",

                                  style: TextStyle(
                                    color: isIncoming
                                        ? Colors.green
                                        : Colors.red,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<TransactionModel> filterTransactions(List<TransactionModel> items) {
    switch (selectedFilter) {
      case "Deposit":
        return items
            .where((e) => e.type == "credit" && e.counterparty == null)
            .toList();

      case "Transfer Received":
        return items
            .where((e) => e.type == "credit" && e.counterparty != null)
            .toList();

      case "Withdrawal":
        return items
            .where((e) => e.type == "debit" && e.counterparty == null)
            .toList();

      case "Transfer Sent":
        return items
            .where((e) => e.type == "debit" && e.counterparty != null)
            .toList();

      default:
        return items;
    }
  }

  String getTitle(TransactionModel transaction) {
    if (transaction.type == "credit") {
      if (transaction.counterparty != null) {
        return "Transfer Received";
      }

      return "Deposit";
    }

    if (transaction.type == "debit") {
      if (transaction.counterparty != null) {
        return "Transfer Sent";
      }

      return "Withdrawal";
    }

    return "Transaction";
  }

  IconData getFilterIcon(String filter) {
    switch (filter) {
      case "Deposit":
        return Icons.add_circle_outline;

      case "Withdrawal":
        return Icons.remove_circle_outline;

      case "Transfer Received":
        return Icons.arrow_downward_rounded;

      case "Transfer Sent":
        return Icons.arrow_upward_rounded;

      default:
        return Icons.list_alt_rounded;
    }
  }

  Color getFilterColor(String filter) {
    switch (filter) {
      case "Deposit":
        return Colors.green;

      case "Withdrawal":
        return Colors.red;

      case "Transfer Received":
        return Colors.blue;

      case "Transfer Sent":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }
}
