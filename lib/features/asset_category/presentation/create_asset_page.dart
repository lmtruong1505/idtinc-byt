import 'package:auto_route/auto_route.dart';
import 'package:tasa/app/data/bloc/app_cubit.dart';
import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/injection/injection.dart';
import 'package:tasa/core/navigation/navigator.dart';
import 'package:tasa/core/preferences/preferences.dart';
import 'package:tasa/core/widgets/base/appbar.dart';
import 'package:tasa/features/asset_category/data/bloc/create_asset_cubit.dart';
import 'package:tasa/features/asset_category/data/bloc/create_asset_state.dart';
import 'package:tasa/features/asset_category/data/repositories/asset_repository.dart';
import 'package:tasa/features/asset_category/presentation/widgets/asset_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';

@RoutePage()
class CreateAssetPage extends StatefulWidget {
  const CreateAssetPage({super.key});

  @override
  State<CreateAssetPage> createState() => _CreateAssetPageState();
}

class _CreateAssetPageState extends State<CreateAssetPage>
    with SingleTickerProviderStateMixin {
  late final CreateAssetCubit _cubit;
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cubit =
        CreateAssetCubit(getIt.get<AssetRepository>())
          ..navigator = getIt.get<AppNavigator>()
          ..appCubit = getIt.get<AppCubit>()
          ..preferences = getIt.get<Preferences>();

    _cubit.loadAvailableAssets();
    _cubit.loadAssetTypes();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _cubit.switchTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          title: 'Danh sách tài sản',
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
            // ── Page Heading ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tạo mới tài sản',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // ── Tab Bar ──
            _buildTabBar(),
            Divider(height: 1, color: AppColors.border_tertiary),

            // ── Form Body ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildAssetProfileTab(), _buildAttachedAssetTab()],
              ),
            ),

            // ── Bottom Buttons matching screenshot ──
            Container(
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
                    child: BlocBuilder<CreateAssetCubit, CreateAssetState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap:
                              state.isSubmitting
                                  ? null
                                  : () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _cubit.submit();
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
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Tab Bar
  // ────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.text_primary,
      unselectedLabelColor: AppColors.text_tertiary,
      labelStyle: AppTypography.p5.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTypography.p5,
      indicatorColor: AppColors.text_primary,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: const [Tab(text: 'Hồ sơ tài sản'), Tab(text: 'Tài sản đi kèm')],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Tab 1: Hồ sơ tài sản
  // ────────────────────────────────────────────────────────────
  Widget _buildAssetProfileTab() {
    return BlocBuilder<CreateAssetCubit, CreateAssetState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 24),
            child: AssetProfileForm(
              asset: state.mainAsset,
              delegate: _cubit,
              assetTypes: state.assetTypes,
              onScrollToTop: _scrollToTop,
            ),
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────────────────────
  // Tab 2: Tài sản đi kèm
  // ────────────────────────────────────────────────────────────
  Widget _buildAttachedAssetTab() {
    return BlocBuilder<CreateAssetCubit, CreateAssetState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              // ── Nút Thêm tài sản ──
              _buildAddAttachedAssetButton(),
              24.height,

              if (state.attachedAssets.isNotEmpty) ...[
                // ── Thanh điều hướng (Tài sản đi kèm X) ──
                _buildNavigationHeader(state),
                24.height,

                // ── Nút Xóa tài sản ──
                _buildDeleteAssetButton(),
                24.height,

                // ── Radio Options ──
                _buildAttachedAssetActionOptions(state),
                24.height,

                // ── Content area ──
                _buildAttachedAssetContent(state),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachedAssetContent(CreateAssetState state) {
    final currentAsset = state.attachedAssets[state.currentAttachedAssetIndex];

    if (currentAsset.action == AttachedAssetAction.selectAvailable) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildAssetSelectionField(state),
      );
    } else {
      return AssetProfileForm(
        asset: currentAsset.assetDetail,
        delegate: _cubit,
        assetTypes: state.assetTypes,
        attachedIndex: state.currentAttachedAssetIndex,
      );
    }
  }

  Widget _buildAddAttachedAssetButton() {
    return Center(
      child: GestureDetector(
        onTap: _cubit.addAttachedAsset,
        child: DottedBorder(
          color: AppColors.grey30,
          strokeWidth: 1.2,
          dashPattern: const [4, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          child: Container(
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Thêm tài sản',
                  style: AppTypography.p5.copyWith(
                    color: AppColors.text_secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                6.width,
                const Icon(
                  Icons.add,
                  size: 18,
                  color: AppColors.text_secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationHeader(CreateAssetState state) {
    final isFirst = state.currentAttachedAssetIndex == 0;
    final isLast =
        state.currentAttachedAssetIndex == state.attachedAssets.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavButton(
            icon: Icons.chevron_left,
            enabled: !isFirst,
            onTap: _cubit.previousAttachedAsset,
          ),
          SizedBox(
            width: 180,
            child: Text(
              'Tài sản đi kèm ${state.currentAttachedAssetIndex + 1}',
              textAlign: TextAlign.center,
              style: AppTypography.p4.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildNavButton(
            icon: Icons.chevron_right,
            enabled: !isLast,
            onTap: _cubit.nextAttachedAsset,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? const Color(0xFFF2F2F3) : const Color(0xFFF8F8F8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.text_primary : AppColors.text_disable,
        ),
      ),
    );
  }

  Widget _buildDeleteAssetButton() {
    return Center(
      child: GestureDetector(
        onTap: _cubit.removeAttachedAsset,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEAEA),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Xóa tài sản',
            style: AppTypography.p5.copyWith(
              color: const Color(0xFFFF4D4D),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachedAssetActionOptions(CreateAssetState state) {
    final currentAsset = state.attachedAssets[state.currentAttachedAssetIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildRadioButton(
              label: 'Chọn tài sản có sẵn',
              isSelected:
                  currentAsset.action == AttachedAssetAction.selectAvailable,
              onTap:
                  () => _cubit.updateAttachedAssetAction(
                    AttachedAssetAction.selectAvailable,
                  ),
            ),
          ),
          12.width,
          Expanded(
            child: _buildRadioButton(
              label: 'Tạo mới tài sản',
              isSelected: currentAsset.action == AttachedAssetAction.createNew,
              onTap:
                  () => _cubit.updateAttachedAssetAction(
                    AttachedAssetAction.createNew,
                  ),
            ),
          ),
        ],
      ),
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
          Text(
            label,
            style: AppTypography.p6.copyWith(
              color: AppColors.text_primary,
              fontWeight: FontWeight.w500,
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

  Widget _buildAssetSelectionField(CreateAssetState state) {
    final currentAsset = state.attachedAssets[state.currentAttachedAssetIndex];
    final selectedId = currentAsset.selectedAssetId;
    String? displayText;
    if (selectedId != null) {
      final match = _cubit.availableAssets.where(
        (a) => a.id.toString() == selectedId,
      );
      if (match.isNotEmpty) {
        displayText = match.first.tenTaiSan;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn tài sản',
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
                'Chọn tài sản',
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
                        _cubit.updateAttachedAssetId(asset.id.toString());
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
}
