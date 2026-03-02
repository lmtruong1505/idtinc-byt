import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/core/widgets/dashed_line_widget.dart';
import 'package:tasa/features/asset_category/data/models/asset_history_event.dart';
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

  Color get _lineColor {
    switch (event.type) {
      case AssetEventType.initial:
      case AssetEventType.transfer:
        return AppColors.blue30;
      case AssetEventType.transferRejected:
      case AssetEventType.disposePending:
      case AssetEventType.disposed:
        return AppColors.red30;
      case AssetEventType.transferPending:
        return AppColors.grey30;
    }
  }

  Widget _buildTimelineColumn() {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          _buildEventIcon(),
          if (!isLast)
            Expanded(
              child: SizedBox.expand(
                child: CustomPaint(
                  painter: DashedLinePainter(
                    axis: Axis.vertical,
                    // color: _lineColor,
                    color:
                        event.isWarning ? AppColors.grey20 : AppColors.blue60,
                    strokeWidth: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventIcon() {
    IconData iconData;
    Color mainColor;
    Color borderColor;

    switch (event.type) {
      case AssetEventType.initial:
        iconData = Icons.south_east;
        mainColor = AppColors.blue60;
        borderColor = AppColors.blue20;
        break;
      case AssetEventType.transfer:
        iconData = Icons.swap_horiz;
        mainColor = AppColors.blue60;
        borderColor = AppColors.blue20;
        break;
      case AssetEventType.transferRejected:
        iconData = Icons.close;
        mainColor = AppColors.red60;
        borderColor = AppColors.red20;
        break;
      case AssetEventType.transferPending:
        iconData = Icons.autorenew;
        mainColor = AppColors.grey60;
        borderColor = AppColors.grey20;
        break;
      case AssetEventType.disposePending:
      case AssetEventType.disposed:
        iconData = Icons.north_west;
        mainColor = AppColors.red60;
        borderColor = AppColors.red20;
        break;
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor.withOpacity(0.4), width: 1),
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 2),
        ),
        padding: const EdgeInsets.all(6),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: mainColor),
          padding: const EdgeInsets.all(7),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Icon(
                iconData,
                color: mainColor, // icon cùng màu viền
                size: 18,
              ),
            ),
          ),
        ),
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
                          event.type == AssetEventType.disposed
                              ? "Đã thanh lý"
                              : "Đang ở đây",
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
            if (event.type != AssetEventType.disposed &&
                event.type != AssetEventType.disposePending) ...[
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
                      (event.assigneeName == null ||
                              event.assigneeName!.isEmpty)
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
          ],
        ),
      ),
    );
  }
}
