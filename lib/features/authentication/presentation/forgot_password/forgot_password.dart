import 'package:auto_route/auto_route.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/init_ext.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/injection/injection.dart';
import 'package:tasa/core/widgets/banner_asbc.dart';
import 'package:tasa/core/widgets/buttons/main_button.dart';
import 'package:tasa/core/widgets/common/title_required.dart';
import 'package:tasa/core/widgets/textfield/validate_textfield.dart';
import 'package:tasa/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:tasa/features/authentication/data/bloc/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final bloc = getIt.get<AuthenticationCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        bloc: bloc,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [const BannerAsbc(), 24.height, _formView()],
            ),
          );
        },
      ),
    );
  }

  Form _formView() {
    return Form(
      key: bloc.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Quên mật khẩu",
            textAlign: TextAlign.left,
            style: s24w700,
          ),
          if (bloc.state.step == 1) step1(),
          if (bloc.state.step == 2) step2(),
          if (bloc.state.step == 3) step3(),
        ],
      ).padding(16.pading),
    );
  }

  Widget step3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        24.height,
        requiredTitle("Mật khẩu mới"),
        const SizedBox(height: 8),
        ValidateTextField(
          margin: EdgeInsets.zero,
          backgroundColor: AppColors.white,
          hintText: 'Nhập mật khẩu',
          hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
          maxLines: 1,
          onChanged: bloc.onChangePassword,
          obscureText: !bloc.state.showPassword,
          suffixIcon: GestureDetector(
            onTap: bloc.onShowPassword,
            child: Icon(
              !bloc.state.showPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: AppColors.grey_1,
              size: 20,
            ),
          ),
          validator: (value) {
            final RegExp regex = RegExp(
              r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\][:()"`;+\-|_?,.</\\>=$%}{^&*~]).{8,}$',
            );
            if (value?.isEmpty ?? false) {
              return 'Hãy nhập mật khẩu';
            }
            if (!regex.hasMatch(value ?? '')) {
              return "Mật khẩu phải chứa ít nhất một số\nMột ký tự đặc biệt và phải có ít nhất 8 ký tự";
            }
            return bloc.validateConfirmPassword();
          },
        ),
        const SizedBox(height: 16),
        requiredTitle("Xác nhận mật khẩu mới"),
        const SizedBox(height: 8),
        ValidateTextField(
          margin: EdgeInsets.zero,
          backgroundColor: AppColors.white,
          hintText: 'Nhập mật khẩu',
          hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
          maxLines: 1,
          onChanged: bloc.onChangeConfirmPassword,
          obscureText: !bloc.state.showConfirmPassword,
          suffixIcon: GestureDetector(
            onTap: bloc.onShowConfirmPassword,
            child: Icon(
              !bloc.state.showConfirmPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: AppColors.grey_1,
              size: 20,
            ),
          ),
          validator: (value) {
            final RegExp regex = RegExp(
              r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\][:()"`;+\-|_?,.</\\>=$%}{^&*~]).{8,}$',
            );
            if (value?.isEmpty ?? false) {
              return 'Hãy nhập mật khẩu';
            }
            if (!regex.hasMatch(value ?? '')) {
              return "Mật khẩu phải chứa ít nhất một số\nMột ký tự đặc biệt và phải có ít nhất 8 ký tự";
            }
            return bloc.validateConfirmPassword();
          },
        ),
        16.height,
        SizedBox(
          height: 45,
          width: double.infinity,
          child: MainButton(
            title: 'Xác nhận đổi mật khẩu',
            onTap: () {
              bloc.changePassForgot();
            },
            isDisable: bloc.state.countTime != 0,
            largeButton: true,
          ),
        ),
        16.height,
      ],
    );
  }

  Widget step2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        8.height,
        Text(
          "Nhập mã OTP được gửi về Zalo theo số điện thoại của bạn để xác nhận thông tin",
          textAlign: TextAlign.left,
          style: s14w400.copyWith(color: AppColors.grey79),
        ),
        24.height,
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
                bloc.state.isOTPVerify == 0
                    ? AppColors.red_1
                    : AppColors.border_2,
            activeColor:
                bloc.state.isOTPVerify == 0
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
            } else if (bloc.state.isOTPVerify == 0) {
              bloc.setDisable(true);
              return 'Mã OTP không đúng hoặc đã hết hạn';
            }
            bloc.setDisable(false);
            return null;
          },
          onChanged: bloc.onChangeOTP,
          onCompleted: (value) {
            bloc.verifyOtpForgot();
          },
        ).padding(16.pading),
        16.height,
        if (bloc.state.isDisable)
          SizedBox(
            height: 45,
            width: double.infinity,
            child: MainButton(
              title:
                  'Gửi lại mã${bloc.state.countTime != 0 ? ' (${bloc.state.countTime} giây)' : ""}',
              onTap: () {
                bloc.sendOTP();
              },
              isDisable: bloc.state.countTime != 0,
              largeButton: true,
            ),
          ),
        16.height,
      ],
    );
  }

  Widget step1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        24.height,
        ValidateTextField(
          margin: EdgeInsets.zero,
          backgroundColor: AppColors.white,
          hintText: 'Nhập số điện thoại',
          hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
          maxLines: 1,
          onChanged: bloc.onChangePhoneNumber,
          validator: (value) {
            final RegExp regex = RegExp(r'^0\d{9,11}$');
            if (value?.isEmpty ?? false) {
              return 'Hãy nhập số điện thoại';
            }
            if (!regex.hasMatch(value ?? '')) {
              return "Số điện thoại không đúng định dạng";
            }
            return null;
          },
        ),
        16.height,
        SizedBox(
          height: 45,
          width: double.infinity,
          child: MainButton(
            title: 'Nhận mã OTP',
            onTap: () {
              bloc.forgotPassword();
            },
            largeButton: true,
          ),
        ),
        16.height,
      ],
    );
  }
}
