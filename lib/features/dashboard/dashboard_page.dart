import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/buttons/label_button.dart';
import 'package:bpg_retail/features/dashboard/widgets/dashboard_header.dart';
import 'package:bpg_retail/features/dashboard/widgets/hospital_filter.dart';
import 'package:bpg_retail/features/dashboard/widgets/overview_cards.dart';
import 'package:bpg_retail/features/dashboard/widgets/depreciation_chart.dart';
import 'package:bpg_retail/features/dashboard/widgets/liquidation_chart.dart';
import 'package:bpg_retail/features/dashboard/widgets/asset_lists.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();

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
    return Scaffold(
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
                      // Scroll to top button
                      LabelButton(
                        label: 'Lên đầu',
                        onPressed: _scrollToTop,
                        backgroundColor: AppColors.blue50.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: AppColors.blue50,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Icon(
                          Icons.arrow_upward,
                          color: AppColors.blue50,
                          size: 20,
                        ),
                      ),
                      40.height,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
