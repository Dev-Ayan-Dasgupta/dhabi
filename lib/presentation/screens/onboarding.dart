import 'dart:async';

import 'package:dialup_mobile_app/presentation/widgets/core/gradient_button.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/solid_button.dart';
import 'package:dialup_mobile_app/presentation/widgets/onboarding/page_indicator.dart';
import 'package:dialup_mobile_app/utils/constants/dimensions.dart';
import 'package:dialup_mobile_app/utils/constants/textstyles.dart';
import 'package:dialup_mobile_app/utils/lists/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final padding = (28 / Dimensions.designWidth);
  final space = (10 / Dimensions.designWidth);

  PageController pageController = PageController(initialPage: 0);

  int page = 0;
  int time = 0;

  @override
  void initState() {
    super.initState();
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
                        SizedBox(height: (24 / Dimensions.designHeight).h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Login",
                              style: TextStyles.primaryBold.copyWith(
                                fontSize: (20 / Dimensions.designWidth).w,
                              ),
                            ),
                            SizedBox(
                              width: (10 / Dimensions.designWidth).w,
                            ),
                          ],
                        ),
                        SizedBox(height: (28 / Dimensions.designHeight).h),
                        Text(
                          "DHABI",
                          style: TextStyle(
                            color: const Color.fromRGBO(255, 255, 255, 0.5),
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        SizedBox(height: (10 / Dimensions.designHeight).h),
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
                        GradientButton(
                          onTap: () {},
                          text: "Get Started",
                        ),
                        SizedBox(height: (20 / Dimensions.designHeight).h),
                        SolidButton(
                          onTap: () {},
                          text: "Explore as a Guest",
                        ),
                        SizedBox(height: (40 / Dimensions.designHeight).h),
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
}
