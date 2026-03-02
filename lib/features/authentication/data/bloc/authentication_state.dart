import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasa/core/utilities/enum.dart';

part 'authentication_state.freezed.dart';

@freezed
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default('') String phoneNumber,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String email,
    @Default('') String fullname,
    @Default('') String otp,
    @Default('') String business,
    @Default('') String represent,
    @Default('') String tax,

    String? userReferralCode,
    @Default(false) bool showPassword,
    @Default(false) bool showConfirmPassword,
    @Default(false) bool isRemember,
    @Default(0) int countTime,
    @Default(0) int sendOtpCount,
    @Default(3) int isOTPVerify,
    @Default(true) bool isDisable,
    @Default(false) bool isDisableV2,
    @Default(1) int step,
    @Default(false) bool toPromotionScreen,
    @Default(true) bool useRememberAccount,
    @Default('') String sessionKey,
    @Default(ForgotPasswordType.email) ForgotPasswordType type,
    @Default(CubitStatus.init) CubitStatus status,
    @Default("") String? message,
  }) = _AuthenticationState;
}
