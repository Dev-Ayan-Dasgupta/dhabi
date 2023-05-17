// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/map_send_email_otp.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/input_validator.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

String emailAddress = "";

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  bool _isLoading = false;

  late RegistrationArgumentModel registrationArgument;

  @override
  void initState() {
    super.initState();
    registrationArgument =
        RegistrationArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        promptUser();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          leading: AppBarLeading(onTap: promptUser),
          backgroundColor: Colors.white,
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
                    Ternary(
                      condition: registrationArgument.isInitial,
                      truthy: Text(
                        labels[211]["labelText"],
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.primary,
                          fontSize: (28 / Dimensions.designWidth).w,
                        ),
                      ),
                      falsy: Text(
                        "Confirm Email",
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.primary,
                          fontSize: (28 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                    const SizeBox(height: 22),
                    Ternary(
                      condition: registrationArgument.isInitial,
                      truthy: Text(
                        labels[212]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      falsy: Text(
                        "We will send the OTP to your registered email address",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                    const SizeBox(height: 30),
                    Row(
                      children: [
                        Text(
                          labels[39]["labelText"],
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color(0xFF636363),
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _emailController,
                      suffix: BlocBuilder<ShowButtonBloc, ShowButtonState>(
                        builder: buildCheckCircle,
                      ),
                      onChanged: emailValidation,
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: buildErrorMessage,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildSubmitButton,
                  ),
                  Ternary(
                    condition: registrationArgument.isInitial,
                    truthy: Column(
                      children: [
                        const SizeBox(height: 15),
                        InkWell(
                          onTap: () {
                            // TODO: Add biometricPrompt
                            Navigator.pushNamed(context, Routes.loginUserId);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: '${labels[213]["labelText"]} ',
                              style: TextStyles.primary.copyWith(
                                color: AppColors.primary,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: labels[214]["labelText"],
                                  style: TextStyles.primaryBold.copyWith(
                                    color: AppColors.primary,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    falsy: const SizeBox(),
                  ),
                  SizeBox(
                      height: PaddingConstants.bottomPadding +
                          MediaQuery.of(context).padding.bottom),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[250]["labelText"],
          message:
              "Going to the previous screen will make you repeat this step.",
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
  }

  Widget buildCheckCircle(BuildContext context, ShowButtonState state) {
    if (!_isEmailValid) {
      return const SizedBox();
    } else {
      return Padding(
        padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
        child: SvgPicture.asset(
          ImageConstants.checkCircle,
          width: (20 / Dimensions.designWidth).w,
          height: (20 / Dimensions.designWidth).w,
        ),
      );
    }
  }

  void emailValidation(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    _isEmailValid = InputValidator.isEmailValid(p0);
    showButtonBloc.add(ShowButtonEvent(show: _isEmailValid || p0.length <= 5));
  }

  Widget buildErrorMessage(BuildContext context, ShowButtonState state) {
    if (_isEmailValid || _emailController.text.length <= 5) {
      return const SizeBox();
    } else {
      return Row(
        children: [
          SvgPicture.asset(
            ImageConstants.errorSolid,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "Invalid email",
            style: TextStyles.primaryMedium.copyWith(
              color: const Color(0xFFC94540),
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    }
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (!_isEmailValid) {
      return SolidButton(onTap: () {}, text: "Proceed");
    } else {
      return GradientButton(
        onTap: () async {
          await storage.write(
              key: "emailAddress", value: _emailController.text);
          emailAddress = _emailController.text;
          _isLoading = true;
          showButtonBloc.add(ShowButtonEvent(show: _isLoading));

          var result = await MapSendEmailOtp.mapSendEmailOtp(
              {"emailID": _emailController.text});
          log("Send Email OTP Response -> $result");

          if (_isLoading) {
            if (context.mounted) {
              Navigator.pushNamed(
                context,
                Routes.otp,
                arguments: OTPArgumentModel(
                  emailOrPhone: _emailController.text,
                  isEmail: true,
                  isBusiness: false,
                  isInitial: registrationArgument.isInitial,
                  isLogin: false,
                ).toMap(),
              );
            }
          }

          _isLoading = false;
          showButtonBloc.add(ShowButtonEvent(show: _isLoading));
        },
        text: labels[31]["labelText"],
        auxWidget: Ternary(
          condition: _isLoading,
          truthy: const LoaderRow(),
          falsy: const SizeBox(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
