import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/data/bloc/localization_cubit.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/localization_helper.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/core/widgets/common/base_check_box.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:bpg_retail/features/authentication/data/bloc/authentication_state.dart';
import 'package:bpg_retail/features/authentication/presentation/widget/header_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    passworkCtrl = TextEditingController();
  }

  final bloc = getIt.get<AuthenticationCubit>();
  final navigator = getIt.get<AppNavigator>();
  late TextEditingController passworkCtrl;

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const HeaderAuthForm(), _formView(trans)],
        ).padding(16.padingHor),
      ),
    );
  }

  Form _formView(AppLocalizations trans) {
    return Form(
      key: bloc.formKey,
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        bloc: bloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              32.height,
              ValidateTextField(
                labelText: 'Tài khoản/Số điện thoại',
                isRequired: true,
                initialValue: state.phoneNumber,
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                maxLines: 1,
                onChanged: bloc.onChangePhoneNumber,
                // validator: (value) {
                //   if (value?.isEmpty ?? false) {
                //     return trans.translate('pls_email');
                //   }
                //   if (!value.isEmail()) {
                //     return trans.translate('email_not_valid');
                //   }

                //   return null;
                // },
              ),
              16.height,
              ValidateTextField(
                labelText: 'Mật khẩu',
                isRequired: true,
                initialValue: state.password,
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
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
                    return trans.translate('pw_not_valid');
                  }
                  return null;
                },
              ),
              16.height,
              Row(
                children: [
                  BaseCheckbox(
                    value: state.isRemember,
                    radius: 4,
                    onChanged: (bool? value) {
                      bloc.onRememberAccount(value ?? false);
                    },
                  ),
                  8.height,
                  GestureDetector(
                    onTap: () {
                      bloc.onRememberAccount(!state.isRemember);
                    },
                    child: Column(
                      children: [
                        const SizedBox(height: 1),
                        Text(
                          trans.translate('remember_password'),
                          style: AppTypography.p4.copyWith(
                            color: AppColors.grey79,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const Spacer(),
                  // GestureDetector(
                  //   onTap: () {
                  //     navigator.push(const ForgotPasswordPage());
                  //   },
                  //   child: Text(
                  //     'Quên mật khẩu?',
                  //     style: AppTypography.p4.copyWith(
                  //       color: AppColors.blue_3,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: MainButton(
                  title: trans.translate('log_in'),
                  onTap: () => bloc.onLogin(context),
                  largeButton: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn chưa có tài khoản? ',
                    style: AppTypography.p6,
                  ),
                  GestureDetector(
                    onTap: () {
                      navigator.push(const RegisterRoute());
                    },
                    child: Text(
                      'Đăng ký ngay',
                      style: AppTypography.p5.copyWith(color: AppColors.blue_3),
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
