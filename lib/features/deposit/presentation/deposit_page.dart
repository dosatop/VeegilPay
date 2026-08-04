import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/widgets/custom_textfield.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart';
import 'package:veegil_pay/features/dashboard/provider/dashboard_provider.dart';
import 'package:veegil_pay/features/deposit/model/deposit_request.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_provider.dart';

class DepositPage extends ConsumerStatefulWidget {
  const DepositPage({super.key});

  @override
  ConsumerState<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends ConsumerState<DepositPage> {
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

              const SizedBox(height: 25),

              CustomTextfield(
                controller: _amountController,

                hintText: "Enter amount",

                iconType: Icons.money,

                textFieldName: "Amount",

                textInputType: TextInputType.number,

                obscureText: false,

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Amount is required";
                  }

                  final amount = double.tryParse(value);

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
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          final request = DepositRequest(
                            phoneNumber: user!.phoneNumber,

                            amount: int.parse(_amountController.text.trim()),
                          );

                          final success = await ref
                              .read(transactionProvider.notifier)
                              .deposit(request);

                          if (!mounted) return;

                          if (success) {
                            await ref.read(authProvider.notifier).refreshUser();

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Deposit successful"),
                              ),
                            );

                            context.pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Deposit failed")),
                            );
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
}
