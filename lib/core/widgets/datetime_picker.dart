import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/utilities/converts.dart';

class DatetimePicker extends StatelessWidget {
  const DatetimePicker({
    super.key,
    this.showTitleActions = true,
    this.locale = LocaleType.vi,
    required this.onConfirm,
    this.defaultValue,
    this.valueStyle,
    this.decoration,
    this.hintStyle,
    this.startDate,
    this.hintText,
    this.padding,
    this.endDate,
    this.icon,
  });

  final Function(DateTime date) onConfirm;
  final EdgeInsetsGeometry? padding;
  final bool? showTitleActions;
  final Decoration? decoration;
  final TextStyle? valueStyle;
  final TextStyle? hintStyle;
  final String? defaultValue;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? hintText;
  final dynamic locale;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final bool isNotEmpty = defaultValue != null && defaultValue!.isNotEmpty;

    final DateTime dateNow = DateTime.now();
    final currentTime =
        isNotEmpty ? stringToDate(defaultValue!, isDDMMYY: false) : null;
    final int lastday = DateTime(dateNow.year, dateNow.month + 1, 0).day;

    final DateTime maxDate = DateTime(dateNow.year, dateNow.month, lastday);
    final DateTime minDate = DateTime(1900);

    final TextStyle textStyle =
        !isNotEmpty
            ? valueStyle ?? AppTypography.p6.copyWith(color: AppColors.grey_1)
            : hintStyle ?? AppTypography.p5;

    final textPreview = isNotEmpty ? defaultValue! : hintText ?? 'Lựa chọn';

    const EdgeInsetsGeometry defaultPadding = EdgeInsets.only(
      left: 12,
      right: 12,
      bottom: 15.5,
      top: 16.5,
    );

    final Decoration defaultDecoration = BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.border_2, width: 1.2),
    );

    return GestureDetector(
      onTap: () async {
        DatePicker.showDatePicker(
          context,
          currentTime: currentTime,
          showTitleActions: showTitleActions!,
          minTime: endDate ?? minDate,
          maxTime: startDate ?? maxDate,
          onConfirm: onConfirm,
          locale: locale,
        );
      },
      child: Container(
        width: double.infinity,
        padding: padding ?? defaultPadding,
        decoration: decoration ?? defaultDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(textPreview, style: textStyle, maxLines: 1)),
            icon ?? const Icon(Icons.calendar_today, size: 16),
          ],
        ),
      ),
    );
  }
}
