import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// class Formatter {
currencyFormatter(number) {
  return NumberFormat.simpleCurrency(locale: "id ", decimalDigits: 0)
      .format(number);
}

dateFormatter(DateTime? date) {
  if (date is DateTime)
    return DateFormat.yMMMEd('id').format(date);
  else
    return '';
}

timeFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat.Hm('id').format(date);
  }
  return '';
}
// }

class DecimalInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    int value = int.parse(newValue.text);

    // final formatter = NumberFormat.simpleCurrency(
    //   locale: "id ",
    // );
    final formatter = NumberFormat.decimalPattern("id ");

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

class CurrrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    int value = int.parse(newValue.text);

    final formatter =
        NumberFormat.simpleCurrency(locale: "id ", decimalDigits: 0);
    // final formatter = NumberFormat.decimalPattern("id ");

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
