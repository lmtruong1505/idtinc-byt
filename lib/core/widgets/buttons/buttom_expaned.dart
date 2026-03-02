import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/extension/init_ext.dart';

import '../../constants/typography.dart';
import '../expanded_section.dart';

class ButtomExpaned extends StatefulWidget {
  final Widget? child;
  final Function()? onTap;
  final String title;
  const ButtomExpaned({super.key, required this.title, this.child, this.onTap});

  @override
  State<ButtomExpaned> createState() => _ButtomExpanedState();
}

class _ButtomExpanedState extends State<ButtomExpaned> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.child == null
              ? widget.onTap
              : () {
                isSelected = !isSelected;
                setState(() {});
              },
      child: Container(
        padding: 16.padingVer + 16.padingLeft + 8.padingRight,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: 8.radius,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: !isSelected ? s16w400 : s16w500,
                ).expanded(),
                16.width,
                Icon(
                  widget.child != null
                      ? isSelected
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded
                      : Icons.arrow_forward_ios_rounded,
                  size: widget.child != null ? null : 16,
                ),
                if (widget.child == null) 4.width,
              ],
            ),
            if (widget.child != null)
              ExpandedSection(
                isSelected: isSelected,
                child: widget.child!.padding(8.padingRight),
              ),
          ],
        ),
      ),
    );
  }
}
