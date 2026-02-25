import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

/// Tab content for "Lịch sử bảo dưỡng".
/// Currently shows an empty state placeholder.
/// Ready for API integration — just replace [_buildEmptyState]
/// with a [ListView] when data is available.
class MaintenanceHistoryTab extends StatelessWidget {
  /// Maintenance records from API (null = not loaded yet, empty = no data).
  final List<dynamic>? records;

  /// Called when user taps "Tạo mới +"
  final VoidCallback? onCreateNew;

  const MaintenanceHistoryTab({super.key, this.records, this.onCreateNew});

  @override
  Widget build(BuildContext context) {
    // When records are available, switch to _buildList
    if (records != null && records!.isNotEmpty) {
      return _buildList();
    }
    return _buildEmptyState();
  }

  /// Empty state — matches the design screenshot
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.grey10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 28,
                color: AppColors.text_tertiary,
              ),
            ),
            20.height,

            // Title
            Text(
              'Không có phiếu bảo dưỡng',
              style: AppTypography.h3.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            8.height,

            // Description
            Text(
              'Không có dữ liệu khả dụng liên quan đến chức năng bạn truy cập',
              textAlign: TextAlign.center,
              style: AppTypography.p6.copyWith(color: AppColors.text_tertiary),
            ),
            24.height,

            // Create New button
            if (onCreateNew != null)
              GestureDetector(
                onTap: onCreateNew,
                child: DottedBorder(
                  color: AppColors.grey30,
                  strokeWidth: 1.2,
                  dashPattern: const [4, 4],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tạo mới',
                          style: AppTypography.p5.copyWith(
                            color: AppColors.text_secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        6.width,
                        const Icon(
                          Icons.add,
                          size: 18,
                          color: AppColors.text_secondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Placeholder for list view — implement when API is ready
  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: records!.length,
      separatorBuilder: (_, __) => 12.height,
      itemBuilder: (context, index) {
        // TODO: Replace with MaintenanceRecordItem widget when model is ready
        return const SizedBox.shrink();
      },
    );
  }
}
