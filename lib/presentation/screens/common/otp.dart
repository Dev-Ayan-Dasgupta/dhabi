// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dialup_mobile_app/bloc/otp/pinput/error_bloc.dart';
import 'package:dialup_mobile_app/bloc/otp/pinput/error_event.dart';
import 'package:dialup_mobile_app/bloc/otp/pinput/error_state.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_bloc.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_event.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/create_account.dart';
import 'package:dialup_mobile_app/data/models/arguments/otp.dart';
import 'package:dialup_mobile_app/data/models/arguments/retail_dashboard.dart';
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
      obscuredPhone =
          ObscureHelper.obscurePhone("+971${otpArgumentModel.emailOrPhone}");
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
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();

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
          padding: EdgeInsets.symmetric(
            horizontal: (22 / Dimensions.designWidth).w,
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      const SizeBox(height: 30),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                          builder: (context, state) {
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
                      }),
                      const SizeBox(height: 20),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                          builder: (context, state) {
                        if (pinputErrorCount < 3) {
                          return Text(
                            "Enter One-Time Password",
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0xFF252525),
                              fontSize: (24 / Dimensions.designWidth).w,
                            ),
                          );
                        } else {
                          return Text(
                            "Oops!",
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0xFF252525),
                              fontSize: (24 / Dimensions.designWidth).w,
                            ),
                          );
                        }
                      }),
                      const SizeBox(height: 15),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                          builder: (context, state) {
                        if (pinputErrorCount < 3) {
                          if (otpArgumentModel.isEmail) {
                            return Text(
                              "A 6-digit code has been sent to the email: $obscuredEmail",
                              style: TextStyles.primaryMedium.copyWith(
                                color: const Color(0xFF343434),
                                fontSize: (18 / Dimensions.designWidth).w,
                              ),
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Text(
                              "A 6-digit code has been sent to the mobile number: $obscuredPhone",
                              style: TextStyles.primaryMedium.copyWith(
                                color: const Color(0xFF343434),
                                fontSize: (18 / Dimensions.designWidth).w,
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
                      }),
                      const SizeBox(height: 25),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: (context, state) {
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
                                if (otpArgumentModel.code ==
                                    _pinController.text) {
                                  pinputErrorBloc.add(
                                    PinputErrorEvent(
                                      isError: false,
                                      isComplete: true,
                                      errorCount: pinputErrorCount,
                                    ),
                                  );

                                  await Future.delayed(
                                      const Duration(milliseconds: 750));
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
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, Routes.thankYou);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomDialog(
                                              svgAssetPath:
                                                  ImageConstants.checkCircle,
                                              title: "You're One Step Closer!",
                                              message:
                                                  "Select below to continue",
                                              auxWidget: const SizeBox(),
                                              actionWidget: Column(
                                                children: [
                                                  GradientButton(
                                                    onTap: () {},
                                                    text: "Scan ID",
                                                  ),
                                                  const SizeBox(height: 15),
                                                  SolidButton(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.pushReplacementNamed(
                                                          context,
                                                          Routes
                                                              .retailDashboard,
                                                          arguments:
                                                              RetailDashboardArgumentModel(
                                                            imgUrl:
                                                                "https://images.unsplash.com/photo-1619895862022-09114b41f16f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                                                            name:
                                                                "ayan@qolarisdata.com",
                                                          ).toMap());
                                                    },
                                                    text: "Skip for now",
                                                    color: const Color.fromRGBO(
                                                        34, 97, 105, 0.17),
                                                    fontColor:
                                                        AppColors.primary,
                                                  ),
                                                  const SizeBox(height: 22),
                                                ],
                                              ),
                                            );
                                          },
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
                                pinputErrorBloc.add(PinputErrorEvent(
                                    isError: false,
                                    isComplete: false,
                                    errorCount: pinputErrorCount));
                              }
                            },
                            enabled: state.errorCount < 3 ? true : false,
                          );
                        },
                      ),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                          builder: (context, state) {
                        if (pinputErrorCount < 3) {
                          return Column(
                            children: [
                              const SizeBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Your code will expire in ",
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: const Color(0xFF636363),
                                      fontSize: (14 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                  BlocBuilder<OTPTimerBloc, OTPTimerState>(
                                    builder: (context, state) {
                                      if (seconds % 60 < 10) {
                                        return Text(
                                          "${seconds ~/ 60}:0${seconds % 60}",
                                          style:
                                              TextStyles.primaryMedium.copyWith(
                                            color: const Color(0xFFFF6D4F),
                                            fontSize:
                                                (14 / Dimensions.designWidth).w,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          "${seconds ~/ 60}:${seconds % 60}",
                                          style:
                                              TextStyles.primaryMedium.copyWith(
                                            color: const Color(0xFFFF6D4F),
                                            fontSize:
                                                (14 / Dimensions.designWidth).w,
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
                                      "Resend code",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: seconds == 0
                                            ? AppColors.primary
                                            : const Color(0xFFC6C6C6),
                                        fontSize:
                                            (18 / Dimensions.designWidth).w,
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
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resendOTP() {
    if (seconds == 0) {
      seconds = 30;
      startTimer();
      final OTPTimerBloc otpTimerBloc = context.read<OTPTimerBloc>();
      otpTimerBloc.add(OTPTimerEvent(seconds: seconds));
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}