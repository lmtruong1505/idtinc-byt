import 'package:auto_route/auto_route.dart';
import 'package:tasa/app/routes/router.gr.dart';
import 'package:tasa/core/widgets/base_container.dart';
import 'package:tasa/features/asset_category/presentation/asset_category_page.dart';
import 'package:tasa/features/dashboard/dashboard_page.dart';
import 'package:tasa/features/profile/presentation/personal_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasa/app/data/bloc/app_state.dart';
import 'package:tasa/core/base/index_cubit.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/core/utilities/assets.dart';

import '../../app/data/bloc/app_cubit.dart';

@RoutePage()
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final indexCubit = IndexCubit();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<IndexCubit, int>(
          bloc: indexCubit,
          listener: (context, state) {
            _tabController.animateTo(state, duration: 300.milliseconds);
          },
        ),
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state.isLoggedIn) {}
        },
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: _btnNav(),
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const DashboardPage(),
                AssetCategoryPage(),
                Container(
                  color: AppColors.bg_6,
                  child: const Center(
                    child: Text(
                      'Tính năng này đang được phát triển',
                      style: s16w500,
                    ),
                  ),
                ),
                Container(
                  color: AppColors.bg_6,
                  child: const Center(
                    child: Text(
                      'Tính năng này đang được phát triển',
                      style: s16w500,
                    ),
                  ),
                ),
                const PersonalInfoPage(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _btnNav() {
    return BlocBuilder<IndexCubit, int>(
      bloc: indexCubit,
      builder: (context, state) {
        return BaseContainer(
          padding: const EdgeInsets.symmetric(vertical: 12),
          borderRadius: 0,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _iconBtn(icon: 'ic_home', index: 0),
                _iconBtn(icon: 'ic_laptop_medical', index: 1),
                _qrBtn(),
                _iconBtn(icon: 'ic_noti', index: 2),
                _iconBtn(icon: 'ic_bars', index: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _iconBtn({required String icon, required int index}) {
    return InkWell(
      onTap: () {
        indexCubit.set(index);
      },
      child: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: Assets.icon(
            assetName: "${icon}_active.svg",
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              index == indexCubit.state ? AppColors.blackish : AppColors.grey79,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _qrBtn() {
    return InkWell(
      onTap: () => context.router.push(const QRScanRoute()),
      borderRadius: BorderRadius.circular(28),
      child: BaseContainer(
        width: 56,
        height: 56,
        isCircle: true,
        borderColor: AppColors.greyE2,
        borderWidth: 2,
        color: Colors.transparent,
        child: Center(
          child: BaseContainer(
            width: 44,
            height: 44,
            isCircle: true,
            color: AppColors.accent_4,
            child: Center(
              child: Assets.icon(
                assetName: "ic_qrcode.svg",
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
