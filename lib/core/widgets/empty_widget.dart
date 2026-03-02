import 'package:flutter/material.dart';
import 'package:tasa/core/constants/typography.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title ?? "Chưa có sản phẩm", style: s16w500));
  }
}
