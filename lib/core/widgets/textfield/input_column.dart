import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/widgets/buttons/app_input.dart';
import 'package:bpg_retail/core/widgets/buttons/label_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../style_app/init_style.dart';

Widget InputColumn({
  TextEditingController? controller,
  String? label,
  bool isRequired = false,
  Function()? onTap,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Function(String)? onChanged,
  String? initialValue,
  TextInputType textInputType = TextInputType.text,
  EdgeInsets? padding,
  bool? readOnly,
  bool isPassword = false,
  List<TextInputFormatter>? inputFormatters,
  double? radius,
  int? maxLines,
  int? maxLength,
  int? minLength,
  Color? fillColor,
  String? hintText,
  ScrollPhysics? scrollPhysics,
  Function(String? value)? validate,
  TextStyle? textStyle,
  Key? key,
}) {
  return Padding(
    padding: padding ?? Dimensions.sp16.pading,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.input_label,
              ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_warning,
                    ),
                  ),
              ],
            ),
          ),
          Dimensions.sp8.height,
        ],
        AppInputV2(
          scrollPhysics: scrollPhysics,
          key: key,
          backgroundColor: fillColor,
          minLines: maxLines,
          textStyle: textStyle ?? AppStyle.bodyBsMedium,
          maxLines: maxLines,
          initialValue: initialValue,
          radius: radius ?? Dimensions.sp8,
          onChanged: onChanged,
          controller: controller,
          onTap: onTap,
          readOnly: readOnly ?? onTap != null,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText:
              hintText ??
              '${onTap != null ? "Chọn" : 'Nhập'} ${label?.toLowerCase()}',
          textInputType: textInputType,
          hintStyle: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.input_placeholderDefault,
            height: 1,
          ),
          show: !isPassword,
          inputFormatters:
              inputFormatters ??
              [
                if (TextInputType.phone == textInputType ||
                    TextInputType.number == textInputType)
                  FilteringTextInputFormatter.digitsOnly,
              ],
          validate:
              validate ??
              (value) {
                if (isRequired && value.validator.trim().isEmptyOrNull) {
                  return 'Vui lòng nhập ${label?.toLowerCase()}';
                }

                if (isRequired && value!.isNotEmpty) {
                  return value.validatorTextField(
                    type: textInputType,
                    // maxLength: maxLength,
                    minLength: minLength,
                  );
                }

                return null;
              },
        ),
      ],
    ),
  );
}

Widget InputColumn2({
  TextEditingController? controller,
  required String label,
  bool isRequired = false,
  Function()? onTap,
  Widget? prefixIcon,
  required String textSuffix,
  Widget? iconSuffix,
  Function(String)? onChanged,
  String? initialValue,
  TextInputType textInputType = TextInputType.name,
  EdgeInsets? padding,
  bool? readOnly,
  bool isPassword = false,
  List<TextInputFormatter>? inputFormatters,
  double? radius,
  int? minLines,
  Color? fillColor,
  String? hintText,
  TextStyle? textStyle,
}) {
  return Padding(
    padding: padding ?? Dimensions.sp16.pading,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppStyle.bodyBsMedium.copyWith(color: AppColors.input_label),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_brand_primary_variant2,
                  ),
                ),
            ],
          ),
        ),
        Dimensions.sp8.height,
        AppInputV2(
          backgroundColor: fillColor,
          minLines: minLines,
          maxLines: minLines,
          initialValue: initialValue,
          radius: radius ?? Dimensions.sp8,
          onChanged: onChanged,
          controller: controller,
          textStyle: textStyle ?? AppStyle.bodyBsMedium,
          onTap: onTap,
          readOnly: readOnly ?? onTap != null,
          prefixIcon: prefixIcon,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (iconSuffix != null) iconSuffix,
              const VerticalDivider(
                color: AppColors.input_borderDefault,
                thickness: 1,
                width: 0,
              ).size(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: LabelButton(
                  label: textSuffix,
                  labelStyle: AppStyle.bodySmMedium.copyWith(
                    color: AppColors.button_neutral_ghost_textDefault,
                  ),
                  padding: 12.padingHor,
                  radius: radius?.radiusRight ?? 8.radiusRight,
                  fixedSize: const Size(double.infinity, 46),
                ),
              ),
            ],
          ),
          hintText:
              hintText ??
              '${onTap != null ? "Chọn" : 'Nhập'} ${label.toLowerCase()}',
          textInputType: textInputType,
          hintStyle: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.input_placeholderDefault,
          ),
          show: !isPassword,
          inputFormatters:
              inputFormatters ??
              [
                if (TextInputType.phone == textInputType ||
                    TextInputType.number == textInputType)
                  FilteringTextInputFormatter.digitsOnly,
              ],
          validate: (value) {
            if (isRequired && value.isEmptyOrNull) {
              return 'Vui lòng nhập ${label.toLowerCase()}';
            }
            if (value!.isNotEmpty) {
              return value.validatorTextField(type: textInputType);
            }
            return null;
          },
        ),
      ],
    ),
  );
}

