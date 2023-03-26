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

  int seconds = 300;

  @override
  void initState() {
    super.initState();
    otpArgumentModel =
        OTPArgumentModel.fromMap(widget.argument as dynamic ?? {});
    obscuredEmail = ObscureHelper.obscureEmail(otpArgumentModel.email);
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    pinputErrorBloc.add(
        PinputErrorEvent(isError: false, isComplete: false, errorCount: 0));
    startTimer();
  }

  void startTimer() {
    final OTPTimerBloc otpTimerBloc = context.read<OTPTimerBloc>();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        otpTimerBloc.add(OTPTimerEvent(seconds: seconds));
      } else {
        timer.cancel();
      }
    });
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
                          return SvgPicture.asset(
                            ImageConstants.otp,
                            width: (78 / Dimensions.designWidth).w,
                            height: (70 / Dimensions.designHeight).h,
                          );
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
                                    : const Color(0XFFEEEEEE)
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
                                  // TODO: Probably call navigation to next screen here
                                  // TODO: maybe navigate after a small delay to show the green for sometime or log session in api call in which case don;t need to add delay
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  if (context.mounted) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.selectAccountType,
                                      arguments: CreateAccountArgumentModel(
                                        email: otpArgumentModel.email,
                                      ).toMap(),
                                    );
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
                                    onTap: () {
                                      resendOTP();
                                    },
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
              Column(
                children: [
                  //TODO: Potentially remove it - may not be needed as we will call API onChanged in pinput
                  BlocBuilder<PinputErrorBloc, PinputErrorState>(
                      builder: (context, state) {
                    if (pinputErrorCount < 3) {
                      return GradientButton(onTap: () {}, text: "Validate");
                    } else {
                      return SolidButton(onTap: () {}, text: "Validate");
                    }
                  }),
                  const SizeBox(height: 32),
                ],
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
