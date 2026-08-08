import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: Text(message),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(cancelText),
        ),

        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: TextButton.styleFrom(
            foregroundColor: confirmColor ?? Theme.of(context).primaryColor,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
