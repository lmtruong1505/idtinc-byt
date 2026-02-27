import 'package:flutter/material.dart';
import 'package:bpg_retail/core/check_version/check_vesion.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/utilities/launch_url.dart';
import "package:bpg_retail/core/widgets/buttons/main_button.dart";

class UpdateAppDialog extends StatelessWidget {
  final ModelVersion version;
  const UpdateAppDialog({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: 16.radius,
          color: AppColors.white,
        ),
        padding: 16.pading,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x21000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  // child: SvgPicture.asset(Assets.i),
                ),
              ],
            ),
            16.height,
            Text('Cập nhật ứng dụng?', style: s16w400.copyWith(fontSize: 20)),
            2.height,
            Text(
              'Phiên bản mới đã hoàn thiện.\n'
              'Phiên bản mới ${version.version ?? "1.0.0"}.\n'
              'Phiên bản hiện tại của bạn ${version.localVersion ?? "1.0.0"}',
              style: s16w500.copyWith(fontSize: 16, color: AppColors.border_2),
            ),
            24.height,
            Text(
              'Ghi chú cập nhật:',
              style: s16w400.copyWith(fontSize: 16, color: AppColors.border_2),
            ),
            if (version.notes.validator.isNotEmpty)
              ...List.generate(
                version.notes!.length,
                (index) => Text(
                  '${index + 1}. ${version.notes![index]}',
                  style: s16w500.copyWith(
                    fontSize: 16,
                    color: AppColors.border_2,
                  ),
                ),
              )
            else
              Text(
                'Nâng cấp hiệu năng và sữa lỗi ứng dụng',
                style: s16w500.copyWith(
                  fontSize: 16,
                  color: AppColors.border_2,
                ),
              ),
            16.height,
            MainButton(
              onTap: () {
                if (version.url.isEmptyOrNull == false) {
                  LaunchUrl.url(version.url ?? '');
                }
              },
              radius: 40,
              // backgroundColor: AppColors.black,
              title: 'Cập nhật',
            ),
          ],
        ),
      ),
    );
  }
}
