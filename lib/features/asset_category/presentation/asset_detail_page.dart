import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/widgets/base/appbar.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/chip_custom.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/asset_detail_cubit.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/asset_detail_state.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/asset_depreciation_bottom_sheet.dart';
import 'widgets/asset_technical_specs_bottom_sheet.dart';
import 'widgets/asset_set_bottom_sheet.dart';
import 'widgets/maintenance_history_tab.dart';

@RoutePage()
class AssetDetailPage extends StatefulWidget {
  final HospitalAssetModel asset;
  const AssetDetailPage({super.key, required this.asset});

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AssetDetailCubit _detailCubit = getIt.get<AssetDetailCubit>();

  @override
  void initState() {
    super.initState();
    _detailCubit
      ..navigator = getIt.get<AppNavigator>()
      ..appCubit = getIt.get<AppCubit>()
      ..preferences = getIt.get<Preferences>();

    _tabController = TabController(length: 3, vsync: this);
    if (widget.asset.id != null) {
      _detailCubit.getAssetDetail(widget.asset.id!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _detailCubit,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: BaseAppBar(
          title: "Danh sách tài sản",
          hasLeading: true,
          centerTitle: false,
          textStyle: AppTypography.p5.copyWith(color: AppColors.text_tertiary),
        ),
        body: BlocBuilder<AssetDetailCubit, AssetDetailState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: (message) => Center(child: Text(message)),
              success: (asset) => _buildContent(asset),
              orElse: () => _buildContent(widget.asset),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(HospitalAssetModel asset) {
    return Column(
      children: [
        _buildHeader(asset),
        _buildTabs(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAssetHistory(asset),
              const Center(child: Text("Lịch sử điều chuyển")),
              MaintenanceHistoryTab(
                onCreateNew: () {
                  // TODO: Navigate to create maintenance record
                },
              ),
            ],
          ),
        ),
        _buildBottomAction(),
      ],
    );
  }

  Widget _buildHeader(HospitalAssetModel asset) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              asset.tenTaiSan ?? "N/A",
              style: AppTypography.h3.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(Icons.memory, color: AppColors.text_tertiary, size: 24),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey20, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppColors.text_primary,
        unselectedLabelColor: AppColors.text_tertiary,
        indicatorColor: AppColors.text_primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: AppTypography.p5.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: AppTypography.p5,
        tabs: [
          const Tab(text: "Lý lịch tài sản"),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Lịch sử điều chuyển và thanh lý tài sản"),
                6.width,
                _buildTabBadge('10'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Lịch sử bảo dưỡng"),
                6.width,
                _buildTabBadge('10'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBadge(String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.grey10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count,
        style: AppTypography.p7.copyWith(
          color: AppColors.text_tertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAssetHistory(HospitalAssetModel asset) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAssetSummary(asset),
          const Divider(height: 1, color: AppColors.grey20),
          _buildDetailedInfo(asset),
        ],
      ),
    );
  }

  Widget _buildAssetSummary(HospitalAssetModel asset) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and status
          Expanded(
            flex: 4,
            child: Column(
              children: [
                BaseContainer(
                  width: double.infinity,
                  height: 150,
                  borderRadius: 8,
                  color: AppColors.grey10,
                  child:
                      asset.hinhAnh != null
                          ? Image.network(asset.hinhAnh!, fit: BoxFit.contain)
                          : const Icon(
                            Icons.image,
                            size: 64,
                            color: AppColors.grey40,
                          ),
                ),
                12.height,
                _buildStatusChip(asset),
                8.height,
                _buildUsageStatus(asset),
              ],
            ),
          ),
          16.width,
          // Depreciation Info
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryItem(
                  "Nguyên giá",
                  "${formatCurrency(asset.originalPriceValue)} / ${asset.thoiGianTinhKhauHao ?? '0'} năm",
                ),
                const Divider(height: 24),
                _buildSummaryItem(
                  "Tỷ lệ hao mòn năm",
                  "${formatCurrency(asset.annualDepreciation)} / ${asset.depreciationRatio.toStringAsFixed(2)}%",
                ),
                const Divider(height: 24),
                _buildSummaryItem(
                  "Đã hao mòn (${asset.usageYears.toStringAsFixed(asset.usageYears % 1 == 0 ? 0 : 1)} năm)",
                  "${formatCurrency(asset.accumulatedDepreciation)} / ${asset.accumulatedDepreciationRatio.toStringAsFixed(2)}%",
                ),
                const Divider(height: 24),
                _buildSummaryItem(
                  "Còn lại",
                  formatCurrency(asset.remainingValue),
                  isValueGreen: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(HospitalAssetModel asset) {
    return chipCustomBadge(
      color: getAssetStatusColor(asset.trangThai?.value),
      title: asset.trangThai?.label ?? "Chưa xác định",
      titleStyle: AppTypography.p7.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildUsageStatus(HospitalAssetModel asset) {
    final bool isUsing = asset.trangThai?.value == "DANG_SU_DUNG";
    return BaseContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      borderRadius: 12,
      borderColor: AppColors.grey20,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Đang sử dụng",
              style: AppTypography.p6.copyWith(color: AppColors.text_primary),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isUsing,
              onChanged: (val) {
                if (asset.id != null) {
                  _detailCubit.toggleStatus(asset.id!);
                }
              },
              activeColor: AppColors.main,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value, {
    bool isValueGreen = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.p7.copyWith(color: AppColors.text_tertiary),
        ),
        4.height,
        Text(
          value,
          style: AppTypography.p4.copyWith(
            color: isValueGreen ? AppColors.green60 : AppColors.text_primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedInfo(HospitalAssetModel asset) {
    final bool hasBoTaiSan = asset.hasBoTaiSan ?? false;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (hasBoTaiSan)
            _buildInfoAction(
              "Xem bộ tài sản",
              Icons.visibility_outlined,
              onTap: () => _showAssetSet(asset),
            )
          else ...[
            _buildInfoAction(
              "Thêm vào bộ tài sản",
              Icons.add,
              onTap: () async {
                final result = await context.router.push(
                  AddToSetRoute(asset: asset),
                );
                if (result == true && asset.id != null) {
                  _detailCubit.getAssetDetail(asset.id!);
                }
              },
            ),
            12.height,
            _buildInfoAction(
              "Thêm tài sản đi kèm",
              Icons.add,
              onTap: () async {
                final result = await context.router.push(
                  AddAccompanyingRoute(asset: asset),
                );
                if (result == true && asset.id != null) {
                  _detailCubit.getAssetDetail(asset.id!);
                }
              },
            ),
          ],
          16.height,
          _buildDetailRow("Tên tài sản", asset.tenTaiSan ?? "N/A"),
          _buildDetailRow(
            "Loại tài sản",
            asset.loaiTaiSan?.tenDanhMuc ?? "N/A",
          ),
          _buildDetailRow("Mã tài sản", asset.maTaiSan ?? "N/A"),
          _buildDetailRow("Số seri", asset.maSeri ?? "N/A"),
          _buildDetailRow("Model", asset.maModel ?? "N/A"),
          _buildDetailRow("Hãng sản xuất", asset.hangSanXuat ?? "N/A"),
          _buildDetailRow("Nước sản xuất", asset.nuocSanXuat ?? "N/A"),
          _buildDetailRow("Thời gian sản xuất", asset.thoiGianSanXuat ?? "N/A"),
          _buildDetailRow(
            "Ngày bắt đầu sử dụng",
            convertDateFormat(asset.ngayBatDauSuDung ?? ''),
          ),
          _buildDetailRow(
            "Thời gian tính khấu hao",
            "${asset.thoiGianTinhKhauHao ?? '0'} Năm",
          ),
          _buildDetailRow(
            "Tạo lúc",
            convertDateFormat(asset.createdAt ?? ''),
            subValue:
                asset.createdBy != null
                    ? "Bởi ${asset.createdBy!.hoVaTen}"
                    : null,
          ),
          _buildDetailRow(
            "Cập nhật lúc",
            asset.updatedAt != null
                ? convertDateFormat(asset.updatedAt!)
                : "N/A",
            subValue:
                asset.updatedBy != null
                    ? "Bởi ${asset.updatedBy!.hoVaTen}"
                    : null,
          ),
          24.height,
          _buildWideAction(
            "Truy vết khấu hao",
            Icons.visibility_outlined,
            isFilled: true,
            onTap: () => _showDepreciationTrace(asset),
          ),
          16.height,
          _buildWideAction(
            "Xem thông số kỹ thuật",
            Icons.visibility_outlined,
            onTap: () => _showTechnicalSpecs(asset),
          ),
          24.height,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {String? subValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppTypography.p6.copyWith(color: AppColors.text_tertiary),
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: AppTypography.p6.copyWith(
                    color: AppColors.text_primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
                if (subValue != null)
                  Text(
                    subValue,
                    style: AppTypography.p7.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                    textAlign: TextAlign.right,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoAction(String label, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: BaseContainer(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        isDotted: true,
        borderColor: AppColors.grey30,
        borderRadius: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTypography.p6.copyWith(
                color: AppColors.text_tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            8.width,
            Icon(icon, size: 16, color: AppColors.text_tertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildWideAction(
    String label,
    IconData icon, {
    bool isFilled = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isFilled ? AppColors.blueAlpha10 : Colors.transparent,
          border: isFilled ? null : Border.all(color: AppColors.grey30),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTypography.p5.copyWith(
                color: isFilled ? AppColors.blue60 : AppColors.text_tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.width,
            Icon(
              icon,
              size: 20,
              color: isFilled ? AppColors.blue60 : AppColors.text_tertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showDepreciationTrace(HospitalAssetModel asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AssetDepreciationBottomSheet(asset: asset),
    );
  }

  void _showTechnicalSpecs(HospitalAssetModel asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AssetTechnicalSpecsBottomSheet(asset: asset),
    );
  }

  void _showAssetSet(HospitalAssetModel asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => BlocProvider.value(
            value: _detailCubit,
            child: AssetSetBottomSheet(mainAsset: asset),
          ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BaseContainer(
        width: double.infinity,
        padding: 10.pading,
        borderRadius: 24,
        color: AppColors.grey10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.edit_outlined,
              size: 16,
              color: AppColors.text_primary,
            ),
            8.width,
            Text(
              "Chỉnh sửa",
              style: AppTypography.p6.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
