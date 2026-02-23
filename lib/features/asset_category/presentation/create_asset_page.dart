import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/widgets/base/appbar.dart';
import 'package:bpg_retail/core/widgets/textfield/input_column.dart';
import 'package:bpg_retail/core/widgets/two_button_box.dart';
import 'package:bpg_retail/core/widgets/datetime_picker.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/create_asset_cubit.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/create_asset_state.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_image_picker_widget.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/depreciation_method_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _cubit = CreateAssetCubit();
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

            // ── Bottom Buttons ──
            TwoButtonBox(
              leftTitle: 'Hủy bỏ',
              rightTitle: 'Lưu lại',
              leftOnTap: () => Navigator.pop(context),
              rightOnTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _cubit.submit();
                }
              },
              isDisable: false,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Image Picker ──
                AssetImagePickerWidget(
                  imagePath: state.imagePath,
                  onImagePicked: _cubit.setImage,
                  onImageRemoved: _cubit.removeImage,
                ),
                Divider(height: 1, color: AppColors.border_tertiary),
                16.height,

                // ── Tên tài sản * ──
                InputColumn(
                  label: 'Tên tài sản',
                  isRequired: true,
                  hintText: 'Nhập tên thiết bị',
                  onChanged: _cubit.updateAssetName,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                12.height,

                // ── Mã tài sản ──
                InputColumn(
                  label: 'Mã tài sản',
                  hintText: 'Nhập mã thiết bị',
                  onChanged: _cubit.updateAssetCode,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                12.height,

                // ── Loại tài sản (Dropdown) ──
                InputColumn(
                  label: 'Loại tài sản',
                  hintText: 'Chọn',
                  readOnly: true,
                  onTap: () {
                    // TODO: Mở bottom sheet chọn loại tài sản
                  },
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.grey80,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                12.height,

                // ── Đơn vị tính & Seri ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputColumn(
                          label: 'Đơn vị tính',
                          hintText: 'Nhập',
                          onChanged: _cubit.updateUnit,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: InputColumn(
                          label: 'Seri',
                          hintText: 'Nhập',
                          onChanged: _cubit.updateSerial,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                12.height,

                // ── Model & Nước sản xuất ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputColumn(
                          label: 'Model',
                          hintText: 'Nhập',
                          onChanged: _cubit.updateModel,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: InputColumn(
                          label: 'Nước sản xuất',
                          hintText: 'Nhập',
                          onChanged: _cubit.updateOrigin,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                12.height,

                // ── Hãng sản xuất & Ngày sản xuất ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputColumn(
                          label: 'Hãng sản xuất',
                          hintText: 'Nhập',
                          onChanged: _cubit.updateManufacturer,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: _buildDateField(
                          label: 'Ngày sản xuất',
                          value: state.manufacturingDate,
                          onConfirm: (date) {
                            _cubit.updateManufacturingDate(
                              convertDateYYYYMMDD(date),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                24.height,

                // ── Depreciation Method ──
                DepreciationMethodWidget(
                  method: state.depreciationMethod,
                  period: state.depreciationPeriod,
                  onMethodChanged: _cubit.setDepreciationMethod,
                  onPeriodChanged: _cubit.setDepreciationPeriod,
                ),
                24.height,

                // ── Nguyên giá ──
                InputColumn2(
                  textSuffix: 'đ',
                  label: 'Nguyên giá',
                  hintText: 'Nhập',
                  textInputType: TextInputType.number,
                  onChanged: _cubit.updateOriginalPrice,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                12.height,

                // ── Ngày bắt đầu sử dụng ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildDateField(
                    label: 'Ngày bắt đầu sử dụng',
                    value: state.usageStartDate,
                    onConfirm: (date) {
                      _cubit.updateUsageStartDate(convertDateYYYYMMDD(date));
                    },
                  ),
                ),
                12.height,

                // ── Thời gian tính khấu hao ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InputColumn2(
                          textSuffix: 'Năm',
                          label: 'Thời gian tính khấu hao',
                          hintText: 'Nhập',
                          textInputType: TextInputType.number,
                          onChanged: _cubit.updateDepreciationDuration,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                32.height,

                // ── Scroll to top ──
                Center(
                  child: GestureDetector(
                    onTap: _scrollToTop,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          color: AppColors.main,
                          size: 16,
                        ),
                        4.width,
                        Text(
                          'Lên đầu trang',
                          style: AppTypography.p5.copyWith(
                            color: AppColors.main,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                16.height,
              ],
            ),
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────────────────────
  // Tab 2: Tài sản đi kèm (placeholder)
  // ────────────────────────────────────────────────────────────
  Widget _buildAttachedAssetTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: AppColors.grey80.withValues(alpha: 0.5),
          ),
          16.height,
          Text(
            'Chưa có tài sản đi kèm',
            style: AppTypography.p5.copyWith(color: AppColors.grey80),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Helper: Date field with label
  // ────────────────────────────────────────────────────────────
  Widget _buildDateField({
    required String label,
    String? value,
    required Function(DateTime) onConfirm,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.p5.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        8.height,
        DatetimePicker(
          defaultValue: value,
          hintText: 'Chọn',
          onConfirm: onConfirm,
        ),
      ],
    );
  }
}
