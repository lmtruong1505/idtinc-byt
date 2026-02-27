import 'package:bpg_retail/core/core.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';

class BtnIcon extends StatelessWidget {
  final double radius;
  final Widget icon;
  final Function()? onTap;
  final Size? size;
  final Color? borderColor;
  final Color? color;
  final bool hasData;
  const BtnIcon({
    super.key,
    required this.icon,
    this.radius = 8,
    this.onTap,
    this.size,
    this.borderColor,
    this.color,
    this.hasData = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size?.width,
            height: size?.height,
            // clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor ?? color ?? Colors.white,
                width: 1,
              ),
              color: color ?? Colors.white,
              borderRadius: radius.radius,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(child: icon),
          ),
          Visibility(
            visible: hasData,
            child: Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.main,
                  shape: BoxShape.circle,
                ),
                width: 6,
                height: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
