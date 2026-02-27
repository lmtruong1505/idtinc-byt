import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';

class ExtraButton extends StatefulWidget {
  final String? title;
  final VoidCallback? onTap;
  final bool largeButton;
  final bool isLoading;
  final Color? borderColor;
  final Widget? icon;
  final Color? bgColor;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double radius;

  const ExtraButton({
    Key? key,
    this.title,
    required this.onTap,
    this.largeButton = true,
    this.borderColor,
    this.icon,
    this.bgColor,
    this.color,
    this.padding,
    this.textStyle,
    this.radius = 30,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ExtraButton> createState() => _ExtraButtonState();
}

class _ExtraButtonState extends State<ExtraButton> {
  bool canPress = true;
  @override
  Widget build(BuildContext context) {
    final buttonTypography =
        widget.textStyle ??
        (widget.largeButton ? AppTypography.h6 : AppTypography.p5);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor:
            widget.isLoading
                ? AppColors.grey_1
                : widget.bgColor ?? AppColors.white,
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        side: BorderSide(
          color:
              widget.isLoading
                  ? AppColors.grey_1
                  : widget.borderColor ?? AppColors.border_2,
          width: 1.2,
        ),
      ),
      onPressed:
          widget.isLoading || !canPress
              ? null
              : () {
                canPress = false;
                widget.onTap?.call();
                Future.delayed(300.milliseconds, () => canPress = true);
              },
      child:
          widget.isLoading
              ? const SizedBox(
                height: 16,
                width: 16,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.icon ?? const SizedBox.shrink(),
                  if (widget.icon != null && widget.title != null)
                    const SizedBox(width: 8),
                  if (widget.title != null)
                    Flexible(
                      child: Text(
                        '${widget.title}',
                        style: buttonTypography.copyWith(
                          color: widget.color ?? AppColors.blackish,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
    );
  }
}

class ExtraButtonV2 extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final bool largeButton;
  final bool isDissemble;
  final Color? borderColor;
  final Widget? icon;
  final Color? bgColor;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? borderRadius;

  const ExtraButtonV2({
    Key? key,
    this.title,
    this.onTap,
    required this.largeButton,
    this.borderColor,
    this.icon,
    this.bgColor,
    this.color,
    this.padding,
    this.textStyle,
    this.isDissemble = false,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonTypography =
        textStyle ?? (largeButton ? AppTypography.h6 : AppTypography.p5);
    final backgroundColor =
        isDissemble
            ? AppColors.grey_1.withOpacity(0.5)
            : bgColor ?? AppColors.white;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 30),
        ),
        side: BorderSide(color: backgroundColor, width: 1.2),
      ),
      onPressed: isDissemble ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? const SizedBox.shrink(),
          if (icon != null && title != null) const SizedBox(width: 8),
          if (title != null)
            Flexible(
              child: Text(
                '$title',
                style: buttonTypography.copyWith(
                  color:
                      isDissemble
                          ? AppColors.border_1
                          : color ?? AppColors.blackish,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
