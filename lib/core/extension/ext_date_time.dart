part of 'init_ext.dart';

extension extDateTime on DateTime? {
  String get toTextDefaulft =>
      this == null ? '' : DateFormat('dd/MM/yyyy').format(this!);
  String get toTextDefaulftV2 =>
      this == null ? '' : DateFormat('yyyy/MM/dd').format(this!);

  TimeOfDay? get toTime =>
      this == null ? null : TimeOfDay(hour: this!.hour, minute: this!.minute);

  String toText({String fomat = 'dd/MM/yyyy', String valDefault = ''}) {
    if (this != null) {
      return DateFormat(fomat, 'vi').format(this!);
    }
    return valDefault;
  }

  String get toTextVi {
    if (this == null) return '';

    final String dayOfWeek = DateFormat('EEEE', 'vi').format(this!);
    final String day = DateFormat('dd', 'vi').format(this!);
    final String month = DateFormat('MM', 'vi').format(this!);
    final String year = DateFormat('yyyy', 'vi').format(this!);

    return '$dayOfWeek, Ngày $day, Tháng $month năm $year';
  }

  String get toTextWeek {
    if (this == null) return '';

    final String dayOfWeek = DateFormat('EEEE', 'vi').format(this!);

    return dayOfWeek;
  }

  DateTime? get startDay {
    return this?.copyWith(hour: 0, minute: 0, second: 0);
  }

  DateTime? get endDay {
    return this?.copyWith(hour: 23, minute: 59, second: 59);
  }
}
