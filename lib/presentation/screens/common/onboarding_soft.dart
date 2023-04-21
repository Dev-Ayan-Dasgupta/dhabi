// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dialup_mobile_app/data/models/arguments/onboarding_soft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:local_auth/local_auth.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/onboarding/page_indicator.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/biometric.dart';
import 'package:dialup_mobile_app/utils/lists/onboarding_soft.dart';

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
                top: kToolbarHeight + (20 / Dimensions.designHeight).h,
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
                                  "Login",
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
                              Navigator.pushNamed(context, Routes.registration);
                            },
                            text: "Get Started",
                          ),
                          falsy: GradientButton(
                            onTap: biometricPrompt,
                            text: "Login",
                          ),
                        ),
                        const SizeBox(height: 20),
                        Ternary(
                          condition: onboardingArgumentModel.isInitial,
                          truthy: SolidButton(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.captureFace);
                              // Navigator.pushNamed(
                              //     context, Routes.exploreDashboard);
                              // Navigator.pushNamed(
                              //   context,
                              //   Routes.retailOnboardingStatus,
                              //   arguments: OnboardingStatusArgumentModel(
                              //     stepsCompleted: 1,
                              //     isFatca: false,
                              //     isPassport: false,
                              //   ).toMap(),
                              // );
                              // OAuthHelper.oAuth();
                            },
                            text: "Explore as a Guest",
                          ),
                          falsy: SolidButton(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.registration);
                            },
                            text: "Register",
                          ),
                        ),
                        const SizeBox(height: 40),
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
    if (!isBiometricSupported) {
      if (context.mounted) {
        Navigator.pushNamed(context, Routes.login);
      }
    } else {
      bool isAuthenticated = await BiometricHelper.authenticateUser();
      if (isAuthenticated) {
        if (context.mounted) {
          Navigator.pushNamed(context, Routes.login);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Biometric Authentication failed.',
                style: TextStyles.primary.copyWith(
                  fontSize: (12 / Dimensions.designWidth).w,
                ),
              ),
            ),
          );
        }
      }
    }
  }
}
