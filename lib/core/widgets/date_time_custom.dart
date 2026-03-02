import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasa/core/extension/init_ext.dart';

class DateTimeCustom {
  final now = DateTime.now();

  static Future<DateTime?> datePickerCustom({
    required BuildContext context,
    required String? initialDate,
  }) {
    DateTime date = DateTime.now();
    try {
      if (!initialDate.isEmptyOrNull) {
        date = DateFormat('dd/MM/yyyy').parse(initialDate!);
        print(date);
      }
    } catch (e) {
      print(e);
      date = DateFormat(
        'yyyy/MM/dd',
      ).parse(initialDate ?? date.toTextDefaulftV2);
    }

    return showDatePicker(
      locale: const Locale('vi'),
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }
}
