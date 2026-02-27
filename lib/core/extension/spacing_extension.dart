import 'package:flutter/material.dart';

extension SpaceExtension on int {
  Widget get height {
    return SizedBox(height: toDouble());
  }

  Widget get width {
    return SizedBox(width: toDouble());
  }
}
