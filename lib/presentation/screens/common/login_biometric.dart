// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:local_auth/local_auth.dart';

class LoginBiometricScreen extends StatefulWidget {
  const LoginBiometricScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<LoginBiometricScreen> createState() => _LoginBiometricScreenState();
}

class _LoginBiometricScreenState extends State<LoginBiometricScreen> {
  late LoginPasswordArgumentModel loginPasswordArgument;

  bool isShowBiometric = true;
  int biometricFailedCount = 0;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    biometricPrompt();
  }

  void argumentInitialization() {
    loginPasswordArgument =
        LoginPasswordArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(ImageConstants.dhabiText),
        backgroundColor: Colors.transparent,
        centerTitle: true,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 15),
                  Text(
                    // "Mr. Mohamed Abood",
                    storageCustomerName ?? "",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SolidButton(
                  onTap: () {
                    isShowBiometric = false;
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.loginPassword,
                      arguments: LoginPasswordArgumentModel(
                        emailId: storageEmail ?? "",
                        userId: storageUserId ?? 0,
                        userTypeId: storageUserTypeId ?? 1,
                        companyId: storageCompanyId ?? 0,
                      ).toMap(),
                    );
                  },
                  text: "Use password instead",
                  color: Colors.white,
                  fontColor: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(
                        (4 / Dimensions.designWidth).w,
                        (4 / Dimensions.designHeight).h,
                      ),
                      blurRadius: (8 / Dimensions.designWidth).w,
                    )
                  ],
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void biometricPrompt() async {
    log("storageEmail -> $storageEmail");
    log("storagePassword -> $storagePassword");
    await Future.delayed(const Duration(seconds: 3));
    log("isShowBiometric -> $isShowBiometric");
    if (isShowBiometric) {
      if (persistBiometric!) {
        bool isBiometricSupported =
            await LocalAuthentication().isDeviceSupported();
        log("isBiometricSupported -> $isBiometricSupported");

        if (deviceId == "bf8e43a90970f33c") {
          if (context.mounted) {
            Navigator.pushReplacementNamed(
              context,
              Routes.loginPassword,
              arguments: LoginPasswordArgumentModel(
                emailId: storageEmail ?? "",
                userId: storageUserId ?? 0,
                userTypeId: storageUserTypeId ?? 1,
                companyId: storageCompanyId ?? 0,
              ).toMap(),
            );
          }
        }

        if (!isBiometricSupported) {
        } else {
          bool isAuthenticated = await BiometricHelper.authenticateUser();

          if (isAuthenticated) {
            if (context.mounted) {
              onSubmit(storagePassword ?? "");
            }
          } else {
            // TODO: Verify from client if they want a dialog box to enable biometric
            // OpenSettings.openBiometricEnrollSetting();
            if (context.mounted) {
              biometricFailedCount++;
              log("biometricFailedCount -> $biometricFailedCount");
              if (biometricFailedCount == 3) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.loginPassword,
                  arguments: LoginPasswordArgumentModel(
                    emailId: storageEmail ?? "",
                    userId: storageUserId ?? 0,
                    userTypeId: storageUserTypeId ?? 1,
                    companyId: storageCompanyId ?? 0,
                  ).toMap(),
                );
              }
            }
          }
        }
      }
    }
  }

  void onSubmit(String password) async {
    // log("companyID -> ${loginPasswordArgument.companyId}");
    // log("userTypeId -> ${loginPasswordArgument.userTypeId}");
    // final MatchPasswordBloc matchPasswordBloc =
    //     context.read<MatchPasswordBloc>();

    // isLoading = true;
    // matchPasswordBloc
    //     .add(MatchPasswordEvent(isMatch: isMatch, count: ++toggle));
    var result = await MapLogin.mapLogin({
      "emailId": storageEmail,
      "userTypeId": storageUserTypeId,
      "userId": storageUserId,
      "companyId": storageCompanyId,
      "password": password,
      "deviceId": deviceId,
      "registerDevice": false,
      "deviceName": deviceName,
      "deviceType": deviceType,
      "appVersion": appVersion
    });
    log("Login API Response -> $result");
    token = result["token"];
    log("token -> $token");

    if (result["success"]) {
      await storage.write(key: "newInstall", value: true.toString());
      storageIsNotNewInstall =
          (await storage.read(key: "newInstall")) == "true";
      customerName = result["customerName"];
      await storage.write(key: "customerName", value: customerName);
      storageCustomerName = await storage.read(key: "customerName");
      if (context.mounted) {
        if (loginPasswordArgument.userTypeId == 1) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.retailDashboard,
            (route) => false,
            arguments: RetailDashboardArgumentModel(
              imgUrl: "",
              name: result["customerName"],
              isFirst: storageIsFirstLogin == true ? false : false,
            ).toMap(),
          );
        } else {
          if (storageCif == null || storageCif == "null") {
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Application approval pending",
                  message:
                      "You already have a registration pending. Please contact Dhabi support.",
                  auxWidget: Column(
                    children: [
                      GradientButton(
                        onTap: () async {
                          if (context.mounted) {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.onboarding,
                              arguments: OnboardingArgumentModel(
                                isInitial: true,
                              ).toMap(),
                            );
                          }
                        },
                        text: labels[347]["labelText"],
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
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.businessDashboard,
              (route) => false,
              arguments: RetailDashboardArgumentModel(
                imgUrl: "",
                name: "",
                isFirst: storageIsFirstLogin == true ? false : true,
              ).toMap(),
            );
          }
        }
      }
      await storage.write(key: "cif", value: cif.toString());
      storageCif = await storage.read(key: "cif");
      log("storageCif -> $storageCif");

      await storage.write(key: "isCompany", value: isCompany.toString());
      storageIsCompany = await storage.read(key: "isCompany") == "true";
      log("storageIsCompany -> $storageIsCompany");

      await storage.write(
          key: "isCompanyRegistered", value: isCompanyRegistered.toString());
      storageisCompanyRegistered =
          await storage.read(key: "isCompanyRegistered") == "true";
      log("storageisCompanyRegistered -> $storageisCompanyRegistered");

      await storage.write(key: "isFirstLogin", value: true.toString());
      storageIsFirstLogin = (await storage.read(key: "isFirstLogin")) == "true";
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
          case 9:
            promptMaxRetries();
            break;
          default:
        }
      }
    }

    // isLoading = false;
    // matchPasswordBloc
    //     .add(MatchPasswordEvent(isMatch: isMatch, count: ++toggle));
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
                  Navigator.pushReplacementNamed(context, Routes.loginUserId);
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
          title: messages[65]["messageText"],
          message: messages[66]["messageText"],
          auxWidget: Column(
            children: [
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizeBox(height: 15),
                      GradientButton(
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
                            "password": storagePassword,
                            "deviceId": deviceId,
                            "registerDevice": true,
                            "deviceName": deviceName,
                            "deviceType": deviceType,
                            "appVersion": appVersion
                          });
                          log("Login API Response -> $result");
                          token = result["token"];
                          log("token -> $token");
                          if (result["success"]) {
                            await storage.write(
                                key: "newInstall", value: true.toString());
                            storageIsNotNewInstall =
                                (await storage.read(key: "newInstall")) ==
                                    "true";
                            customerName = result["customerName"];
                            await storage.write(
                                key: "customerName", value: customerName);
                            storageCustomerName =
                                await storage.read(key: "customerName");
                            if (context.mounted) {
                              if (loginPasswordArgument.userTypeId == 1) {
                                await storage.write(
                                    key: "retailLoggedIn",
                                    value: true.toString());
                                storageRetailLoggedIn =
                                    await storage.read(key: "retailLoggedIn") ==
                                        "true";
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.retailDashboard,
                                    (route) => false,
                                    arguments: RetailDashboardArgumentModel(
                                      imgUrl: "",
                                      name: result["customerName"],
                                      isFirst: storageIsFirstLogin == true
                                          ? false
                                          : true,
                                    ).toMap(),
                                  );
                                }
                              } else {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.businessDashboard,
                                  (route) => false,
                                  arguments: RetailDashboardArgumentModel(
                                    imgUrl: "",
                                    name: "",
                                    isFirst: storageIsFirstLogin == true
                                        ? false
                                        : true,
                                  ).toMap(),
                                );
                              }
                            }

                            await storage.write(
                                key: "isFirstLogin", value: true.toString());
                            storageIsFirstLogin =
                                (await storage.read(key: "isFirstLogin")) ==
                                    "true";
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
                                case 9:
                                  promptMaxRetries();
                                  break;
                                default:
                              }
                            }
                          }
                          isLoading = false;
                          showButtonBloc.add(ShowButtonEvent(show: isLoading));
                        },
                        text: labels[31]["labelText"],
                        auxWidget:
                            isLoading ? const LoaderRow() : const SizeBox(),
                      ),
                    ],
                  );
                },
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

  void promptMaxRetries() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Retry Limit Reached",
          message:
              "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.",
          actionWidget: Column(
            children: [
              const SizeBox(height: 20),
              GradientButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.onboarding,
                    arguments: OnboardingArgumentModel(isInitial: true).toMap(),
                  );
                },
                text: "Go Home",
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
}
