import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/image_utils.dart';

class SelectImageWidgetV2 extends StatelessWidget {
  final bool isVideo;
  final bool isCrop;
  final Function(String?) onTapGallary;
  final Function() onTapCamera;
  final String? title;
  final CropStyle cropStyle;

  SelectImageWidgetV2({
    super.key,
    required this.onTapGallary,
    required this.onTapCamera,
    this.isVideo = false,
    this.isCrop = false,
    this.title,
    this.cropStyle = CropStyle.rectangle,
  });
  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('Thêm ảnh', style: s14w500),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            navigator.pop();
            final res = await ImageUtils.pickerSingleImage(
              ImageSource.gallery,
              cropStyle: cropStyle,
            );
            if (res != null) {
              onTapGallary.call(res);
            }
          },
          child: Text(
            'Chọn từ thư viện',
            style: s16w700.copyWith(color: AppColors.main),
          ),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: onTapCamera,
          child: Text(
            "Chụp ảnh",
            style: s16w700.copyWith(color: AppColors.main),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: navigator.pop,
        child: Text('Hủy', style: s16w700.copyWith(color: AppColors.red_1)),
      ),
    );
  }

  Future<String?> onTapOption(ImageSource source) async {
    navigator.pop();
    if (isVideo) {
      if (Platform.isAndroid) {
        if (source == ImageSource.gallery) {
          return (await FilePicker.platform.pickFiles(
            allowedExtensions: ['mp4'],
            type: FileType.custom,
          ))?.files.first.path;
        } else {
          return ImageUtils.pickerSingleVideo(source);
        }
      } else {
        return ImageUtils.pickerSingleVideo(source);
      }
    }
    final result = await ImageUtils.pickerSingleImage(
      source,
      isCrop: isCrop,
    ).catchError((e) {
      if (e.message == "The user did not allow camera access.") {
        // ToastUtil.showToast("Camera chưa được cấp quyền.");
      } else {
        return null;
      }
    });
    return result;
  }

  Future<XFile?> pickGallary() async {
    navigator.pop();
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    return photo;
  }
}

class SelectImageWidget extends StatelessWidget {
  final bool isVideo;
  final bool isCrop;
  final Function(String) callback;
  final String? title;

  SelectImageWidget({
    super.key,
    required this.callback,
    this.isVideo = false,
    this.isCrop = true,
    this.title,
  });
  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(title ?? (isVideo == false ? 'Thêm ảnh' : 'Thêm video')),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            final res = await onTapOption(ImageSource.gallery);
            if (res != null) {
              callback.call(res);
            }
          },
          child: const Text('Chọn từ thư viện', style: s18w700),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () async {
            final res = await onTapOption(ImageSource.camera);
            if (res != null) {
              callback.call(res);
            }
          },
          child: Text(
            isVideo == false ? 'Chụp ảnh' : 'Quay video',
            style: s18w700,
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Hủy', style: s18w700.copyWith(color: AppColors.main)),
        onPressed: () {
          navigator.pop();
        },
      ),
    );
  }

  Future<String?> onTapOption(ImageSource source) async {
    navigator.pop();
    if (isVideo) {
      if (Platform.isAndroid) {
        if (source == ImageSource.gallery) {
          return (await FilePicker.platform.pickFiles(
            allowedExtensions: ['mp4'],
            type: FileType.custom,
          ))?.files.first.path;
        } else {
          return ImageUtils.pickerSingleVideo(source);
        }
      } else {
        return ImageUtils.pickerSingleVideo(source);
      }
    }
    // ignore: body_might_complete_normally_catch_error
    return ImageUtils.pickerSingleImage(source, isCrop: isCrop).catchError((e) {
      if (e.message == "The user did not allow camera access.") {
      } else {
        return null;
      }
    });
  }
}
