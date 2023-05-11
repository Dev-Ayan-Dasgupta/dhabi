// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/otp/pinput/error_bloc.dart';
import 'package:dialup_mobile_app/bloc/otp/pinput/error_event.dart';
import 'package:dialup_mobile_app/bloc/otp/pinput/error_state.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_bloc.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_event.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/map_customer_details.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/obscure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _pinController = TextEditingController();

  late OTPArgumentModel otpArgumentModel;

  int pinputErrorCount = 0;
  late final String obscuredEmail;
  late final String obscuredPhone;

  late int seconds;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    blocInitialization();
    startTimer();
  }

  void argumentInitialization() {
    otpArgumentModel =
        OTPArgumentModel.fromMap(widget.argument as dynamic ?? {});
    if (otpArgumentModel.isEmail) {
      obscuredEmail = ObscureHelper.obscureEmail(otpArgumentModel.emailOrPhone);
    } else {
      obscuredPhone = ObscureHelper.obscurePhone(otpArgumentModel.emailOrPhone);
    }
  }

  void blocInitialization() {
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    pinputErrorBloc.add(
        PinputErrorEvent(isError: false, isComplete: false, errorCount: 0));
  }

  void startTimer() {
    seconds = otpArgumentModel.isEmail ? 300 : 90;
    final OTPTimerBloc otpTimerBloc = context.read<OTPTimerBloc>();
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds > 0) {
          seconds--;
          otpTimerBloc.add(OTPTimerEvent(seconds: seconds));
        } else {
          timer.cancel();
        }
      },
    );
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
              child: Center(
                child: Column(
                  children: [
                    const SizeBox(height: 30),
                    BlocBuilder<PinputErrorBloc, PinputErrorState>(
                      builder: buildIcon,
                    ),
                    const SizeBox(height: 20),
                    BlocBuilder<PinputErrorBloc, PinputErrorState>(
                      builder: buildTitle,
                    ),
                    const SizeBox(height: 15),
                    BlocBuilder<PinputErrorBloc, PinputErrorState>(
                      builder: buildDescription,
                    ),
                    const SizeBox(height: 25),
                    BlocBuilder<PinputErrorBloc, PinputErrorState>(
                      builder: buildPinput,
                    ),
                    BlocBuilder<PinputErrorBloc, PinputErrorState>(
                      builder: buildTimer,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIcon(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      if (otpArgumentModel.isEmail) {
        return SvgPicture.asset(
          ImageConstants.otp,
          width: (78 / Dimensions.designWidth).w,
          height: (70 / Dimensions.designHeight).h,
        );
      } else {
        return SvgPicture.asset(
          ImageConstants.phoneAndroid,
          width: (50 / Dimensions.designWidth).w,
          height: (83 / Dimensions.designHeight).h,
        );
      }
    } else {
      return SvgPicture.asset(
        ImageConstants.warningBlue,
        width: (100 / Dimensions.designWidth).w,
        height: (100 / Dimensions.designWidth).w,
      );
    }
  }

  Widget buildTitle(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      return Text(
        labels[32]["labelText"],
        style: TextStyles.primaryMedium.copyWith(
          color: AppColors.dark80,
          fontSize: (24 / Dimensions.designWidth).w,
        ),
      );
    } else {
      return Text(
        "Oops!",
        style: TextStyles.primaryMedium.copyWith(
          color: AppColors.dark80,
          fontSize: (24 / Dimensions.designWidth).w,
        ),
      );
    }
  }

  Widget buildDescription(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      if (otpArgumentModel.isEmail) {
        return Text(
          "${labels[41]["labelText"]} $obscuredEmail",
          style: TextStyles.primaryMedium.copyWith(
            color: AppColors.dark80,
            fontSize: (16 / Dimensions.designWidth).w,
          ),
          textAlign: TextAlign.center,
        );
      } else {
        return Text(
          "${labels[33]["labelText"]} $obscuredPhone",
          style: TextStyles.primaryMedium.copyWith(
            color: AppColors.dark80,
            fontSize: (16 / Dimensions.designWidth).w,
          ),
          textAlign: TextAlign.center,
        );
      }
    } else {
      return Text(
        "Reached the maximum number of entries.\nTry again later.",
        style: TextStyles.primaryMedium.copyWith(
          color: const Color(0xFF343434),
          fontSize: (18 / Dimensions.designWidth).w,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget buildPinput(BuildContext context, PinputErrorState state) {
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    return CustomPinput(
      pinController: _pinController,
      pinColor: (!state.isError)
          ? (state.isComplete)
              ? const Color(0XFFBCE5DD)
              : AppColors.blackEE
          : (state.errorCount >= 3)
              ? const Color(0XFFC0D6FF)
              : const Color(0XFFFFC3C0),
      onChanged: (p0) async {
        if (_pinController.text.length == 6) {
          if (otpArgumentModel.isEmail) {
            if (otpArgumentModel.isLogin) {
              var result = await MapValidateEmailOtpForPassword
                  .mapValidateEmailOtpForPassword({
                "emailId": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
              });
              log("result -> $result");
              tokenCP = result["token"];
              log("tokenCP -> $tokenCP");
              if (result["success"]) {
                pinputErrorBloc.add(
                  PinputErrorEvent(
                    isError: false,
                    isComplete: true,
                    errorCount: pinputErrorCount,
                  ),
                );
                // TODO: Call API for getCustomer details and navigate to SelectAccountScreen
                var getCustomerDetailsResponse =
                    await MapCustomerDetails.mapCustomerDetails(tokenCP);
                log("Get Customer Details API response -> $getCustomerDetailsResponse");

                List cifDetails = getCustomerDetailsResponse["cifDetails"];

                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.selectAccount,
                    arguments: SelectAccountArgumentModel(
                      emailId: otpArgumentModel.emailOrPhone,
                      cifDetails: cifDetails,
                      isPwChange: false,
                      isLogin: true,
                    ).toMap(),
                  );
                }
              } else {
                pinputErrorCount++;
                pinputErrorBloc.add(
                  PinputErrorEvent(
                    isError: true,
                    isComplete: true,
                    errorCount: pinputErrorCount,
                  ),
                );
              }
            } else {
              if (otpArgumentModel.isInitial) {
                var result = await MapVerifyEmailOtp.mapVerifyEmailOtp(
                  {
                    "emailId": otpArgumentModel.emailOrPhone,
                    "otp": _pinController.text,
                  },
                );
                log("Verify Email OTP Response -> $result");

                if (result["success"] == true) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );

                  await Future.delayed(const Duration(milliseconds: 250));
                  if (context.mounted) {
                    if (otpArgumentModel.isEmail) {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.selectAccountType,
                        arguments: CreateAccountArgumentModel(
                          email: otpArgumentModel.emailOrPhone,
                          isRetail: true,
                        ).toMap(),
                      );
                    } else {
                      if (otpArgumentModel.isBusiness) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.checkCircleOutlined,
                              title: "Verified",
                              message:
                                  "Your phone number has been verified.\nYou will receive email on the next steps.",
                              actionWidget: Column(
                                children: [
                                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                    builder: (context, state) {
                                      return GradientButton(
                                        onTap: () async {
                                          isLoading = true;
                                          final ShowButtonBloc showButtonBloc =
                                              context.read<ShowButtonBloc>();
                                          showButtonBloc.add(
                                              ShowButtonEvent(show: isLoading));
                                          var getCustomerDetailsResponse =
                                              await MapCustomerDetails
                                                  .mapCustomerDetails(token);
                                          log("Get Customer Details API response -> $getCustomerDetailsResponse");
                                          List cifDetails =
                                              getCustomerDetailsResponse[
                                                  "cifDetails"];
                                          if (context.mounted) {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.selectAccount,
                                              arguments:
                                                  SelectAccountArgumentModel(
                                                emailId: otpArgumentModel
                                                    .emailOrPhone,
                                                cifDetails: cifDetails,
                                                isPwChange: false,
                                                isLogin: false,
                                              ).toMap(),
                                            );
                                          }
                                        },
                                        text: labels[31]["labelText"],
                                        auxWidget: isLoading
                                            ? const LoaderRow()
                                            : const SizeBox(),
                                      );
                                    },
                                  ),
                                  const SizeBox(height: 20),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          Routes.retailOnboardingStatus,
                          arguments: OnboardingStatusArgumentModel(
                            stepsCompleted: 4,
                            isFatca: false,
                            isPassport: false,
                            isRetail: !otpArgumentModel.isBusiness,
                          ).toMap(),
                        );
                      }
                    }
                  }
                } else {
                  pinputErrorCount++;
                  pinputErrorBloc.add(PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount));
                }
              } else {
                var result = await MapValidateEmailOtpForPassword
                    .mapValidateEmailOtpForPassword(
                  {
                    "emailId": otpArgumentModel.emailOrPhone,
                    "otp": _pinController.text,
                  },
                );
                log("Validate Email OTP For Password Response -> $result");
                tokenCP = result["token"];
                log("tokenCP -> $tokenCP");

                if (result["success"] == true) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );

                  // await Future.delayed(const Duration(milliseconds: 250));
                  if (context.mounted) {
                    if (otpArgumentModel.isEmail) {
                      // Navigator.pop(context);
                      // TODO: Check for new device

                      // TODO: if not new device, go to select entity screen
                      var getCustomerDetailsResponse =
                          await MapCustomerDetails.mapCustomerDetails(tokenCP);
                      log("Get Customer Details API response -> $getCustomerDetailsResponse");
                      List cifDetails =
                          getCustomerDetailsResponse["cifDetails"];

                      if (cifDetails.length == 1) {
                        if (context.mounted) {
                          cif = getCustomerDetailsResponse["cifDetails"][0]
                              ["cif"];
                          Navigator.pushNamed(context, Routes.setPassword);
                        }
                      } else {
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.selectAccount,
                            arguments: SelectAccountArgumentModel(
                              emailId: otpArgumentModel.emailOrPhone,
                              cifDetails: cifDetails,
                              isPwChange: true,
                              isLogin: false,
                            ).toMap(),
                          );
                        }
                      }
                    } else {
                      if (otpArgumentModel.isBusiness) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.checkCircleOutlined,
                              title: "Verified",
                              message:
                                  "Your phone number has been verified.\nYou will receive email on the next steps.",
                              actionWidget: Column(
                                children: [
                                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                    builder: (context, state) {
                                      return GradientButton(
                                        onTap: () async {
                                          isLoading = true;
                                          final ShowButtonBloc showButtonBloc =
                                              context.read<ShowButtonBloc>();
                                          showButtonBloc.add(
                                              ShowButtonEvent(show: isLoading));
                                          var getCustomerDetailsResponse =
                                              await MapCustomerDetails
                                                  .mapCustomerDetails(token);
                                          log("Get Customer Details API response -> $getCustomerDetailsResponse");
                                          List cifDetails =
                                              getCustomerDetailsResponse[
                                                  "cifDetails"];
                                          if (context.mounted) {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.selectAccount,
                                              arguments:
                                                  SelectAccountArgumentModel(
                                                emailId: otpArgumentModel
                                                    .emailOrPhone,
                                                cifDetails: cifDetails,
                                                isPwChange: false,
                                                isLogin: false,
                                              ).toMap(),
                                            );
                                          }
                                        },
                                        text: labels[31]["labelText"],
                                        auxWidget: isLoading
                                            ? const LoaderRow()
                                            : const SizeBox(),
                                      );
                                    },
                                  ),
                                  const SizeBox(height: 20),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          Routes.retailOnboardingStatus,
                          arguments: OnboardingStatusArgumentModel(
                            stepsCompleted: 4,
                            isFatca: false,
                            isPassport: false,
                            isRetail: !otpArgumentModel.isBusiness,
                          ).toMap(),
                        );
                      }
                    }
                  }
                } else {
                  pinputErrorCount++;
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                }
              }
            }
          } else {
            log("Phone no. -> ${otpArgumentModel.emailOrPhone}");
            var result = await MapVerifyMobileOtp.mapVerifyMobileOtp(
              {
                "mobileNo": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
              },
              token,
            );
            log("Verify Mobile OTP Response -> $result");

            if (result["success"] == true) {
              pinputErrorBloc.add(
                PinputErrorEvent(
                  isError: false,
                  isComplete: true,
                  errorCount: pinputErrorCount,
                ),
              );

              await Future.delayed(const Duration(milliseconds: 250));
              if (context.mounted) {
                if (otpArgumentModel.isEmail) {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.retailOnboardingStatus,
                    arguments: OnboardingStatusArgumentModel(
                      stepsCompleted: 4,
                      isFatca: false,
                      isPassport: false,
                      isRetail: true,
                    ).toMap(),
                  );
                } else {
                  if (otpArgumentModel.isBusiness) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.checkCircleOutlined,
                          title: "Verified",
                          message:
                              "Your phone number has been verified.\nYou will receive email on the next steps.",
                          actionWidget: Column(
                            children: [
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: (context, state) {
                                  return GradientButton(
                                    onTap: () async {
                                      isLoading = true;
                                      final ShowButtonBloc showButtonBloc =
                                          context.read<ShowButtonBloc>();
                                      showButtonBloc.add(
                                          ShowButtonEvent(show: isLoading));
                                      var getCustomerDetailsResponse =
                                          await MapCustomerDetails
                                              .mapCustomerDetails(token);
                                      log("Get Customer Details API response -> $getCustomerDetailsResponse");
                                      List cifDetails =
                                          getCustomerDetailsResponse[
                                              "cifDetails"];
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.selectAccount,
                                          arguments: SelectAccountArgumentModel(
                                            emailId:
                                                otpArgumentModel.emailOrPhone,
                                            cifDetails: cifDetails,
                                            isPwChange: false,
                                            isLogin: false,
                                          ).toMap(),
                                        );
                                      }
                                    },
                                    text: labels[31]["labelText"],
                                    auxWidget: isLoading
                                        ? const LoaderRow()
                                        : const SizeBox(),
                                  );
                                },
                              ),
                              const SizeBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      Routes.retailOnboardingStatus,
                      arguments: OnboardingStatusArgumentModel(
                        stepsCompleted: 4,
                        isFatca: true,
                        isPassport: false,
                        isRetail: !otpArgumentModel.isBusiness,
                      ).toMap(),
                    );
                  }
                }
              }
            } else {
              pinputErrorCount++;
              pinputErrorBloc.add(PinputErrorEvent(
                  isError: true,
                  isComplete: true,
                  errorCount: pinputErrorCount));
            }
          }
        } else {
          pinputErrorBloc.add(PinputErrorEvent(
              isError: false, isComplete: false, errorCount: pinputErrorCount));
        }
      },
      enabled: state.errorCount < 3 ? true : false,
    );
  }

  Widget buildTimer(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      return Column(
        children: [
          const SizeBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${labels[34]["labelText"]} ",
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark50,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              BlocBuilder<OTPTimerBloc, OTPTimerState>(
                builder: (context, state) {
                  if (seconds % 60 < 10) {
                    return Text(
                      "${seconds ~/ 60}:0${seconds % 60}",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.red100,
                        fontSize: (14 / Dimensions.designWidth).w,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else {
                    return Text(
                      "${seconds ~/ 60}:${seconds % 60}",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.red100,
                        fontSize: (14 / Dimensions.designWidth).w,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizeBox(height: 25),
          BlocBuilder<OTPTimerBloc, OTPTimerState>(
            builder: (context, state) {
              return InkWell(
                onTap: resendOTP,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Text(
                  labels[35]["labelText"],
                  style: TextStyles.primaryBold.copyWith(
                    color: seconds == 0 ? AppColors.primary : AppColors.dark50,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizeBox(height: 20),
          Text(
            "OTP Frozen",
            style: TextStyles.primaryMedium.copyWith(
              color: const Color(0xFF636363),
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    }
  }

  void resendOTP() async {
    if (seconds == 0) {
      seconds = 30;
      startTimer();
      final OTPTimerBloc otpTimerBloc = context.read<OTPTimerBloc>();
      otpTimerBloc.add(OTPTimerEvent(seconds: seconds));
    }
    if (otpArgumentModel.isEmail) {
      await MapSendEmailOtp.mapSendEmailOtp(
          {"emailID": otpArgumentModel.emailOrPhone});
    } else {
      await MapSendMobileOtp.mapSendMobileOtp(
        {"mobileNo": otpArgumentModel.emailOrPhone},
        token,
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}
