import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';

class DropdownButtonModel {
  final String label;
  final dynamic value;
  final dynamic custom;
  final bool? enabled;

  DropdownButtonModel({
    required this.label,
    required this.value,
    this.custom,
    this.enabled,
  });

  DropdownButtonModel copyWith({
    String? label,
    dynamic value,
    dynamic custom,
    dynamic enabled,
  }) {
    return DropdownButtonModel(
      label: label ?? this.label,
      value: value ?? this.value,
      custom: custom ?? this.custom,
      enabled: enabled ?? this.enabled,
    );
  }
}

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isExpanded,
    this.iconStyleData,
    this.buttonStyleData,
    this.menuItemStyleData,
    this.dropdownStyleData,
    this.maxLines,
  });

  final dynamic value;
  final String? hintText;
  final List<DropdownButtonModel> items;
  final Function(DropdownButtonModel?) onChanged;

  final bool? isExpanded;
  final IconStyleData? iconStyleData;
  final ButtonStyleData? buttonStyleData;
  final MenuItemStyleData? menuItemStyleData;
  final DropdownStyleData? dropdownStyleData;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final previewSelected = items.firstWhere(
      (e) => e.value == value,
      orElse:
          () => DropdownButtonModel(label: hintText ?? "Lựa chọn", value: null),
    );

    return DropdownButtonHideUnderline(
      child: DropdownButton2<DropdownButtonModel>(
        isExpanded: isExpanded != null ? isExpanded! : true,
        hint: Text(
          previewSelected.label,
          style:
              previewSelected.value == null
                  ? AppTypography.p6.copyWith(color: AppColors.grey_1)
                  : AppTypography.p5.copyWith(color: AppColors.blackish),
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines ?? 1,
        ),
        items:
            items.map((item) {
              return DropdownMenuItem(
                value: item,
                enabled: item.enabled ?? true,
                child: Text(
                  item.label,
                  style: AppTypography.p5.copyWith(
                    color:
                        [true, null].contains(item.enabled)
                            ? AppColors.blackish
                            : AppColors.grey_1,
                  ),
                  textAlign: TextAlign.right,
                ),
              );
            }).toList(),
        onChanged: (value) {
          onChanged(value);
        },
        iconStyleData:
            iconStyleData != null
                ? iconStyleData!
                : const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  openMenuIcon: Icon(Icons.keyboard_arrow_up_rounded),
                  iconSize: 26,
                ),
        buttonStyleData:
            buttonStyleData != null
                ? buttonStyleData!
                : ButtonStyleData(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border_2, width: 1.2),
                  ),
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  width: double.infinity,
                ),
        menuItemStyleData:
            menuItemStyleData != null
                ? menuItemStyleData!
                : const MenuItemStyleData(height: 36),
        dropdownStyleData:
            dropdownStyleData != null
                ? dropdownStyleData!
                : DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  offset: const Offset(0, -2),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all(6),
                    thumbVisibility: WidgetStateProperty.all(true),
                  ),
                ),
      ),
    );
  }
}
