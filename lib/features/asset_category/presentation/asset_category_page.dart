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
import 'package:bpg_retail/features/asset_category/data/bloc/asset_filter_state.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_filter_bottom_sheet.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_filter_widget.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_item_widget.dart';
import 'package:bpg_retail/core/widgets/common/scroll_to_top_button.dart';
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
  bool _showScrollToTop = false;

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
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _categoryCubit.loadMore();
    }

    if (_scrollController.offset > 300 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset <= 300 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
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
                style: AppTypography.h3.copyWith(
                  color: AppColors.text_primary,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          centerTitle: false,
          hasLeading: false,
          titleSpacing: 16,
          trailingIcons: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () async {
                  final result = await context.router.push(
                    const CreateAssetRoute(),
                  );
                  if (result == true && context.mounted) {
                    _categoryCubit.getAssets(refresh: true);
                  }
                },
                child: const Icon(
                  Icons.add,
                  color: AppColors.text_primary,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const Divider(height: 1, color: AppColors.grey20),
            BlocBuilder<AssetCategoryCubit, AssetCategoryState>(
              builder: (context, state) {
                final bool isFiltering =
                    state.search.isNotEmpty ||
                    (state.khoa != null && state.khoa != 'all') ||
                    (state.trangThai != null && state.trangThai != 'Tất cả') ||
                    (state.loaiTaiSan != null && state.loaiTaiSan != 'all');

                return AssetFilterWidget(
                  isFiltering: isFiltering,
                  onFilterTap: () => _showFilterBottomSheet(context),
                  onSearchChanged: (value) {
                    _searchDebouncer.run(() {
                      _categoryCubit.getAssets(refresh: true, search: value);
                      _filterCubit.updateSearchKeyword(value);
                    });
                  },
                );
              },
            ),
            BlocBuilder<AssetFilterCubit, AssetFilterState>(
              builder: (context, filterState) {
                if (filterState.searchKeyword.isEmpty) return const SizedBox();
                return BlocBuilder<AssetCategoryCubit, AssetCategoryState>(
                  builder: (context, categoryState) {
                    final int count = categoryState.pagination?.count ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: RichText(
                              text: TextSpan(
                                style: AppTypography.p6.copyWith(
                                  color: AppColors.text_tertiary,
                                ),
                                children: [
                                  const TextSpan(text: "Có "),
                                  TextSpan(
                                    text: "$count",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.text_primary,
                                    ),
                                  ),
                                  const TextSpan(text: " kết quả tìm kiếm"),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    );
                  },
                );
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
        floatingActionButton: ScrollToTopButton(
          show: _showScrollToTop,
          onTap: () {
            if (!_scrollController.hasClients) return;
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                loaiTaiSan: filterState.selectedAssetTypeId,
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
            onTap: () async {
              final result = await context.router.push(
                const CreateAssetRoute(),
              );
              if (result == true && context.mounted) {
                _categoryCubit.getAssets(refresh: true);
              }
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
