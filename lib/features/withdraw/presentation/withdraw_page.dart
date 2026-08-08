import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/utils/text_input_formater.dart';
import 'package:veegil_pay/core/widgets/confirmation_dialog.dart';
import 'package:veegil_pay/core/widgets/custom_textfield.dart';
import 'package:veegil_pay/core/widgets/overlay_pill.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';
import 'package:veegil_pay/features/dashboard/provider/dashboard_provider.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_history_provider.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_provider.dart';
import 'package:veegil_pay/features/withdraw/model/withdraw_request.dart';

class WithdrawPage extends ConsumerStatefulWidget {
  const WithdrawPage({super.key});

  @override
  ConsumerState<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends ConsumerState<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);

    final user = ref.watch(userProvider);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Withdraw")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Withdraw Money",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 5),
              SizedBox(
                height: 35,
                child: Center(
                  child: _errorMessage != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cancel,
                              size: 18,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),

              CustomTextfield(
                enabled: !transactionState.isLoading,
                controller: _amountController,
                hintText: "Enter amount",
                iconType: Icons.money,
                textFieldName: "Amount",
                textInputType: TextInputType.number,
                obscureText: false,

                inputFormatters: [AmountInputFormatter()],

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Amount is required";
                  }

                  final amount = int.tryParse(value.replaceAll(',', ''));

                  if (amount == null) {
                    return "Enter a valid amount";
                  }

                  if (amount <= 0) {
                    return "Amount must be greater than zero";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: transactionState.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          setState(() {
                            _errorMessage = null;
                          });
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          final amount = _amountController.text.replaceAll(
                            ',',
                            '',
                          );
                          final formattedAmount = _amountController.text.trim();
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: "Confirm Withdrawal",
                              message:
                                  "Are you sure you want to withdraw ₦$formattedAmount from your account?",
                              confirmText: "Withdraw",
                              cancelText: "Cancel",
                              confirmColor: Colors.red,
                            ),
                          );
                          if (confirmed != true || !mounted) {
                            return;
                          }

                          final request = WithdrawRequest(
                            phoneNumber: user!.phoneNumber,

                            amount: int.parse(amount),
                          );

                          final success = await ref
                              .read(transactionProvider.notifier)
                              .withdraw(request);

                          if (!mounted) return;

                          if (success) {
                            await ref.read(authProvider.notifier).refreshUser();
                            await ref
                                .read(transactionHistoryProvider.notifier)
                                .refresh();

                            if (!mounted) return;

                            showOverlayPill(context, "Withdrawal Successful");

                            _amountController.clear();

                            context.pop();
                          } else {
                            final error = ref.read(transactionProvider).error;

                            setState(() {
                              _errorMessage = getWithdrawErrorMessage(
                                error.toString(),
                              );
                            });
                          }
                        },

                  child: transactionState.isLoading
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : const Text("Withdraw"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getWithdrawErrorMessage(String code) {
    switch (code) {
      case "NETWORK_ERROR":
      case "NO_CONNECTION":
        return "No internet connection. Please check your network";

      case "INSUFFICIENT_FUNDS":
        return "You do not have enough balance";

      case "AMOUNT_TOO_LARGE":
        return "The amount is too large";

      case "AMOUNT_TOO_SMALL":
        return "The amount is below the minimum limit";

      case "ACCOUNT_NOT_FOUND":
        return "Account not found";

      default:
        return "Unable to complete withdrawal. Please try again";
    }
  }
}
