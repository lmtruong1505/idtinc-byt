import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'base_cubit.dart';

abstract class BaseState<T extends StatefulWidget, B extends BaseCubit>
    extends BaseStateDelegate<T, B> {}

abstract class BaseStateDelegate<T extends StatefulWidget, B extends BaseCubit>
    extends State<T> {
  final AppNavigator navigator = getIt.get<AppNavigator>();
  final AppCubit appCubit = getIt.get<AppCubit>();
  final Preferences preferences = getIt.get<Preferences>();

  late final B bloc =
      getIt.get<B>()
        ..navigator = navigator
        ..appCubit = appCubit
        ..preferences = preferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<AppNavigator>(create: (_) => navigator)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) {
              // appCubit.getCurrentLocation();
              return bloc..initState();
            },
          ),
        ],
        child: buildPage(context),
      ),
    );
  }

  Widget buildPage(BuildContext context);
}
