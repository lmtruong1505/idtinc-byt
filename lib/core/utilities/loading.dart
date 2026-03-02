import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasa/core/constants/colors.dart';

void showLoading() {
  EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.black);
}

Future<bool?> showToast(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.blackish,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
