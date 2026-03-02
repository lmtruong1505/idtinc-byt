import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/core/injection/injection.dart';
import 'package:tasa/core/navigation/navigator.dart';
import 'package:tasa/core/utilities/image_utils.dart';
import 'package:tasa/core/widgets/camera_float_button.dart';
import 'package:tasa/core/widgets/kyc_camera_preview.dart';

@RoutePage()
class KycCameraPortraitScreen extends StatefulWidget {
  const KycCameraPortraitScreen({super.key});

  @override
  State<KycCameraPortraitScreen> createState() =>
      _KycCameraPortraitScreenState();
}

class _KycCameraPortraitScreenState extends State<KycCameraPortraitScreen> {
  CameraController? controller;
  final navigator = getIt.get<AppNavigator>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          'Chân dung',
          style: s18w700.copyWith(color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => navigator.pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildCameraPreview(),
        ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Color(0xB3000000),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top:
                      ImageUtils.kycPortraitOffsetY(
                        context.height.toInt(),
                      ).toDouble(),
                ),
                height: context.height,
                width: context.width,
                decoration: const BoxDecoration(color: Color(0x33000000)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width:
                          ImageUtils.kycPortraitSize(
                            context.width.toInt(),
                          ).toDouble(),
                      height:
                          ImageUtils.kycPortraitSize(
                            context.width.toInt(),
                          ).toDouble(),
                      decoration: const BoxDecoration(
                        color: AppColors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top:
                    ImageUtils.kycPortraitOffsetY(
                      context.height.toInt(),
                    ).toDouble() -
                    6,
              ),
              child: DottedBorder(
                borderType: BorderType.Circle,
                dashPattern: const [5],
                color: AppColors.grey79,
                child: SizedBox(
                  width:
                      ImageUtils.kycPortraitSize(
                        context.width.toInt(),
                      ).toDouble() +
                      6,
                  height:
                      ImageUtils.kycPortraitSize(
                        context.width.toInt(),
                      ).toDouble() +
                      6,
                ),
              ),
            ),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
        //   child: Text(
        //     'Đưa khuôn mặt của bạn vừa với vòng tròn và nhấn chụp',
        //     textAlign: TextAlign.center,
        //     style: AppTextStyles.s14w400,
        //   ),
        // ),
        Positioned(bottom: 0, right: 0, left: 0, child: _buildBottom()),
      ],
    );
  }

  Widget _buildBottom() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: CameraFloatButton(
            onPressed: () async {
              final XFile? file = await controller?.takePicture();
              if (file != null) {
                navigator.pop(result: file);
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        Container(height: context.height * 0.1, color: AppColors.black),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return FutureBuilder<List<CameraDescription>?>(
      future: availableCameras(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Align(
            child: Text(
              'No camera found',
              style: TextStyle(color: Colors.black),
            ),
          );
        } else {
          return KycCameraPreview(
            camera:
                snapshot.data!
                    .where(
                      (element) =>
                          element.lensDirection == CameraLensDirection.front,
                    )
                    .first,
            onCameraCreated: (controller) => this.controller = controller,
          );
        }
      },
    );
  }
}
