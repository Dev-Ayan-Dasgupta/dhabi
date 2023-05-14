// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/matchPassword/match_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_event.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_state.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/login/attempts.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class LoginPasswordScreen extends StatefulWidget {
  const LoginPasswordScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = false;

  bool isMatch = true;

  int matchPasswordErrorCount = 0;
  int toggle = 0;

  bool isLoading = false;

  late LoginPasswordArgumentModel loginPasswordArgument;

  @override
  void initState() {
    super.initState();
    loginPasswordArgument =
        LoginPasswordArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels[214]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Enter Password",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.black63,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                    builder: buildShowHidePassword,
                  ),
                  const SizeBox(height: 7),
                  BlocBuilder<MatchPasswordBloc, MatchPasswordState>(
                    builder: buildErrorMessage,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<MatchPasswordBloc, MatchPasswordState>(
                  builder: buildLoginButton,
                ),
                const SizeBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: onForgotEmailPwd,
                    child: Text(
                      labels[47]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.primaryLighter,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ),
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShowHidePassword(BuildContext context, ShowPasswordState state) {
    if (showPassword) {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: hidePassword,
            child: Icon(
              Icons.visibility_off_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: onChanged,
        obscureText: !showPassword,
      );
    } else {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: showsPassword,
            child: Icon(
              Icons.visibility_outlined,
              color: AppColors.primaryBright50,
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: onChanged,
        obscureText: !showPassword,
      );
    }
  }

  void hidePassword() {
    final ShowPasswordBloc showPasswordBloc = context.read<ShowPasswordBloc>();
    showPasswordBloc
        .add(HidePasswordEvent(showPassword: false, toggle: ++toggle));
    showPassword = !showPassword;
  }

  void showsPassword() {
    final ShowPasswordBloc showPasswordBloc = context.read<ShowPasswordBloc>();
    showPasswordBloc
        .add(DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
    showPassword = !showPassword;
  }

  void onChanged(String p0) {
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    if (p0 == "AyanDg16@#") {
      isMatch = true;
      matchPasswordBloc.add(
          MatchPasswordEvent(isMatch: isMatch, count: matchPasswordErrorCount));
    } else {
      isMatch = true;
      matchPasswordBloc.add(
          MatchPasswordEvent(isMatch: isMatch, count: matchPasswordErrorCount));
    }
  }

  void onSubmit() async {
    log("companyID -> ${loginPasswordArgument.companyId}");
    log("userTypeId -> ${loginPasswordArgument.userTypeId}");
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();

    isLoading = true;
    matchPasswordBloc
        .add(MatchPasswordEvent(isMatch: isMatch, count: ++toggle));
    var result = await MapLogin.mapLogin({
      "emailId": loginPasswordArgument.emailId,
      "userTypeId": loginPasswordArgument.userTypeId,
      "userId": loginPasswordArgument.userId,
      "companyId": loginPasswordArgument.companyId,
      "password": _passwordController.text,
      "deviceId": "${deviceId}1",
      "registerDevice": false,
      "deviceName": deviceName,
      "deviceType": deviceType,
      "appVersion": appVersion
    });
    log("Login API Response -> $result");
    token = result["token"];
    log("token -> $token");

    if (result["success"]) {
      if (context.mounted) {
        if (loginPasswordArgument.userTypeId == 1) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.retailDashboard,
            (route) => false,
            arguments: RetailDashboardArgumentModel(
              imgUrl:
                  "https://images.unsplash.com/photo-1619895862022-09114b41f16f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
              name: emailAddress,
            ).toMap(),
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.businessDashboard, (route) => false);
        }
      }
    } else {
      log("Reason Code -> ${result["reasonCode"]}");
      if (context.mounted) {
        switch (result["reasonCode"]) {
          case 1:
            // promptWrongCredentials();
            break;
          case 2:
            promptWrongCredentials();
            break;
          case 3:
            promptWrongCredentials();
            break;
          case 4:
            promptWrongCredentials();
            break;
          case 5:
            promptWrongCredentials();
            break;
          case 6:
            promptKycExpired();
            break;
          case 7:
            promptVerifySession();
            break;
          default:
        }
      }
    }

    isLoading = false;
    matchPasswordBloc
        .add(MatchPasswordEvent(isMatch: isMatch, count: ++toggle));
  }

  void promptWrongCredentials() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Wrong Credentials",
          message: "You have entered invalid username or password",
          actionWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: labels[88]["labelText"],
              ),
              const SizeBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void promptVerifySession() {
    bool isLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Verify this session",
          message: messages[66]["messageText"],
          actionWidget: Column(
            children: [
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: (context, state) {
                  return GradientButton(
                    onTap: () async {
                      isLoading = true;
                      final ShowButtonBloc showButtonBloc =
                          context.read<ShowButtonBloc>();
                      showButtonBloc.add(ShowButtonEvent(show: isLoading));
                      var result = await MapLogin.mapLogin({
                        "emailId": loginPasswordArgument.emailId,
                        "userTypeId": loginPasswordArgument.userTypeId,
                        "userId": loginPasswordArgument.userId,
                        "companyId": loginPasswordArgument.companyId,
                        "password": _passwordController.text,
                        "deviceId": "${deviceId}1",
                        "registerDevice": true,
                        "deviceName": deviceName,
                        "deviceType": deviceType,
                        "appVersion": appVersion
                      });
                      log("Login API Response -> $result");
                      token = result["token"];
                      log("token -> $token");
                      if (result["success"]) {
                        if (context.mounted) {
                          if (loginPasswordArgument.userTypeId == 1) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.retailDashboard,
                              (route) => false,
                              arguments: RetailDashboardArgumentModel(
                                imgUrl:
                                    "https://images.unsplash.com/photo-1619895862022-09114b41f16f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                                name: emailAddress,
                              ).toMap(),
                            );
                          } else {
                            Navigator.pushNamedAndRemoveUntil(context,
                                Routes.businessDashboard, (route) => false);
                          }
                        }
                      } else {
                        log("Reason Code -> ${result["reasonCode"]}");
                        if (context.mounted) {
                          switch (result["reasonCode"]) {
                            case 1:
                              // promptWrongCredentials();
                              break;
                            case 2:
                              promptWrongCredentials();
                              break;
                            case 3:
                              promptWrongCredentials();
                              break;
                            case 4:
                              promptWrongCredentials();
                              break;
                            case 5:
                              promptWrongCredentials();
                              break;
                            case 6:
                              promptKycExpired();
                              break;
                            case 7:
                              promptVerifySession();
                              break;
                            default:
                          }
                        }
                      }
                      isLoading = false;
                      showButtonBloc.add(ShowButtonEvent(show: isLoading));
                    },
                    text: labels[31]["labelText"],
                    auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
                  );
                },
              ),
              const SizeBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void promptKycExpired() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "KYC Expired",
          message:
              "Your KYC Documents have expired. Please verify your documents again.",
          actionWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  Navigator.pushNamed(context, Routes.verificationInitializing);
                },
                text: "Verify",
              ),
              const SizeBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget buildErrorMessage(BuildContext context, MatchPasswordState state) {
    if (isMatch == false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Incorrect Password",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.red100,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 22),
          Ternary(
            condition:
                matchPasswordErrorCount < 3 && matchPasswordErrorCount > 0,
            truthy: Center(
              child: LoginAttempt(
                message:
                    "Incorrect password - ${3 - matchPasswordErrorCount} attempts left",
              ),
            ),
            falsy: Ternary(
              condition: matchPasswordErrorCount == 0,
              truthy: const SizeBox(),
              falsy: LoginAttempt(
                message: messages[68]["messageText"],
                // "Your account credentials are temporarily blocked. Use ''Forgot Password'' to reset your credentials",
              ),
            ),
          )
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildLoginButton(BuildContext context, MatchPasswordState state) {
    if (matchPasswordErrorCount < 3) {
      return GradientButton(
        onTap: onSubmit,
        text: labels[205]["labelText"],
        auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
      );
    } else {
      return SolidButton(onTap: () {}, text: labels[205]["labelText"]);
    }
  }

  void onForgotEmailPwd() {
    Navigator.pushNamed(context, Routes.registration,
        arguments: RegistrationArgumentModel(isInitial: false).toMap());
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
