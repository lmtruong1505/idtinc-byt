import 'dart:convert';

RememberAccount rememberAccountFromJson(String str) =>
    RememberAccount.fromJson(json.decode(str));

String rememberAccountToJson(RememberAccount data) =>
    json.encode(data.toJson());

class RememberAccount {
  final String? phoneNumber;
  final String? password;

  RememberAccount({this.phoneNumber, this.password});

  factory RememberAccount.fromJson(Map<String, dynamic> json) =>
      RememberAccount(
        phoneNumber: json["phone_number"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
    "phone_number": phoneNumber,
    "password": password,
  };
}
