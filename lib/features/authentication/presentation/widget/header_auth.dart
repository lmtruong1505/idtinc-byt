import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
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
        Assets.images.logo.image(width: width ?? 198, height: height ?? 100),
      ],
    );
  }
}
