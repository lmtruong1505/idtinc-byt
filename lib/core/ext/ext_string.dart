import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

extension extString on String? {
  String get validator => this ?? '';
  String get capitalizeFirstLetter {
    if (validator.isEmpty) return validator;
    return validator[0].toUpperCase() + validator.substring(1).toLowerCase();
  }

  bool get isEmptyOrNull => this == null || this == 'null' || this!.isEmpty;
  bool get isTimeOfDay {
    if (isEmptyOrNull) {
      return false;
    }

    final res = this!.split(':');
    final left = int.tryParse(res.first) ?? 0;
    final right = int.tryParse(res.last) ?? 0;

    return left >= 0 && left <= 23 && right <= 60 && right >= 0;
  }

  double? get toDouble => double.tryParse(this ?? '');
  num? get toNum =>
      num.tryParse(this?.replaceAll('.', '').replaceAll(',', '.') ?? '');
  int? get toInt => int.tryParse(this ?? '');

  bool get copy {
    Clipboard.setData(ClipboardData(text: validator));
    return true;
  }

  String fomatDate2({
    String fomat = 'dd/MM/yyyy',
    String? parseFormat = 'yyyy-MM-dd',
    String defaultReturn = '',
    int hours = 0,
  }) {
    if (this != null) {
      try {
        final dateTime = DateFormat(
          parseFormat,
        ).parse(this!).add(Duration(hours: hours));
        return DateFormat(fomat).format(dateTime);
      } catch (e) {}
    }
    return defaultReturn;
  }

  DateTime? get toDate {
    if (this != null) {
      try {
        final date = DateTime.tryParse(this!);
        return date;
      } catch (e) {
        print(e.toString());
      }
    }
    return null;
  }

  DateTime? get toDateV2 {
    if (this == null) return null;
    try {
      final formatter = DateFormat('dd/MM/yyyy');
      return formatter.parse(this!);
    } catch (e) {
      print('Lỗi khi parse date: $e');
      return null;
    }
  }

  String? validatorTextField({
    String? msg,
    TextInputType type = TextInputType.text,
    String? textConfirm,
    int? minLength,
    int? maxLength,
  }) {
    if (validator.isEmpty) {
      return msg ?? 'Không bỏ trống';
    }
    if (maxLength != null && validator.length > maxLength) {
      return msg ?? 'Vui lòng nhập tối đa $maxLength kí tự';
    }
    if (minLength != null && validator.length < minLength) {
      return msg ?? 'Vui lòng nhập tối thiểu $minLength kí tự';
    }

    /// check phone
    final int? phone = int.tryParse(validator);
    if (phone == null && type == TextInputType.phone) {
      return msg ?? 'Số điện thoại không đúng định dạng';
    }
    if (validator.length != 10 && type == TextInputType.phone) {
      return msg ?? 'Số điện thoại không đúng định dạng';
    }
    if (!validator.startsWith('0') && type == TextInputType.phone) {
      return msg ?? 'Số điện thoại không đúng định dạng';
    }

    /// check email
    final isEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!isEmail.hasMatch(validator) && type == TextInputType.emailAddress) {
      return msg ?? 'Email không đúng định dạng';
    }

    /// check password
    if ((validator.length < 6 || validator.length > 12) &&
        type == TextInputType.visiblePassword) {
      return msg ?? 'Mật khẩu phải từ 6 -12 ký tự';
    }
    if (textConfirm != null &&
        this != textConfirm &&
        type == TextInputType.visiblePassword) {
      return msg ?? 'Mật khẩu không khớp';
    }
    return null;
  }

  String get autoConvertToHHmm {
    if (this == null) {
      return '00:00';
    }
    String time = this!;
    String temp = time;

    if (time.length == 1) {
      return '00:0$this';
    }
    time = time.replaceAll(':', '');
    if (time.length == 5) {
      time = time.substring(1, 5);
    }
    if (time.length == 3) {
      time = '0$time';
    }
    final cur = '${time.substring(0, 2)}:${time.substring(2)}';
    if (cur.isHourValid) {
      return cur;
    }
    if (temp.length == 6) {
      temp = temp.substring(0, 5);
    }
    return temp;
  }

  bool get isHourValid {
    // make sure the time is in the format HH:mm
    if (this == null) {
      return false;
    }
    final RegExp regex = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');
    return regex.hasMatch(this!);
  }

  String removeAllNonNumeric() {
    if (this == null) {
      return '';
    }
    return this!.replaceAll(RegExp(r'[^\d]'), '');
  }

  String removeAllDot() {
    if (this == null) {
      return '';
    }
    return this!.replaceAll(RegExp(r'[.]'), '');
  }

  String formatCurrency() {
    if (this == null) {
      return '';
    }
    final formatter = NumberFormat.simpleCurrency(
      locale: 'vi',
      name: '',
      decimalDigits: 0,
    );
    return formatter.format(double.parse(this!));
  }

  bool get validatePassword {
    if (this == null) {
      return false;
    }
    final RegExp regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.*\d)[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$',
    );

    return regex.hasMatch(this!);
  }

  String get getGender {
    switch (this) {
      case 'Nam':
        return 'MALE';
      case 'Nữ':
        return 'FEMALE';
      case 'Khác':
        return 'ORTHER';
      default:
        return 'ORTHER';
    }
  }

  int get getGenderValue {
    switch (this) {
      case 'Nữ':
        return 1;
      case 'Nam':
        return 2;
      case 'Khác':
        return 0;
      default:
        return 1;
    }
  }

  int get getPetGenderValue {
    switch (this) {
      case 'Đực':
        return 0;
      case 'Cái':
        return 1;
      default:
        return 0;
    }
  }

  bool isDigit() {
    if (this == null) {
      return false;
    }
    return this == '0' ||
        this == '1' ||
        this == '2' ||
        this == '3' ||
        this == '4' ||
        this == '5' ||
        this == '6' ||
        this == '7' ||
        this == '8' ||
        this == '9';
  }

  String toFixedLength(int length) {
    if (this == null) {
      return ''.padRight(length, ' ');
    }
    if (this!.length > length) {
      return this!.substring(0, length);
    } else if (this!.length < length) {
      return this!.padRight(length, ' ');
    }
    return this!;
  }

  String padLeftLength(int length) {
    if (this == null) {
      return '---'.padLeft(length, ' ');
    }
    if (this!.length > length) {
      return this!.substring(0, length);
    } else if (this!.length < length) {
      return this!.padLeft(length, ' ');
    }
    return this!;
  }
}
