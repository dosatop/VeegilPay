import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:veegil_pay/core/theme/app_colors.dart';
import 'package:veegil_pay/core/utils/text_input_formater.dart';
import 'package:veegil_pay/core/widgets/custom_textfield.dart';
import 'package:veegil_pay/core/widgets/overlay_pill.dart';

import 'package:veegil_pay/features/auth/provider/auth_provider.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_history_provider.dart';
import 'package:veegil_pay/features/transaction/provider/transaction_provider.dart';
import 'package:veegil_pay/features/transfer/models/transfer_request.dart';
import 'package:veegil_pay/features/account/provider/account_provider.dart';

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({super.key});

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final _formKey = GlobalKey<FormState>();

  final _receiverController = TextEditingController();
  final _amountController = TextEditingController();
  bool? _receiverExists;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(accountUsersProvider.notifier).loadUsers();
    });

    _receiverController.addListener(_checkReceiver);
  }

  void _checkReceiver() {
    final phone = _receiverController.text.trim();

    if (phone.isEmpty) {
      setState(() {
        _receiverExists = null;
      });

      return;
    }

    final users = ref.read(accountUsersProvider);

    final exists = users.any((user) => user.phoneNumber == phone);

    setState(() {
      _receiverExists = exists;
    });
  }

  @override
  void dispose() {
    _receiverController.removeListener(_checkReceiver);

    _receiverController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(accountUsersProvider);
    final transactionState = ref.watch(transactionProvider);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Transfer")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Send Money",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 25),

              CustomTextfield(
                controller: _receiverController,

                hintText: "Receiver phone number",

                iconType: Icons.phone,

                textFieldName: "Receiver",

                textInputType: TextInputType.phone,

                obscureText: false,

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Receiver phone number is required";
                  }

                  return null;
                },
              ),
              if (_receiverExists != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        _receiverExists! ? Icons.check_circle : Icons.cancel,
                        size: 18,
                        color: _receiverExists! ? Colors.green : Colors.red,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        _receiverExists!
                            ? "Account found"
                            : "Account does not exist",
                        style: TextStyle(
                          color: _receiverExists! ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

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

                  final amount = int.tryParse(value.replaceAll(",", ""));

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

                          final receiver = _receiverController.text.trim();

                          if (_receiverExists != true) {
                            showOverlayPill(
                              context,
                              "Receiver account does not exist",
                            );

                            return;
                          }

                          final request = TransferRequest(
                            phoneNumber: receiver,
                            amount: int.parse(
                              _amountController.text.replaceAll(",", ""),
                            ),
                          );

                          final error = await ref
                              .read(transactionProvider.notifier)
                              .transfer(request);

                          if (!mounted) return;

                          if (error == null) {
                            await ref.read(authProvider.notifier).refreshUser();

                            await ref
                                .read(transactionHistoryProvider.notifier)
                                .refresh();

                            if (!mounted) return;

                            showOverlayPill(context, "Transfer Successful");

                            _receiverController.clear();

                            _amountController.clear();

                            context.pop();
                          } else {
                            showOverlayPill(
                              context,
                              getTransferErrorMessage(error),
                            );
                          }
                        },

                  child: transactionState.isLoading
                      ? const SizedBox(
                          height: 22,

                          width: 22,

                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Send Money"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTransferErrorMessage(String? error) {
    if (error == null || error.isEmpty) {
      return "Transfer failed";
    }

    if (error.contains("RECIPIENT_NOT_FOUND")) {
      return "The receiver account does not exist";
    }

    if (error.contains("INSUFFICIENT_FUNDS")) {
      return "You do not have enough balance";
    }

    if (error.contains("TRANSFER_TO_SELF")) {
      return "You cannot transfer money to yourself";
    }

    return "Unable to complete transfer. Please try again";
  }
}
