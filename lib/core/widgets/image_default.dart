import 'package:flutter/material.dart';
import 'package:tasa/gen/assets.gen.dart';

class ImageLogoLgDefault extends StatelessWidget {
  const ImageLogoLgDefault({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Assets.images.logo.image(
      width: width ?? 61,
      height: height ?? 61,
      fit: BoxFit.cover,
    );
  }
}
