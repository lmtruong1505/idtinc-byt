import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/core/utilities/dialog_utils.dart';
import 'package:tasa/core/widgets/toast/toast.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUtils {
  static Future<String?> pickerSingleImage(
    ImageSource source, {
    bool isCrop = true,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: source);
    if (photo != null) {
      String? finalPath = photo.path;
      if (isCrop) {
        final cropData = await cropImage(
          path: photo.path,
          cropStyle: cropStyle,
        );
        finalPath = cropData?.path;
      }

      if (finalPath != null) {
        // Luôn nén để đảm bảo dưới 1MB
        return await compressImageSize(finalPath);
      }
    }
    return null;
  }

  static Future<String?> compressImageSize(
    String path, {
    int maxSizeInBytes = 1 * 1024 * 1024, // 1MB
  }) async {
    File file = File(path);
    int size = await file.length();
    if (size <= maxSizeInBytes) return path;

    // Nếu quá lớn, dùng thư viện image để nén
    final image = img.decodeImage(await file.readAsBytes());
    if (image == null) return path;

    int quality = 80;
    while (size > maxSizeInBytes && quality > 10) {
      final compressedBytes = img.encodeJpg(image, quality: quality);
      await file.writeAsBytes(compressedBytes);
      size = await file.length();
      quality -= 10;
    }

    return file.path;
  }

  static Future<String?> pickerSingleVideo(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickVideo(source: source);
    return photo?.path;
  }

  static Future<CroppedFile?> cropImage({
    required String path,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      // cropStyle removed from here as it is not a valid named parameter
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 80,
      aspectRatio:
          cropStyle == CropStyle.circle
              ? null
              : const CropAspectRatio(ratioX: 16, ratioY: 9),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Chỉnh sửa',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          cropStyle: cropStyle, // Added here
        ),
        IOSUiSettings(
          title: 'Chỉnh sửa',
          cropStyle: cropStyle, // Added here
        ),
      ],
    );
    return croppedFile;
  }

  static String cropIdentityImage({
    required BuildContext context,
    required XFile file,
  }) {
    final File imageFile = File(file.path);

    final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    final img.Image croppedImage = img.copyCrop(
      image!,
      x: (context.width - kycIdentityOffsetX(context.width.toInt())) ~/ 2,
      y: (context.height - kycIdentityOffsetY(context.height.toInt())) ~/ 2,
      width: kycIdentityWidth(context.width.toInt()),
      height: kycIdentityHeight(context.width.toInt()),
    );

    final String uniqueFileName =
        'cropped_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Lưu ảnh đã cắt
    final String croppedImagePath = '${imageFile.parent.path}/$uniqueFileName';

    File(croppedImagePath).writeAsBytesSync(img.encodeJpg(croppedImage));
    return croppedImagePath;
  }

  static int kycIdentityOffsetY(int height) => (height * 0.27).toInt();

  static int kycIdentityOffsetX(int width) => (width * 0.1).toInt();

  static int kycIdentityWidth(int width) =>
      width - (2 * kycIdentityOffsetX(width));

  static int kycIdentityHeight(int width) => kycIdentityWidth(width) ~/ 1.5;

  static int kycPortraitRadius(int width) => (width * 0.7).toInt();

  static int kycPortraitSize(int width) => (width * 0.9).toInt();

  static int kycPortraitOffsetX(int width) => (width * 0.05).toInt();

  static int kycPortraitOffsetY(int height) => (height * 0.2).toInt();

  static Future<bool> saveImage(String? url, BuildContext context) async {
    try {
      print(url);
      // 1. Yêu cầu quyền lưu trữ
      if (!context.mounted) return false;
      PermissionStatus? status;
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          status = await Permission.storage.request();
        } else {
          status = await Permission.photos.request();
        }
      } else {
        status = await Permission.photos.request();
      }

      if (!status.isGranted) {
        DialogUtils.showConfirmDialog(
          context,
          description:
              'Quyền bị truy cập ảnh bị từ chối! .Mở lại vui lòng cấp quyền để lưu ảnh',
          rightTitle: "Mở AppSetting",
          ontap: () => openAppSettings(),
        );
        // Toast.showToast(
        //     'Quyền bị truy cập ảnh bị từ chối! .Mở lại vui lòng cấp quyền để lưu ảnh',
        //     context);

        return false;
      }

      Toast.showToast('Ảnh đã được lưu', context);

      return true;
    } catch (e) {
      Toast.showToast('Lỗi khi lưu ảnh: $e', context);
      return false;
    }
  }
}
