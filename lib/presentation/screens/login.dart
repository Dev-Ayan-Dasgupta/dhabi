import 'package:dialup_mobile_app/data/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/data/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/data/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final ShowPasswordBloc showPasswordBloc = context.read<ShowPasswordBloc>();

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: (22 / Dimensions.designWidth).w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizeBox(height: 10),
              Text(
                "Login",
                style: TextStyles.primaryBold.copyWith(
                  color: AppColors.primary,
                  fontSize: (28 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 30),
              RichText(
                text: TextSpan(
                  text: 'User ID ',
                  style: TextStyles.primary.copyWith(
                    color: const Color(0xFF636363),
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '(Email address)',
                      style: TextStyles.primary.copyWith(
                        color: const Color.fromRGBO(99, 99, 99, 0.5),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
              ),
              const SizeBox(height: 9),
              CustomTextField(
                controller: _emailController,
                suffix: Padding(
                  padding:
                      EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
                  child: InkWell(
                    onTap: () {
                      _emailController.clear();
                    },
                    child: SvgPicture.asset(
                      ImageConstants.deleteText,
                      width: (17.5 / Dimensions.designWidth).w,
                      height: (17.5 / Dimensions.designWidth).w,
                    ),
                  ),
                ),
                onChanged: (p0) {},
              ),
              const SizeBox(height: 15),
              Text(
                "Password",
                style: TextStyles.primaryMedium.copyWith(
                  color: const Color(0xFF636363),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 9),
              BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                builder: (context, state) {
                  if (showPassword) {
                    return CustomTextField(
                      controller: _passwordController,
                      suffix: Padding(
                        padding: EdgeInsets.only(
                            left: (10 / Dimensions.designWidth).w),
                        child: InkWell(
                          onTap: () {
                            showPasswordBloc
                                .add(HidePasswordEvent(showPassword: false));
                            showPassword = !showPassword;
                          },
                          child: Icon(
                            Icons.visibility_off_outlined,
                            color: const Color.fromRGBO(34, 97, 105, 0.5),
                            size: (20 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                      onChanged: (p0) {},
                      obscureText: !showPassword,
                    );
                  } else {
                    return CustomTextField(
                      controller: _passwordController,
                      suffix: Padding(
                        padding: EdgeInsets.only(
                            left: (10 / Dimensions.designWidth).w),
                        child: InkWell(
                          onTap: () {
                            showPasswordBloc
                                .add(DisplayPasswordEvent(showPassword: true));
                            showPassword = !showPassword;
                          },
                          child: Icon(
                            Icons.visibility_outlined,
                            color: const Color.fromRGBO(34, 97, 105, 0.5),
                            size: (20 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                      onChanged: (p0) {},
                      obscureText: !showPassword,
                    );
                  }
                },
              ),
              const SizeBox(height: 30),
              GradientButton(
                onTap: () {},
                text: "Login",
              ),
              const SizeBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    // TODO
                  },
                  child: Text(
                    "Forgot your email ID or password?",
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color.fromRGBO(34, 97, 105, 0.5),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
