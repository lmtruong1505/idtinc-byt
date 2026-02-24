import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthenticationService {
  AuthenticationService(
    this._baseDio,
  );

  final BaseDio _baseDio;

  Future<dynamic> login(
    String phoneNumber,
    String password,
  ) async {
    final res = await _baseDio.post(
      //Api.login,
      Api.loginV2,
      // data: {
      //   'phone_number': phoneNumber,
      //   'password': password,
      // },
      data: {
        "phone": phoneNumber,
        "password": password,
        "system_code": "ADMIN",
      },
    );
    return res.data;
  }

  Future<dynamic> register({
    required String phoneNumber,
    required String password,
    required String fullName,
    String? referralCode,
  }) async {
    final data = {
      'phone_number': phoneNumber,
      "is_register": true,
      "type": "PATIENT",
    };

    final res = await _baseDio.post(
      Api.register,
      data: data,
    );
    return res.data;
  }

  Future<dynamic> sendOTPPhone(
    String phoneNumber,
  ) async {
    final payload = {
      'phone_number': phoneNumber,
    };

    final res = await _baseDio.post(
      Api.sendOtpPhoneV2,
      data: payload,
    );
    return res.data;
  }

  Future<dynamic> verifyOTPPhone(
    String otp,
    String phoneNumber,
    String fullName,
  ) async {
    final payload = {
      'phone': phoneNumber,
      //'full_name': fullName,
      'otp': otp,
    };

    final res = await _baseDio.post(
      Api.verifyOtpPhoneV2,
      data: payload,
    );
    return res.data;
  }


  Future<dynamic> forgotPassword(
    String phoneNumber,
  ) async {
    final res = await _baseDio.post(
      Api.forgotPasswordV2,
      data: {
        'phone': phoneNumber,
      },
    );
    return res.data;
  }

  Future<dynamic> verifyForgot(
    String otp,
    String sessionKey,
  ) async {
    final res = await _baseDio.post(
      Api.verifyForgotV2,
      data: {
        'otp_forgot': otp,
        'session_key': sessionKey,
      },
    );
    return res.data;
  }

  Future<dynamic> changePassForgot(
    String sessionKey,
    String password,
  ) async {
    final res = await _baseDio.post(
      Api.resetPasswordV2,
      data: {
        "session_key": sessionKey,
        "new_password": password,
        "confirm_password": password,
      },
    );
    return res.data;
  }

  // Future<dynamic> updatePhoneNumber(
  //   String otp,
  //   String phoneNumber,
  //   int id,
  // ) async {
  //   final res = await _baseDio.put(
  //     "${Api.updatePhoneNumber}/$id",
  //     data: {
  //       'phone_number': phoneNumber,
  //       'otp': otp,
  //     },
  //   );
  //   return res.data;
  // }

  // Future<dynamic> updateProfile(
  //   id,
  //   formData,
  // ) async {
  //   final res = await _baseDio.put(
  //     "${Api.updateProfile}/$id",
  //     data: formData,
  //   );
  //   return res.data;
  // }

  Future<dynamic> changePassword(
    String oldPassword,
    String password,
  ) async {
    final res = await _baseDio.post(
      Api.changePassword,
      data: {
        'new_password': password,
        'old_password': oldPassword,
      },
    );
    return res.data;
  }
}
