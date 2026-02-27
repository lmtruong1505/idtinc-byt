import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';

import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

@RoutePage()
class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

enum QRScanStatus { idle, scanning, error }

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  QRScanStatus _status = QRScanStatus.idle;
  StreamSubscription? _subscription;

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
    _subscription?.cancel();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    _subscription = controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && _status == QRScanStatus.idle) {
        setState(() {
          _status = QRScanStatus.scanning;
        });

        int? assetId;
        try {
          final decoded = jsonDecode(scanData.code!);
          if (decoded is Map<String, dynamic> && decoded.containsKey('id')) {
            assetId = int.tryParse(decoded['id'].toString());
          }
        } catch (e) {
          assetId = int.tryParse(scanData.code!);
        }

        if (assetId != null) {
          // Valid asset found, show loading for 3 seconds as requested
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted && _status == QRScanStatus.scanning) {
              controller.pauseCamera();
              context.router.replace(
                AssetDetailRoute(
                  asset: HospitalAssetModel(id: assetId!),
                  initialIndex: 1,
                ),
              );
            }
          });
        } else {
          controller.pauseCamera();
          setState(() {
            _status = QRScanStatus.error;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.router.maybePop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        12.width,
                        const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: AppColors.text_secondary,
                        ),
                        Text(
                          "Trang chủ",
                          style: AppStyle.bodyMdMedium.copyWith(
                            color: AppColors.text_secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.height,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Quét mã QR",
                      style: AppStyle.headingLg.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.text_primary,
                      ),
                    ),
                  ),
                  8.height,
                ],
              ),
            ),
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
                child:
                    _status == QRScanStatus.error
                        ? _buildErrorPanel()
                        : _buildInfoPanel(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_status == QRScanStatus.scanning)
          const CircularProgressIndicator(color: AppColors.main)
        else ...[
          BaseContainer(
            width: 56,
            height: 56,
            isCircle: true,
            color: AppColors.black.withValues(alpha: 0.1),
            child: const Center(
              child: Icon(Icons.camera_alt, color: AppColors.black, size: 28),
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
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
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
      ],
    );
  }

  Widget _buildErrorPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: Color(0xFFFFEBEE),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.close, color: Color(0xFFE53935), size: 32),
          ),
        ),
        24.height,
        Text(
          "Không tìm thấy tài sản",
          style: AppTypography.h3.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        12.height,
        Text(
          "Vui lòng quét lại đúng mã QR của tài sản",
          textAlign: TextAlign.center,
          style: AppTypography.p5.copyWith(color: AppColors.grey80),
        ),
        32.height,
        GestureDetector(
          onTap: () {
            setState(() {
              _status = QRScanStatus.idle;
            });
            controller?.resumeCamera();
          },
          child: BaseContainer(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
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
    );
  }
}
