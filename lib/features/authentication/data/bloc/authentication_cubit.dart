import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/loading.dart';
import 'package:bpg_retail/core/widgets/toast/overlay_custom.dart';
import 'package:bpg_retail/features/authentication/data/models/remember_account.dart';
import 'package:bpg_retail/features/authentication/data/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_id/android_id.dart';

import 'authentication_state.dart';

@Injectable()
class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(this._authenticationRepository)
    : super(const AuthenticationState()) {
    if (preferences.rememberAccount != null) {
      onChangePhoneNumber(preferences.rememberAccount!.phoneNumber!);
      onChangePassword(preferences.rememberAccount!.password!);
    }
    onRememberAccount(preferences.rememberAccount != null);
  }

  final AuthenticationRepository _authenticationRepository;
  final navigator = getIt.get<AppNavigator>();
  final preferences = getIt.get<Preferences>();
  // final appCubit = getIt.get<AppCubit>();
  final formKey = GlobalKey<FormState>();
  Timer? _timer;
  int countTime = 120;

  void onChangeEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void onChangeTypeOTP(ForgotPasswordType type) {
    emit(state.copyWith(type: type));
  }

  void onChangeFullname(String fullname) {
    emit(state.copyWith(fullname: fullname));
  }

  // void onChangeReferralCode(String? code) {
  //   // emit(state.copyWith(referralCode: code));
  // }

  void onChangePhoneNumber(String phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void onChangePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void onChangeConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  void onShowPassword() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void onShowConfirmPassword() {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  void onChangeOTP(String otp) {
    emit(state.copyWith(otp: otp));
  }

  void onRemember() {
    emit(state.copyWith(isRemember: !state.isRemember));
  }

  void onRememberAccount(bool isRemember) {
    emit(state.copyWith(isRemember: isRemember));
  }

  void onChangeBusiness(String business) {
    emit(state.copyWith(business: business));
  }

  void onChangeRepresent(String represent) {
    emit(state.copyWith(represent: represent));
  }

  void onChangeTax(String tax) {
    emit(state.copyWith(tax: tax));
  }

  String? validateConfirmPassword() {
    if (state.confirmPassword.isEmpty || state.password.isEmpty) {
      return null;
    }
    if (state.confirmPassword != state.password) {
      return "Mật khẩu không khớp";
    }
    return null;
  }

  void clearFormRegister() {
    emit(
      state.copyWith(
        phoneNumber: '',
        password: '',
        confirmPassword: '',
        email: '',
        fullname: '',
        otp: '',
        showPassword: false,
        showConfirmPassword: false,
      ),
    );
  }

  FutureOr onLogin(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    final deviceId = await getPermanentDeviceId();
    if (state.isRemember) {
      preferences.saveRememberAccount(
        RememberAccount(
          phoneNumber: state.phoneNumber,
          password: state.password,
        ),
      );
    } else {
      preferences.removeRememberAccount();
    }

    try {
      showLoading();
      final res = await _authenticationRepository.login(
        state.phoneNumber,
        state.password,
        deviceId,
      );

      if (res.code == 200) {
        navigator.showSuccessSnackBar(
          'Đăng nhập thành công',
          duration: const Duration(seconds: 2),
        );
        EasyLoading.dismiss();

        final authData = res.data;
        if (authData != null) {
          preferences.saveAccessToken(authData.accessToken ?? '');
          preferences.saveRefreshToken(authData.refreshToken ?? '');
          preferences.saveUserData(jsonEncode(authData.user?.toJson()));
          navigator.replaceAll([const RootRoute()]);
        }
      } else {
        navigator.showAppTopSnackBar(
          res.message ?? "Tài khoản hoặc mật khẩu không chính xác",
          type: 'error',
        );
        EasyLoading.dismiss();
      }
    } catch (e) {
      print('======$e');
      EasyLoading.dismiss();
    }
  }

  FutureOr onRegisterAsbc() async {
    if (!formKey.currentState!.validate()) return;
    try {
      showLoading();
      final res = await _authenticationRepository.register(
        fullName: state.fullname,
        password: state.password,
        email: state.email,
        phoneNumber: state.phoneNumber,
        taxCode: state.tax,
        rePresentative: state.represent,
        confirmPassword: state.confirmPassword,
      );
      EasyLoading.dismiss();
      if (res.code == 200) {
        navigator.showSuccessDialog(
          title: 'Đăng ký thành công',
          // mainTitle: 'Đến màn OTP',
          // content: 'Chào mừng bạn đến với chúng tôi. Nhập mã OTP để xác nhận tài khoản.',
          mainTitle: 'Đến màn Đăng nhập',
          content: 'Chào mừng bạn đến với chúng tôi. Trở lại màn đăng nhập.',
          hasButtonBack: false,
          accept: () {
            emit(state.copyWith(countTime: 0));
            navigator.pop();
            navigator.replace(const LoginRoute());

            // navigator.push(
            //   VerifyOtpPage(
            //     fullName: state.fullname,
            //     phoneNumber: state.phoneNumber,
            //     password: state.password,
            //     referralCode: state.userReferralCode ?? '',
            //   ),
            // );
          },
        );
      } else {
        navigator.showAppTopSnackBar(
          res.message ?? 'Có lỗi xảy ra!',
          type: 'error',
        );
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  // void onVerification() {
  //   if (!formKey.currentState!.validate()) return;

  //   navigator.push(
  //     OtpVerificationPage(
  //       email: state.email,
  //       password: state.password,
  //       fullname: state.fullname,
  //       phoneNumber: state.phoneNumber,
  //       referralCode: state.referralCode?.accountCode,
  //       userReferralCode: state.userReferralCode,
  //     ),
  //   );
  // }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    emit(state.copyWith(countTime: countTime));
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (state.countTime == 0) {
        _timer!.cancel();
      } else {
        int time = state.countTime;
        time--;
        emit(state.copyWith(countTime: time));
      }
    });
  }

  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  Future<void> sendOTP() async {
    if (state.countTime < 1) {
      try {
        showLoading();
        final res = await _authenticationRepository.sendOTPPhone(
          state.phoneNumber,
        );
        EasyLoading.dismiss();
        res.fold(
          (l) {
            navigator.showAppTopSnackBar(
              l["message"] ?? 'Có lỗi xảy ra!',
              type: 'error',
            );
          },
          (r) {
            int sendOtpCount = state.sendOtpCount;
            sendOtpCount++;
            emit(state.copyWith(sendOtpCount: sendOtpCount));
            startTimer();

            if (state.countTime < 1) {
              emit(state.copyWith(countTime: 0));
            }
          },
        );
      } catch (e) {
        EasyLoading.dismiss();
      }
    }
  }

  void setDisable(bool isDisable) {
    emit(state.copyWith(isDisable: isDisable));
  }

  // void setDisableV2(bool isDisable) {
  //   emit(state.copyWith(isDisableV2: isDisable));
  // }

  Future<void> verifyOtp() async {
    if (!formKey.currentState!.validate()) return;

    try {
      showLoading();

      final res = await _authenticationRepository.verifyOTPPhone(
        otp: state.otp,
        fullName: state.fullname,
        phoneNumber: state.phoneNumber,
        password: state.password,
        referralCode: state.userReferralCode ?? '',
      );
      EasyLoading.dismiss();
      if (res.code == 200) {
        emit(state.copyWith(step: 2, countTime: 0));
        navigator.showSuccessDialog(
          title: 'Đăng ký thành công',
          mainTitle: 'Đóng',
          content: 'Chào mừng bạn đến với chúng tôi.',
          hasButtonBack: false,
          accept: () {
            emit(state.copyWith(countTime: 0));
            navigator.popUntilRoot(useRootNavigator: true);
            navigator.push(const LoginRoute());
          },
        );
      } else {
        navigator.showAppTopSnackBar(
          res.message ?? 'Mã xác nhận không chính xá',
          type: 'error',
        );
      }
      // res.fold(
      //   (l) {
      //     navigator.showAppTopSnackBar(
      //       "Mã xác nhận không chính xác",
      //       type: 'error',
      //     );
      //   },
      //   (r) {
      //     emit(state.copyWith(step: 2, countTime: 0));
      //     navigator.showSuccessDialog(
      //       title: 'Đăng ký thành công',
      //       mainTitle: 'Đóng',
      //       content:
      //           'Chào mừng bạn đến với chúng tôi. Nhập mã OTP để xác nhận tài khoản.',
      //       hasButtonBack: false,
      //       accept: () {
      //         emit(state.copyWith(countTime: 0));
      //         navigator.popUntilRoot(useRootNavigator: true);
      //         navigator.push(LoginPage(hasAGift: false));
      //       },
      //     );
      //   },
      // );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> verifyOtpForgot() async {
    if (!formKey.currentState!.validate()) return;

    try {
      showLoading();

      final res = await _authenticationRepository.verifyForgot(
        otp: state.otp,
        sessionKey: state.sessionKey,
      );
      EasyLoading.dismiss();
      res.fold(
        (l) {
          navigator.showAppTopSnackBar(
            "Mã xác nhận không chính xác",
            type: 'error',
          );
        },
        (r) {
          emit(state.copyWith(step: 3, countTime: 0));
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> changePassForgot() async {
    if (!formKey.currentState!.validate()) return;

    try {
      showLoading();

      final res = await _authenticationRepository.changePassForgot(
        sessionKey: state.sessionKey,
        password: state.password,
      );
      EasyLoading.dismiss();
      res.fold(
        (l) {
          navigator.showAppTopSnackBar(
            l['message'] ?? "Cập nhật mật khẩu mới không thành công.",
            type: 'error',
          );
        },
        (r) {
          navigator.showSuccessDialog(
            title: 'Thông báo',
            mainTitle: 'Đóng',
            content: 'Cập nhật mật khẩu mới thành công.',
            hasButtonBack: false,
            accept: () {
              navigator.popUntilRoot(useRootNavigator: true);
              navigator.push(const LoginRoute());
            },
          );
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> forgotPassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      showLoading();

      final res = await _authenticationRepository.forgotPassword(
        state.phoneNumber,
      );
      EasyLoading.dismiss();

      res.fold(
        (l) {
          navigator.showAppTopSnackBar(
            "Số điện thoại chưa được tạo",
            type: 'error',
          );
        },
        (r) {
          startTimer();
          emit(state.copyWith(step: 2, sessionKey: r['data']['session_key']));
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  static Future<bool> requestPermissionPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showOverlayToast(title: "Dịch vụ định vị đã bị vô hiệu hóa.");
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showOverlayToast(title: "Quyền vị trí bị từ chối ");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showOverlayToast(
        title:
            "Quyền vị trí bị từ chối vĩnh viễn, chúng tôi không thể yêu cầu quyền",
      );
      return false;
    }
    return true;
  }

  void onChangeToken(String token) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _authenticationRepository.sendRequestChangeToken(
      token,
      state.otp,
    );
    if (res.code == 200) {
      emit(state.copyWith(status: CubitStatus.success, message: res.message));
    } else {
      emit(state.copyWith(status: CubitStatus.loaded, message: res.message));
    }
  }

  void setWarningMessage() {
    emit(state.copyWith(message: 'Không thể nhập mã của chính mình!'));
  }

  useDifferAccount() {
    emit(
      state.copyWith(password: '', phoneNumber: '', useRememberAccount: false),
    );
  }

  void logOut() async {
    try {
      navigator.showSuccessSnackBar(
        'Đăng xuất thành công',
        duration: const Duration(seconds: 1),
      );
      navigator.replaceAll([const LoginRoute()]);
    } catch (e) {
      EasyLoading.dismiss();
      navigator.replaceAll([const LoginRoute()]);
    }
  }

  static Future<String> getPermanentDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Lấy từ SharedPreferences nếu có
    final String? savedId = prefs.getString('device_id');

    // 2. Lấy từ phần cứng
    final String hardwareId = await _getHardwareId();

    // 3. Nếu chưa có savedId → lưu mới
    if (savedId == null || savedId.isEmpty) {
      await prefs.setString('device_id', hardwareId);
      return hardwareId;
    }

    // 4. Nếu hardware ID thay đổi → cập nhật lại
    if (savedId != hardwareId) {
      await prefs.setString('device_id', hardwareId);
      return hardwareId;
    }

    // 5. Nếu không thay đổi → dùng bản cũ
    return savedId;
  }

  static Future<String> _getHardwareId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        final androidId = await androidIdPlugin.getId();
        return androidId ?? 'unknown_android_id';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown_ios_id';
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        return macInfo.systemGUID ?? 'unknown_macos_id';
      } else if (Platform.isWindows) {
        final winInfo = await deviceInfo.windowsInfo;
        return winInfo.deviceId;
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        return linuxInfo.machineId ?? 'unknown_linux_id';
      }
    } catch (e) {
      print('Lỗi khi lấy hardware ID: $e');
    }
    return 'unknown_device_id';
  }

  Future<String?> getFcmToken() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Yêu cầu quyền (iOS cần hỏi, Android thì auto)
    await messaging.requestPermission();

    // Lấy token
    final String? token = await messaging.getToken();
    print('FCM Token: $token');

    return token;
  }
}
