import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/features/asset_category/data/models/asset_history_event.dart';
import 'package:flutter/material.dart';

class AssetHistoryTimelineItem extends StatelessWidget {
  final AssetHistoryEvent event;
  final bool isFirst;
  final bool isLast;

  const AssetHistoryTimelineItem({
    super.key,
    required this.event,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimelineColumn(),
          16.width,
          Expanded(child: _buildEventCard()),
        ],
      ),
    );
  }

  Widget _buildTimelineColumn() {
    return SizedBox(
      width: 48,
      child: Column(
        children: [
          _buildEventIcon(),
          if (!isLast)
            Expanded(
              child: Container(
                width: 1,
                // Using a solid line or implementing a custom dashed painter if strictly needed.
                // Using solid light blue/red based on type for simplicity unless dashed is mandatory.
                // Mockup shows dashed line color matching the icon color subtly.
                color: event.isWarning ? AppColors.red60 : AppColors.blue60,
                // We'll use a basic solid line or specialized dashed widget if available in base.
                // Assuming basic container for now.
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventIcon() {
    IconData iconData;
    Color bgColor;
    Color borderColor;

    switch (event.type) {
      case AssetEventType.initial:
        iconData = Icons.south_east;
        bgColor = AppColors.blue60;
        borderColor = AppColors.blue20;
        break;
      case AssetEventType.transfer:
        iconData = Icons.swap_horiz;
        bgColor = AppColors.blue60;
        borderColor = AppColors.blue20;
        break;
      case AssetEventType.transferRejected:
        iconData = Icons.close;
        bgColor = AppColors.red60;
        borderColor = AppColors.red20;
        break;
      case AssetEventType.transferPending:
        iconData = Icons.pending_outlined;
        bgColor = AppColors.grey60;
        borderColor = AppColors.grey20;
        break;
      case AssetEventType.disposePending:
        iconData = Icons.north_west;
        bgColor = AppColors.red60;
        borderColor = AppColors.red20;
        break;
      case AssetEventType.disposed:
        iconData = Icons.north_west;
        bgColor = AppColors.red60;
        borderColor = AppColors.red20;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Icon(iconData, color: AppColors.white, size: 20),
      ),
    );
  }

  Widget _buildEventCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: BaseContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 8,
        borderColor: AppColors.grey20,
        isDotted: true, // Mockup shows a dashed/dotted border for the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Essential for IntrinsicHeight
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    event.date,
                    style: AppTypography.p5.copyWith(
                      color: AppColors.text_primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (event.isWarning)
                  BaseContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    borderRadius: 12,
                    color: AppColors.red10,
                    borderColor: AppColors.red20,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.red60,
                        ),
                        4.width,
                        Text(
                          "Đang ở đây",
                          style: AppTypography.p7.copyWith(
                            color: AppColors.red60,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            4.height,
            Text(
              event.title,
              style: AppTypography.p6.copyWith(
                color: AppColors.text_tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            8.height,
            Text(
              event.departmentName.isEmpty
                  ? 'Chưa cập nhật'
                  : event.departmentName,
              style: AppTypography.h6.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (event.departmentType != null &&
                event.departmentType!.isNotEmpty) ...[
              2.height,
              Text(
                event.departmentType!,
                style: AppTypography.p6.copyWith(
                  color: AppColors.text_primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            16.height,
            BaseContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              borderRadius: 4,
              color: AppColors.grey10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Người được giao",
                    style: AppTypography.p7.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                  4.height,
                  Text(
                    (event.assigneeName == null || event.assigneeName!.isEmpty)
                        ? "Không có thông tin"
                        : event.assigneeName!,
                    style: AppTypography.h6.copyWith(
                      color: AppColors.text_primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (event.assigneeRole != null &&
                event.assigneeRole!.isNotEmpty) ...[
              4.height,
              Text(
                event.assigneeRole!,
                style: AppTypography.p6.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
            16.height,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.orange20, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.orange60,
                    size: 14,
                  ),
                ),
                8.width,
                RichText(
                  text: TextSpan(
                    style: AppTypography.p6.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                    children: [
                      const TextSpan(text: "Ghi nhận "),
                      TextSpan(
                        text: "${event.incidentsCount}",
                        style: AppTypography.p6.copyWith(
                          color: AppColors.text_primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: " sự cố"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
