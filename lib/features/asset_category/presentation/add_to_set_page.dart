import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';

import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/widgets/base/appbar.dart';

import 'package:bpg_retail/features/asset_category/data/bloc/add_to_set_cubit.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/add_to_set_state.dart';
import 'package:bpg_retail/features/asset_category/data/models/hospital_asset_model.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AddToSetPage extends StatefulWidget {
  final HospitalAssetModel asset;
  const AddToSetPage({super.key, required this.asset});

  @override
  State<AddToSetPage> createState() => _AddToSetPageState();
}

class _AddToSetPageState extends State<AddToSetPage> {
  late final AddToSetCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit =
        getIt.get<AddToSetCubit>()
          ..navigator = getIt.get<AppNavigator>()
          ..appCubit = getIt.get<AppCubit>()
          ..preferences = getIt.get<Preferences>()
          ..loadAvailableAssets(widget.asset.id!);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: BaseAppBar(
          title: widget.asset.tenTaiSan ?? '',
          centerTitle: false,
          textStyle: AppTypography.p5.copyWith(color: AppColors.text_primary),
          leadingIcon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.text_primary,
          ),
        ),
        body: Column(
          children: [
            // ── Page Title ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Thêm vào bộ tài sản',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // ── Body ──
            Expanded(
              child: BlocBuilder<AddToSetCubit, AddToSetState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Radio Options ──
                        _buildRadioOptions(state),
                        24.height,

                        // ── Content ──
                        if (state.action == AddToSetAction.selectExisting)
                          _buildSelectExisting(state)
                        else
                          AssetProfileForm(
                            asset: state.newParentAsset,
                            delegate: _cubit,
                            onScrollToTop: _scrollToTop,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Bottom Buttons ──
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  // Radio Options
  // ────────────────────────────────────────────────────────
  Widget _buildRadioOptions(AddToSetState state) {
    return Row(
      children: [
        Expanded(
          child: _buildRadioButton(
            label: 'Chọn tài sản có sẵn',
            isSelected: state.action == AddToSetAction.selectExisting,
            onTap: () => _cubit.switchAction(AddToSetAction.selectExisting),
          ),
        ),
        12.width,
        Expanded(
          child: _buildRadioButton(
            label: 'Tạo mới tài sản chính',
            isSelected: state.action == AddToSetAction.createNew,
            onTap: () => _cubit.switchAction(AddToSetAction.createNew),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _radioIcon(isSelected, size: 18),
          8.width,
          Flexible(
            child: Text(
              label,
              style: AppTypography.p6.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioIcon(bool isSelected, {double size = 18}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.main : AppColors.grey30,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.5,
          height: size * 0.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.main : Colors.transparent,
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  // Select Existing
  // ────────────────────────────────────────────────────────
  Widget _buildSelectExisting(AddToSetState state) {
    final selectedAsset = _cubit.availableAssets.where(
      (a) => a.id == state.selectedParentId,
    );
    final displayText =
        selectedAsset.isNotEmpty ? selectedAsset.first.tenTaiSan : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn tài sản chính',
          style: AppTypography.p6.copyWith(
            color: AppColors.text_primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.height,
        GestureDetector(
          onTap: () => _showAssetPicker(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText ?? 'Chọn',
                    style: AppTypography.p5.copyWith(
                      color:
                          displayText != null
                              ? AppColors.text_primary
                              : AppColors.text_disable,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.grey80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAssetPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              16.height,
              Text(
                'Chọn tài sản chính',
                style: AppTypography.h3.copyWith(fontWeight: FontWeight.bold),
              ),
              16.height,
              Expanded(
                child: ListView.separated(
                  itemCount: _cubit.availableAssets.length,
                  separatorBuilder:
                      (_, __) =>
                          const Divider(height: 1, color: AppColors.grey20),
                  itemBuilder: (ctx, index) {
                    final asset = _cubit.availableAssets[index];
                    // Don't show the current asset itself
                    if (asset.id == widget.asset.id) {
                      return const SizedBox.shrink();
                    }
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        asset.tenTaiSan ?? 'N/A',
                        style: AppTypography.p5.copyWith(
                          color: AppColors.text_primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        asset.maTaiSan ?? '',
                        style: AppTypography.p7.copyWith(
                          color: AppColors.text_tertiary,
                        ),
                      ),
                      onTap: () {
                        _cubit.selectParent(asset.id);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────────────────
  // Bottom Buttons
  // ────────────────────────────────────────────────────────
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'Hủy bỏ',
                  style: AppTypography.p4.copyWith(
                    color: AppColors.text_primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          12.width,
          Expanded(
            child: BlocBuilder<AddToSetCubit, AddToSetState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap:
                      state.isSubmitting
                          ? null
                          : () async {
                            final success = await _cubit.submit(
                              widget.asset.id!,
                            );
                            if (success && mounted) {
                              Navigator.pop(context, true);
                            }
                          },
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2B2B),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child:
                        state.isSubmitting
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              'Lưu lại',
                              style: AppTypography.p4.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
