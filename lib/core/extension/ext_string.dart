part of 'init_ext.dart';

extension extString on String? {
  String get validator => this ?? "";

  String get capitalize {
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

  bool get copy {
    print("====copy");
    showToast("Đã copy");
    Clipboard.setData(ClipboardData(text: validator));
    return true;
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

  DateTime? get toDate {
    DateTime? date = DateTime.tryParse(validator);
    return date;
  }

  String toDateText({String? valDefault, String? format}) {
    try {
      double time = double.tryParse(toString()) ?? 0;
      if (time <= 0) {
        return valDefault ?? "";
      }
      return DateFormat(
        format ?? "dd/MM/yyyy",
      ).format(DateTime.fromMillisecondsSinceEpoch(time.round() * 1000));
    } catch (e) {
      return valDefault ?? "";
    }
  }

  String get toCamelCase {
    return validator
        .split(' ')
        .map((String word) {
          return word.capitalize;
        })
        .join('');
  }

  String get toPascalCase {
    return validator.capitalize.toCamelCase;
  }

  String toSnakeCase() {
    return validator.toLowerCase().replaceAll(' ', '_');
  }

  String toKebabCase() {
    return validator.toLowerCase().replaceAll(' ', '-');
  }

  String toConstantCase() {
    return validator.toUpperCase().replaceAll(' ', '_');
  }

  String toDotCase() {
    return validator.toLowerCase().replaceAll(' ', '.');
  }

  bool isMatch(String pattern) {
    return RegExp(pattern).hasMatch(validator);
  }

  bool isEmail() {
    return isMatch(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  }

  bool isPhoneNumber() {
    return isMatch(r'^0\d{9,11}$');
  }

  bool isUrl() {
    return isMatch(r'^http(s)?://([\w-]+\.)+[\w-]{2,4}(/[\w- ./?%&=]*)?$');
  }

  bool isIpv4() {
    return isMatch(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
  }

  bool isIpv6() {
    return isMatch(r'^([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}$');
  }

  bool isHexColor() {
    return isMatch(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');
  }

  bool isRgbColor() {
    return isMatch(r'^rgb\((\d{1,3}), (\d{1,3}), (\d{1,3})\)$');
  }

  bool isRgbaColor() {
    return isMatch(
      r'^rgba\((\d{1,3}), (\d{1,3}), (\d{1,3}), (0(\.\d+)?|1(\.0+)?)\)$',
    );
  }

  bool isHslColor() {
    return isMatch(r'^hsl\((\d{1,3}), (\d{1,3})%, (\d{1,3})%\)$');
  }

  bool isHslaColor() {
    return isMatch(
      r'^hsla\((\d{1,3}), (\d{1,3})%, (\d{1,3})%, (0(\.\d+)?|1(\.0+)?)\)$',
    );
  }

  String removeAllNonNumeber() {
    if (this == null) {
      return '0';
    }
    return this!.replaceAll(RegExp('[^0-9]'), '');
  }

  String get toDateTimeFormat {
    if (this == null) {
      return '';
    }
    return this!.replaceAll('-', '/');
  }
}
