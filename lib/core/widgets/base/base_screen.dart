import 'package:flutter/material.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/widgets/text_title.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

import '../../constants/colors.dart';
import '../buttons/extra_button.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final AppBar? appBar;
  final bool isBottom;
  final bool isImageBg;
  final double padding;
  final void Function()? onTap;
  final Color? backgroundColor;
  const BaseScreen({
    super.key,
    required this.title,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.isImageBg = true,
    this.isBottom = true,
    this.padding = 0,
    this.onTap,
    this.backgroundColor = AppColors.bg_6,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        appBar:
            appBar ??
            AppBar(
              elevation: 1,
              backgroundColor: AppColors.white,
              leading: const SizedBox(),
              leadingWidth: 0,
              centerTitle: false,
              title:
                  isBottom
                      ? ExtraButton(
                        onTap:
                            onTap ??
                            () {
                              context.pop();
                            },
                        largeButton: false,
                        title: 'Trở lại',
                        radius: 12,
                        icon: Assets.icons.icArrowLeftCalendar.svg(height: 16),
                        padding: 12.padingHor + 6.padingVer,
                      )
                      : TextTitel(title: title),
              bottom:
                  isBottom
                      ? PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: TextTitel(title: title).padding(16.pading),
                      )
                      : null,
            ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (isImageBg) Assets.images.bgScreen.image(fit: BoxFit.cover),
            Container(
              padding: EdgeInsets.all(padding),
              width: context.width,
              height: context.height,
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
