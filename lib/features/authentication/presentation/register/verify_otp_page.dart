import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/base_state.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:bpg_retail/features/authentication/data/bloc/authentication_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/constants/colors.dart';

@RoutePage()
class VerifyOtpPage extends StatefulWidget {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String referralCode;
  const VerifyOtpPage({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.referralCode,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  @override
  void initState() {
    super.initState();
    bloc.startTimer();
  }

  final bloc = getIt.get<AuthenticationCubit>();
  final navigator = getIt.get<AppNavigator>();

  @override
  void dispose() {
    bloc.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.white),
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              paddingTop.height,
              24.height,
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: 999.radius,
                  color: AppColors.green_2,
                ),
                child: Center(
                  child: Assets.icons.icShieldCheck.svg(width: 24, height: 24),
                ),
              ),
              24.height,
              _formView(),
            ],
          ),
        ),
      ),
    );
  }

  Form _formView() {
    return Form(
      key: bloc.formKey,
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Xác thực OTP",
                textAlign: TextAlign.left,
                style: s24w700,
              ),
              8.height,
              Text(
                "Mã OTP đã được gửi về Zalo ",
                textAlign: TextAlign.left,
                style: s14w400.copyWith(color: AppColors.grey79),
              ),
              4.height,
              Text(
                // widget.phoneNumber ??
                '091 234 5678',
                style: s20w700.copyWith(color: AppColors.black),
              ),
              16.height,
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
                onChanged: bloc.onChangeOTP,
                onCompleted: (value) {
                  bloc.onChangeFullname(widget.fullName);
                  bloc.onChangePhoneNumber(widget.phoneNumber);
                  bloc.onChangePassword(widget.password);
                  bloc.verifyOtp();
                },
              ).padding(16.pading),
              if (state.isDisable)
                MainButton(
                  title:
                      'Gửi lại mã${state.countTime != 0 ? ' (${state.countTime} giây)' : ""}',
                  onTap: () {
                    bloc.sendOTP();
                  },
                  isDisable: state.countTime != 0,
                  largeButton: true,
                ),
            ],
          );
        },
      ).padding(16.pading),
    );
  }
}
