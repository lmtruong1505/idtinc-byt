import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/core/widgets/common/title_required.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:bpg_retail/features/authentication/data/bloc/authentication_state.dart';
import 'package:bpg_retail/features/authentication/presentation/widget/header_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final debouncer = Debouncer();
  final referralCodeCtrl = TextEditingController();
  final bloc = getIt<AuthenticationCubit>();
  final navigator = getIt<AppNavigator>();

  @override
  void initState() {
    super.initState();
    bloc.clearFormRegister();
  }

  @override
  void dispose() {
    referralCodeCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final regexPassword = RegExp(
    r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\][:()"`;+\-|_?,.</\\>=$%}{^&*~]).{8,}$',
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeaderAuthForm(height: 50, width: 97, isPaddingTop: 0),
                24.height,
                _formView(),
              ],
            ).padding(16.pading),
          ),
        ),
      ),
    );
  }

  Widget _formView() {
    return Form(
      key: bloc.formKey,
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              requiredTitle("Email đăng nhập"),
              8.height,
              ValidateTextField(
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Nhập email',
                hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
                maxLines: 1,
                onChanged: bloc.onChangeEmail,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Hãy nhập email';
                  }
                  return null;
                },
              ),
              8.height,
              // requiredTitle("Họ và tên"),
              // const SizedBox(height: 8),
              // ValidateTextField(
              //   margin: EdgeInsets.zero,
              //   backgroundColor: AppColors.white,
              //   hintText: 'Nhập họ và tên',
              //   hintStyle: AppTypography.p6.copyWith(
              //     color: AppColors.grey_1,
              //   ),
              //   maxLines: 1,
              //   onChanged: bloc.onChangeFullname,
              //   validator: (value) {
              //     if (value?.isEmpty ?? false) {
              //       return 'Hãy nhập họ và tên';
              //     }
              //     return null;
              //   },
              // ),
              // 8.height,
              requiredTitle("Mật khẩu"),
              8.height,
              ValidateTextField(
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Nhập mật khẩu',
                hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
                maxLines: 1,
                onChanged: bloc.onChangePassword,
                obscureText: !state.showPassword,
                suffixIcon: GestureDetector(
                  onTap: bloc.onShowPassword,
                  child: Icon(
                    !state.showPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.grey_1,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Hãy nhập mật khẩu';
                  }
                  if (!regexPassword.hasMatch(value ?? '')) {
                    return "Mật khẩu phải chứa ít nhất một số\nMột ký tự đặc biệt và phải có ít nhất 8 ký tự";
                  }
                  return bloc.validateConfirmPassword();
                },
              ),
              8.height,
              requiredTitle("Xác nhận mật khẩu"),
              8.height,
              ValidateTextField(
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Nhập mật khẩu',
                hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
                maxLines: 1,
                onChanged: bloc.onChangeConfirmPassword,
                obscureText: !state.showConfirmPassword,
                suffixIcon: GestureDetector(
                  onTap: bloc.onShowConfirmPassword,
                  child: Icon(
                    !state.showConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.grey_1,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Hãy nhập mật khẩu';
                  }
                  if (!regexPassword.hasMatch(value ?? '')) {
                    return "Mật khẩu phải chứa ít nhất một số\nMột ký tự đặc biệt và phải có ít nhất 8 ký tự";
                  }
                  return bloc.validateConfirmPassword();
                },
              ),
              24.height,
              requiredTitle("Tên doanh nghiệp"),
              const SizedBox(height: 8),
              ValidateTextField(
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Nhập tên doanh nghiệp',
                hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
                maxLines: 1,
                onChanged: (value) {
                  bloc.onChangeFullname(value);
                },
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Hãy nhập tên doanh nghiệp';
                  }
                  return null;
                },
              ),
              8.height,
              Text(
                "Người đại diện",
                style: AppTypography.p5.copyWith(color: AppColors.blackish),
              ),
              const SizedBox(height: 8),
              ValidateTextField(
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Nhập tên người đại diện',
                hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
                maxLines: 1,
                onChanged: (value) {
                  bloc.onChangeRepresent(value);
                },
                validator: (value) {
                  return null;
                },
              ),
              8.height,
              Text(
                "Mã số thuế",
                style: AppTypography.p5.copyWith(color: AppColors.blackish),
              ),
              const SizedBox(height: 8),
              ValidateTextField(
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Nhập mã số thuế',
                hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
                maxLines: 1,
                onChanged: (value) {
                  bloc.onChangeTax(value);
                },
                validator: (value) {
                  return null;
                },
              ),
              8.height,
              requiredTitle("Hotline/Số điện thoại"),
              const SizedBox(height: 8),
              ValidateTextField(
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Nhập số điện thoại',
                hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
                maxLines: 1,
                onChanged: (value) {
                  bloc.onChangePhoneNumber(value);
                  // debouncer.run(() => validateRefferalCode(value));
                },
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

              // Row(
              // children: [
              // Text(
              // 'Mã giới thiệu',
              // style: AppTypography.p5.copyWith(color: AppColors.blackish),
              // ),
              // const Spacer(),
              // GestureDetector(
              //   onTap: () async {
              //     final result =
              //         await navigator.push(QRCodeScreen(isScanUser: true));
              //     if (result is String) {
              //       referralCodeCtrl.text = result.removeAllNonNumeber();
              //       validateRefferalCode(state.phoneNumber);
              //     }
              //   },
              //   child: Row(
              //     children: [
              //       const Icon(
              //         Icons.qr_code,
              //         size: 14,
              //         color: AppColors.blue31,
              //       ),
              //       Text(
              //         'Quét mã QR',
              //         style: s14w500.copyWith(color: AppColors.blue31),
              //       ),
              //     ],
              //   ),
              // ),
              // ],
              // ),
              // const SizedBox(height: 8),
              // ValidateTextField(
              //   controller: referralCodeCtrl,
              //   margin: EdgeInsets.zero,
              //   backgroundColor: AppColors.white,
              //   hintText: 'Nhập mã giới thiệu',
              //   hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
              //   maxLines: 1,
              //   onChanged: (value) {
              //     debouncer.run(
              //       () {
              //         referralCodeCtrl.text = value.removeAllNonNumeber();
              //         // validateRefferalCode(state.phoneNumber);
              //       },
              //     );
              //   },
              //   validator: (p0) {
              //     if (!p0.nullOrEmpty && !state.message.nullOrEmpty) {
              //       return state.message;
              //     }
              //     return null;
              //   },
              // ),
              // 16.height,
              // Visibility(
              //   visible: state.message == null && state.userReferralCode != null && state.status != CubitStatus.loading,
              //   child: Text(
              //     "Mã hợp lệ cho ${state.referralCode?.accountName} (${state.referralCode?.accountCode})",
              //     style: s14w500.copyWith(
              //       color: AppColors.green65,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),
              24.height,
              SizedBox(
                height: 45,
                width: double.infinity,
                child: MainButton(
                  title: 'Gửi duyệt',
                  onTap: () => bloc.onRegisterAsbc(),
                  largeButton: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Đã có tài khoản? ', style: AppTypography.p6),
                  GestureDetector(
                    onTap: () {
                      navigator.replace(const LoginRoute());
                    },
                    child: Text(
                      'Đăng nhập ngay',
                      style: AppTypography.p5.copyWith(color: AppColors.main),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
