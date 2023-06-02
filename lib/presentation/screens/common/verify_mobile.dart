// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/input_validator.dart';

class VerifyMobileScreen extends StatefulWidget {
  const VerifyMobileScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<VerifyMobileScreen> createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  late VerifyMobileArgumentModel verifyMobileArgumentModel;
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    verifyMobileArgumentModel =
        VerifyMobileArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
                    labels[227]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 22),
                  Text(
                    "We will send the OTP to your registered mobile number",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 22),
                  Text(
                    labels[27]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 9),
                  CustomTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    // isDense: true,
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCircleAvatarAsset(
                          width: (25 / Dimensions.designWidth).w,
                          height: (25 / Dimensions.designWidth).w,
                          imgUrl: ImageConstants.uaeFlag,
                        ),
                        const SizeBox(width: 7),
                        Text(
                          "+971",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.black63,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(width: 7),
                      ],
                    ),
                    suffixIcon: BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: buildCheckCircle,
                    ),
                    onChanged: checkPhoneNumber,
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
                const SizeBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildCheckCircle(BuildContext context, ShowButtonState state) {
    if (!_isPhoneValid) {
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

  void checkPhoneNumber(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    _isPhoneValid = InputValidator.isPhoneValid("+971$p0");
    showButtonBloc.add(ShowButtonEvent(show: _isPhoneValid || p0.length <= 9));
  }

  Widget buildErrorMessage(BuildContext context, ShowButtonState state) {
    if (_isPhoneValid || _phoneController.text.length <= 9) {
      return const SizeBox();
    } else {
      return Row(
        children: [
          SvgPicture.asset(ImageConstants.errorSolid),
          const SizeBox(width: 5),
          Text(
            "Invalid mobile number",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.red100,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    }
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (!_isPhoneValid) {
      return const SizeBox();
    } else {
      return GradientButton(
        onTap: () async {
          isLoading = true;
          final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
          showButtonBloc.add(ShowButtonEvent(show: isLoading));
          // TODO: Call Send Mobile OTP API here
          var result = await MapSendMobileOtp.mapSendMobileOtp(
              {"mobileNo": "+971${_phoneController.text}"}, token ?? "");
          log("Send Mobile OTP API response -> $result");

          if (result["success"]) {
            if (isLoading) {
              if (context.mounted) {
                Navigator.pushNamed(
                  context,
                  Routes.otp,
                  arguments: OTPArgumentModel(
                    emailOrPhone: "+971${_phoneController.text}",
                    isEmail: false,
                    isBusiness: verifyMobileArgumentModel.isBusiness,
                    isInitial: true,
                    isLogin: false,
                    isIncompleteOnboarding: false,
                  ).toMap(),
                );
              }
            }
            isLoading = false;
            showButtonBloc.add(ShowButtonEvent(show: isLoading));
          } else {
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    svgAssetPath: ImageConstants.warning,
                    title: "Retry Limit Reached",
                    message: result["message"],
                    actionWidget: GradientButton(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.onboarding,
                          arguments: OnboardingArgumentModel(
                            isInitial: true,
                          ).toMap(),
                        );
                      },
                      text: "Go Home",
                    ),
                  );
                },
              );
              isLoading = false;
              showButtonBloc.add(ShowButtonEvent(show: isLoading));
            }
          }
        },
        text: labels[31]["labelText"],
        auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
