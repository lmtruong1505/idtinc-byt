import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasa/core/extension/init_ext.dart';

import '../../gen/assets.gen.dart';

class BannerAsbc extends StatelessWidget {
  const BannerAsbc({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Assets.images.bannerAsbc.image(
          height: 185 + context.padding.top,
          fit: BoxFit.cover,
        ),
        Assets.images.logo
            .image(width: 56, height: 56)
            .padding(16.padingBottom),
        if (Navigator.canPop(context))
          Positioned(
            top: context.padding.top,
            left: 16,
            child: SizedBox(
              width: 38,
              height: 38,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
