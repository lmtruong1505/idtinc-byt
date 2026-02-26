import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/core/widgets/toast/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart' as v2;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../core/constants/colors.dart';

// @RoutePage()
class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({
    super.key,
    this.isScanUser = false,
    this.isShowBack = false,
  });
  final bool? isScanUser;
  final bool? isShowBack;

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen>
    with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'scan_code');

  bool isSnackbar = true;
  QRViewController? controller;
  final nav = getIt.get<AppNavigator>();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: const BaseBottomNavigation(),
      body: _scanView(),
    );
  }

  Widget _scanView() {
    final topPadding = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        QRView(
          key: qrKey,
          overlay: QrScannerOverlayShape(
            borderColor: AppColors.white,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 5,
            cutOutWidth: 250,
            cutOutHeight: 250,
          ),
          onPermissionSet: _onPermissionSet,
          onQRViewCreated: _onQRViewCreated,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: 16.padingBottom,
            child: ExtraButton(
              bgColor: AppColors.main,
              color: AppColors.white,
              title: "Chọn ảnh từ bộ sưu tập",
              onTap: () async {
                final res = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                if (res is XFile) {
                  final data = await v2.QRCodeDartScanDecoder(
                    formats: [
                      // v2.BarcodeFormat.qrCode,
                      // v2.BarcodeFormat.aztec,
                      // v2.BarcodeFormat.dataMatrix,
                      // v2.BarcodeFormat.pdf417,
                      // v2.BarcodeFormat.code39,
                      // v2.BarcodeFormat.code93,
                      // v2.BarcodeFormat.code128,
                      // v2.BarcodeFormat.ean8,
                      // v2.BarcodeFormat.ean13,
                      // v2.BarcodeFormat.itf,
                    ],
                  ).decodeFile(res);
                  print(data);
                  if (data != null) {
                    controller?.pauseCamera();
                    if (widget.isScanUser == true) {
                      nav.pop(result: data.text);
                    } else {}
                  } else {
                    controller?.resumeCamera();
                    Toast.showToast('Mã QR không hợp lệ', context);
                  }
                }
              },
            ),
          ),
        ),
        if (widget.isShowBack == true)
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios,
                // color: AppColors.white,
              ).padding(topPadding.padingTop + 32.padingLeft),
            ),
          ),
      ],
    );
  }

  void _onPermissionSet(QRViewController ctrl, bool isPermission) {
    if (!isPermission && isSnackbar) {
      isSnackbar = false;
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: const Text(
            'Vui lòng cho phép quyền sử dụng Camera để sử dụng chức năng',
            style: s14w400,
          ),
          actions: [
            MainButton(
              title: "Cho phép",
              largeButton: false,
              onTap: () async {
                ScaffoldMessenger.of(context).clearMaterialBanners();
                final status = await Permission.camera.status;
                if (status.isDenied) {
                  openAppSettings().then((value) async {
                    final per = await Permission.camera.status;
                    if (per.isGranted) {
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                    }
                  });
                }
              },
            ),
          ],
        ),
      );
    } else if (isPermission) {
      ScaffoldMessenger.of(context).clearMaterialBanners();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    this.controller?.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        this.controller?.pauseCamera();
      }
      if (widget.isScanUser == true) {
        nav.pop(result: scanData.code);
      } else {
        final code = jsonDecode(scanData.code ?? "");
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller != null) {
      if (state == AppLifecycleState.resumed) {
        print('=======resumed');
        controller!.resumeCamera();
      } else if (state == AppLifecycleState.paused) {
        controller!.pauseCamera();
      }
    }
  }
}

// Future<String?> scanQRCodeFromImageBytes(Uint8List imageBytes) async {
//   try {
//     final String? qrResult = await QrCodeDartScan.scanBytes(imageBytes);
//     return qrResult;
//   } catch (e) {
//     print("Error scanning QR code: $e");
//     return null;
//   }
// }
