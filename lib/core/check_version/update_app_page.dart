import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/core/widgets/buttons/extra_button.dart';
import 'package:tasa/core/widgets/buttons/main_button.dart';

import 'package:url_launcher/url_launcher.dart';

import '../constants/spacing.dart';
import 'check_vesion.dart';

@RoutePage()
class UpdateAppPage extends StatefulWidget {
  final ModelVersion modelVersion;
  const UpdateAppPage({super.key, required this.modelVersion});

  @override
  State<UpdateAppPage> createState() => _UpdateAppPageState();
}

class _UpdateAppPageState extends State<UpdateAppPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.border_1,
        appBar: AppBar(title: const Text('Cập nhật phiên bản', style: s16w500)),
        body: SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: 16.padingHor + 16.padingTop,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.3),
                      blurRadius: sp4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Đã có phiên bản mới', style: s16w500),
                    const SizedBox(height: sp16),
                    RichText(
                      text: TextSpan(
                        text: 'Phiên bản mới: ',
                        style: s14w400.copyWith(color: AppColors.bg_2),
                        children: [
                          TextSpan(
                            text: '${widget.modelVersion.version} (có sẵn)',
                            style: s14w500,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: sp12),
                    RichText(
                      text: TextSpan(
                        text: 'Phiên bản đang sử dụng: ',
                        style: s14w400.copyWith(color: AppColors.bg_2),
                        children: [
                          TextSpan(
                            text: widget.modelVersion.localVersion,
                            style: s14w500,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: sp24),
                    MainButton(
                      title: 'Tải xuống bản cập nhật mới ngay !',
                      onTap: _updateApp,
                      icon: const Icon(
                        Icons.download_rounded,
                        size: sp20,
                        color: AppColors.white,
                      ),
                    ),
                    ExtraButton(
                      title: 'Bỏ qua',
                      bgColor: AppColors.white,
                      onTap: () {
                        context.router.back();
                        // final token = AppSharedPreference.instance
                        //     .getValue(PrefKeys.token);
                        // if (token != null) {
                        //   context.router.replaceAll([const WorkSpaceRoute()]);
                        // } else {
                        //   context.router.replaceAll([const LoginRoute()]);
                        // }
                      },
                      icon: const Icon(
                        Icons.navigate_next,
                        size: sp20,
                        color: AppColors.white,
                      ),
                    ),
                    5.height,
                  ],
                ),
              ),
              const SizedBox(height: sp24),
              Text(
                'Phiên bản mới có gì',
                style: s14w500.copyWith(color: AppColors.grey79),
              ),
              context.padding.bottom.height,
              50.height,
            ],
          ),
        ),
      ),
    );
  }

  void _updateApp() async {
    if (Platform.isAndroid) {
      final url = Uri.parse(widget.modelVersion.url ?? '');
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else if (Platform.isIOS) {
      final url = Uri.parse(widget.modelVersion.url ?? '');
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
