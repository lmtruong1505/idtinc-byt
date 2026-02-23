import 'dart:io';
import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/widgets/fa_icon.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bpg_retail/core/utilities/image_utils.dart';
import 'package:dotted_border/dotted_border.dart';

class AssetImagePickerWidget extends StatelessWidget {
  final String? imagePath;
  final ValueChanged<String> onImagePicked;
  final VoidCallback onImageRemoved;

  const AssetImagePickerWidget({
    super.key,
    this.imagePath,
    required this.onImagePicked,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: 16.pading,
      child: Column(
        children: [
          if (imagePath != null && imagePath!.isNotEmpty) ...[
            // ── Preview ảnh ──
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(imagePath!),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            12.height,
            GestureDetector(
              onTap: onImageRemoved,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.red60.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Xóa ảnh',
                  style: AppTypography.p5.copyWith(
                    color: AppColors.red60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ] else ...[
            // ── Placeholder matching the screenshot ──
            DottedBorder(
              color: AppColors.grey30,
              strokeWidth: 1.5,
              dashPattern: const [6, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(24),
              child: Container(
                width: double.infinity,
                padding: 16.pading,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPickerButton(
                              context: context,
                              iconCode: 'f093', // upload
                              label: 'Tải lên',
                              onTap:
                                  () =>
                                      _pickImage(context, ImageSource.gallery),
                            ),
                            const SizedBox(width: 48), // Space for "Hoặc"
                            _buildPickerButton(
                              context: context,
                              iconCode: 'f030', // camera
                              label: 'Chụp ảnh',
                              onTap:
                                  () => _pickImage(context, ImageSource.camera),
                            ),
                          ],
                        ),
                        Text(
                          'Hoặc',
                          style: AppTypography.p4.copyWith(
                            color: AppColors.grey60,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    Text(
                      'Định dạng JPEG, PNG',
                      textAlign: TextAlign.center,
                      style: AppTypography.p6.copyWith(
                        color: AppColors.grey60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    4.height,
                    Text(
                      'Giới hạn 1MB',
                      textAlign: TextAlign.center,
                      style: AppTypography.p6.copyWith(
                        color: AppColors.grey60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPickerButton({
    required BuildContext context,
    required String iconCode,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Circular Icon Container
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(
                  0xFF49494E,
                ), // AppColors.grey90 or similar dark grey
              ),
              alignment: Alignment.center,
              child: FaIcon(
                iconCode: iconCode,
                color: Colors.white,
                size: 18,
                type: FaIconType.solid,
              ),
            ),
          ),
          12.height,
          // Label with Background
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(
                0xFFF2F2F3,
              ), // AppColors.bg_primary_active or light grey
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: AppTypography.p5.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final result = await ImageUtils.pickerSingleImage(source);
    if (result != null) {
      onImagePicked(result);
    }
  }
}
