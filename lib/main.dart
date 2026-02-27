import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:bpg_retail/app/presentation/my_app.dart';
import 'package:flutter/material.dart';

import 'core/injection/injection.dart';
import 'core/utilities/log_utils.dart';

void main() async {
  await runZonedGuarded(_bootstrap, _reportError);
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Color.fromARGB(50, 0, 0, 0)),
  );

  await configureDependencies();
  configLoading();

  // final Location location = Location();

  // location.serviceEnabled().then((value) {
  //   value ? null : location.requestService();
  //   location.hasPermission().then(
  //     (value) {
  //       if (value == PermissionStatus.denied) {
  //         location.requestPermission();
  //       }
  //     },
  //   );
  // });

  runApp(const MyApp());
}

void _reportError(Object error, StackTrace stackTrace) {
  LogUtils.e(error, stackTrace: stackTrace, name: 'Uncaught exception');
}
