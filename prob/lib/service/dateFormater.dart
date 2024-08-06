import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final buffer = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      // Add '-' at the appropriate positions
      if (i == 3 || i == 6) {
        buffer.write('-');
      }
    }

    // Handle the case where '-' is manually deleted
    if (newText.length == 4 || newText.length == 7) {
      if (oldValue.text.length < newText.length) {
        buffer.write('-');
      }
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