Widget InputColumnButon({
  TextEditingController? controller,
  String? label,
  bool isRequired = false,
  Function()? onTap,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Function(String)? onChanged,
  String? initialValue,
  TextInputType textInputType = TextInputType.text,
  EdgeInsets? padding,
  bool? readOnly,
  bool isPassword = false,
  List<TextInputFormatter>? inputFormatters,
  double? radius,
  int? minLines,
  int? maxLength,
  int? minLength,
  Color? fillColor,
  String? hintText,
  Function(String? value)? validate,
  Key? key,
  Widget? child,
}) {
  return Padding(
    padding: padding ?? Dimensions.sp16.pading,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          RichText(
            text: TextSpan(
              text: label,
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.input_label,
              ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_warning,
                    ),
                  ),
              ],
            ),
          ),
        Dimensions.sp8.height,
        child ??
            AppInputV2(
              key: key,
              backgroundColor: fillColor,
              minLines: minLines,
              maxLines: minLines,
              initialValue: initialValue,
              radius: radius ?? Dimensions.sp8,
              onChanged: onChanged,
              controller: controller,
              onTap: onTap,
              readOnly: readOnly ?? onTap != null,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText:
                  hintText ??
                  '${onTap != null ? "Chọn" : 'Nhập'} ${label?.toLowerCase()}',
              textInputType: textInputType,
              hintStyle: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.input_placeholderDefault,
              ),
              show: !isPassword,
              inputFormatters:
                  inputFormatters ??
                  [
                    if (TextInputType.phone == textInputType ||
                        TextInputType.number == textInputType)
                      FilteringTextInputFormatter.digitsOnly,
                  ],
              validate:
                  validate ??
                  (value) {
                    if (isRequired && value.validator.trim().isEmptyOrNull) {
                      return 'Vui lòng nhập ${label?.toLowerCase()}';
                    }

                    if (isRequired && value!.isNotEmpty) {
                      return value.validatorTextField(
                        type: textInputType,
                        minLength: minLength,
                      );
                    }

                    return null;
                  },
            ),
      ],
    ),
  );
}

Widget InputColumnComfirm({
  TextEditingController? controller,
  String? label,
  bool isRequired = false,
  Function()? onTap,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Function(String)? onChanged,
  Function(String)? onSubmitted, // 👈 NEW
  String? initialValue,
  TextInputType textInputType = TextInputType.text,
  TextInputAction? textInputAction, // 👈 NEW
  EdgeInsets? padding,
  bool? readOnly,
  bool isPassword = false,
  List<TextInputFormatter>? inputFormatters,
  double? radius,
  int? maxLines,
  int? maxLength,
  int? minLength,
  Color? fillColor,
  String? hintText,
  ScrollPhysics? scrollPhysics,
  Function(String? value)? validate,
  Key? key,
}) {
  return Padding(
    padding: padding ?? Dimensions.sp16.pading,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.input_label,
              ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_warning,
                    ),
                  ),
              ],
            ),
          ),
          Dimensions.sp8.height,
        ],
        AppInputV2(
          key: key,
          controller: controller,
          initialValue: initialValue,
          onChanged: onChanged,
          onConfirm: onSubmitted, // 👈 PASS DOWN
          textInputAction: textInputAction ?? TextInputAction.done, // 👈
          scrollPhysics: scrollPhysics,
          backgroundColor: fillColor,
          minLines: maxLines,
          maxLines: maxLines,
          radius: radius ?? Dimensions.sp8,
          onTap: onTap,
          readOnly: readOnly ?? onTap != null,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText:
              hintText ??
              '${onTap != null ? "Chọn" : 'Nhập'} ${label?.toLowerCase()}',
          textInputType: textInputType,
          hintStyle: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.input_placeholderDefault,
            height: 1,
          ),
          show: !isPassword,
          inputFormatters:
              inputFormatters ??
              [
                if (TextInputType.phone == textInputType ||
                    TextInputType.number == textInputType)
                  FilteringTextInputFormatter.digitsOnly,
              ],
          validate:
              validate ??
              (value) {
                if (isRequired && value.validator.trim().isEmptyOrNull) {
                  return 'Vui lòng nhập ${label?.toLowerCase()}';
                }

                if (isRequired && value!.isNotEmpty) {
                  return value.validatorTextField(
                    type: textInputType,
                    minLength: minLength,
                  );
                }

                return null;
              },
        ),
      ],
    ),
  );
}

