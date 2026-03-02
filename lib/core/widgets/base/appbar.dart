import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    this.backgroundColor,
    this.title = '',
    this.textStyle,
    this.onTap,
    this.leadingIcon,
    this.hasBack = true,
    this.trailingIcons,
    this.iconColor,
    this.centerTitle = false,
    this.hasLeading = true,
    this.iconTheme,
    this.titleWidget,
    this.titleSpacing,
    this.leadingWidth,
  }) : super(key: key);

  final Color? backgroundColor;
  final String title;
  final Widget? titleWidget;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final Widget? leadingIcon;
  final bool hasBack;
  final double? titleSpacing;
  final double? leadingWidth;
  final List<Widget>? trailingIcons;
  final Color? iconColor;
  final bool centerTitle;
  final bool hasLeading;
  final IconThemeData? iconTheme;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      backgroundColor: backgroundColor ?? AppColors.white,
      title:
          titleWidget ??
          Text(
            title,
            style:
                textStyle ??
                AppTypography.h5.copyWith(color: AppColors.blackish),
          ),
      leading:
          hasLeading
              ? GestureDetector(
                onTap: () {
                  if (hasBack) {
                    Navigator.pop(context);
                  } else {
                    onTap?.call();
                  }
                },
                child:
                    leadingIcon ??
                    Icon(
                      Icons.arrow_back_rounded,
                      color: iconColor ?? AppColors.blackish,
                    ),
              )
              : null,
      iconTheme: iconTheme ?? IconThemeData(color: backgroundColor),
      actions: trailingIcons,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
