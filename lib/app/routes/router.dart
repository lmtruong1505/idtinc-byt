import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
@singleton
class AppRouter extends $AppRouter {
  @override
  List<CustomRoute> get routes => [
    CustomRoute(
      page: RootRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: VerifyOtpRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),

    CustomRoute(
      page: LoginRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: RegisterRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: OtpVerificationRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: ForgotPasswordRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: QRScanRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),

    CustomRoute(
      page: KycCameraIdentityScreen.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: KycCameraPreview.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: KycCameraPortraitScreen.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: DashboardRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: CreateAssetRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: AssetDetailRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: AddToSetRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: AddAccompanyingRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
  ];
}
