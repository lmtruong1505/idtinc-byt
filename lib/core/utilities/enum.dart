enum DeliveryType { pickUp, shipping }

enum CubitStatus {
  init,
  loading,
  loaded,
  success,
  error,
  loadMore,
  sendSuccess,
  sendFaild,
  update,
}

enum ForgotPasswordType { email, zalo }

enum PaymentMethodEnum { wallet, banking }

enum DeliveryMethodEnum { pickUp, ship }

enum OrderEnum {
  DRAFT(code: 'DRAFT'),
  APPROVED(code: 'APPROVED'),
  SHIPPING(code: 'SHIPPING'),
  DELIVERED(code: 'DELIVERED'),
  DONE(code: 'DONE'),
  RETURN(code: 'RETURN'),
  COMPLAINT(code: 'COMPLAINT'),
  CANCEL(code: 'CANCEL');

  const OrderEnum({this.code});
  final String? code;
}
