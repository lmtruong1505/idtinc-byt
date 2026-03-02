import 'dart:async';
import 'dart:convert';
import 'package:tasa/core/constants/preference_keys.dart';
import 'package:tasa/features/authentication/data/models/login_model.dart';
import 'package:tasa/features/authentication/data/models/remember_account.dart';
import 'package:tasa/features/authentication/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Preferences {
  Preferences(this._preferences);

  final SharedPreferences _preferences;

  String? get accessToken {
    return _preferences.getString(PrefKeys.accessToken);
  }

  String? get refreshToken {
    return _preferences.getString(PrefKeys.refreshToken);
  }

  String? get language {
    return _preferences.getString(PrefKeys.language);
  }

  RememberAccount? get rememberAccount {
    final user = _preferences.getString(PrefKeys.rememberAccount) ?? '';
    return user.isNotEmpty ? RememberAccount.fromJson(jsonDecode(user)) : null;
  }

  LoginModel get currentUser {
    final user = _preferences.getString(PrefKeys.currentUser) ?? '{}';
    return LoginModel.fromJson(jsonDecode(user));
  }

  UserModel get getUserData {
    final user = _preferences.getString(PrefKeys.userData) ?? '{}';
    try {
      return UserModel.fromJson(jsonDecode(user));
    } catch (e) {
      return UserModel();
    }
  }

  String get cartPrds {
    final data = _preferences.getString(PrefKeys.cart) ?? '[]';
    return data;
  }

  List get locations {
    final booths = _preferences.getString(PrefKeys.location) ?? '[]';
    return jsonDecode(booths);
  }

  List get accountDisabled {
    final account = _preferences.getString(PrefKeys.accountDisabled) ?? '[]';
    return jsonDecode(account);
  }

  bool get isFirstLogin {
    return (_preferences.getString(PrefKeys.isFirstLogin) ?? '').isNotEmpty;
  }

  bool get isFirstLaunchApp {
    return (_preferences.getString(PrefKeys.isFirstLaunchApp) ?? '').isNotEmpty;
  }

  Future<void> removeCurrentUser() async {
    await Future.wait([
      _preferences.remove(PrefKeys.currentUser),
      _preferences.remove(PrefKeys.accessToken),
      _preferences.remove(PrefKeys.refreshToken),
      _preferences.remove(PrefKeys.userData),
    ]);
  }

  Future<bool> saveRememberAccount(RememberAccount account) {
    return _preferences.setString(
      PrefKeys.rememberAccount,
      jsonEncode(account),
    );
  }

  FutureOr removeRememberAccount() {
    _preferences.remove(PrefKeys.rememberAccount);
  }

  Future<bool> saveAccessToken(String token) async {
    final success = await _preferences.setString(PrefKeys.accessToken, token);
    print(token);

    return success;
  }

  Future<bool> saveRefreshToken(String token) async {
    final success = await _preferences.setString(PrefKeys.refreshToken, token);
    return success;
  }

  Future<bool> saveCurrentUser(String currentUser) async {
    final success = await _preferences.setString(
      PrefKeys.currentUser,
      currentUser,
    );
    return success;
  }

  Future<bool> saveUserData(String currentUser) async {
    final success = await _preferences.setString(
      PrefKeys.userData,
      currentUser,
    );
    return success;
  }

  Future<bool> saveBoothFavorite(String boothFavorite) async {
    final success = await _preferences.setString(
      PrefKeys.boothFavorite,
      boothFavorite,
    );
    return success;
  }

  Future<bool> saveCarts(String carts) async {
    final success = await _preferences.setString(PrefKeys.cart, carts);
    return success;
  }

  Future<bool> saveLocation(String location) async {
    final success = await _preferences.setString(PrefKeys.location, location);
    return success;
  }

  Future<bool> saveProductFavorite(String productFavorite) async {
    final success = await _preferences.setString(
      PrefKeys.productFavorite,
      productFavorite,
    );
    return success;
  }

  Future<bool> saveProductFavoriteV2(String productFavorite) async {
    final success = await _preferences.setString(
      PrefKeys.productFavoriteV2,
      productFavorite,
    );
    return success;
  }

  Future<bool> saveViewedBooths(String viewedBooths) async {
    final success = await _preferences.setString(
      PrefKeys.viewedBooths,
      viewedBooths,
    );
    return success;
  }

  Future<bool> saveAccountDisabled(String accountDisabled) async {
    final success = await _preferences.setString(
      PrefKeys.accountDisabled,
      accountDisabled,
    );
    return success;
  }

  Future<bool> saveLanguage(String value) async {
    final success = await _preferences.setString(PrefKeys.language, value);
    return success;
  }
}
