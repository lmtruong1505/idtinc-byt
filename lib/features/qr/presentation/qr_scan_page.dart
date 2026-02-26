import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base/appbar.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/toast/toast.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

@RoutePage()
class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    // [qr_code_scanner_plus] It is not required to call dispose() on QRViewController anymore.
    super.dispose();
  }

  bool _isScanned = false;
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && !_isScanned) {
        _isScanned = true;
        print('--- QR Code Scanned ---');
        print('Raw Data: ${scanData.code}');

        int? assetId;
        try {
          final decoded = jsonDecode(scanData.code!);
          if (decoded is Map<String, dynamic> && decoded.containsKey('id')) {
            assetId = int.tryParse(decoded['id'].toString());
          }
        } catch (e) {
          // Not JSON, try raw numeric ID
          assetId = int.tryParse(scanData.code!);
        }

        if (assetId != null) {
          print('Navigating to Asset ID: $assetId');
          controller.pauseCamera();
          context.router.replace(
            AssetDetailRoute(
              asset: HospitalAssetModel(id: assetId),
              initialIndex: 1, // Go to Transfer History tab
            ),
          );
        } else {
          print('Invalid QR format. Code: ${scanData.code}');
          Toast.showToast('Mã QR không hợp lệ hoặc thiếu thông tin', context);
          // Resume scanning after a delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _isScanned = false;
            }
          });
        }
        print('-----------------------');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: BaseAppBar(
        leadingIcon: GestureDetector(
          onTap: () => context.router.maybePop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: AppColors.grey80,
              ),
              4.width,
              Text(
                "Trang chủ",
                style: AppTypography.p5.copyWith(color: AppColors.grey80),
              ),
            ],
          ),
        ),
        title: "Quét mã QR",
        centerTitle: true,
        leadingWidth: 100.0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.blue60,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BaseContainer(
                    width: 56,
                    height: 56,
                    isCircle: true,
                    color: AppColors.black.withValues(alpha: 0.1),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColors.black,
                        size: 28,
                      ),
                    ),
                  ),
                  24.height,
                  Text(
                    "Quét mã QR trên tài sản",
                    style: AppTypography.h3.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.height,
                  Text(
                    "Vui lòng đưa mã QR vào khung camera trên màn hình để quét mã tài sản",
                    textAlign: TextAlign.center,
                    style: AppTypography.p5.copyWith(color: AppColors.grey80),
                  ),
                  32.height,
                  GestureDetector(
                    onTap: () => context.router.maybePop(),
                    child: BaseContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 12,
                      ),
                      color: AppColors.grey10,
                      borderRadius: 24,
                      child: Text(
                        "Quay lại",
                        style: AppTypography.p5.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
