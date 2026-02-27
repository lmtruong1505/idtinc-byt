part of 'init_ext.dart';

extension extNum on num? {
  num get validator => this ?? 0;
  double get toDouble => validator.toDouble();
  int get toInt => validator.toInt();
  Widget get height {
    return SizedBox(height: toDouble);
  }

  Widget get width {
    return SizedBox(width: toDouble);
  }

  String toDateText({String? valDefault, String? format}) {
    try {
      final double time = double.tryParse(toString()) ?? 0;
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

  DateTime? toDate({bool seconds = false}) {
    return DateTime.fromMillisecondsSinceEpoch(
      validator.round() * (seconds ? 1 : 1000),
    );
  }

  String toPrice({String type = ""}) {
    if (validator < 0) {
      return '0$type';
    }
    final formatCurrency = NumberFormat("#,###,###.##", "vi");
    final String format = formatCurrency.format(validator);
    return format + type;
  }

  num? checkDecimal() {
    if (this == null) {
      return 0;
    }
    if (this! % 1 == 0) {
      return this!.toInt();
    } else {
      return this;
    }
  }

  BorderRadius get radius => BorderRadius.circular(toDouble);
  BorderRadius get radiusTop =>
      BorderRadius.vertical(top: Radius.circular(toDouble));
  BorderRadius get radiusBottom =>
      BorderRadius.vertical(bottom: Radius.circular(toDouble));

  BorderRadius get radiusLeft =>
      BorderRadius.horizontal(left: Radius.circular(toDouble));
  BorderRadius get radiusRight =>
      BorderRadius.horizontal(right: Radius.circular(toDouble));

  BorderRadius get radiusTopLeft =>
      BorderRadius.only(topLeft: Radius.circular(toDouble));
  BorderRadius get radiusTopRight =>
      BorderRadius.only(topRight: Radius.circular(toDouble));
  BorderRadius get radiusBottomLeft =>
      BorderRadius.only(bottomLeft: Radius.circular(toDouble));
  BorderRadius get radiusBottomRight =>
      BorderRadius.only(bottomRight: Radius.circular(toDouble));

  EdgeInsets get padingTop => EdgeInsets.only(top: toDouble);
  EdgeInsets get padingLeft => EdgeInsets.only(left: toDouble);
  EdgeInsets get padingRight => EdgeInsets.only(right: toDouble);
  EdgeInsets get padingBottom => EdgeInsets.only(bottom: toDouble);
  EdgeInsets get padingVer => EdgeInsets.symmetric(vertical: toDouble);
  EdgeInsets get padingHor => EdgeInsets.symmetric(horizontal: toDouble);
  EdgeInsets get pading => EdgeInsets.all(toDouble);

  Duration get microseconds => Duration(microseconds: toInt);
  Duration get milliseconds => Duration(milliseconds: toInt);
  Duration get seconds => Duration(seconds: toInt);
  Duration get minutes => Duration(minutes: toInt);
  Duration get hours => Duration(hours: toInt);
  Duration get days => Duration(days: toInt);
}
