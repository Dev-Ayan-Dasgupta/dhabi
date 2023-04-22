// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/applicationTax/application_tax_bloc.dart';
import 'package:dialup_mobile_app/bloc/applicationTax/application_tax_event.dart';
import 'package:dialup_mobile_app/bloc/applicationTax/application_tax_state.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_bloc.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_event.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class ApplicationTaxFATCAScreen extends StatefulWidget {
  const ApplicationTaxFATCAScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationTaxFATCAScreen> createState() =>
      _ApplicationTaxFATCAScreenState();
}

class _ApplicationTaxFATCAScreenState extends State<ApplicationTaxFATCAScreen> {
  int progress = 3;
  bool isUSCitizen = false;
  bool isUSResident = false;
  bool isPPonly = true;
  bool isEmirateID = false;
  bool isTINvalid = false;
  bool isCRS = false;
  bool hasTIN = false;
  bool isShowButton = false;

  bool usResidentYes = false;
  bool usResidentNo = false;

  int toggles = 0;

  final TextEditingController _tinssnController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationTaxBloc applicationTaxBloc =
        context.read<ApplicationTaxBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Application Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  ApplicationProgress(progress: progress),
                  const SizeBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "FATCA",
                                style: TextStyles.primary.copyWith(
                                  color: AppColors.primary,
                                  fontSize: (24 / Dimensions.designWidth).w,
                                ),
                              ),
                              const SizeBox(width: 10),
                              HelpSnippet(onTap: () {}),
                            ],
                          ),
                          const SizeBox(height: 30),
                          BlocBuilder<ApplicationTaxBloc, ApplicationTaxState>(
                            builder: (context, state) {
                              if (isUSCitizen) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "You are a U.S. Citizen",
                                      style: TextStyles.primary.copyWith(
                                        color: AppColors.black63,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Press ',
                                        style: TextStyles.primary.copyWith(
                                          color: AppColors.black63,
                                          fontSize:
                                              (15 / Dimensions.designWidth).w,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Yes',
                                            style:
                                                TextStyles.primaryBold.copyWith(
                                              color: AppColors.black63,
                                              fontSize:
                                                  (15 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' if:',
                                            style: TextStyles.primary.copyWith(
                                              color: AppColors.black63,
                                              fontSize:
                                                  (15 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizeBox(height: 10),
                                    Text(
                                      "You are a U.S. Citizen or Resident?",
                                      style: TextStyles.primary.copyWith(
                                        color: AppColors.black63,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          BlocBuilder<ApplicationTaxBloc, ApplicationTaxState>(
                            builder: (context, state) {
                              if (isUSCitizen) {
                                return const SizeBox(height: 20);
                              } else {
                                return const SizeBox(height: 30);
                              }
                            },
                          ),
                          BlocBuilder<ApplicationTaxBloc, ApplicationTaxState>(
                            builder: (context, state) {
                              if (isUSCitizen) {
                                return const SizeBox();
                              } else {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BlocBuilder<ButtonFocussedBloc,
                                            ButtonFocussedState>(
                                          builder: (context, state) {
                                            return SolidButton(
                                              width:
                                                  (185 / Dimensions.designWidth)
                                                      .w,
                                              color: Colors.white,
                                              fontColor: AppColors.primary,
                                              boxShadow: [BoxShadows.primary],
                                              borderColor: usResidentYes
                                                  ? const Color.fromRGBO(
                                                      0, 184, 148, 0.21)
                                                  : Colors.transparent,
                                              onTap: () {
                                                isUSResident = true;
                                                applicationTaxBloc.add(
                                                  ApplicationTaxEvent(
                                                    isUSCitizen: isUSCitizen,
                                                    isUSResident: isUSResident,
                                                    isPPonly: isPPonly,
                                                    isTINvalid: isTINvalid,
                                                    isCRS: isCRS,
                                                    hasTIN: hasTIN,
                                                  ),
                                                );
                                                usResidentYes = true;
                                                usResidentNo = false;
                                                buttonFocussedBloc.add(
                                                  ButtonFocussedEvent(
                                                    isFocussed: usResidentNo,
                                                    toggles: ++toggles,
                                                  ),
                                                );
                                                if (!isTINvalid) {
                                                  isShowButton = false;
                                                  showButtonBloc.add(
                                                    ShowButtonEvent(
                                                        show: isShowButton),
                                                  );
                                                }
                                              },
                                              text: "Yes",
                                            );
                                          },
                                        ),
                                        BlocBuilder<ButtonFocussedBloc,
                                            ButtonFocussedState>(
                                          builder: (context, state) {
                                            return SolidButton(
                                              width:
                                                  (185 / Dimensions.designWidth)
                                                      .w,
                                              color: Colors.white,
                                              fontColor: AppColors.primary,
                                              boxShadow: [BoxShadows.primary],
                                              borderColor: usResidentNo
                                                  ? const Color.fromRGBO(
                                                      0, 184, 148, 0.21)
                                                  : Colors.transparent,
                                              onTap: () {
                                                isUSResident = false;
                                                applicationTaxBloc.add(
                                                  ApplicationTaxEvent(
                                                    isUSCitizen: isUSCitizen,
                                                    isUSResident: isUSResident,
                                                    isPPonly: isPPonly,
                                                    isTINvalid: isTINvalid,
                                                    isCRS: isCRS,
                                                    hasTIN: hasTIN,
                                                  ),
                                                );
                                                usResidentYes = false;
                                                usResidentNo = true;
                                                buttonFocussedBloc.add(
                                                  ButtonFocussedEvent(
                                                    isFocussed: usResidentNo,
                                                    toggles: ++toggles,
                                                  ),
                                                );
                                                isShowButton = true;
                                                showButtonBloc.add(
                                                  ShowButtonEvent(
                                                      show: isShowButton),
                                                );
                                              },
                                              text: "No",
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          BlocBuilder<ApplicationTaxBloc, ApplicationTaxState>(
                            builder: (context, state) {
                              if (isUSCitizen) {
                                return const SizeBox(height: 0);
                              } else {
                                return const SizeBox(height: 30);
                              }
                            },
                          ),
                          BlocBuilder<ApplicationTaxBloc, ApplicationTaxState>(
                            builder: (context, state) {
                              if (isUSCitizen || isUSResident) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "US TIN or SSN Number",
                                      style: TextStyles.primary.copyWith(
                                        color: AppColors.black63,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    const SizeBox(height: 10),
                                    CustomTextField(
                                      controller: _tinssnController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (p0) {
                                        if (_tinssnController.text.length ==
                                            9) {
                                          isTINvalid = true;
                                          applicationTaxBloc.add(
                                            ApplicationTaxEvent(
                                                isUSCitizen: isUSCitizen,
                                                isUSResident: isUSResident,
                                                isPPonly: isPPonly,
                                                isTINvalid: isTINvalid,
                                                isCRS: isCRS,
                                                hasTIN: hasTIN),
                                          );
                                          isShowButton = true;
                                          showButtonBloc.add(ShowButtonEvent(
                                              show: isShowButton));
                                        } else {
                                          isTINvalid = false;
                                          applicationTaxBloc.add(
                                            ApplicationTaxEvent(
                                                isUSCitizen: isUSCitizen,
                                                isUSResident: isUSResident,
                                                isPPonly: isPPonly,
                                                isTINvalid: isTINvalid,
                                                isCRS: isCRS,
                                                hasTIN: hasTIN),
                                          );
                                          isShowButton = false;
                                          showButtonBloc.add(ShowButtonEvent(
                                              show: isShowButton));
                                        }
                                      },
                                      hintText: "000000000",
                                    ),
                                    const SizeBox(height: 5),
                                    isTINvalid
                                        ? const SizeBox()
                                        : Text(
                                            "Must be 9 digits",
                                            style: TextStyles.primary.copyWith(
                                              color: AppColors.red,
                                              fontSize:
                                                  (16 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                  ],
                                );
                              } else {
                                return const SizeBox();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                if (isShowButton) {
                  return Column(
                    children: [
                      const SizeBox(height: 20),
                      GradientButton(
                        onTap: () {
                          if (isEmirateID || isUSCitizen) {
                            Navigator.pushNamed(
                                context, Routes.applicationAccount);
                          } else {
                            Navigator.pushNamed(
                                context, Routes.applicationTaxCRS);
                          }
                        },
                        text: "Continue",
                      ),
                      const SizeBox(height: 32),
                    ],
                  );
                } else {
                  return const SizeBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tinssnController.dispose();
    super.dispose();
  }
}
