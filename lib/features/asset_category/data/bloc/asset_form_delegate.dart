import 'package:bpg_retail/features/asset_category/data/models/asset_type_model.dart';
import 'create_asset_state.dart';

/// Shared interface for cubits that provide form field updates
/// to [AssetProfileForm]. Implemented by CreateAssetCubit,
/// AddToSetCubit, and AddAccompanyingCubit.
abstract class AssetFormDelegate {
  void setImage(String path, {int? attachedIndex});
  void removeImage({int? attachedIndex});
  void updateAssetName(String v, {int? attachedIndex});
  void updateAssetCode(String v, {int? attachedIndex});
  void updateAssetType(AssetTypeModel? type, {int? attachedIndex});
  void updateUnit(String v, {int? attachedIndex});
  void updateSerial(String v, {int? attachedIndex});
  void updateModel(String v, {int? attachedIndex});
  void updateOrigin(String v, {int? attachedIndex});
  void updateManufacturer(String v, {int? attachedIndex});
  void updateManufacturingDate(String v, {int? attachedIndex});
  void updateOriginalPrice(String v, {int? attachedIndex});
  void updateUsageStartDate(String v, {int? attachedIndex});
  void updateDepreciationDuration(String v, {int? attachedIndex});
  void setDepreciationMethod(DepreciationMethod m, {int? attachedIndex});
  void setDepreciationPeriod(DepreciationPeriod p, {int? attachedIndex});
}
