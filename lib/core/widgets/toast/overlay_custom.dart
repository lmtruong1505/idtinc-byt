import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:overlay_support/overlay_support.dart';

OverlaySupportEntry showOverlayToast({
  required String title,
  String? subtitle,
  Widget? iconPreffix,
  Color? iconColor,
  ToastStatus? status = ToastStatus.success,
}) {
  return showOverlayNotification((context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          OverlaySupportEntry.of(context)?.dismiss();
        },
        child: Card(
          child: ListTile(
            leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(
                child: Container(
                  color:
                      iconColor?.withOpacity(0.1) ??
                      const Color.fromARGB(255, 0, 2, 1),
                  child:
                      iconPreffix ??
                      Icon(
                        Icons.shopping_bag,
                        color:
                            status == ToastStatus.success
                                ? AppColors.green_1
                                : AppColors.red_1,
                      ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: subtitle != null ? Text(subtitle) : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }, duration: const Duration(milliseconds: 2000));
}

enum ToastStatus { error, success }
