import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/money_overview_chart.dart';
import 'package:veegil_pay/features/transaction/model/transaction_model.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_history_provider.dart';

class TransactionOverviewPage extends ConsumerStatefulWidget {
  const TransactionOverviewPage({super.key});

  @override
  ConsumerState<TransactionOverviewPage> createState() =>
      _TransactionOverviewPageState();
}

class _TransactionOverviewPageState
    extends ConsumerState<TransactionOverviewPage> {
  String selectedType = "All";

  DateTime? selectedDate;

  final List<String> types = [
    "All",
    "Deposit",
    "Withdrawal",
    "Incoming Transfer",
    "Outgoing Transfer",
  ];

  List<TransactionModel> filterTransactions(List<TransactionModel> items) {
    return items.where((transaction) {
      bool typeMatch = true;

      switch (selectedType) {
        case "Deposit":
          typeMatch =
              transaction.type == "credit" && transaction.counterparty == null;
          break;

        case "Withdrawal":
          typeMatch =
              transaction.type == "debit" && transaction.counterparty == null;
          break;

        case "Transfer Received":
          typeMatch =
              transaction.type == "credit" && transaction.counterparty != null;
          break;

        case "Transfer Sent":
          typeMatch =
              transaction.type == "debit" && transaction.counterparty != null;
          break;
      }

      bool dateMatch = true;

      if (selectedDate != null) {
        final transactionDate = transaction.created.toLocal();

        dateMatch =
            transactionDate.year == selectedDate!.year &&
            transactionDate.month == selectedDate!.month &&
            transactionDate.day == selectedDate!.day;
      }

      return typeMatch && dateMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Overview"),

        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),

            onPressed: () async {
              final date = await showDatePicker(
                context: context,

                firstDate: DateTime(2020),

                lastDate: DateTime.now(),

                initialDate: DateTime.now(),
              );

              if (date != null) {
                setState(() {
                  selectedDate = date;
                });
              }
            },
          ),
        ],
      ),

      body: transactions.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(child: Text(error.toString())),

        data: (items) {
          final filtered = filterTransactions(items);

          final depositAmount = filtered
              .where((e) => e.type == "credit" && e.counterparty == null)
              .fold<double>(0, (sum, e) => sum + e.amount);

          final withdrawalAmount = filtered
              .where((e) => e.type == "debit" && e.counterparty == null)
              .fold<double>(0, (sum, e) => sum + e.amount);

          final transferReceivedAmount = filtered
              .where((e) => e.type == "credit" && e.counterparty != null)
              .fold<double>(0, (sum, e) => sum + e.amount);

          final transferSentAmount = filtered
              .where((e) => e.type == "debit" && e.counterparty != null)
              .fold<double>(0, (sum, e) => sum + e.amount);

          return Column(
            children: [
              SizedBox(
                height: 50,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  padding: const EdgeInsets.all(8),

                  children: types.map((type) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),

                      child: ChoiceChip(
                        label: Text(
                          type,
                          style: TextStyle(
                            color: selectedType == type
                                ? AppColors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        selected: selectedType == type,
                        side: BorderSide(color: AppColors.primary, width: 1),

                        selectedColor: AppColors.primary,

                        backgroundColor: Colors.grey.shade100,

                        checkmarkColor: AppColors.white,

                        onSelected: (_) {
                          setState(() {
                            selectedType = type;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(
                child: MoneyOverviewChart(
                  deposit: depositAmount,

                  withdrawal: withdrawalAmount,

                  transferReceived: transferReceivedAmount,

                  transferSent: transferSentAmount,
                ),
              ),

              Text(
                selectedDate != null
                    ? DateFormat.yMMMMd().format(selectedDate!)
                    : "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
