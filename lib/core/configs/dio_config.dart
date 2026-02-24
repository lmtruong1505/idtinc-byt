import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/core/env/env.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'dio_logger.dart';

@injectable
class BaseDio {
  Dio? _instance;

  Dio _dio() {
    _instance = _createDioInstance();
    return _instance!;
  }

  final isLog = kDebugMode;
  final preferences = getIt.get<Preferences>();
  final navigator = getIt.get<AppNavigator>();
  final appCubit = getIt.get<AppCubit>();

  Dio _createDioInstance() {
    late Dio dio;
    final accessToken = preferences.accessToken;
    if (accessToken == null) {
      dio = Dio(
        BaseOptions(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            "X-App-Code": "PATIENT",
          },
        ),
      );
    } else {
      if (kDebugMode) print(accessToken);

      dio = Dio(
        BaseOptions(
          headers: {
            'Authorization': "Bearer $accessToken",
            'accept': 'application/json',
            "X-DEVICE-TYPE": "mobile",
            "X-App-Code": "PATIENT",
          },
        ),
      );
    }

    dio.interceptors.clear();

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.data is Map) {
            final statusCode = response.data['status'];
            if (statusCode == 401 || statusCode == 403) {
              await appCubit.onForceLogout(isMessage: false);
            }
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          if (statusCode == 401 || statusCode == 403) {
            await appCubit.onForceLogout(isMessage: false);
          }
          return handler.next(error);
        },
      ),
      PrettyDioLogger(
        requestBody: isLog,
        responseBody: isLog,
        requestHeader: isLog,
        error: true,
        maxWidth: 90,
      ),
      CurlLoggerDioInterceptor(printOnSuccess: true),
    ]);
    return dio;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    return _dio().get(path, queryParameters: data, options: options);
  }

  Future<Response> post(String path, {Object? data, Options? options}) async {
    return _dio().post(path, data: data, options: options);
  }

  Future<Response> put(String path, {Object? data, Options? options}) async {
    return _dio().put(path, data: data, options: options);
  }

  Future<Response> delete(String path, {Object? data, Options? options}) async {
    return _dio().delete(path, data: data, options: options);
  }

  Future<String?> download(String path) async {
    final status = await Permission.storage.request();
    print(status);
    if (status == PermissionStatus.denied) {
      return null;
    }

    try {
      // Get the directory to store the image
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          "${directory.path}/qr-${DateTime.now().millisecondsSinceEpoch}.png";

      // Use Dio to download the image
      final Dio dio = Dio();
      await dio.download(path, filePath);

      return filePath; // Return the file path where the image is saved
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String baseURL = EnvironmentConfig.ENV;

  Future<List<String>> checkVersion() async {
    final List<String> notes = [];
    try {
      final be = await _dio().get('$baseURL/${Api.checkversion}');

      if (be.data['details']?['notes'] is List) {
        for (final note in be.data['details']['notes']) {
          notes.add(note);
        }
        notes.removeWhere((element) => element.nullOrEmpty);
      }
    } catch (e) {}
    return notes;
  }
}
