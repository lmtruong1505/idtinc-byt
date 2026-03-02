import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/init_ext.dart';

class FilterButtonModel {
  final String title;
  final dynamic value;
  final Icon? icon;
  final dynamic badges;

  const FilterButtonModel({
    required this.title,
    required this.value,
    this.badges,
    this.icon,
  });

  factory FilterButtonModel.fromJson(Map<String, dynamic> json) =>
      FilterButtonModel(
        title: json["title"],
        value: json["value"],
        icon: json["icon"],
        badges: json["badges"],
      );
}

class FilterButton extends StatelessWidget {
  final List<FilterButtonModel> listFilter;
  final FilterButtonModel selectFilter;
  final Function(FilterButtonModel item) handleSelectFilter;
  final Color? defaultColor;
  final ScrollController? scrollController;

  const FilterButton({
    super.key,
    required this.listFilter,
    required this.selectFilter,
    required this.handleSelectFilter,
    this.defaultColor = AppColors.border_1,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      separatorBuilder: (context, index) => const SizedBox(width: 8),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final filter = listFilter[index];
        final isSelect = filter.value == selectFilter.value;
        return InkWell(
          onTap: () => handleSelectFilter(filter),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: 8.radius),
            color: isSelect ? AppColors.accent_5 : defaultColor,
            child: Center(
              child: Text(
                filter.title,
                style: AppTypography.p5.copyWith(
                  color: isSelect ? AppColors.white : AppColors.grey_1,
                  height: 1,
                ),
              ).padding(10.pading),
            ),
          ),
        );
      },
      itemCount: listFilter.length,
    );
  }
}
