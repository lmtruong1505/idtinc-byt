import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:bpg_retail/core/widgets/select_image_widget_V2.dart';

class BottomSheetService {
  static FutureOr showBottomSheetSelectImage(
    BuildContext context,
    Function(String) callback, {
    bool isCrop = true,
    String? title,
  }) async {
    return showCupertinoModalPopup(
      context: context,
      builder:
          (context) => SelectImageWidget(
            isCrop: isCrop,
            callback: callback,
            title: title,
          ),
    );
  }

  static FutureOr showBottomSheetSelectImageV2({
    required BuildContext context,
    required Function(String?) onTapGallary,
    required Function() onTapCamera,
    bool isCrop = false,
    String? title,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    return showCupertinoModalPopup(
      context: context,
      builder:
          (context) => SelectImageWidgetV2(
            isCrop: isCrop,
            onTapGallary: (p0) async {
              await onTapGallary.call(p0);
            },
            onTapCamera: () async {
              onTapCamera.call();
            },
            title: title,
            cropStyle: cropStyle,
          ),
    );
  }

  static Future showBottomSheetSelectVideo(
    BuildContext context,
    Function(String) callback,
  ) async {
    return showCupertinoModalPopup(
      context: context,
      builder:
          (context) => SelectImageWidget(
            isCrop: false,
            isVideo: true,
            callback: callback,
          ),
    );
  }
}
