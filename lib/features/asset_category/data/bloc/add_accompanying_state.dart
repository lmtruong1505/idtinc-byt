import 'package:freezed_annotation/freezed_annotation.dart';
import 'create_asset_state.dart';

part 'add_accompanying_state.freezed.dart';

@freezed
abstract class AddAccompanyingState with _$AddAccompanyingState {
  const factory AddAccompanyingState({
    /// Danh sách tài sản đi kèm (carousel)
    @Default([]) List<AttachedAsset> attachedAssets,

    /// Chỉ mục tài sản đang hiển thị trong carousel
    @Default(0) int currentIndex,

    /// Trạng thái submit
    @Default(false) bool isSubmitting,
  }) = _AddAccompanyingState;
}
