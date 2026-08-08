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
  String? _errorMessage;
  bool _isSelfTransfer = false;

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
    final currentUser = ref.read(userProvider);

    setState(() {});

    if (phone.length < 11) {
      setState(() {
        _receiverExists = null;
        _isSelfTransfer = false;
        _errorMessage = null;
      });
      return;
    }

    _isSelfTransfer = phone == currentUser?.phoneNumber;

    if (_isSelfTransfer) {
      setState(() {
        _receiverExists = null;
        _errorMessage = "You cannot transfer money to yourself";
      });
      return;
    }

    final users = ref.read(accountUsersProvider);
    final exists = users.any((user) => user.phoneNumber == phone);

    setState(() {
      _receiverExists = exists;
      _errorMessage = null;
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
    final canTransfer = _receiverExists == true && !_isSelfTransfer;

    return Scaffold(
      appBar: AppBar(title: const Text("Transfer")),

      body: Padding(
        padding: const EdgeInsets.all(10),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              SizedBox(
                height: 35,
                child: Center(
                  child: _errorMessage != null || _receiverExists != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _errorMessage != null
                                  ? Icons.cancel
                                  : (_receiverExists!
                                        ? Icons.check_circle
                                        : Icons.cancel),
                              size: 18,
                              color: _errorMessage != null
                                  ? Colors.red
                                  : (_receiverExists!
                                        ? Colors.green
                                        : Colors.red),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _errorMessage ??
                                  (_receiverExists!
                                      ? "Account found"
                                      : "Account does not exist"),
                              style: TextStyle(
                                color: _errorMessage != null
                                    ? Colors.red
                                    : (_receiverExists!
                                          ? Colors.green
                                          : Colors.red),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),

              Consumer(
                builder: (context, ref, child) {
                  final users = ref.watch(accountUsersProvider);
                  final currentUser = ref.watch(userProvider);

                  final filteredUsers = users.where((user) {
                    return user.phoneNumber.contains(
                          _receiverController.text.trim(),
                        ) &&
                        user.phoneNumber != currentUser?.phoneNumber;
                  }).toList();

                  return Column(
                    children: [
                      CustomTextfield(
                        enabled: !transactionState.isLoading,
                        controller: _receiverController,
                        hintText: "Search receiver account",
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

                      if (filteredUsers.isNotEmpty && _receiverExists != true)
                        const SizedBox(height: 10),
                      const SizedBox(height: 10),

                      if (filteredUsers.isNotEmpty && _receiverExists != true)
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];

                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),

                                title: Text(user.phoneNumber),

                                onTap: () {
                                  setState(() {
                                    _receiverController.text = user.phoneNumber;
                                    _receiverExists = true;
                                    _errorMessage = null;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 10),
              if (canTransfer)
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
                  onPressed: transactionState.isLoading || !canTransfer
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          final receiver = _receiverController.text.trim();
                          final amount = _amountController.text.replaceAll(
                            ",",
                            "",
                          );
                          final formattedAmount = _amountController.text.trim();

                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: "Confirm Transfer",
                              message:
                                  "Are you sure you want to send ₦$formattedAmount to $receiver?",
                              confirmText: "Send",
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

                          final request = TransferRequest(
                            phoneNumber: receiver,
                            amount: int.parse(
                             amount,
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
                            setState(() {
                              _errorMessage = getTransferErrorMessage(error);
                            });
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

  String getTransferErrorMessage(String? code) {
    switch (code) {
      case "NETWORK_ERROR":
      case "NO_CONNECTION":
        return "No internet connection. Please check your network";

      case "RECIPIENT_NOT_FOUND":
        return "The receiver account does not exist";

      case "INSUFFICIENT_FUNDS":
        return "You do not have enough balance";

      case "TRANSFER_TO_SELF":
        return "You cannot transfer money to yourself";

      case "AMOUNT_TOO_LARGE":
        return "The amount is too large";

      default:
        return "Unable to complete transfer. Please try again";
    }
  }
}
