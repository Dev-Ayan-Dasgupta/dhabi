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
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
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
    startTimer(otpArgumentModel.isEmail ? 300 : 90);
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

  void startTimer(int count) {
    seconds = count;
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
    return WillPopScope(
      onWillPop: () async {
        promptUser();
        return true;
      },
      child: Scaffold(
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
      return SizedBox(
        width: 80.w,
        child: Text(
          "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.",
          style: TextStyles.primaryMedium.copyWith(
            color: const Color(0xFF343434),
            fontSize: (18 / Dimensions.designWidth).w,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
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
          auxWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: labels[347]["labelText"],
          ),
          actionWidget: SolidButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[166]["labelText"],
            color: AppColors.primaryBright17,
            fontColor: AppColors.primary,
          ),
        );
      },
    );
  }

  Widget buildPinput(BuildContext context, PinputErrorState state) {
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
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
                    await MapCustomerDetails.mapCustomerDetails(tokenCP ?? "");
                log("Get Customer Details API response -> $getCustomerDetailsResponse");

                List cifDetails = getCustomerDetailsResponse["cifDetails"];

                if (cifDetails.isEmpty) {
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.loginPassword,
                      arguments: LoginPasswordArgumentModel(
                        emailId: storageEmail ?? "",
                        userId: storageUserId ?? 0,
                        userTypeId: storageUserTypeId ?? 2,
                        companyId: storageCompanyId ?? 0,
                      ).toMap(),
                    );
                  }
                } else {
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
                }
              } else {
                pinputErrorCount++;
                seconds = 0;
                showButtonBloc.add(const ShowButtonEvent(show: true));
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
                          userTypeId: 1,
                          companyId: 0,
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
                              title: "Thank You!",
                              message:
                                  "Your request is submitted with reference number $storagReferenceNumber. We will contact you on next steps.",
                              actionWidget:
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
                                              .mapCustomerDetails(token ?? "");
                                      log("Get Customer Details API response -> $getCustomerDetailsResponse");
                                      List cifDetails =
                                          getCustomerDetailsResponse[
                                              "cifDetails"];
                                      if (context.mounted) {
                                        if (cifDetails.length == 1) {
                                          cif = getCustomerDetailsResponse[
                                              "cifDetails"][0]["cif"];

                                          isCompany =
                                              getCustomerDetailsResponse[
                                                  "cifDetails"][0]["isCompany"];

                                          isCompanyRegistered =
                                              getCustomerDetailsResponse[
                                                      "cifDetails"][0]
                                                  ["isCompanyRegistered"];

                                          if (cif == null || cif == "null") {
                                            if (isCompany) {
                                              if (isCompanyRegistered) {
                                                Navigator.pop(context);
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  Routes.loginPassword,
                                                  arguments:
                                                      LoginPasswordArgumentModel(
                                                    emailId: storageEmail ?? "",
                                                    userId: storageUserId ?? 0,
                                                    userTypeId:
                                                        storageUserTypeId ?? 2,
                                                    companyId:
                                                        storageCompanyId ?? 0,
                                                  ).toMap(),
                                                );
                                              } else {
                                                Navigator.pop(context);
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  Routes.onboarding,
                                                  arguments:
                                                      OnboardingArgumentModel(
                                                    isInitial: true,
                                                  ).toMap(),
                                                );
                                              }
                                            } else {
                                              Navigator.pop(context);
                                              Navigator.pushReplacementNamed(
                                                context,
                                                Routes.loginPassword,
                                                arguments:
                                                    LoginPasswordArgumentModel(
                                                  emailId: storageEmail ?? "",
                                                  userId: storageUserId ?? 0,
                                                  userTypeId:
                                                      storageUserTypeId ?? 2,
                                                  companyId:
                                                      storageCompanyId ?? 0,
                                                ).toMap(),
                                              );
                                            }
                                          }
                                        } else {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            Routes.selectAccount,
                                            arguments:
                                                SelectAccountArgumentModel(
                                              emailId:
                                                  otpArgumentModel.emailOrPhone,
                                              cifDetails: cifDetails,
                                              isPwChange: false,
                                              isLogin: false,
                                            ).toMap(),
                                          );
                                        }
                                      }
                                      isLoading = false;
                                      showButtonBloc.add(
                                          ShowButtonEvent(show: isLoading));

                                      await storage.write(
                                          key: "stepsCompleted",
                                          value: 0.toString());
                                      storageStepsCompleted = int.parse(
                                          await storage.read(
                                                  key: "stepsCompleted") ??
                                              "0");
                                      await storage.write(
                                          key: "hasFirstLoggedIn",
                                          value: true.toString());
                                      storageHasFirstLoggedIn = (await storage
                                              .read(key: "hasFirstLoggedIn")) ==
                                          "true";
                                    },
                                    text: labels[31]["labelText"],
                                    auxWidget: isLoading
                                        ? const LoaderRow()
                                        : const SizeBox(),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.pushReplacementNamed(
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
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
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
                          await MapCustomerDetails.mapCustomerDetails(
                              tokenCP ?? "");
                      log("Get Customer Details API response -> $getCustomerDetailsResponse");
                      List cifDetails =
                          getCustomerDetailsResponse["cifDetails"];

                      if (cifDetails.length == 1) {
                        if (context.mounted) {
                          cif = getCustomerDetailsResponse["cifDetails"][0]
                              ["cif"];

                          isCompany = getCustomerDetailsResponse["cifDetails"]
                              [0]["isCompany"];

                          isCompanyRegistered =
                              getCustomerDetailsResponse["cifDetails"][0]
                                  ["isCompanyRegistered"];

                          log("cif -> $cif");
                          log("cif RTT -> ${cif.runtimeType}");
                          log("isCompany -> $isCompany");
                          log("isCompanyRegistered -> $isCompanyRegistered");

                          // TODO: call deviceValid API
                          var isDeviceValidApiResult =
                              await MapIsDeviceValid.mapIsDeviceValid({
                            "userId": cifDetails[0]["userID"],
                            "deviceId": deviceId,
                          }, tokenCP ?? "");
                          log("isDeviceValidApiResult -> $isDeviceValidApiResult");

                          if (isDeviceValidApiResult["success"]) {
                            if (context.mounted) {
                              if (cif != null || cif != "null") {
                                if (isCompany) {
                                  if (isCompanyRegistered) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.setPassword,
                                    );
                                  }
                                } else {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routes.setPassword,
                                  );
                                }
                              }
                              if (cif == null) {
                                log("cif is null");
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return CustomDialog(
                                      svgAssetPath: ImageConstants.warning,
                                      title: "Application approval pending",
                                      message:
                                          "You already have a registration pending. Please contact Dhabi support.",
                                      auxWidget: GradientButton(
                                        onTap: () async {
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                              context,
                                              Routes.registration,
                                              arguments:
                                                  RegistrationArgumentModel(
                                                isInitial: true,
                                              ).toMap(),
                                            );
                                          }
                                        },
                                        text: "Go Home",
                                      ),
                                      actionWidget: SolidButton(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        text: labels[166]["labelText"],
                                        color: AppColors.primaryBright17,
                                        fontColor: AppColors.primary,
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          }
                        }
                      } else {
                        if (cifDetails.isEmpty) {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return CustomDialog(
                                  svgAssetPath: ImageConstants.warning,
                                  title: "Invalid Email",
                                  message:
                                      "There is no Dhabi Account associated with this email address.",
                                  actionWidget: GradientButton(
                                    onTap: () async {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                          context,
                                          Routes.registration,
                                          arguments: RegistrationArgumentModel(
                                            isInitial: true,
                                          ).toMap(),
                                        );
                                      }
                                    },
                                    text: "Go Home",
                                  ),
                                );
                              },
                            );
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
                      }
                    } else {
                      if (otpArgumentModel.isBusiness) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.checkCircleOutlined,
                              title: "Thank You!",
                              message:
                                  "Your request is submitted with reference number $storagReferenceNumber. We will contact you on next steps.",
                              actionWidget:
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
                                              .mapCustomerDetails(token ?? "");
                                      log("Get Customer Details API response -> $getCustomerDetailsResponse");
                                      List cifDetails =
                                          getCustomerDetailsResponse[
                                              "cifDetails"];
                                      if (context.mounted) {
                                        if (cifDetails.length == 1) {
                                          cif = getCustomerDetailsResponse[
                                              "cifDetails"][0]["cif"];

                                          isCompany =
                                              getCustomerDetailsResponse[
                                                  "cifDetails"][0]["isCompany"];

                                          isCompanyRegistered =
                                              getCustomerDetailsResponse[
                                                      "cifDetails"][0]
                                                  ["isCompanyRegistered"];

                                          if (cif == null || cif == "null") {
                                            if (isCompany) {
                                              if (isCompanyRegistered) {
                                                Navigator.pop(context);
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  Routes.loginPassword,
                                                  arguments:
                                                      LoginPasswordArgumentModel(
                                                    emailId: storageEmail ?? "",
                                                    userId: storageUserId ?? 0,
                                                    userTypeId:
                                                        storageUserTypeId ?? 2,
                                                    companyId:
                                                        storageCompanyId ?? 0,
                                                  ).toMap(),
                                                );
                                              } else {
                                                Navigator.pop(context);
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  Routes.onboarding,
                                                  arguments:
                                                      OnboardingArgumentModel(
                                                    isInitial: true,
                                                  ).toMap(),
                                                );
                                              }
                                            } else {
                                              Navigator.pop(context);
                                              Navigator.pushReplacementNamed(
                                                context,
                                                Routes.loginPassword,
                                                arguments:
                                                    LoginPasswordArgumentModel(
                                                  emailId: storageEmail ?? "",
                                                  userId: storageUserId ?? 0,
                                                  userTypeId:
                                                      storageUserTypeId ?? 2,
                                                  companyId:
                                                      storageCompanyId ?? 0,
                                                ).toMap(),
                                              );
                                            }
                                          }
                                        } else {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            Routes.selectAccount,
                                            arguments:
                                                SelectAccountArgumentModel(
                                              emailId:
                                                  otpArgumentModel.emailOrPhone,
                                              cifDetails: cifDetails,
                                              isPwChange: false,
                                              isLogin: false,
                                            ).toMap(),
                                          );
                                        }
                                      }
                                      isLoading = false;
                                      showButtonBloc.add(
                                          ShowButtonEvent(show: isLoading));

                                      await storage.write(
                                          key: "stepsCompleted",
                                          value: 0.toString());
                                      storageStepsCompleted = int.parse(
                                          await storage.read(
                                                  key: "stepsCompleted") ??
                                              "0");
                                      await storage.write(
                                          key: "hasFirstLoggedIn",
                                          value: true.toString());
                                      storageHasFirstLoggedIn = (await storage
                                              .read(key: "hasFirstLoggedIn")) ==
                                          "true";
                                    },
                                    text: labels[31]["labelText"],
                                    auxWidget: isLoading
                                        ? const LoaderRow()
                                        : const SizeBox(),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.pushReplacementNamed(
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
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
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
              token ?? "",
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
                          title: "Thank You!",
                          message:
                              "Your request is submitted with reference number $storagReferenceNumber. We will contact you on next steps.",
                          actionWidget:
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              return GradientButton(
                                onTap: () async {
                                  isLoading = true;
                                  final ShowButtonBloc showButtonBloc =
                                      context.read<ShowButtonBloc>();
                                  showButtonBloc
                                      .add(ShowButtonEvent(show: isLoading));
                                  var getCustomerDetailsResponse =
                                      await MapCustomerDetails
                                          .mapCustomerDetails(token ?? "");
                                  log("Get Customer Details API response -> $getCustomerDetailsResponse");
                                  List cifDetails =
                                      getCustomerDetailsResponse["cifDetails"];
                                  if (context.mounted) {
                                    if (cifDetails.length == 1) {
                                      cif = getCustomerDetailsResponse[
                                          "cifDetails"][0]["cif"];

                                      isCompany = getCustomerDetailsResponse[
                                          "cifDetails"][0]["isCompany"];

                                      isCompanyRegistered =
                                          getCustomerDetailsResponse[
                                                  "cifDetails"][0]
                                              ["isCompanyRegistered"];

                                      if (cif == null || cif == "null") {
                                        if (isCompany) {
                                          if (isCompanyRegistered) {
                                            Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                              context,
                                              Routes.loginPassword,
                                              arguments:
                                                  LoginPasswordArgumentModel(
                                                emailId: storageEmail ?? "",
                                                userId: storageUserId ?? 0,
                                                userTypeId:
                                                    storageUserTypeId ?? 2,
                                                companyId:
                                                    storageCompanyId ?? 0,
                                              ).toMap(),
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                              context,
                                              Routes.onboarding,
                                              arguments:
                                                  OnboardingArgumentModel(
                                                isInitial: true,
                                              ).toMap(),
                                            );
                                          }
                                        } else {
                                          Navigator.pop(context);
                                          Navigator.pushReplacementNamed(
                                            context,
                                            Routes.loginPassword,
                                            arguments:
                                                LoginPasswordArgumentModel(
                                              emailId: storageEmail ?? "",
                                              userId: storageUserId ?? 0,
                                              userTypeId:
                                                  storageUserTypeId ?? 2,
                                              companyId: storageCompanyId ?? 0,
                                            ).toMap(),
                                          );
                                        }
                                      }
                                    } else {
                                      Navigator.pushReplacementNamed(
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
                                  }
                                  isLoading = false;
                                  showButtonBloc
                                      .add(ShowButtonEvent(show: isLoading));

                                  await storage.write(
                                      key: "stepsCompleted",
                                      value: 0.toString());
                                  storageStepsCompleted = int.parse(
                                      await storage.read(
                                              key: "stepsCompleted") ??
                                          "0");
                                  await storage.write(
                                      key: "hasFirstLoggedIn",
                                      value: true.toString());
                                  storageHasFirstLoggedIn = (await storage.read(
                                          key: "hasFirstLoggedIn")) ==
                                      "true";
                                },
                                text: labels[31]["labelText"],
                                auxWidget: isLoading
                                    ? const LoaderRow()
                                    : const SizeBox(),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.retailOnboardingStatus,
                      arguments: OnboardingStatusArgumentModel(
                        stepsCompleted: 4,
                        isFatca: true,
                        isPassport: false,
                        isRetail: !otpArgumentModel.isBusiness,
                      ).toMap(),
                    );
                    await storage.write(
                        key: "stepsCompleted", value: 10.toString());
                    storageStepsCompleted = int.parse(
                        await storage.read(key: "stepsCompleted") ?? "0");
                  }
                }
              }
            } else {
              pinputErrorCount++;
              seconds = 0;
              showButtonBloc.add(const ShowButtonEvent(show: true));
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
          BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return Ternary(
                condition: pinputErrorCount == 0,
                truthy: Row(
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
                falsy: Text(
                  messages[7]["messageText"],
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.red100,
                    fontSize: (14 / Dimensions.designWidth).w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
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
                    color: seconds == 0 || pinputErrorCount > 0
                        ? AppColors.primary
                        : AppColors.dark50,
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
            labels[36]["labelText"],
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
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    if (seconds == 0) {
      final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
      if (seconds == 0 || pinputErrorCount > 0) {
        if (otpArgumentModel.isEmail) {
          seconds = 90;
        } else {
          seconds = 90;
        }
        startTimer(seconds);
        final OTPTimerBloc otpTimerBloc = context.read<OTPTimerBloc>();
        otpTimerBloc.add(OTPTimerEvent(seconds: seconds));
      }
      if (otpArgumentModel.isEmail) {
        await MapSendEmailOtp.mapSendEmailOtp(
            {"emailID": otpArgumentModel.emailOrPhone});
      } else {
        await MapSendMobileOtp.mapSendMobileOtp(
          {"mobileNo": otpArgumentModel.emailOrPhone},
          token ?? "",
        );
      }
      pinputErrorCount = 0;
      _pinController.clear();
      pinputErrorBloc.add(
        PinputErrorEvent(
          isError: false,
          isComplete: false,
          errorCount: pinputErrorCount,
        ),
      );

      showButtonBloc.add(const ShowButtonEvent(show: true));
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}
