import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/extension/string_extension.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/gen/assets.gen.dart';

class CacheAvatarImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit? fit;
  final Widget? errorWidget;

  const CacheAvatarImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final wD = width ?? 61;
    final he = height ?? 61;
    return SizedBox(
      width: wD,
      height: he,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        child:
            url.nullOrEmpty
                ? Container(
                  width: wD,
                  height: he,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius ?? 8),
                    border: Border.all(color: AppColors.border_1),
                  ),
                  child: Assets.icons.avatarDefault.svg(
                    width: wD,
                    height: he,
                    fit: BoxFit.cover,
                  ),
                )
                : BaseContainer(
                  width: wD,
                  height: he,
                  borderColor: AppColors.greyA7,
                  borderRadius: borderRadius,
                  color: AppColors.white,
                  child: CachedNetworkImage(
                    imageUrl: url ?? "",
                    width: wD,
                    height: he,
                    fit: fit ?? BoxFit.cover,
                    placeholder:
                        (context, url) => Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Assets.icons.avatarDefault.svg(
                                width: wD,
                                height: he,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Center(child: CupertinoActivityIndicator()),
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
                              Assets.icons.avatarDefault.svg(
                                width: wD,
                                height: he,
                                fit: BoxFit.contain,
                              ),
                        ),
                  ),
                ),
      ),
    );
  }
}
