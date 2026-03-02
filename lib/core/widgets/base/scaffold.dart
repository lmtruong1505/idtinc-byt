import 'dart:io';

import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/utilities/assets.dart';
import 'package:tasa/core/utilities/screens.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    Key? key,
    this.backgroundColor,
    this.body,
    this.resizeToAvoidBottomInset,
    this.appBar,
    this.bottomNavigationBar,
    this.backgroundImage = true,
    this.backgroundImageSecond = false,
    this.height,
    this.paddingTop = true,
    this.paddingTopAppBar = false,
  }) : super(key: key);

  final Color? backgroundColor;
  final Widget? body;
  final bool? resizeToAvoidBottomInset;
  final bool? backgroundImage;
  final bool? backgroundImageSecond;
  final bool? paddingTop;
  final bool? paddingTopAppBar;
  final Widget? appBar;
  final Widget? bottomNavigationBar;
  final double? height;

  double get plusHeight {
    if (Platform.isAndroid) {
      return 26;
    } else if (Platform.isIOS) {
      return 50;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: backgroundColor ?? AppColors.white,
          bottomNavigationBar: bottomNavigationBar,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              height ??
                  (paddingTopAppBar == true
                      ? AppBar().preferredSize.height + plusHeight
                      : AppBar().preferredSize.height),
            ),
            child: Padding(
              padding:
                  paddingTopAppBar == true
                      ? EdgeInsets.only(top: plusHeight)
                      : EdgeInsets.zero,
              child: appBar != null ? appBar! : const SizedBox.shrink(),
            ),
          ),
          body: Stack(
            children: [
              if (backgroundImage == true)
                Positioned.fill(
                  child: Assets.image(
                    assetName:
                        backgroundImageSecond == true
                            ? "background_1.png"
                            : "background_1.png",
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              Container(
                padding:
                    paddingTop == true
                        ? EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top,
                        )
                        : EdgeInsets.zero,
                width: double.infinity,
                height: heightDevice(context),
                child: body ?? const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
