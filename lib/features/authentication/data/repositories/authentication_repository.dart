import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tasa/core/base/base_response.dart';
import 'package:tasa/core/configs/dio_config.dart';
import 'package:tasa/core/constants/api_constants.dart';
import 'package:tasa/features/authentication/data/models/auth_response.dart';
import 'package:tasa/features/authentication/data/services/authentication_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthenticationRepository {
  AuthenticationRepository(this._authenticationService, this._baseDio);

  final AuthenticationService _authenticationService;

  final BaseDio _baseDio;

  Future<BaseResponseModel<AuthResponse>> login(
    String phoneNumber,
    String password,
    String deviceId,
  ) async {
    try {
      final res = await _baseDio.post(
        Api.login,
        data: {
          'device_id': deviceId,
          "tai_khoan": phoneNumber,
          "mat_khau": password,
        },
      );
      if (res.data['success'] == true) {
        final authResponse = AuthResponse.fromJson(res.data['data']);
        return BaseResponseModel(code: 200, data: authResponse);
      } else {
        return BaseResponseModel(
          code: res.data['status'] ?? 400,
          message: res.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  Future<BaseResponseModel> register({
    required String email,
    required String password,
    required String fullName,
    String? rePresentative,
    String? taxCode,
    required String phoneNumber,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        "email": email,
        "password": password,
        "fullname": fullName,
        "confirm_password": confirmPassword,
        "representative": rePresentative,
        "tax_code": taxCode,
        "phone_number": phoneNumber,
      };
      final res = await _baseDio.post(Api.register, data: data);
      if (res.data['success'] == true) {
        return BaseResponseModel(code: 200, data: res.data);
      } else {
        return BaseResponseModel(
          code: res.data['status'],
          message: res.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  Future<Either<dynamic, dynamic>> sendOTPPhone(String phoneNumber) async {
    try {
      final response = await _authenticationService.sendOTPPhone(phoneNumber);
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  Future<BaseResponseModel> verifyOTPPhone({
    required String phoneNumber,
    required String otp,
    required String fullName,
    required String referralCode,
    required String password,
  }) async {
    try {
      // final response = await _authenticationService.verifyOTPPhone(
      //   otp,
      //   phoneNumber,
      //   fullName,
      // );
      final payload = {
        'phone_number': phoneNumber,
        'full_name': fullName,
        "password": password,
        "referral_code": referralCode,
        "otp_code": otp,
      };

      final response = await _baseDio.post(Api.verifyOtpPhone, data: payload);
      if (response.data['success'] == true) {
        return BaseResponseModel(code: 200, data: response.data);
      } else {
        return BaseResponseModel(
          code: response.data['status'],
          message: response.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }

  // Future<Either<dynamic, dynamic>> sendOTP(
  //   String email,
  //   String phoneNumber,
  //   int type,
  // ) async {
  //   try {
  //     final response = await _authenticationService.sendOTP(
  //       email,
  //       phoneNumber,
  //       type,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  // Future<Either<dynamic, dynamic>> sendOTPSubject(
  //   bool isForgot,
  //   String? email,
  //   String subject,
  //   String message,
  //   String? phoneNumber,
  //   int? id,
  //   int sendOtpCode,
  // ) async {
  //   try {
  //     final response = await _authenticationService.sendOTPSubject(
  //       isForgot = isForgot,
  //       email = email,
  //       subject = subject,
  //       message = message,
  //       phoneNumber = phoneNumber,
  //       id = id,
  //       sendOtpCode,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  // Future<Either<dynamic, dynamic>> verifyOTP(
  //   String otp,
  //   int optCode,
  //   String? email,
  //   String? phoneNumber,
  // ) async {
  //   try {
  //     final response = await _authenticationService.verifyOTP(
  //       otp,
  //       optCode,
  //       email,
  //       phoneNumber,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  Future<Either<dynamic, dynamic>> forgotPassword(String phoneNumber) async {
    try {
      final response = await _authenticationService.forgotPassword(phoneNumber);
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  Future<Either<dynamic, dynamic>> verifyForgot({
    required String otp,
    required String sessionKey,
  }) async {
    try {
      final response = await _authenticationService.verifyForgot(
        otp,
        sessionKey,
      );
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  Future<Either<dynamic, dynamic>> changePassForgot({
    required String password,
    required String sessionKey,
  }) async {
    try {
      final response = await _authenticationService.changePassForgot(
        sessionKey,
        password,
      );
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  // Future<Either<dynamic, dynamic>> updatePhoneNumber(
  //   String otp,
  //   String phoneNumber,
  //   int id,
  // ) async {
  //   try {
  //     final response = await _authenticationService.updatePhoneNumber(
  //       otp,
  //       phoneNumber,
  //       id,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  // Future<Either<dynamic, dynamic>> updateProfile(
  //   int id,
  //   FormData formData,
  // ) async {
  //   try {
  //     final response = await _authenticationService.updateProfile(
  //       id,
  //       formData,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  Future<Either<dynamic, dynamic>> changePassword(
    String oldPassword,
    String password,
  ) async {
    try {
      final response = await _authenticationService.changePassword(
        oldPassword,
        password,
      );
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  Future<BaseResponseModel> deactive(int? id) async {
    try {
      final res = await _baseDio.put('${Api.disableAccount}/$id');
      if (res.data["code"] == 200) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel> sendRequestChangeToken(
    String token,
    String otp,
  ) async {
    try {
      final payload = {"session": token, "otp": otp};
      final response = await _baseDio.post(Api.verifySoftToken, data: payload);
      if (response.data["code"] == 200) {
        return BaseResponseModel(
          code: 200,
          message: "Tạo yêu cầu đổi mã token thành công",
        );
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }

  Future<BaseResponseModel> verifyBankAccout(String phone, String otp) async {
    try {
      final payload = {"phone": phone, "otp": otp};
      final response = await _baseDio.post(Api.verifyBankAccout, data: payload);
      if (response.data["code"] == 200) {
        return BaseResponseModel(
          code: 200,
          message: "Tạo yêu cầu đổi mã token thành công",
        );
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }

  Future<BaseResponseModel> logOut() async {
    try {
      final res = await _baseDio.get(Api.logOut);
      if (res.data["success"] == true) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
}
