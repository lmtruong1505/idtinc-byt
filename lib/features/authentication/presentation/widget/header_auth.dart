import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';

class HeaderAuthForm extends StatelessWidget {
  const HeaderAuthForm({this.height, this.width, this.isPaddingTop, super.key});
  final double? width;
  final double? height;
  final double? isPaddingTop;
  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        paddingTop.height,
        isPaddingTop?.height ?? 190.height,
        Image.asset(
          'assets/images/TASA_logo.png',
          width: width ?? 198,
          height: height ?? 100,
        ),
      ],
    );
  }
}
