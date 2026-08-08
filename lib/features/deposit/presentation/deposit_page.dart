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
import 'package:veegil_pay/features/deposit/model/deposit_request.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_history_provider.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_provider.dart';

class DepositPage extends ConsumerStatefulWidget {
  const DepositPage({super.key});

  @override
  ConsumerState<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends ConsumerState<DepositPage> {
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

    final theme = Theme.of(context);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Deposit")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Add Money",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

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
                              title: "Confirm Deposit",
                              message:
                                  "Are you sure you want to deposit ₦$formattedAmount into your account?",
                              confirmText: "Deposit",
                              cancelText: "Cancel",
                              confirmColor: AppColors.primary,
                            ),
                          );
                          if (confirmed != true || !mounted) {
                            return;
                          }

                          setState(() {
                            _errorMessage = null;
                          });

                          final request = DepositRequest(
                            phoneNumber: user!.phoneNumber,

                            amount: int.parse(amount),
                          );

                          final success = await ref
                              .read(transactionProvider.notifier)
                              .deposit(request);

                          if (!mounted) return;

                          if (success) {
                            await ref.read(authProvider.notifier).refreshUser();
                            await ref
                                .read(transactionHistoryProvider.notifier)
                                .refresh();

                            if (!mounted) return;

                            _amountController.clear();

                            showOverlayPill(context, "Deposit Successful");

                            context.pop();
                          } else {
                            final error = ref.read(transactionProvider).error;

                            setState(() {
                              _errorMessage = getDepositErrorMessage(
                                error.toString(),
                              );
                            });
                          }
                        },

                  child: transactionState.isLoading
                      ? const SizedBox(
                          height: 22,

                          width: 22,

                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Deposit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDepositErrorMessage(String code) {
    switch (code) {
      case "NETWORK_ERROR":
      case "NO_CONNECTION":
        return "No internet connection. Please check your network";

      case "AMOUNT_TOO_LARGE":
        return "The amount is too large";

      case "AMOUNT_TOO_SMALL":
        return "The amount is below the minimum limit";

      case "ACCOUNT_NOT_FOUND":
        return "Account not found";

      case "UNAUTHORIZED":
        return "Session expired, please login again";

      default:
        return "Unable to complete deposit. Please try again";
    }
  }
}
