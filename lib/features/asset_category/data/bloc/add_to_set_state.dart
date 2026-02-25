import 'package:freezed_annotation/freezed_annotation.dart';
import 'create_asset_state.dart';

part 'add_to_set_state.freezed.dart';

/// Loại hành động: chọn tài sản có sẵn hoặc tạo mới
enum AddToSetAction { selectExisting, createNew }

@freezed
abstract class AddToSetState with _$AddToSetState {
  const factory AddToSetState({
    @Default(AddToSetAction.selectExisting) AddToSetAction action,

    // Khi chọn tài sản có sẵn
    @Default(null) int? selectedParentId,

    // Khi tạo mới tài sản chính
    @Default(AssetDetail()) AssetDetail newParentAsset,

    // Trạng thái form
    @Default(false) bool isSubmitting,
  }) = _AddToSetState;
}
