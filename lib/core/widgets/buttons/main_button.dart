import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/init_ext.dart';

class MainButton extends StatefulWidget {
  final String? title;
  final VoidCallback? onTap;
  final bool largeButton;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final bool isDisable;
  final bool isLoad;
  final double radius;
  final Color? loadColor;

  const MainButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.largeButton = true,
    this.icon,
    this.padding,
    this.radius = 8,
    this.isDisable = false,
    this.isLoad = false,
    this.loadColor,
  }) : super(key: key);

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool canPress = true;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor:
            widget.isDisable ? AppColors.main.withOpacity(0.6) : AppColors.main,
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
      onPressed:
          widget.isLoad || !canPress || widget.isDisable
              ? null
              : () {
                canPress = false;
                widget.onTap?.call();
                Future.delayed(300.milliseconds, () => canPress = true);
              },
      child:
          widget.isLoad
              ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: widget.loadColor ?? Colors.white,
                ),
              ).size(height: 20, width: 20)
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
                        style: (widget.largeButton
                                ? AppTypography.h6
                                : AppTypography.p5)
                            .copyWith(color: AppColors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
    );
  }
}
