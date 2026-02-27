import 'package:bpg_retail/core/utilities/enum.dart';

class CubitState {
  CubitStatus status;
  String message;
  dynamic data;
  CubitState({this.status = CubitStatus.init, this.message = "", this.data});

  CubitState copyWith({CubitStatus? status, String? message, dynamic data}) {
    return CubitState(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
