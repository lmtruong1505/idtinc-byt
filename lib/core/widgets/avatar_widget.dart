import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/utilities/assets.dart';

class AvatarWidget extends StatelessWidget {
  final String url;
  final double? size;
  final bool? isEdit;
  final Function()? onTap;

  const AvatarWidget({
    super.key,
    required this.url,
    this.size,
    this.isEdit = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        url.isEmpty
            ? _defaultImage()
            : CachedNetworkImage(
              imageUrl: url,
              width: size ?? 32,
              height: size ?? 32,
              fit: BoxFit.cover,
              imageBuilder: (_, provider) {
                return Container(
                  width: size ?? 32,
                  height: size ?? 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: provider, fit: BoxFit.cover),
                    border: Border.all(color: AppColors.white, width: 0),
                  ),
                );
              },
              memCacheWidth: 500,
              progressIndicatorBuilder: (_, __, ___) {
                return _defaultImage();
              },
              errorWidget: (_, __, ___) {
                return _defaultImage();
              },
            ),
        // if (isEdit ?? false)
        //   Positioned(
        //     bottom: 0,
        //     right: 0,
        //     left: 0,
        //     top: 0,
        //     child: BaseButton(
        //       onTap: onTap,
        //       child: SizedBox(
        //         width: 15,
        //         height: 15,
        //         child: Assets.icons.avatar.image(
        //           width: 15,
        //           height: 15,
        //           scale: 2,
        //           color: AppColors.white,
        //           fit: BoxFit.scaleDown,
        //         ),
        //       ),
        //     ),
        //   ),
        // if (isEdit ?? false)
        //   Positioned(
        //     bottom: 0,
        //     right: 0,
        //     child: BaseButton(
        //       onTap: onTap,
        //       child: Assets.icons.icCamera.svg(
        //         width: (size ?? 32.w) / 3,
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  ClipRRect _defaultImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular((size ?? 32) / 2),
      child: Assets.icon(
        assetName: 'avatar_default.svg',
        width: size ?? 32,
        height: size ?? 32,
      ),
    );
  }
}
