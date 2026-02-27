import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/widgets/common/scroll_to_top_button.dart';
import 'package:bpg_retail/features/dashboard/widgets/dashboard_header.dart';
import 'package:bpg_retail/features/dashboard/widgets/hospital_filter.dart';
import 'package:bpg_retail/features/dashboard/widgets/overview_cards.dart';
import 'package:bpg_retail/features/dashboard/widgets/depreciation_chart.dart';
import 'package:bpg_retail/features/dashboard/widgets/liquidation_chart.dart';
import 'package:bpg_retail/features/dashboard/widgets/asset_lists.dart';
import 'package:flutter/material.dart';

import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/department_catalog_cubit.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/department_catalog_state.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/asset_overview_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 0;
      if (show != _showBackToTop) {
        setState(() {
          _showBackToTop = show;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  getIt.get<DepartmentCatalogCubit>()..getMyDepartments(),
        ),
        BlocProvider(
          create:
              (context) => getIt.get<AssetOverviewCubit>()..getAssetOverview(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.main,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const DashboardHeader(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: AppColors.bg_secondary_subtle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Stack(
                    children: [
                      BlocListener<
                        DepartmentCatalogCubit,
                        DepartmentCatalogState
                      >(
                        listenWhen:
                            (previous, current) =>
                                previous.selectedDepartment?.id !=
                                current.selectedDepartment?.id,
                        listener: (context, state) {
                          // Fetch new overview data when department changes
                          // If 'Toàn viện' is selected, ID is null, default to 5 in Cubit
                          context.read<AssetOverviewCubit>().getAssetOverview(
                            toChucId: state.selectedDepartment?.id,
                          );
                        },
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: Column(
                            children: [
                              const HospitalFilter(),
                              24.height,
                              const OverviewCards(),
                              24.height,
                              const DepreciationChartWidget(),
                              24.height,
                              const LiquidationChartWidget(),
                              24.height,
                              const AssetListsWidget(),
                              24.height,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ScrollToTopButton(
                            show: _showBackToTop,
                            onTap: _scrollToTop,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
