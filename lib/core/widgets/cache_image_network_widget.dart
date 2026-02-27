import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

import 'base/base_loading.dart';

class CacheNetworkImageWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit? fit;

  const CacheNetworkImageWidget({
    super.key,
    this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child:
          url.nullOrEmpty
              ? Assets.images.logo.image(
                width: width ?? 61,
                height: height ?? 61,
                fit: BoxFit.contain,
              )
              : CachedNetworkImage(
                imageUrl: url ?? "",
                width: width ?? 61,
                height: height ?? 61,
                fit: fit ?? BoxFit.cover,
                placeholder:
                    (context, url) => Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Assets.images.placeHolderImage.image(
                            width: width ?? 61,
                            height: height ?? 61,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Center(child: CupertinoActivityIndicator()),
                      ],
                    ),
                errorWidget:
                    (context, url, error) => Assets.images.logo.image(
                      width: width ?? 61,
                      height: height ?? 61,
                      fit: BoxFit.contain,
                    ),
              ),
    );
  }
}

class CacheNetworkImageV2 extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit? fit;
  final Widget? errorWidget;
  final bool showLoad;
  // final bool? showBorder;

  const CacheNetworkImageV2({
    super.key,
    this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.errorWidget,
    this.showLoad = false,
    // this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: (borderRadius ?? 8).radius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            // border: Border.all(
            //   color: showBorder == true ? AppColors.grey_1 : AppColors.white,
            //   width: showBorder == true ? 1 : 0,
            // ),
          ),
          child:
              url.nullOrEmpty
                  ? Assets.images.logo.image(
                    width: width ?? 61,
                    height: height ?? 61,
                    fit: BoxFit.contain,
                  )
                  : ClipRRect(
                    borderRadius: (borderRadius ?? 8).radius,
                    child: CachedNetworkImage(
                      imageUrl: url ?? "",
                      width: width ?? 61,
                      height: height ?? 61,
                      fit: fit ?? BoxFit.cover,
                      placeholder:
                          (context, url) => Stack(
                            children: [
                              Visibility(
                                visible: !showLoad,
                                child: Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Assets.images.logo.image(
                                    width: width ?? 61,
                                    height: height ?? 61,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Center(
                                child:
                                    showLoad
                                        ? SizedBox(
                                          width: width,
                                          height: width,
                                          child:
                                              const CircularProgressIndicator(
                                                color: AppColors.main,
                                              ),
                                        )
                                        : const CupertinoActivityIndicator(),
                              ),
                            ],
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                borderRadius ?? 8,
                              ),
                              border: Border.all(color: AppColors.border_1),
                            ),
                            child:
                                errorWidget ??
                                Assets.images.logo.image(
                                  width: width ?? 61,
                                  height: height ?? 61,
                                  fit: BoxFit.contain,
                                ),
                          ),
                    ),
                  ),
        ),
      ),
    );
  }
}

class CacheNetworkImageV3 extends StatelessWidget {
  final String? url;

  const CacheNetworkImageV3({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return url.nullOrEmpty
        ? Assets.images.logo.image(height: 60, width: 60, fit: BoxFit.contain)
        : CachedNetworkImage(
          imageUrl: url ?? "",
          width: 120,
          fit: BoxFit.contain,
          placeholder:
              (context, url) =>
                  const Center(child: CupertinoActivityIndicator()),
          // Stack(
          //   children: [
          //     Positioned(
          //       top: 0,
          //       left: 0,
          //       right: 0,
          //       bottom: 0,
          //       child: Assets.images.logo.image(
          //         height: 60,
          //         width: 60,
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //     const Center(
          //       child: CupertinoActivityIndicator(),
          //     ),
          //   ],
          // ),
          errorWidget:
              (context, url, error) => Assets.images.logo.image(
                height: 60,
                width: 60,
                fit: BoxFit.contain,
              ),
        );
  }
}

Widget imageNetWork({
  required String path,
  double? width,
  double? height,
  Color? color,
  BoxFit fit = BoxFit.contain,
  BorderRadius radius = BorderRadius.zero,
  Widget? errorWidget,
  Widget? placeholder,
}) {
  return CachedNetworkImage(
    imageUrl: path,
    height: height,
    width: width,
    color: color,
    fit: fit,
    placeholder:
        (context, url) => placeholder ?? const Center(child: BaseLoading()),
    errorWidget:
        (context, url, error) =>
            errorWidget ??
            const ColoredBox(
              color: AppColors.white,
              child: Center(child: Icon(Icons.hide_image_outlined)),
            ),
  ).radius(radius);
}
