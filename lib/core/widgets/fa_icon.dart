import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:flutter/cupertino.dart';

enum FaIconType {
  thin(FontWeight.w100),
  light(FontWeight.w300),
  regular(FontWeight.w400),
  solid(FontWeight.w900);

  final FontWeight weight;
  const FaIconType(this.weight);
}

Widget FaIcon({
  required String iconCode,
  Color? color,
  double size = 16,
  FaIconType type = FaIconType.regular,
}) {
  return Text(
    String.fromCharCode(int.parse(iconCode, radix: 16)),
    style: TextStyle(
      fontFamily: 'FontAwesome',
      color: color ?? AppColors.text_tertiary,
      fontSize: size,
      fontWeight: type.weight,
    ),
    textAlign: TextAlign.center,
  );
}

abstract class CalendarFaIcon {
  static Widget day = FaIcon(iconCode: 'f783');
  static Widget week = FaIcon(iconCode: 'f784');
  static Widget month = FaIcon(iconCode: 'e0d5');
  static Widget range = FaIcon(iconCode: 'e0d6');
}

abstract class ArrowFaIcon {
  static Widget right = FaIcon(iconCode: 'f105');
  static Widget left = FaIcon(iconCode: 'f104');
}

abstract class CommonFaIcon {
  static Widget wallet = FaIcon(iconCode: 'f555');
  static Widget upload = FaIcon(iconCode: 'f093');
  static Widget camera = FaIcon(iconCode: 'f030');
}
