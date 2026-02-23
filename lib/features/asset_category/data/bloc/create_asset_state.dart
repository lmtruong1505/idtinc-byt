import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_asset_state.freezed.dart';

/// Phương pháp tính khấu hao
enum DepreciationMethod { byTime, byUsage }

/// Chu kỳ khấu hao (khi chọn "Theo thời gian")
enum DepreciationPeriod { yearly, monthly, daily }

/// Loại hành động cho tài sản đi kèm
enum AttachedAssetAction { selectAvailable, createNew }

@freezed
abstract class AssetDetail with _$AssetDetail {
  const factory AssetDetail({
    // Ảnh tài sản
    @Default(null) String? imagePath,

    // Thông tin cơ bản
    @Default('') String assetName,
    @Default('') String assetCode,
    @Default(null) String? assetType,
    @Default('') String unit,
    @Default('') String serial,
    @Default('') String model,
    @Default('') String origin,
    @Default('') String manufacturer,

    // Ngày sản xuất & ngày bắt đầu sử dụng
    @Default(null) String? manufacturingDate,
    @Default(null) String? usageStartDate,

    // Phương pháp tính khấu hao
    @Default(DepreciationMethod.byTime) DepreciationMethod depreciationMethod,
    @Default(DepreciationPeriod.yearly) DepreciationPeriod depreciationPeriod,

    // Nguyên giá & thời gian tính khấu hao
    @Default('') String originalPrice,
    @Default('') String depreciationDuration,
  }) = _AssetDetail;
}

@freezed
abstract class AttachedAsset with _$AttachedAsset {
  const factory AttachedAsset({
    @Default(AttachedAssetAction.selectAvailable) AttachedAssetAction action,
    @Default(null) String? selectedAssetId,
    @Default(AssetDetail()) AssetDetail assetDetail,
  }) = _AttachedAsset;
}

@freezed
abstract class CreateAssetState with _$CreateAssetState {
  const factory CreateAssetState({
    // Tab hiện tại: 0 = Hồ sơ tài sản, 1 = Tài sản đi kèm
    @Default(0) int activeTab,

    // Thông tin tài sản chính
    @Default(AssetDetail()) AssetDetail mainAsset,

    // Danh sách tài sản đi kèm
    @Default([]) List<AttachedAsset> attachedAssets,
    @Default(0) int currentAttachedAssetIndex,

    // Trạng thái form
    @Default(false) bool isSubmitting,
  }) = _CreateAssetState;
}
