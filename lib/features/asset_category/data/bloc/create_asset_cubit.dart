import 'package:bpg_retail/features/asset_category/data/models/asset_type_model.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:bpg_retail/features/asset_category/data/repositories/asset_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'dart:convert';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'asset_form_delegate.dart';
import 'create_asset_state.dart';

@injectable
class CreateAssetCubit extends Cubit<CreateAssetState>
    implements AssetFormDelegate {
  final AssetRepository _assetRepository;

  late AppNavigator navigator;
  late AppCubit appCubit;
  late Preferences preferences;

  /// Danh sách tài sản có sẵn để chọn
  List<HospitalAssetModel> availableAssets = [];

  CreateAssetCubit(this._assetRepository) : super(const CreateAssetState());

  // ── Load available assets ──────────────────────────────
  Future<void> loadAvailableAssets() async {
    final response = await _assetRepository.getAssetList();
    if (response.success == true && response.data != null) {
      availableAssets = response.data!;
    }
  }

  // ── Tab ──────────────────────────────────────────────
  void switchTab(int index) {
    emit(state.copyWith(activeTab: index));
  }

  // ── Helper ──────────────────────────────────────────
  void _updateAssetDetail(
    AssetDetail Function(AssetDetail) updateFn, {
    int? attachedIndex,
  }) {
    if (attachedIndex == null) {
      emit(state.copyWith(mainAsset: updateFn(state.mainAsset)));
    } else {
      final newList = List<AttachedAsset>.from(state.attachedAssets);
      if (attachedIndex < newList.length) {
        newList[attachedIndex] = newList[attachedIndex].copyWith(
          assetDetail: updateFn(newList[attachedIndex].assetDetail),
        );
        emit(state.copyWith(attachedAssets: newList));
      }
    }
  }

  // ── Image ────────────────────────────────────────────
  @override
  void setImage(String path, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(imagePath: path),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void removeImage({int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(imagePath: null),
      attachedIndex: attachedIndex,
    );
  }

  // ── Text Fields ──────────────────────────────────────
  @override
  void updateAssetName(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(assetName: value),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void updateAssetCode(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(assetCode: value),
      attachedIndex: attachedIndex,
    );
  }

  Future<void> loadAssetTypes() async {
    final response = await _assetRepository.getAssetTypes();
    if (response.success == true && response.data != null) {
      emit(state.copyWith(assetTypes: response.data!));
    }
  }

  @override
  void updateAssetType(AssetTypeModel? type, {int? attachedIndex}) {
    _updateAssetDetail((d) {
      String updatedDuration = d.depreciationDuration;
      if (type?.metaData?.thoiGianTinhKhauHao != null) {
        updatedDuration = type!.metaData!.thoiGianTinhKhauHao!.toString();
      }
      return d.copyWith(assetType: type, depreciationDuration: updatedDuration);
    }, attachedIndex: attachedIndex);
  }

  @override
  void updateUnit(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(unit: value),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void updateSerial(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(serial: value),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void updateModel(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(model: value),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void updateOrigin(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(origin: value),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void updateManufacturer(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(manufacturer: value),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void updateOriginalPrice(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(originalPrice: value),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void updateDepreciationDuration(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(depreciationDuration: value),
      attachedIndex: attachedIndex,
    );
  }

  // ── Date Pickers ─────────────────────────────────────
  @override
  void updateManufacturingDate(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(manufacturingDate: value),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void updateUsageStartDate(String value, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(usageStartDate: value),
      attachedIndex: attachedIndex,
    );
  }

  // ── Depreciation ─────────────────────────────────────
  @override
  void setDepreciationMethod(DepreciationMethod method, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(depreciationMethod: method),
      attachedIndex: attachedIndex,
    );
  }

  @override
  void setDepreciationPeriod(DepreciationPeriod period, {int? attachedIndex}) {
    _updateAssetDetail(
      (d) => d.copyWith(depreciationPeriod: period),
      attachedIndex: attachedIndex,
    );
  }

  // ── Submit ───────────────────────────────────────────
  /// Placeholder – sẽ gọi API khi ghép backend
  Future<void> submit() async {
    emit(state.copyWith(isSubmitting: true));

    try {
      final main = state.mainAsset;

      final Map<String, dynamic> data = {
        'to_chuc': 5,
        'ten_tai_san': main.assetName,
        'ma_tai_san': main.assetCode,
        'loai_tai_san': main.assetType?.id ?? '',
        'don_vi_tinh': main.unit,
        'ma_seri': main.serial,
        'ma_model': main.model,
        'nuoc_san_xuat': main.origin,
        'hang_san_xuat': main.manufacturer,
        'nguyen_gia': double.tryParse(main.originalPrice) ?? 0,
        'thoi_gian_tinh_khau_hao': int.tryParse(main.depreciationDuration) ?? 0,
        'thoi_gian_san_xuat': main.manufacturingDate ?? '',
        'ngay_bat_dau_su_dung': main.usageStartDate ?? '',
        'khau_hao_con_lai': '', // Cần xác định field này
        'id': '',
      };

      if (main.imagePath != null && main.imagePath!.isNotEmpty) {
        data['hinh_anh'] = main.imagePath;
      }

      // Handle accompanying assets
      final List<Map<String, dynamic>> newChildren = [];
      final List<int> existingChildrenIds = [];

      int childImageIndex = 0;
      for (final attached in state.attachedAssets) {
        if (attached.action == AttachedAssetAction.createNew) {
          final detail = attached.assetDetail;
          newChildren.add({
            'to_chuc': 5,
            'ten_tai_san': detail.assetName,
            'ma_tai_san': detail.assetCode,
            'loai_tai_san': detail.assetType?.id ?? '',
            'don_vi_tinh': detail.unit,
            'ma_seri': detail.serial,
            'ma_model': detail.model,
            'nuoc_san_xuat': detail.origin,
            'hang_san_xuat': detail.manufacturer,
            'nguyen_gia': double.tryParse(detail.originalPrice) ?? 0,
            'thoi_gian_tinh_khau_hao':
                int.tryParse(detail.depreciationDuration) ?? 0,
            'thoi_gian_san_xuat': detail.manufacturingDate ?? '',
            'ngay_bat_dau_su_dung': detail.usageStartDate ?? '',
            'khau_hao_con_lai': '',
            'children': null,
          });

          // Handle child image if present (per curl: hinh_anh_0, hinh_anh_1...)
          if (detail.imagePath != null && detail.imagePath!.isNotEmpty) {
            data['hinh_anh_$childImageIndex'] = detail.imagePath;
            childImageIndex++;
          }
        } else if (attached.action == AttachedAssetAction.selectAvailable ||
            attached.action == AttachedAssetAction.selectExisting) {
          if (attached.selectedAssetId != null) {
            final id = int.tryParse(attached.selectedAssetId!);
            if (id != null) {
              existingChildrenIds.add(id);
            }
          }
        }
      }

      if (newChildren.isNotEmpty) {
        data['tao_tai_san_di_kem'] = jsonEncode(newChildren);
      }
      if (existingChildrenIds.isNotEmpty) {
        data['them_tai_san_di_kem'] = jsonEncode(existingChildrenIds);
      }

      final response = await _assetRepository.createAsset(data);

      if (response.success == true) {
        navigator.showSuccessSnackBar('Tạo tài sản thành công');
        navigator.pop(result: true);
      } else {
        navigator.showErrorSnackBar(response.message ?? 'Có lỗi xảy ra');
      }
    } catch (e) {
      navigator.showErrorSnackBar('Lỗi hệ thống: ${e.toString()}');
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }

  // ── Attached Assets ──────────────────────────────────
  void addAttachedAsset() {
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList.add(const AttachedAsset());
    emit(
      state.copyWith(
        attachedAssets: newList,
        currentAttachedAssetIndex: newList.length - 1,
      ),
    );
  }

  void removeAttachedAsset() {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList.removeAt(state.currentAttachedAssetIndex);

    int newIndex = state.currentAttachedAssetIndex;
    if (newIndex >= newList.length && newList.isNotEmpty) {
      newIndex = newList.length - 1;
    } else if (newList.isEmpty) {
      newIndex = 0;
    }

    emit(
      state.copyWith(
        attachedAssets: newList,
        currentAttachedAssetIndex: newIndex,
      ),
    );
  }

  void nextAttachedAsset() {
    if (state.currentAttachedAssetIndex < state.attachedAssets.length - 1) {
      emit(
        state.copyWith(
          currentAttachedAssetIndex: state.currentAttachedAssetIndex + 1,
        ),
      );
    }
  }

  void previousAttachedAsset() {
    if (state.currentAttachedAssetIndex > 0) {
      emit(
        state.copyWith(
          currentAttachedAssetIndex: state.currentAttachedAssetIndex - 1,
        ),
      );
    }
  }

  void updateAttachedAssetAction(AttachedAssetAction action) {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList[state.currentAttachedAssetIndex] =
        newList[state.currentAttachedAssetIndex].copyWith(action: action);
    emit(state.copyWith(attachedAssets: newList));
  }

  void updateAttachedAssetId(String? id) {
    if (state.attachedAssets.isEmpty) return;
    final newList = List<AttachedAsset>.from(state.attachedAssets);
    newList[state.currentAttachedAssetIndex] =
        newList[state.currentAttachedAssetIndex].copyWith(selectedAssetId: id);
    emit(state.copyWith(attachedAssets: newList));
  }
}
