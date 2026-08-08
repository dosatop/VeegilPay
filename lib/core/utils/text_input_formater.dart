import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AmountInputFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat("#,###");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final cleanText = newValue.text.replaceAll(',', '');

    final number = int.tryParse(cleanText);

    if (number == null) {
      return oldValue;
    }

    final formatted = formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
