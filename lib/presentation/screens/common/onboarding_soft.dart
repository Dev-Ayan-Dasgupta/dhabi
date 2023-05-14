// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:local_auth/local_auth.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/onboarding/page_indicator.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/biometric.dart';
import 'package:dialup_mobile_app/utils/lists/onboarding_soft.dart';
import 'package:open_settings/open_settings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingArgumentModel onboardingArgumentModel;

  final padding = (28 / Dimensions.designWidth);
  final space = (10 / Dimensions.designWidth);

  PageController pageController = PageController(initialPage: 0);

  int page = 0;
  int time = 0;

  @override
  void initState() {
    super.initState();
    onboardingArgumentModel =
        OnboardingArgumentModel.fromMap(widget.argument as dynamic ?? {});
    animateToPage();
  }

  animateToPage() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      time++;
      if (time == 5 || time == 10 || time == 15) {
        pageController.animateToPage(page + 1,
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
        page++;
        if (page == 3) {
          timer.cancel();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView.builder(
        controller: pageController,
        itemCount: onboardingSoftList.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage(onboardingSoftList[index].backgroundImage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: 100.w,
                height: 100.h,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                      Colors.black38,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top +
                    (10 / Dimensions.designWidth).w,
                child: SizedBox(
                  width: 100.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (28 / Dimensions.designWidth).w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PageIndicator(
                          count: onboardingSoftList.length,
                          page: index,
                        ),
                        const SizeBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Ternary(
                              condition: onboardingArgumentModel.isInitial,
                              truthy: InkWell(
                                onTap: biometricPrompt,
                                child: Text(
                                  labels[205]["labelText"],
                                  style: TextStyles.primaryBold.copyWith(
                                    fontSize: (20 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ),
                              falsy: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.exploreDashboard);
                                },
                                child: Text(
                                  "Explore",
                                  style: TextStyles.primaryBold.copyWith(
                                    fontSize: (20 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ),
                            ),
                            const SizeBox(width: 10),
                          ],
                        ),
                        const SizeBox(height: 28),
                        Text(
                          "DHABI",
                          style: TextStyle(
                            color: const Color.fromRGBO(255, 255, 255, 0.5),
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(height: 10),
                        SizedBox(
                          width: 67.w,
                          child: Text(
                            onboardingSoftList[index].caption,
                            style: TextStyles.primaryMedium.copyWith(
                                fontSize: (35 / Dimensions.designWidth).w),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: 100.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (28 / Dimensions.designWidth).w),
                    child: Column(
                      children: [
                        Ternary(
                          condition: onboardingArgumentModel.isInitial,
                          truthy: GradientButton(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.registration,
                                arguments: RegistrationArgumentModel(
                                  isInitial: true,
                                ).toMap(),
                              );
                            },
                            text: labels[207]["labelText"],
                          ),
                          falsy: GradientButton(
                            onTap: biometricPrompt,
                            text: labels[205]["labelText"],
                          ),
                        ),
                        const SizeBox(height: 15),
                        Ternary(
                          condition: onboardingArgumentModel.isInitial,
                          truthy: SolidButton(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.exploreDashboard);
                              // Navigator.pushNamed(context, Routes.setPassword);

                              // OAuthHelper.oAuth();
                            },
                            text: labels[208]["labelText"],
                            color: const Color.fromRGBO(85, 85, 85, 0.2),
                            fontColor: Colors.white,
                          ),
                          falsy: SolidButton(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.registration,
                                arguments: RegistrationArgumentModel(
                                  isInitial: true,
                                ).toMap(),
                              );
                            },
                            text: "Register",
                            color: const Color.fromRGBO(85, 85, 85, 0.2),
                            fontColor: Colors.white,
                          ),
                        ),
                        SizeBox(
                            height: PaddingConstants.bottomPadding +
                                MediaQuery.of(context).padding.bottom),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void biometricPrompt() async {
    bool isBiometricSupported = await LocalAuthentication().isDeviceSupported();
    log("isBiometricSupported -> $isBiometricSupported");

    if (deviceId == "bf8e43a90970f33c") {
      if (context.mounted) {
        Navigator.pushNamed(context, Routes.loginUserId);
      }
    }

    if (!isBiometricSupported) {
      if (context.mounted) {
        Navigator.pushNamed(context, Routes.loginUserId);
      }
    } else {
      bool isAuthenticated = await BiometricHelper.authenticateUser();

      if (isAuthenticated) {
        if (context.mounted) {
          Navigator.pushNamed(context, Routes.loginUserId);
        }
      } else {
        // TODO: Verify from client if they want a dialog box to enable biometric
        OpenSettings.openBiometricEnrollSetting();
      }
    }
  }
}
