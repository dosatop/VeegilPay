import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/utils/text_input_formater.dart';
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

              const SizedBox(height: 25),

              CustomTextfield(
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

                          final request = WithdrawRequest(
                            phoneNumber: user!.phoneNumber,

                            amount: int.parse(
                              _amountController.text.replaceAll(',', ''),
                            ),
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
                            final errorMessage = ref
                                .read(transactionProvider)
                                .error;

                            showOverlayPill(
                              context,
                              errorMessage?.toString() ??
                                  "Something went wrong",
                            );
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
}
