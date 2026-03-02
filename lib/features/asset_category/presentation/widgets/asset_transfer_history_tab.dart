import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/features/asset_category/data/models/asset_history_event.dart';
import 'package:tasa/features/asset_category/presentation/widgets/asset_history_timeline_item.dart';
import 'package:tasa/features/asset_category/data/bloc/asset_location_history_cubit.dart';
import 'package:tasa/features/asset_category/data/bloc/asset_location_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetTransferHistoryTab extends StatelessWidget {
  const AssetTransferHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetLocationHistoryCubit, AssetLocationHistoryState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (data) {
            if (data.isEmpty) {
              return _buildEmptyState();
            }

            // Map API Models to UI Events
            final historyEvents =
                data.map((location) {
                  AssetEventType type = AssetEventType.transfer;
                  bool isWarning = false;

                  // Determine icon and type
                  if (location.loaiViTri?.value == "VI_TRI_BAN_DAU") {
                    type = AssetEventType.initial;
                  } else if (location.loaiViTri?.value ==
                      "VI_TRI_DIEU_CHUYEN") {
                    final status = location.phieuDieuChuyen?.trangThai;
                    if (status == "DA_NHAN") {
                      type = AssetEventType.transfer;
                    } else if (status == "TU_CHOI") {
                      type = AssetEventType.transferRejected;
                    } else {
                      // Defaults to pending for CHO_DUYET or any other status
                      type = AssetEventType.transferPending;
                    }
                  } else if (location.loaiViTri?.value == "VI_TRI_THANH_LY") {
                    if (location.phieuThanhLy?.trangThai == "DA_THANH_LY") {
                      type = AssetEventType.disposed;
                    } else {
                      type = AssetEventType.disposePending;
                    }
                  }

                  // Active location warning for yellow icon style
                  if (location.viTriHienTai == true) {
                    isWarning = true;
                  }

                  final rawDate =
                      location.displayDate ?? location.ngayGhiNhan ?? '';
                  String formattedDate = rawDate.split(' ').first;
                  final dateParts = formattedDate.split('-');
                  if (dateParts.length == 3) {
                    formattedDate =
                        '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
                  }

                  return AssetHistoryEvent(
                    date: formattedDate,
                    title: location.loaiViTri?.label ?? '',
                    departmentName: location.tenKhoaHienTai ?? '',
                    departmentType: location.viTri,
                    assigneeName: location.tenNguoiDuocGiao,
                    assigneeRole: location.chucVu,
                    type: type,
                    isWarning: isWarning,
                    incidentsCount: location.soLuongSuCo ?? 0,
                  );
                }).toList();

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: historyEvents.length,
              itemBuilder: (context, index) {
                final event = historyEvents[index];
                final isFirst = index == 0;
                final isLast = index == historyEvents.length - 1;

                return AssetHistoryTimelineItem(
                  event: event,
                  isFirst: isFirst,
                  isLast: isLast,
                );
              },
            );
          },
          failure: (message) => Center(child: Text(message)),
          orElse: () => const SizedBox(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 64, color: AppColors.grey40),
          16.height,
          Text(
            "Chưa có lịch sử điều chuyển",
            style: AppTypography.h4.copyWith(color: AppColors.text_primary),
          ),
          8.height,
          Text(
            "Tài sản này chưa được điều chuyển lần nào.",
            style: AppTypography.p6.copyWith(color: AppColors.text_tertiary),
          ),
        ],
      ),
    );
  }
}
