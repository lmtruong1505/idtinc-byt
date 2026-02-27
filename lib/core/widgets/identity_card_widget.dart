import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/core/widgets/cache_image_network_widget.dart';

class IdentityCardWidget extends StatelessWidget {
  final ImageIdentityTypeEnum type;
  final String? path;
  final Function() onTap;
  const IdentityCardWidget({
    super.key,
    required this.type,
    this.path,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: const [2, 2],
        color: AppColors.main,
        radius: const Radius.circular(8),
        padding: const EdgeInsets.all(6),
        child: path.nullOrEmpty ? _Card(type: type) : _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.main,
          image: DecorationImage(
            image: FileImage(File(path!)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class IdentityCardWidgetV2 extends StatelessWidget {
  final ImageIdentityTypeEnum type;
  final String? path;
  final String? url;
  final Function()? onTap;
  const IdentityCardWidgetV2({
    super.key,
    required this.type,
    this.url,
    this.path,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: const [2, 2],
        color: AppColors.main,
        radius: const Radius.circular(8),
        padding: const EdgeInsets.all(6),
        child: path.nullOrEmpty ? _CardV2(url: url, type: type) : _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.main,
          image: DecorationImage(
            image: FileImage(File(path!)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final ImageIdentityTypeEnum type;
  const _Card({required this.type});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Center(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, color: AppColors.main),
              6.height,
              Text(
                type == ImageIdentityTypeEnum.front ? "Mặt trước" : "Mặt sau",
                style: s16w500.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardV2 extends StatelessWidget {
  final ImageIdentityTypeEnum type;
  final String? url;
  const _CardV2({required this.type, required this.url});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Center(
        child: CacheNetworkImageWidget(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 6,
          url: url,
        ),
      ),
    );
  }
}

enum ImageIdentityTypeEnum { front, back, other }
