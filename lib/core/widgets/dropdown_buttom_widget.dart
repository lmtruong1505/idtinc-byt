import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';

class DropdownButtonWidget<T> extends StatelessWidget {
  const DropdownButtonWidget({
    super.key,
    required this.hintText,
    required this.text,
    required this.onChanged,
    required this.items,
    this.radius = 8,
    this.value,
    this.maxHeightDropdown,
    this.maxWidthDropdown,
  });

  final String hintText;
  final String? text;
  final double radius;
  final double? maxHeightDropdown;
  final double? maxWidthDropdown;
  final T? value;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;

  @override
  Widget build(BuildContext context) {
    final itemsWithDividers = <DropdownMenuItem<T>>[];
    for (var i = 0; i < (items?.length ?? 0); i++) {
      final item = items?[i];
      itemsWithDividers.add(
        DropdownMenuItem<T>(
          value: item?.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item!.child,
              // chỉ hiển divider nếu không phải là mục cuối cùng
              if (i < (items?.length ?? 0) - 1)
                const Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 4),
                  child: Divider(height: 1, thickness: 1),
                ),
            ],
          ),
        ),
      );
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        value: value,
        isExpanded: true,
        hint: Text(
          text != null ? text! : hintText,
          style:
              text != null
                  ? AppTypography.p5.copyWith(color: AppColors.black)
                  : AppTypography.p6.copyWith(color: AppColors.grey_1),
          maxLines: 1,
        ),
        items: items,
        onChanged: onChanged,
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_rounded),
          openMenuIcon: Icon(Icons.keyboard_arrow_up_rounded),
          iconSize: 24,
        ),
        buttonStyleData: ButtonStyleData(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.border_2, width: 1.2),
          ),
          padding: const EdgeInsets.only(left: 12, right: 12, top: 1),
          width: double.infinity,
        ),
        menuItemStyleData: const MenuItemStyleData(height: 45),
        dropdownStyleData: DropdownStyleData(
          maxHeight: maxHeightDropdown,
          width: maxWidthDropdown,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          offset: const Offset(0, -2),
          scrollbarTheme: ScrollbarThemeData(
            radius: Radius.circular(radius),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
      ),
    );
  }
}
