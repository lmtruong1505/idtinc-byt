import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/app/data/bloc/localization_cubit.dart';
import 'package:bpg_retail/app/routes/router.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/base_state.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/utilities/localization_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends BaseState<MyApp, AppCubit>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    EasyLoading.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hủy đăng ký
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    } else if (state == AppLifecycleState.paused) {}
  }

  final appRouter = getIt.get<AppRouter>();
  final localizationBloc = LocalizationCubit();

  @override
  Widget buildPage(BuildContext context) {
    return OverlaySupport(
      child: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => localizationBloc)],
        child: BlocBuilder<LocalizationCubit, Locale>(
          builder: (context, state) {
            return MaterialApp.router(
              builder: EasyLoading.init(
                builder: (context, child) {
                  final mediaQueryData = MediaQuery.of(context);
                  final scale = mediaQueryData.textScaler.clamp(
                    minScaleFactor: 1.0,
                    maxScaleFactor: 1.0,
                  );
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: scale),
                    child: child!,
                  );
                },
              ),
              routerDelegate: appRouter.delegate(
                deepLinkBuilder: (_) => DeepLink(_mapRouteToPageRouteInfo()),
              ),
              locale: state,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), Locale('vi'),
                // Locale('en', 'US'),
                // Locale('vi', 'VN'),
              ],
              routeInformationParser: appRouter.defaultRouteParser(),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }

  List<PageRouteInfo> _mapRouteToPageRouteInfo() {
    final token = preferences.accessToken;
    if (token == null || token.isEmpty) {
      return [const LoginRoute()];
    } else {
      return [const RootRoute()];
    }
  }
}
