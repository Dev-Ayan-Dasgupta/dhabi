import 'package:dialup_mobile_app/bloc/emailExists/email_exists_bloc.dart';
import 'package:dialup_mobile_app/bloc/emailExists/email_exists_event.dart';
import 'package:dialup_mobile_app/bloc/emailExists/email_exists_state.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_event.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_state.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/login/attempts.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/input_validator.dart';
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
  int matchPasswordErrorCount = 0;
  int toggle = 0;

  @override
  void initState() {
    super.initState();
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    matchPasswordBloc
        .add(MatchPasswordEvent(isMatch: true, count: matchPasswordErrorCount));
  }

  @override
  Widget build(BuildContext context) {
    final ShowPasswordBloc showPasswordBloc = context.read<ShowPasswordBloc>();
    final EmailExistsBloc emailExistsBloc = context.read<EmailExistsBloc>();
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Are you sure?",
                  message:
                      "Going to the previous screen will make you repeat this step.",
                  // buttonText: "Go Back",
                  // buttonAction: () {
                  //   Navigator.pop(context);
                  //   Navigator.pop(context);
                  // },
                  actionWidget: Column(
                    children: [
                      GradientButton(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        text: "Go Back",
                      ),
                      const SizeBox(height: 22),
                    ],
                  ),
                );
              },
            );
          },
        ),
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
          child: SingleChildScrollView(
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
                  onChanged: (p0) {
                    if (InputValidator.isEnailValid(p0)) {
                      if (p0 != "ayan@qolarisdata.com") {
                        emailExistsBloc
                            .add(EmailExistsEvent(emailExists: false));
                      } else {
                        emailExistsBloc
                            .add(EmailExistsEvent(emailExists: true));
                      }
                    } else {
                      emailExistsBloc.add(EmailExistsEvent(emailExists: true));
                    }
                  },
                ),
                const SizeBox(height: 7),
                BlocBuilder<EmailExistsBloc, EmailExistsState>(
                  builder: (context, state) {
                    if (state.emailExists == false) {
                      return Text(
                        "Email ID does not exist",
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color(0xFFC94540),
                          fontSize: (12 / Dimensions.designWidth).w,
                        ),
                      );
                    } else {
                      return const SizeBox();
                    }
                  },
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
                              showPasswordBloc.add(HidePasswordEvent(
                                  showPassword: false, toggle: ++toggle));
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
                              showPasswordBloc.add(DisplayPasswordEvent(
                                  showPassword: true, toggle: ++toggle));
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
                const SizeBox(height: 7),
                BlocBuilder<MatchPasswordBloc, MatchPasswordState>(
                  builder: (context, state) {
                    if (state.isMatch == false) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Incorrect Password",
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0xFFC94540),
                              fontSize: (12 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 22),
                          state.count < 3
                              ? Center(
                                  child: LoginAttempt(
                                      message:
                                          "Incorrect password - ${3 - state.count} attempts left"),
                                )
                              : const LoginAttempt(
                                  message:
                                      "Your account credentials are temporarily blocked. Use ''Forgot Password'' to reset your credentials"),
                        ],
                      );
                    } else {
                      return const SizeBox();
                    }
                  },
                ),
                const SizeBox(height: 30),
                BlocBuilder<MatchPasswordBloc, MatchPasswordState>(
                  builder: (context, state) {
                    if (state.count < 3) {
                      return GradientButton(
                        onTap: () {
                          // TODO: Use API to conduct validation, for now testing with mock static data
                          if (_passwordController.text != "AyanDg16@#") {
                            matchPasswordErrorCount++;
                            matchPasswordBloc.add(MatchPasswordEvent(
                                isMatch: false,
                                count: matchPasswordErrorCount));
                          } else {
                            // TODO: Call Navigation to next page, testing for now, API later
                            Navigator.pushNamed(context, Routes.splash);
                          }
                        },
                        text: "Login",
                      );
                    } else {
                      return SolidButton(
                        onTap: () {},
                        text: "Login",
                        color: const Color(0xFF818181),
                      );
                    }
                  },
                ),
                const SizeBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      // TODO: call API
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
