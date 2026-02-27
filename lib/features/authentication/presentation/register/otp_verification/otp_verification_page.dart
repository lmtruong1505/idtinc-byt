import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/base_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:bpg_retail/features/authentication/data/bloc/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

@RoutePage()
class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String password;
  final String fullname;
  final String phoneNumber;
  final String? referralCode;
  final String? userReferralCode;

  const OtpVerificationPage({
    Key? key,
    required this.email,
    required this.password,
    required this.fullname,
    required this.phoneNumber,
    required this.referralCode,
    required this.userReferralCode,
  }) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final bloc = getIt.get<AuthenticationCubit>();
  final navigator = getIt.get<AppNavigator>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationCubit>(
      create: (context) => bloc,
      child: BaseScaffold(
        body: Container(
          padding: Spacing.a16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: 38,
                height: 38,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Xác nhận OTP', style: AppTypography.h4),
              const SizedBox(height: 16),
              const Text('Số điện thoại', style: AppTypography.p5),
              const SizedBox(height: 8),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                buildWhen:
                    (previous, current) =>
                        previous.countTime != current.countTime,
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.border_1,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border_2, width: 1.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.phoneNumber,
                            style: AppTypography.p5,
                            maxLines: 1,
                          ),
                        ),
                        if (state.sendOtpCount < 1)
                          GestureDetector(
                            onTap: () {
                              // bloc.sendOTP(widget.phoneNumber, widget.email, 0);
                            },
                            child: Text(
                              'Gửi OTP',
                              style: AppTypography.h6.copyWith(
                                color: AppColors.main,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
                  builder: (context, state) {
                    if (state.sendOtpCount > 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          BlocBuilder<AuthenticationCubit, AuthenticationState>(
                            builder: (context, state) {
                              return Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Mã xác thực được gửi đến SĐT ${widget.phoneNumber}",
                                      style: AppTypography.p5,
                                    ),
                                    const Text(
                                      "Vui lòng nhập mã OTP để xác thực.",
                                      style: AppTypography.p5,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Mã OTP', style: AppTypography.p5),
                          const SizedBox(height: 8),
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.transparent,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(8),
                              borderWidth: 1,
                              fieldHeight: 45,
                              fieldWidth: 45,
                              inactiveColor:
                                  state.isOTPVerify == 0
                                      ? AppColors.red_1
                                      : AppColors.border_2,
                              activeColor:
                                  state.isOTPVerify == 0
                                      ? AppColors.red_1
                                      : AppColors.border_2,
                            ),
                            errorTextSpace: 20,
                            errorTextMargin: const EdgeInsets.only(left: 0),
                            textStyle: AppTypography.h4,
                            validator: (value) {
                              if (value!.isEmpty) {
                                bloc.setDisable(true);
                                return 'Bạn cần hoàn thiện trường này';
                              } else if (value.length < 6) {
                                bloc.setDisable(true);
                                return 'Bạn cần nhập đủ 6 số mã code';
                              } else if (state.isOTPVerify == 0) {
                                bloc.setDisable(true);
                                return 'Mã OTP không đúng hoặc đã hết hạn';
                              }
                              bloc.setDisable(false);
                              return null;
                            },
                            onCompleted: (value) {
                              bloc.onChangeOTP(value);
                            },
                          ),
                          const SizedBox(height: 6),
                          if (state.sendOtpCount > 0)
                            Row(
                              children: [
                                if (state.countTime > 0)
                                  Text(
                                    "Bạn chưa nhận được mã. Gửi lại (${formatMinute(state.countTime)})",
                                    style: AppTypography.p5,
                                  ),
                                if (state.countTime < 1)
                                  const Text(
                                    "Bạn chưa nhận được mã. ",
                                    style: AppTypography.p5,
                                  ),
                                if (state.countTime < 1)
                                  InkWell(
                                    onTap: () {
                                      // bloc.sendOTP(
                                      //   widget.phoneNumber,
                                      //   widget.email,
                                      //   0,
                                      // );
                                    },
                                    child: Text(
                                      'Gửi lại',
                                      style: AppTypography.p5.copyWith(
                                        color: AppColors.main,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  return state.sendOtpCount > 0
                      ? SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: MainButton(
                          title: 'Xác nhận',
                          onTap: () {
                            // bloc.onRegister(
                            //   widget.phoneNumber,
                            //   widget.password,
                            //   widget.email,
                            //   widget.fullname,
                            //   widget.referralCode,
                            //   widget.userReferralCode,
                            // );
                          },
                          isDisable: state.isDisable,
                          largeButton: true,
                        ),
                      )
                      : const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Đã có tài khoản? ', style: AppTypography.p6),
                  GestureDetector(
                    onTap: () {
                      navigator.replaceAll([
                        const RootRoute(),
                        const LoginRoute(),
                      ]);
                    },
                    child: Text(
                      'Đăng nhập',
                      style: AppTypography.p5.copyWith(color: AppColors.main),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
