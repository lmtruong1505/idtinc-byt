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

  //card
  static String cards = '$baseURLV2/api/v1/cards/';
  static String myCards = '$baseURLV2/api/v1/cards/me';
  static String cardOrder = '$baseURLV2/api/v1/cards/orders/';
  static String confirmPayment = '$baseURLV2/api/v1/orders/confirm-payment/';
  static String createOnlineOrder = '$baseURLV2/order/api/create-order-v2/';
  static String uploadOnlineOrder =
      '$baseURLV2/order/api/confirm-payment-online/';
  static String banners = '$baseURLV2/banner/api/banner';
  static String updateStatusOrder = '$baseURLV2/order/api/update-status-order';

  //wallet
  static String wallets = '$baseURLV2/api/v1/wallets/profitable/';
  static String withdraw = '$baseURLV2/api/v1/wallets/confirm-consumer/';
  static String transactions = '$baseURLV2/api/v1/wallets/transactions';
  static String updateWallets = '$baseURLV2/api/v1/wallets/take-profit/';
  static String confirmCashback =
      '$baseURLV2/api/v1/wallets/consumer-confirmation';

  static String subdivisions = '$baseURL/$account/subdivisions/api';
  static String productURL = '$baseURL/$product/v2/product/api';
  static String categoryURL = '$baseURL/$product/v2/category/api';
  static String orderURL = '$baseURL/$order/v2/order/api';
  static String notiURL = '$baseURL/$noti/notifications_v2/notification';

  static String district = '$subdivisions/district';

  static String provinceASBC = '$baseURLV2/api/v1/locations/provinces';
  static String districtASBC = '$baseURLV2/api/v1/locations/districts';
  static String wardsASBC = '$baseURLV2/api/v1/locations/wards';
  static String opendShop = '$baseURLV2/api/v1/shops/request-open-shop/';
  static String checkOpendShop = '$baseURLV2/api/v1/shops/my-shop/';
  static String generateQR = '$baseURLV2/api/v1/wallets/vietqr/generate-qr/';
  static String getBankASBC = '$baseURLV2/order/api/bank-owner/';
  static String historyWithdraws =
      '$baseURLV2/api/v1/wallets/request-withdraws/';
  static String listBank = '$baseURLV2/account/api/banks';
  static String listMyBank = '$baseURLV2/account/api/bank-accounts';
  static String createBankAccount =
      '$baseURLV2/account/api/create-bank-account/';
  static String requestChangeSoftToken =
      '$baseURLV2/account/api/change-soft-token/';
  static String verifySoftToken = '$baseURLV2/account/api/verify-soft-token/';
  static String verifyReferralCode =
      '$baseURLV2/account/api/check-referral-code/';
  static String verifyBankAccout =
      '$baseURLV2/account/api/verify-bank-account/';
  static String checkToken = '$baseURLV2/account/api/check-soft-token/';
  static String requestWithdraw =
      '$baseURLV2/api/v1/wallets/request-withdraws/';
  static String aSBCAddress = '$baseURLV2/account/api/address-manager/';
  static String getAsbcShop = '$baseURLV2/api/v1/shops/shop-detail/';
  static String bothCategory = '$baseURLV2/api/v1/shops/category-company';

  static String myReferrer = '$baseURLV2/account/api/my-referrer/';
  static String updateReferrer = '$baseURLV2/account/api/update-referral-code/';

  //auth v2
  static String loginV2 = '$baseURLV2/account/api/login';
  static String asbcProfile = '$baseURLV2/account/api/profile/';
  static String sendOtpPhoneV2 = '$baseURLV2/account/api/resend-otp-v2';
  static String verifyOtpPhoneV2 = '$baseURLV2/account/api/verify-v2';
  static String forgotPasswordV2 = '$baseURLV2/account/api/forgot_password/';
  static String verifyForgotV2 = '$baseURLV2/account/api/verify_forgot/';
  static String resetPasswordV2 = '$baseURLV2/account/api/resetpassword/';
  static String disableAccount = '$baseURLV2/account/api/update-status-account';
  static String myGroup = '$baseURLV2/account/api/my-group';
  static String changePassword = '$baseURLV2/account/api/change-password/';
  static String viettelPost = 'https://api.kafa.pro/order/api/getlistservice/';

  // order
  static String orderList = '$orderURL/tmdt_order_list';
  static String orderDetail = '$orderURL/tmdt_order_detail';

  //newApi
  static String categories = '$categoryURL/in/category';

  //PRODUCT NEW
  static String rating = '$productURL/product_rating';
  static String getRating = '$productURL/product_rating_list';
  static String topRatingProduct = '$productURL/product_top_sale';
  static String promotion = '$productURL/list_promotion_tmdt';
  static String updatePromotion = '$productURL/update_status_promotion_tmdt';
  static String getFirstPurchaseGift = '$productURL/check_first_order';
  static String promotionDetail = '$productURL/promotion_account_detail';

  //PRODUCT ASBC
  static String productsV2 = '$baseURLV2/product/api/product';
  static String productsByCate =
      '$baseURLV2/product/api/product-option-category';
  static String categoryAsbc = '$baseURLV2/product/api/product-category';
  static String favorite = '$baseURLV2/product/api/product-favorite';
  static String addToCartV2 = '$baseURLV2/order/api/add-item-cart';

  //ORDER ASBC
  static String ordersV2 = '$baseURLV2/order/api/order';
  static String ordersV1 = '$baseURLV2/api/v1/orders';
  static String ordersCountV2 = '$baseURLV2/order/api/count-order';
  static String ordersCancelV2 = '$baseURLV2/order/api/cancel-order';
  static String qrOrderDetail = '$baseURLV2/api/v1/orders';
  static String carts = '$baseURLV2/order/api/cart-view';
  static String deleteCarts = '$baseURLV2/order/api/delete-item-cart';
  static String updatePrd = '$baseURLV2/order/api/update-quantity-item-cart';

  //ORDER NEW
  static String getCarts = '$orderURL/shopping-cart/list_shopping_cart/';
  static String deleteOrderProduct =
      '$orderURL/shopping-cart/delete_shopping_cart/';
  static String updateOrderProduct =
      '$orderURL/shopping-cart/update_shopping_cart/';
  static String updateOrderV2 = '$orderURL/update_status_order_tmdt/';
  static String getTotalOrder = '$orderURL/list_order_status_tmdt/';
  static String seenNoti = '$notiURL/seen';
  static String deleteNoti = '$notiURL/delete';
  static String updateDeviceToken =
      '$baseURL/$noti/notifications_v2/token/create_or_update_token';
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
  static String getUser = '$baseURLV2/api/v1/auth/profile';
  static String logOut = '$baseURLV2/api/v1/auth/logout';
  static String getAssetList = '$baseURLV2/api/v1/tai-san/danh-sach-tai-san';
}
