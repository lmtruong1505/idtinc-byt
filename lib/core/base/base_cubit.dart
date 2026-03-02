import 'package:tasa/app/data/bloc/app_cubit.dart';
import 'package:tasa/core/navigation/navigator.dart';
import 'package:tasa/core/preferences/preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<S> extends BaseCubitDelegate<S> {
  BaseCubit(S initialState) : super(initialState);
}

abstract class BaseCubitDelegate<S> extends Cubit<S> {
  BaseCubitDelegate(S initialState) : super(initialState);

  void initState() {}

  late final AppCubit appCubit;
  late final AppNavigator navigator;
  late final Preferences preferences;
}
