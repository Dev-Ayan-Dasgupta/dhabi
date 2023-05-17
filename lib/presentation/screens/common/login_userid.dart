import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginUserIdScreen extends StatefulWidget {
  const LoginUserIdScreen({Key? key}) : super(key: key);

  @override
  State<LoginUserIdScreen> createState() => _LoginUserIdScreenState();
}

class _LoginUserIdScreenState extends State<LoginUserIdScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool isEmailValid = false;
  // bool emailExists = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(onTap: promptUser),
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
                        "Enter User ID",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                      Text(
                        "(Email address)",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return CustomTextField(
                        controller: _emailController,
                        borderColor: isEmailValid
                            ? const Color(0xFFEEEEEE)
                            : AppColors.red100,
                        suffix: Padding(
                          padding: EdgeInsets.only(
                              left: (10 / Dimensions.designWidth).w),
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
                        onChanged: emailValidation,
                      );
                    },
                  ),
                  const SizeBox(height: 7),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildErrorMessage,
                  ),
                  const SizeBox(height: 15),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildProceedButton,
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

  void promptUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[250]["labelText"],
          message:
              "Going to the previous screen will make you repeat this step.",
          auxWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                text: "Go Back",
              ),
              const SizeBox(height: 15),
            ],
          ),
          actionWidget: Column(
            children: [
              SolidButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: labels[166]["labelText"],
                color: AppColors.primaryBright17,
                fontColor: AppColors.primary,
              ),
              const SizeBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void emailValidation(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (InputValidator.isEmailValid(p0)) {
      isEmailValid = true;
      showButtonBloc.add(ShowButtonEvent(show: isEmailValid));
    } else {
      isEmailValid = false;
      showButtonBloc.add(ShowButtonEvent(show: isEmailValid));
    }
  }

  Widget buildErrorMessage(BuildContext context, ShowButtonState state) {
    if (isEmailValid) {
      return const SizeBox();
    } else {
      return Row(
        children: [
          SvgPicture.asset(
            ImageConstants.errorSolid,
            width: (10 / Dimensions.designWidth).w,
            height: (10 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "Invalid email address",
            style: TextStyles.primaryMedium.copyWith(
              color: const Color(0xFFC94540),
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    }
  }

  Widget buildProceedButton(BuildContext context, ShowButtonState state) {
    if (isEmailValid) {
      return GradientButton(
        onTap: () async {
          isLoading = true;
          final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
          showButtonBloc.add(ShowButtonEvent(show: isLoading));

          await storage.write(
              key: "emailAddress", value: _emailController.text);
          storageEmail = await storage.read(key: "emailAddress");

          // check if single cif exists
          var singleCifResult = await MapCustomerSingleCif.mapCustomerSingleCif(
              {"emailId": _emailController.text});
          log("singleCifResult -> $singleCifResult");

          // if only one cif
          if (singleCifResult["hasSingleCIF"]) {
            if (context.mounted) {
              Navigator.pushNamed(
                context,
                Routes.loginPassword,
                arguments: LoginPasswordArgumentModel(
                  emailId: _emailController.text,
                  userId: 0,
                  userTypeId: singleCifResult["userType"],
                  companyId: singleCifResult["cid"],
                ).toMap(),
              );
            }
          } else {
            var sendEmailOtpResult = await MapSendEmailOtp.mapSendEmailOtp(
                {"emailID": _emailController.text});
            log("sendEmailOtpResult -> $sendEmailOtpResult");
            if (context.mounted) {
              Navigator.pushNamed(
                context,
                Routes.otp,
                arguments: OTPArgumentModel(
                  emailOrPhone: _emailController.text,
                  isEmail: true,
                  isBusiness: false,
                  isInitial: false,
                  isLogin: true,
                ).toMap(),
              );
            }
          }
          isLoading = false;
          showButtonBloc.add(ShowButtonEvent(show: isLoading));
        },
        text: labels[31]["labelText"],
        auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
      );
    } else {
      return SolidButton(onTap: () {}, text: labels[31]["labelText"]);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
