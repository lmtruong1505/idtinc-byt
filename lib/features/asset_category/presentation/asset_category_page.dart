import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/core/widgets/base/appbar.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/asset_category_cubit.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/asset_category_state.dart';
import 'package:bpg_retail/features/asset_category/data/bloc/asset_filter_cubit.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_filter_bottom_sheet.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_filter_widget.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetCategoryPage extends StatefulWidget {
  const AssetCategoryPage({super.key});

  @override
  State<AssetCategoryPage> createState() => _AssetCategoryPageState();
}

class _AssetCategoryPageState extends State<AssetCategoryPage> {
  final AssetFilterCubit _filterCubit = getIt.get<AssetFilterCubit>();
  final AssetCategoryCubit _categoryCubit = getIt.get<AssetCategoryCubit>();
  final ScrollController _scrollController = ScrollController();
  final Debouncer _searchDebouncer = Debouncer(
    delay: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    _categoryCubit.getAssets(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _categoryCubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _filterCubit),
        BlocProvider.value(value: _categoryCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: BaseAppBar(
          titleWidget: BlocBuilder<AssetCategoryCubit, AssetCategoryState>(
            bloc: _categoryCubit,
            builder: (context, state) {
              final int count = state.pagination?.count ?? 0;
              return Text(
                "Danh mục tài sản ($count)",
                style: AppTypography.h3.copyWith(color: AppColors.black),
              );
            },
          ),
          centerTitle: false,
          hasLeading: false,
          trailingIcons: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  context.router.push(const CreateAssetRoute());
                },
                child: const Icon(Icons.add, color: AppColors.black),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            AssetFilterWidget(
              onFilterTap: () => _showFilterBottomSheet(context),
              onSearchChanged: (value) {
                _searchDebouncer.run(() {
                  _categoryCubit.getAssets(refresh: true, search: value);
                  _filterCubit.updateSearchKeyword(value);
                });
              },
            ),
            Expanded(
              child: BlocBuilder<AssetCategoryCubit, AssetCategoryState>(
                bloc: _categoryCubit,
                builder: (context, state) {
                  if (state.status == AssetLoadStatus.loading &&
                      state.assets.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.assets.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildListState(context, state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListState(BuildContext context, AssetCategoryState state) {
    return RefreshIndicator(
      onRefresh: () => _categoryCubit.getAssets(refresh: true),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 24),
        itemCount:
            state.assets.length +
            (state.status == AssetLoadStatus.loadingMore ? 1 : 0),
        separatorBuilder: (context, index) => 8.height,
        itemBuilder: (context, index) {
          if (index < state.assets.length) {
            return AssetItemWidget(asset: state.assets[index]);
          }
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    _filterCubit.getStatistics();
    _filterCubit.getDepartments();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => AssetFilterBottomSheet(
            cubit: _filterCubit,
            onApply: () {
              final filterState = _filterCubit.state;
              _categoryCubit.getAssets(
                refresh: true,
                khoa: filterState.selectedDepartment,
                trangThai: filterState.selectedStatus,
              );
            },
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BaseContainer(
            width: 80,
            height: 80,
            isCircle: true,
            color: AppColors.grey80.withValues(alpha: 0.5),
            child: Center(
              child: BaseContainer(
                width: 48,
                height: 48,
                isCircle: true,
                color: AppColors.black,
                child: const Center(
                  child: Icon(
                    Icons.description_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          16.height,
          Text(
            "Không có tài sản",
            style: AppTypography.h3.copyWith(color: AppColors.black),
          ),
          8.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Không có dữ liệu khả dụng liên quan đến chức năng bạn truy cập",
              textAlign: TextAlign.center,
              style: AppTypography.p5.copyWith(color: AppColors.grey80),
            ),
          ),
          24.height,
          GestureDetector(
            onTap: () {
              context.router.push(const CreateAssetRoute());
            },
            child: BaseContainer(
              isDotted: true,
              borderColor: AppColors.grey80,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              borderRadius: 24,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Tạo mới tài sản",
                    style: AppTypography.p5.copyWith(
                      color: AppColors.grey80,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  8.width,
                  const Icon(Icons.add, color: AppColors.grey80, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