Widget InputColumnDrop<T>({
  TextEditingController? controller,
  String? label,
  bool isRequired = false,
  Function()? onTap,
  Widget? prefixIcon,
  Function(String)? onChanged,
  String? initialValue,
  TextInputType textInputType = TextInputType.text,
  EdgeInsets? padding,
  bool? readOnly,
  bool isPassword = false,
  List<TextInputFormatter>? inputFormatters,
  double? radius,
  int? minLines,
  int? maxLength,
  int? minLength,
  Color? fillColor,
  String? hintText,
  Function(String? value)? validate,
  Key? key,

  /// dropdown
  List<DropdownMenuItem<T>>? dropdownItems,
  T? dropdownValue,
  Function(T?)? onDropdownChanged,
}) {
  return Padding(
    padding: padding ?? Dimensions.sp16.pading,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          RichText(
            text: TextSpan(
              text: label,
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.input_label,
              ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_warning,
                    ),
                  ),
              ],
            ),
          ),
        Dimensions.sp8.height,
        AppInputV2(
          key: key,
          backgroundColor: fillColor,
          minLines: minLines,
          maxLines: minLines,
          initialValue: initialValue,
          radius: radius ?? Dimensions.sp8,
          onChanged: onChanged,
          controller: controller,
          onTap: onTap,
          readOnly: readOnly ?? onTap != null,
          prefixIcon: prefixIcon,
          hintText:
              hintText ??
              '${onTap != null ? "Chọn" : "Nhập"} ${label?.toLowerCase()}',
          textInputType: textInputType,
          hintStyle: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.input_placeholderDefault,
          ),
          show: !isPassword,
          inputFormatters:
              inputFormatters ??
              [
                if (TextInputType.phone == textInputType ||
                    TextInputType.number == textInputType)
                  FilteringTextInputFormatter.digitsOnly,
              ],
          validate:
              validate ??
              (value) {
                if (isRequired && value.validator.trim().isEmptyOrNull) {
                  return 'Vui lòng nhập ${label?.toLowerCase()}';
                }
                if (isRequired && value!.isNotEmpty) {
                  return value.validatorTextField(
                    type: textInputType,
                    minLength: minLength,
                  );
                }
                return null;
              },
          suffixIcon:
              dropdownItems != null
                  ? IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 1.5, color: Colors.grey),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(radius ?? 8),
                              bottomRight: Radius.circular(radius ?? 8),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButton<T>(
                            value: dropdownValue,
                            underline: const SizedBox(),
                            dropdownColor: Colors.white,
                            items: dropdownItems,
                            onChanged: onDropdownChanged,
                          ),
                        ),
                      ],
                    ),
                  )
                  : null,
        ),
      ],
    ),
  );
}

Widget InputColumnV2({
  TextEditingController? controller,
  required String label,
  bool isRequired = false,
  Function()? onTap,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Function(String)? onChanged,
  Function(String)? onConfirm,
  Function()? onTapOutside,
  String? initialValue,
  TextInputType textInputType = TextInputType.text,
  EdgeInsets? padding,
  bool? readOnly,
  bool isPassword = false,
  List<TextInputFormatter>? inputFormatters,
  double? radius,
  int? minLines,
  int? maxLength,
  int? minLength,
  Color? fillColor,
  String? hintText,
  Function(String? value)? validate,
  Key? key,
}) {
  return Padding(
    padding: padding ?? Dimensions.sp16.pading,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppStyle.bodyBsMedium.copyWith(color: AppColors.input_label),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_warning,
                  ),
                ),
            ],
          ),
        ),
        Dimensions.sp8.height,
        AppInputV2(
          key: key,
          backgroundColor: fillColor,
          minLines: minLines,
          maxLines: minLines,
          initialValue: initialValue,
          radius: radius ?? Dimensions.sp8,
          onChanged: onChanged,
          onConfirm: onConfirm,
          onTapOutside: onTapOutside,
          controller: controller,
          onTap: onTap,
          readOnly: readOnly ?? onTap != null,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText:
              hintText ??
              '${onTap != null ? "Chọn" : 'Nhập'} ${label.toLowerCase()}',
          textInputType: textInputType,
          hintStyle: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.input_placeholderDefault,
          ),
          show: !isPassword,
          inputFormatters:
              inputFormatters ??
              [
                if (TextInputType.phone == textInputType ||
                    TextInputType.number == textInputType)
                  FilteringTextInputFormatter.digitsOnly,
              ],
          validate:
              validate ??
              (value) {
                if (isRequired && value.validator.trim().isEmptyOrNull) {
                  return 'Vui lòng nhập ${label.toLowerCase()}';
                }

                if (isRequired && value!.isNotEmpty) {
                  return value.validatorTextField(
                    type: textInputType,
                    // maxLength: maxLength,
                    minLength: minLength,
                  );
                }

                return null;
              },
        ),
      ],
    ),
  );
}
