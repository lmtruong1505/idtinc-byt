import 'dart:convert';

import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String convertDateFormat(String originalDateString) {
  try {
    final DateTime dateTime = DateTime.parse(originalDateString).toUtc();
    final dateTimeUtcPlus7 = dateTime.add(const Duration(hours: 7));
    return DateFormat('dd/MM/yyyy').format(dateTimeUtcPlus7);
  } catch (e) {
    // final now = DateTime.now();
    // return DateFormat('dd/MM/yyyy').format(now);
    return "Chưa có thông tin";
  }
}

String convertDateFormatTime(String originalDateString) {
  try {
    final DateTime dateTime = DateTime.parse(originalDateString).toUtc();
    final dateTimeUtcPlus7 = dateTime.add(const Duration(hours: 7));
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTimeUtcPlus7);
  } catch (e) {
    // return DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    return "Chưa có thông tin";
  }
}

String convertDateFormatYYMMDDHHMMSS(DateTime time) {
  return DateFormat('yyMMddHHmmss').format(time);
}

String convertDateYYYYMMDD(DateTime dateTime, {bool isYYMMDD = false}) {
  final define = isYYMMDD ? 'yyyy-MM-dd' : 'dd/MM/yyyy';
  return DateFormat(define).format(dateTime.toUtc());
}

String convertDateYYYYMMDDNormal(DateTime dateTime, {bool isYYMMDD = false}) {
  final define = isYYMMDD ? 'yyyy-MM-dd' : 'dd-MM-yyyy';
  return DateFormat(define).format(dateTime);
}

DateTime stringToDate(String originalDateString, {bool isDDMMYY = false}) {
  try {
    final define = isDDMMYY ? 'yyyy-MM-dd' : 'dd/MM/yyyy';
    return DateFormat(define).parse(originalDateString);
  } catch (e) {
    final define = isDDMMYY ? 'yyyy-MM-dd' : 'dd-MM-yyyy';
    return DateFormat(define).parse(originalDateString);
  }
}

String convertStringToYYMM(DateTime time, {bool isDDMMYY = false}) {
  final define = isDDMMYY ? 'yy-MM' : 'MM/yy';
  return DateFormat(define).format(time);
}

String formatMinute(int seconds) {
  final int minutes = (seconds % 3600) ~/ 60;
  final int remainingSeconds = seconds % 60;

  final String minutesStr = minutes.toString().padLeft(2, '0');
  final String secondsStr = remainingSeconds.toString().padLeft(2, '0');

  return '$minutesStr:$secondsStr';
}

String formatCurrency(num? amount, {int? decimalDigits}) {
  amount ??= 0;

  // If decimalDigits is null, use smart formatting
  if (decimalDigits == null) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 2,
    );
    String formatted = formatter.format(amount);

    // Hide ,00
    formatted = formatted.replaceAll(RegExp(r',00(?=\s|$)'), '');
    // Replace ,X0 with ,X
    formatted = formatted.replaceAllMapped(
      RegExp(r',([0-9])0(?=\s|$)'),
      (match) => ',${match.group(1)}',
    );

    return formatted;
  }

  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: decimalDigits,
  );
  return formatter.format(amount);
}

String formatNumberV2(num? number, {int decimalDigits = 0}) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: decimalDigits,
  );
  return formatter.format(number).trim().replaceAll('\u00A0', '');
}

String formatSmartNumber(num? number) {
  if (number == null) return "0";
  // For whole numbers, format with 0 decimal places immediately
  if (number % 1 == 0) {
    return formatNumberV2(number, decimalDigits: 0);
  }

  // For numbers with decimals, format with up to 2 decimal places
  String formatted = formatNumberV2(number, decimalDigits: 2);

  // vi_VN uses ',' as decimal separator and '.' as thousand separator
  // We want to remove trailing zeros and the comma if unnecessary
  if (formatted.contains(',')) {
    // Remove trailing zeros
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    // Remove trailing decimal separator if it's the last character
    if (formatted.endsWith(',')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
  }

  return formatted;
}

String removeVietnameseTones(String str) {
  str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
  str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
  str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
  str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
  str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
  str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
  str = str.replaceAll(RegExp(r'đ'), 'd');
  str = str.replaceAll(RegExp(r'[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]'), 'A');
  str = str.replaceAll(RegExp(r'[ÈÉẸẺẼÊỀẾỆỂỄ]'), 'E');
  str = str.replaceAll(RegExp(r'[ÌÍỊỈĨ]'), 'I');
  str = str.replaceAll(RegExp(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]'), 'O');
  str = str.replaceAll(RegExp(r'[ÙÚỤỦŨƯỪỨỰỬỮ]'), 'U');
  str = str.replaceAll(RegExp(r'[ỲÝỴỶỸ]'), 'Y');
  str = str.replaceAll(RegExp(r'Đ'), 'D');
  str = str.replaceAll(RegExp(r'\u0300|\u0301|\u0303|\u0309|\u0323'), '');
  str = str.replaceAll(RegExp(r'\u02C6|\u0306|\u031B'), '');
  str = str.replaceAll(RegExp(r'\s+'), ' ');
  str = str.trim();
  str = str.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), ' ');
  return str;
}

ImageProvider<Object> checkNetworkImage(String image) {
  try {
    return NetworkImage(image);
  } catch (e) {
    return const AssetImage("assets/images/logo_absc.png");
  }
}

double bytesToMegabytes(int bytes) {
  return bytes / 1048576;
}

RemoteMessage stringToRemoteMessage(String payload) {
  try {
    final Map<String, dynamic> data = jsonDecode(payload);

    // Create a RemoteNotification object if available
    final notification =
        data['notification'] != null
            ? RemoteNotification(
              title: data['notification']['title'],
              body: data['notification']['body'],
            )
            : null;

    // Return a RemoteMessage object with data and notification
    return RemoteMessage(
      messageId: data['messageId'] ?? '',
      senderId: data['senderId'] ?? '',
      data: Map<String, dynamic>.from(data['data'] ?? {}),
      notification: notification,
    );
  } catch (e) {
    print("Error converting string to RemoteMessage: $e");
    rethrow;
  }
}

String formatNumberWithSpaces(String input) {
  final String reversed = input.split('').reversed.join();
  final String spaced = reversed.replaceAllMapped(
    RegExp(r'.{1,4}'),
    (match) => '${match.group(0)} ',
  );
  return spaced.split('').reversed.join().trim();
}

String convertGender(int? gender) {
  switch (gender) {
    case 1:
      return "Nam";
    case 2:
      return "Nữ";
    case 3:
      return "Khác";
    default:
      return "Nam";
  }
}

int decodeGender(String? gender) {
  switch (gender) {
    case "Nam":
      return 1;
    case "Nữ":
      return 2;
    case "Khác":
      return 3;
    default:
      return 1;
  }
}

Color getAssetStatusColor(String? statusValue) {
  switch (statusValue) {
    case "NHAN_ROI":
      return AppColors.green50;
    case "DANG_SU_DUNG":
      return AppColors.blue50;
    case "CHO_THANH_LY":
      return AppColors.orange50;
    case "DA_THANH_LY":
      return AppColors.red50;
    default:
      return AppColors.grey50;
  }
}

class ThousandSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,###", "vi");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') return newValue;

    // Xóa dấu phân cách hiện tại và format lại
    final String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final String formattedText = _formatter
        .format(int.parse(newText))
        .replaceAll('.', ' '); // Thay dấu ',' bằng dấu cách

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
