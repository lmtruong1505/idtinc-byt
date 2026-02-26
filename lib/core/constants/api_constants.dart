import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/env/env.dart';

@injectable
class Api {
  static String env = EnvironmentConfig.ENV;
  static String domain = "https://kho-benh-vien-be.too.onl";

  static String baseURL = "https://api.thachlonghai.co";
  static String baseURLV2 = domain;

  static String account = 'micro-account-$env';
  static String product = 'micro-product-$env';
  static String order = 'micro-order-$env';
  static String noti = 'micro-notification-$env';

  //wallet
  static String provinceASBC = '$baseURLV2/api/v1/locations/provinces';
  static String districtASBC = '$baseURLV2/api/v1/locations/districts';
  static String wardsASBC = '$baseURLV2/api/v1/locations/wards';
  static String verifySoftToken = '$baseURLV2/account/api/verify-soft-token/';
  static String verifyReferralCode =
      '$baseURLV2/account/api/check-referral-code/';
  static String verifyBankAccout =
      '$baseURLV2/account/api/verify-bank-account/';
  static String checkToken = '$baseURLV2/account/api/check-soft-token/';
  static String requestWithdraw =
      '$baseURLV2/api/v1/wallets/request-withdraws/';
  //auth v2
  static String loginV2 = '$baseURLV2/account/api/login';
  static String sendOtpPhoneV2 = '$baseURLV2/account/api/resend-otp-v2';
  static String verifyOtpPhoneV2 = '$baseURLV2/account/api/verify-v2';
  static String forgotPasswordV2 = '$baseURLV2/account/api/forgot_password/';
  static String verifyForgotV2 = '$baseURLV2/account/api/verify_forgot/';
  static String resetPasswordV2 = '$baseURLV2/account/api/resetpassword/';
  static String disableAccount = '$baseURLV2/account/api/update-status-account';
  static String changePassword = '$baseURLV2/account/api/change-password/';
  static String getAddressGoogleMap =
      'https://maps.googleapis.com/maps/api/geocode/json';
  static String checkversion = 'v1/auth/version';

  // sskdt
  static String login = '$baseURLV2/api/v1/xac-thuc/dang-nhap';
  static String register = '$baseURLV2/api/v1/auth/register';
  static String verifyOtpPhone = '$baseURLV2/api/v1/auth/patient-register';
  static String healthcare = '$baseURLV2/api/v1/healthcare-entity';
  static String getTransaction(int id) =>
      '$baseURLV2/api/v1/user/$id/transaction_v2';
  static String transactionDetail = '$baseURLV2/api/v1/transaction';
  static String getReports(int id) => '$baseURLV2/api/v1/user/$id/report';
  static String getWarehouses = '$baseURLV2/api/v1/warehouse';
  static String logOut = '$baseURLV2/api/v1/auth/logout';
  static String getAssetList = '$baseURLV2/api/v1/tai-san/danh-sach-tai-san';
  static String getAssetStatistics =
      '$baseURLV2/api/v1/tai-san/thong-ke-tai-san';
  static String getDepartments =
      '$baseURLV2/api/v1/to-chuc/danh-muc-khoa-kho-cua-toi';
  static String getAssetDetail(int id) =>
      '$baseURLV2/api/v1/tai-san/$id/chi-tiet-tai-san';
  static String toggleStatusActive(int id) =>
      '$baseURLV2/api/v1/tai-san/$id/toggle-status-active-tai-san';
  static String updateAsset(int id) =>
      '$baseURLV2/api/v1/tai-san/$id/cap-nhat-tai-san';
  static String getAssetTypes =
      '$baseURLV2/api/v1/du-lieu-he-thong/combobox-du-lieu-he-thong';
  static String createAsset = '$baseURLV2/api/v1/tai-san/tao-tai-san';
  static String getAssetLocationHistory(int id) =>
      '$baseURLV2/api/v1/tai-san/$id/danh-sach-vi-tri-tai-san';
}
