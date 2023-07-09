// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/onboarding/page_indicator.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
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

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late OnboardingArgumentModel onboardingArgumentModel;

  final padding = (PaddingConstants.horizontalPadding / Dimensions.designWidth);
  final space = (10 / Dimensions.designWidth);

  PageController pageController = PageController(initialPage: 0);

  int page = 0;
  int time = 0;
  int time2 = 0;

  bool isLoading = false;
  Timer? _timer;
  Timer? _timer2;

  late final AnimationController _progressAnimationController;
  late final Animation _progressLengthAnimation;

  @override
  void initState() {
    super.initState();
    onboardingArgumentModel =
        OnboardingArgumentModel.fromMap(widget.argument as dynamic ?? {});
    // moveCaption();
    animateCaption();
    animateToPage();
  }

  void animateToPage() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {});
        time++;
        if (time % 5 == 0 || time == 19) {
          pageController.animateToPage(page + 1,
              duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
          page++;
          if (time >= 19) {
            _timer?.cancel();
          }
        }
        log("time -> $time");
        log("right -> ${(time % 5) * (25 / Dimensions.designWidth).w}");
      },
    );
  }

  animateCaption() {
    _progressAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _progressLengthAnimation = Tween<double>(
      begin: (400 / Dimensions.designHeight).h,
      end: 0,
    ).animate(CurvedAnimation(
        parent: _progressAnimationController, curve: Curves.linear));
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.forward();
    // _progressAnimationController.repeat();

    log("_progressLengthAnimation -> ${_progressLengthAnimation.value}");
  }

  void moveCaption() {
    _timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time2++;
        if (time2 % 5 == 0) {
          animateCaption();
        }

        if (time2 >= 15) {
          timer.cancel();
        }
      });
      log("time2 -> $time2");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            itemCount: onboardingSoftList.length,
            itemBuilder: (context, index) {
              if (pageController.position.haveDimensions) {
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(seconds: 5),
                      curve: Curves.linear,
                      right: (time % 5) * (25 / Dimensions.designWidth).w,
                      child: Transform.scale(
                        scaleX: pageController.page == 0
                            ? 2
                            : pageController.page == 2
                                ? 3.5
                                : pageController.page == 3
                                    ? 2.2
                                    : 1,
                        child: Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  onboardingSoftList[index].backgroundImage),
                              fit: BoxFit.fill,
                            ),
                          ),
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
                          (20 / Dimensions.designHeight).h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: (PaddingConstants.horizontalPadding /
                                  Dimensions.designWidth)
                              .w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PageIndicator(
                              count: onboardingSoftList.length,
                              page: index,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).padding.top +
                            (72 / Dimensions.designHeight).h +
                            _progressLengthAnimation.value,
                        child: Opacity(
                          opacity: 1,
                          // ((400 / Dimensions.designHeight).h -
                          //         _progressLengthAnimation.value) /
                          //     (400 / Dimensions.designHeight).h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    (PaddingConstants.horizontalPadding /
                                            Dimensions.designWidth)
                                        .w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DHABI",
                                  style: TextStyle(
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.5),
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
                                      fontSize: (35 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                );
              } else {
                return null;
              }
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top +
                (20 / Dimensions.designHeight).h,
            child: SizedBox(
              width: 100.w,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: (PaddingConstants.horizontalPadding /
                            Dimensions.designWidth)
                        .w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizeBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Ternary(
                          condition: onboardingArgumentModel.isInitial,
                          truthy: InkWell(
                            onTap: loginMethod,
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
                                context,
                                Routes.exploreDashboard,
                              );
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
                    horizontal: (PaddingConstants.horizontalPadding /
                            Dimensions.designWidth)
                        .w),
                child: Column(
                  children: [
                    Ternary(
                      condition: onboardingArgumentModel.isInitial,
                      truthy: BlocBuilder<ShowButtonBloc, ShowButtonState>(
                        builder: (context, state) {
                          return GradientButton(
                            onTap: () async {
                              log("storageStepsCompleted -> $storageStepsCompleted");
                              switch (storageStepsCompleted) {
                                case 0:
                                  Navigator.pushNamed(
                                    context,
                                    Routes.registration,
                                    arguments: RegistrationArgumentModel(
                                      isInitial: true,
                                      isUpdateCorpEmail: false,
                                    ).toMap(),
                                  );
                                  break;
                                case 1:
                                  Navigator.pushNamed(
                                    context,
                                    Routes.createPassword,
                                    arguments: CreateAccountArgumentModel(
                                      email: storageEmail ?? "",
                                      isRetail:
                                          storageUserTypeId == 1 ? true : false,
                                      userTypeId: storageUserTypeId ?? 1,
                                      companyId: storageCompanyId ?? 0,
                                    ).toMap(),
                                  );
                                  break;
                                case 2:
                                  callLoginApi();
                                  if (storageUserTypeId == 1) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.retailOnboardingStatus,
                                      arguments: OnboardingStatusArgumentModel(
                                        stepsCompleted: 1,
                                        isFatca: false,
                                        isPassport: false,
                                        isRetail: true,
                                      ).toMap(),
                                    );
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.businessOnboardingStatus,
                                      arguments: OnboardingStatusArgumentModel(
                                        stepsCompleted: 1,
                                        isFatca: false,
                                        isPassport: false,
                                        isRetail: false,
                                      ).toMap(),
                                    );
                                  }
                                  break;
                                case 3:
                                  callLoginApi();
                                  Navigator.pushNamed(
                                    context,
                                    Routes.verificationInitializing,
                                    arguments:
                                        VerificationInitializationArgumentModel(
                                      isReKyc: false,
                                    ).toMap(),
                                  );
                                  break;
                                case 4:
                                  callLoginApi();
                                  Navigator.pushNamed(
                                    context,
                                    Routes.retailOnboardingStatus,
                                    arguments: OnboardingStatusArgumentModel(
                                      stepsCompleted: 2,
                                      isFatca: false,
                                      isPassport: false,
                                      isRetail: true,
                                    ).toMap(),
                                  );
                                  break;
                                case 5:
                                  callLoginApi();
                                  Navigator.pushNamed(
                                      context, Routes.applicationIncome);
                                  break;
                                case 6:
                                  callLoginApi();
                                  Navigator.pushNamed(
                                      context, Routes.applicationTaxFATCA);
                                  break;
                                case 7:
                                  callLoginApi();
                                  Navigator.pushNamed(
                                    context,
                                    Routes.applicationTaxCRS,
                                    arguments: TaxCrsArgumentModel(
                                      isUSFATCA: storageIsUSFATCA ?? true,
                                      ustin: storageUsTin ?? "",
                                    ).toMap(),
                                  );
                                  break;
                                case 8:
                                  callLoginApi();
                                  Navigator.pushNamed(
                                    context,
                                    Routes.applicationAccount,
                                    arguments: ApplicationAccountArgumentModel(
                                      isInitial: true,
                                      isRetail: true,
                                      savingsAccountsCreated: 0,
                                      currentAccountsCreated: 0,
                                    ).toMap(),
                                  );
                                  break;
                                case 9:
                                  callLoginApi();
                                  Navigator.pushNamed(
                                    context,
                                    Routes.retailOnboardingStatus,
                                    arguments: OnboardingStatusArgumentModel(
                                      stepsCompleted: 3,
                                      isFatca: false,
                                      isPassport: false,
                                      isRetail: true,
                                    ).toMap(),
                                  );
                                  break;
                                case 10:
                                  callLoginApi();
                                  Navigator.pushNamed(
                                    context,
                                    Routes.retailOnboardingStatus,
                                    arguments: OnboardingStatusArgumentModel(
                                      stepsCompleted: 4,
                                      isFatca: false,
                                      isPassport: false,
                                      isRetail: true,
                                    ).toMap(),
                                  );
                                  break;
                                case 11:
                                  callLoginApi();
                                  Navigator.pushNamed(
                                    context,
                                    Routes.businessOnboardingStatus,
                                    arguments: OnboardingStatusArgumentModel(
                                      stepsCompleted: 2,
                                      isFatca: false,
                                      isPassport: false,
                                      isRetail: false,
                                    ).toMap(),
                                  );
                                  break;
                                default:
                                  Navigator.pushNamed(
                                    context,
                                    Routes.registration,
                                    arguments: RegistrationArgumentModel(
                                      isInitial: true,
                                      isUpdateCorpEmail: false,
                                    ).toMap(),
                                  );
                              }
                            },
                            text: labels[207]["labelText"],
                            auxWidget:
                                isLoading ? const LoaderRow() : const SizeBox(),
                          );
                        },
                      ),
                      falsy: GradientButton(
                        onTap: loginMethod,
                        text: labels[205]["labelText"],
                      ),
                    ),
                    const SizeBox(height: 15),
                    Ternary(
                      condition: onboardingArgumentModel.isInitial,
                      truthy: SolidButton(
                        onTap: () async {
                          Navigator.pushNamed(context, Routes.exploreDashboard);
                          // Navigator.pushNamed(
                          //   context,
                          //   Routes.verificationInitializing,
                          //   arguments: VerificationInitializationArgumentModel(
                          //     isReKyc: false,
                          //   ).toMap(),
                          // );
                          // Navigator.pushNamed(context, Routes.loginUserId);
                          // await storage.write(
                          //     key: "stepsCompleted", value: 0.toString());
                          // storageStepsCompleted = int.parse(
                          //     await storage.read(key: "stepsCompleted") ?? "0");
                          // Navigator.pushNamed(
                          //   context,
                          //   Routes.otp,
                          //   arguments: OTPArgumentModel(
                          //     emailOrPhone: storageEmail ?? "",
                          //     isEmail: true,
                          //     isBusiness: false,
                          //     isInitial: false,
                          //     isLogin: false,
                          //     isEmailIdUpdate: false,
                          //     isMobileUpdate: false,
                          //   ).toMap(),
                          // );
                          // Navigator.pushNamed(
                          //     context, Routes.applicationAddress);
                          // Navigator.pushNamed(
                          //   context,
                          //   Routes.verifyMobile,
                          //   arguments: VerifyMobileArgumentModel(
                          //     isBusiness: false,
                          //     isUpdate: false,
                          //     isReKyc: false,
                          //   ).toMap(),
                          // );
                          // Navigator.pushNamed(
                          //   context,
                          //   Routes.applicationAccount,
                          //   arguments: ApplicationAccountArgumentModel(
                          //           isInitial: true)
                          //       .toMap(),
                          // );
                          // Navigator.pushNamed(
                          //     context, Routes.applicationAddress);
                          // Navigator.pushNamed(
                          //   context,
                          //   Routes.applicationTaxCRS,
                          //   arguments: TaxCrsArgumentModel(
                          //     isUSFATCA: storageIsUSFATCA ?? true,
                          //     ustin: storageUsTin ?? "",
                          //   ).toMap(),
                          // );
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
                              isUpdateCorpEmail: false,
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
                          MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void callLoginApi() async {
    isLoading = true;
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isLoading));
    var result = await MapLogin.mapLogin({
      "emailId": storageEmail,
      "userTypeId": storageUserTypeId,
      "userId": storageUserId,
      "companyId": storageCompanyId,
      "password": storagePassword,
      "deviceId": storageDeviceId,
      "registerDevice": false,
      "deviceName": deviceName,
      "deviceType": deviceType,
      "appVersion": appVersion,
      "fcmToken": fcmToken,
    });
    log("Login API Response -> $result");
    token = result["token"];
    log("token -> $token");
    customerName = result["customerName"];
    await storage.write(key: "customerName", value: customerName);
    storageCustomerName = await storage.read(key: "customerName");
    await storage.write(key: "loggedOut", value: false.toString());
    storageLoggedOut = await storage.read(key: "loggedOut") == "true";
    isLoading = false;
    showButtonBloc.add(ShowButtonEvent(show: isLoading));
  }

  void loginMethod() {
    if (storageLoggedOut == true) {
      Navigator.pushNamed(context, Routes.loginUserId);
    } else {
      if (storageCif == "null" || storageCif == null) {
        if (storageRetailLoggedIn == true) {
          if (persistBiometric == true) {
            Navigator.pushNamed(
              context,
              Routes.loginBiometric,
              arguments: LoginPasswordArgumentModel(
                emailId: storageEmail ?? "",
                userId: storageUserId ?? 0,
                userTypeId: storageUserTypeId ?? 1,
                companyId: storageCompanyId ?? 0,
              ).toMap(),
            );
          } else {
            Navigator.pushNamed(
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
        } else {
          Navigator.pushNamed(context, Routes.loginUserId);
        }
      } else {
        if (storageIsCompany == true) {
          if (storageisCompanyRegistered == false) {
            Navigator.pushNamed(context, Routes.loginUserId);
          } else {
            if (persistBiometric == true) {
              Navigator.pushNamed(
                context,
                Routes.loginBiometric,
                arguments: LoginPasswordArgumentModel(
                  emailId: storageEmail ?? "",
                  userId: storageUserId ?? 0,
                  userTypeId: storageUserTypeId ?? 1,
                  companyId: storageCompanyId ?? 0,
                ).toMap(),
              );
            } else {
              Navigator.pushNamed(
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
        } else {
          if (persistBiometric == true) {
            Navigator.pushNamed(
              context,
              Routes.loginBiometric,
              arguments: LoginPasswordArgumentModel(
                emailId: storageEmail ?? "",
                userId: storageUserId ?? 0,
                userTypeId: storageUserTypeId ?? 1,
                companyId: storageCompanyId ?? 0,
              ).toMap(),
            );
          } else {
            Navigator.pushNamed(
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

  @override
  void dispose() {
    _timer?.cancel();
    _timer2?.cancel();
    super.dispose();
  }
}
