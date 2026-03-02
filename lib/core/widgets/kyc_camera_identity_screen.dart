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
import 'package:tasa/core/widgets/identity_card_widget.dart';
import 'package:tasa/core/widgets/kyc_camera_preview.dart';

@RoutePage()
class KycCameraIdentityScreen extends StatefulWidget {
  final ImageIdentityTypeEnum type;

  const KycCameraIdentityScreen({super.key, required this.type});

  @override
  State<KycCameraIdentityScreen> createState() =>
      _KycCameraIdentityScreenState();
}

class _KycCameraIdentityScreenState extends State<KycCameraIdentityScreen> {
  CameraController? controller;
  final navgator = getIt.get<AppNavigator>();

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
        title: Text(
          widget.type == ImageIdentityTypeEnum.front ? 'Mặt trước' : 'Mặt sau',
          // "Chụp ảnh",
          style: s16w500.copyWith(color: AppColors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => navgator.pop(),
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
            AppColors.black,
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                height: context.height,
                width: context.width,
                decoration: const BoxDecoration(color: Color(0x33000000)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top:
                            ImageUtils.kycIdentityOffsetY(
                              context.height.toInt(),
                            ).toDouble(),
                        left:
                            ImageUtils.kycIdentityOffsetX(
                              context.width.toInt(),
                            ).toDouble(),
                        right:
                            ImageUtils.kycIdentityOffsetX(
                              context.width.toInt(),
                            ).toDouble(),
                      ),
                      height:
                          ImageUtils.kycIdentityHeight(
                            context.width.toInt(),
                          ).toDouble(),
                      width:
                          ImageUtils.kycIdentityWidth(
                            context.width.toInt(),
                          ).toDouble(),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
          child: Text(
            'Đưa Căn cước/ Hộ chiếu hiển thị vừa trong khung mẫu rồi nhấn chụp',
            textAlign: TextAlign.center,
            style: s14w400.copyWith(color: AppColors.white),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top:
                    ImageUtils.kycIdentityOffsetY(
                      context.height.toInt(),
                    ).toDouble() -
                    6,
              ),
              child: DottedBorder(
                borderType: BorderType.RRect,
                dashPattern: const [5],
                color: AppColors.white,
                radius: const Radius.circular(8),
                padding: const EdgeInsets.all(6),
                child: SizedBox(
                  height:
                      ImageUtils.kycIdentityHeight(
                        context.width.toInt(),
                      ).toDouble(),
                  width:
                      ImageUtils.kycIdentityWidth(
                        context.width.toInt(),
                      ).toDouble(),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: context.height * 0.1,
          left: 0,
          right: 0,
          child: Center(
            child: CameraFloatButton(
              onPressed: () async {
                final XFile? file = await controller?.takePicture();
                if (file != null) {
                  navgator.pop(result: file);
                }
              },
            ),
          ),
        ),
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
            camera: snapshot.data!.first,
            onCameraCreated: (controller) => this.controller = controller,
          );
        }
      },
    );
  }
}
