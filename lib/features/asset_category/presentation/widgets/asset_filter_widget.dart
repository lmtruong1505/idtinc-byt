import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/core.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:flutter/material.dart';

class AssetFilterWidget extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onSearchChanged;

  const AssetFilterWidget({super.key, this.onFilterTap, this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.padingHor + 12.padingVer,
      child: Row(
        children: [
          Expanded(
            child: ValidateTextField(
              padding: 14.pading,
              margin: EdgeInsets.zero,
              backgroundColor: AppColors.white,
              hintText: 'Tìm kiếm',
              hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
              leadingIcon: Padding(
                padding: 6.padingRight,
                child: const Icon(Icons.search, size: 22),
              ),
              maxLines: 1,
              onChanged: (value) {
                onSearchChanged?.call(value);
              },
            ),
          ),
          12.width,
          InkWell(
            onTap: () => context.router.push(const QRScanRoute()),
            child: BaseContainer(
              width: 48,
              height: 48,
              isCircle: true,
              color: AppColors.greyE2.withOpacity(0.5),
              child: const Center(
                child: Icon(Icons.qr_code_scanner, color: AppColors.black),
              ),
            ),
          ),
          12.width,
          InkWell(
            onTap: onFilterTap,
            child: BaseContainer(
              width: 48,
              height: 48,
              isCircle: true,
              color: AppColors.greyE2.withOpacity(0.5),
              child: const Center(
                child: Icon(Icons.filter_list, color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
