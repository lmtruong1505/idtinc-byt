import 'dart:async';
import 'package:tasa/core/core.dart';
import 'package:tasa/app/data/bloc/app_state.dart';
import 'package:tasa/app/routes/router.gr.dart';
import 'package:tasa/core/base/base_cubit.dart';
import 'package:tasa/core/utilities/loading.dart';
import 'package:tasa/core/widgets/address_selection/bloc/address_selection_cubit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppCubit extends BaseCubit<AppState> {
  AppCubit() : super(const AppState());

  @override
  void initState() async {
    if (preferences.accessToken != null) {
      setLoading(true);
      onAppInitialized();
      setLoading(false);
      getProvinces();
    }
    super.initState();
  }

  void getProvinces() async {
    final addressSelectionCubit = getIt.get<AddressSelectionCubit>();
    final provinces = await addressSelectionCubit.getProvinces();
    setProvinces(provinces);
  }

  void setProvinces(List<dynamic> provinces) {
    emit(state.copyWith(provinces: provinces));
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void setLoadingAddress(bool isLoadingAddress) {
    emit(state.copyWith(isLoadingAddress: isLoadingAddress));
  }

  void onAppInitialized() {
    if (preferences.accessToken != null) {
      emit(state.copyWith(isLoggedIn: true));
    } else {
      emit(state.copyWith(isLoggedIn: false));
      emit(state.copyWith(avatar: null));
    }
  }

  FutureOr onForceLogout({bool? isMessage = true}) async {
    try {
      showLoading();
      // await preferences.removeCurrentUser();
      EasyLoading.dismiss();
      // onAppInitialized();
      if (isMessage == true) {
        navigator.showSuccessSnackBar(
          'Đăng xuất thành công',
          duration: const Duration(seconds: 1),
        );
        navigator.replaceAll([const LoginRoute()]);
      }

      navigator.replaceAll([const LoginRoute()]);
    } catch (e) {
      print(e);
      navigator.replaceAll([const LoginRoute()]);
      EasyLoading.dismiss();
    }
  }

  void setCustomId(String customId) {
    emit(state.copyWith(customId: customId));
  }
}
