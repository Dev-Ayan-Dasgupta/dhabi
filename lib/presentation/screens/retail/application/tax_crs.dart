import 'package:dialup_mobile_app/bloc/applicationCRS/application_crs_bloc.dart';
import 'package:dialup_mobile_app/bloc/applicationCRS/application_crs_event.dart';
import 'package:dialup_mobile_app/bloc/applicationCRS/application_crs_state.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_bloc.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_event.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ApplicationTaxCRSScreen extends StatefulWidget {
  const ApplicationTaxCRSScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationTaxCRSScreen> createState() =>
      _ApplicationTaxCRSScreenState();
}

class _ApplicationTaxCRSScreenState extends State<ApplicationTaxCRSScreen> {
  int progress = 3;
  bool isShowButton = false;

  bool showSelectCountry = false;
  bool showTinPrompt = false;
  bool showTinTextField = false;
  bool showTinDropdown = false;

  bool isCRSreportable = false;
  bool isCRSyes = false;
  bool isCRSno = false;

  int toggles = 0;

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  String? selectedCountry;
  String? selectedReason;

  bool isCountrySelected = false;
  bool isReasonSelected = false;

  bool hasTIN = false;
  bool isTinYes = false;
  bool isTinNo = false;

  bool isTINvalid = false;

  final TextEditingController _tinController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ButtonFocussedBloc crsFocusBloc = context.read<ButtonFocussedBloc>();
    final ButtonFocussedBloc tinFocusBloc = context.read<ButtonFocussedBloc>();

    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizeBox(height: 10),
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
                                  "CRS",
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
                            Text(
                              "Do you hold a CRS reportable account?",
                              style: TextStyles.primary.copyWith(
                                color: const Color(0xFF636363),
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<ButtonFocussedBloc,
                                    ButtonFocussedState>(
                                  builder: (context, state) {
                                    return SolidButton(
                                      width: (185 / Dimensions.designWidth).w,
                                      color: Colors.white,
                                      fontColor: AppColors.primary,
                                      boxShadow: [BoxShadows.primary],
                                      borderColor: isCRSyes
                                          ? const Color.fromRGBO(
                                              0, 184, 148, 0.21)
                                          : Colors.transparent,
                                      onTap: () {
                                        toggles++;
                                        isCRSreportable = true;
                                        isCRSyes = true;
                                        isCRSno = false;
                                        crsFocusBloc.add(
                                          ButtonFocussedEvent(
                                              isFocussed: isCRSyes,
                                              toggles: toggles),
                                        );
                                        showSelectCountry = true;
                                        applicationCrsBloc.add(
                                          ApplicationCrsEvent(
                                            showSelectCountry:
                                                showSelectCountry,
                                            showTinPrompt: showTinPrompt,
                                            showTinTextField: showTinTextField,
                                            showTinDropdown: showTinDropdown,
                                          ),
                                        );
                                        isShowButton = false;
                                        showButtonBloc.add(
                                          ShowButtonEvent(show: isShowButton),
                                        );
                                      },
                                      text: "Yes",
                                    );
                                  },
                                ),
                                BlocBuilder<ButtonFocussedBloc,
                                    ButtonFocussedState>(
                                  builder: (context, state) {
                                    return SolidButton(
                                      width: (185 / Dimensions.designWidth).w,
                                      color: Colors.white,
                                      fontColor: AppColors.primary,
                                      boxShadow: [BoxShadows.primary],
                                      borderColor: isCRSno
                                          ? const Color.fromRGBO(
                                              0, 184, 148, 0.21)
                                          : Colors.transparent,
                                      onTap: () {
                                        toggles++;
                                        isCRSreportable = false;
                                        isCRSyes = false;
                                        isCRSno = true;
                                        crsFocusBloc.add(
                                          ButtonFocussedEvent(
                                            isFocussed: isCRSno,
                                            toggles: toggles,
                                          ),
                                        );
                                        showSelectCountry = false;
                                        showTinPrompt = false;
                                        showTinDropdown = false;
                                        showTinTextField = false;
                                        applicationCrsBloc.add(
                                          ApplicationCrsEvent(
                                              showSelectCountry:
                                                  showSelectCountry,
                                              showTinPrompt: showTinPrompt,
                                              showTinTextField:
                                                  showTinTextField,
                                              showTinDropdown: showTinDropdown),
                                        );
                                        isShowButton = true;
                                        showButtonBloc.add(
                                          ShowButtonEvent(show: isShowButton),
                                        );
                                      },
                                      text: "No",
                                    );
                                  },
                                ),
                              ],
                            ),
                            BlocBuilder<ApplicationCrsBloc,
                                ApplicationCrsState>(
                              builder: (context, state) {
                                if (showSelectCountry) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizeBox(height: 20),
                                      Text(
                                        "Select Country",
                                        style: TextStyles.primary.copyWith(
                                          color: const Color(0xFF636363),
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                      const SizeBox(height: 9),
                                      CustomDropDown(
                                        title: "Country",
                                        items: items,
                                        value: selectedCountry,
                                        onChanged: (value) {
                                          toggles++;
                                          isCountrySelected = true;
                                          selectedCountry = value as String;
                                          isCountrySelected = true;
                                          showTinPrompt = true;
                                          applicationCrsBloc.add(
                                            ApplicationCrsEvent(
                                              showSelectCountry:
                                                  showSelectCountry,
                                              showTinPrompt: showTinPrompt,
                                              showTinTextField:
                                                  showTinTextField,
                                              showTinDropdown: showTinDropdown,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizeBox(height: 20),
                                    ],
                                  );
                                } else {
                                  return const SizeBox();
                                }
                              },
                            ),
                            BlocBuilder<ApplicationCrsBloc,
                                ApplicationCrsState>(
                              builder: (context, state) {
                                if (showTinPrompt) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Do you have a Tax Identification Number?",
                                            style: TextStyles.primary.copyWith(
                                              color: const Color(0XFF636363),
                                              fontSize:
                                                  (16 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                          const SizeBox(width: 10),
                                          HelpSnippet(onTap: () {}),
                                        ],
                                      ),
                                      const SizeBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BlocBuilder<ButtonFocussedBloc,
                                              ButtonFocussedState>(
                                            builder: (context, state) {
                                              return SolidButton(
                                                width: (185 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                color: Colors.white,
                                                fontColor: AppColors.primary,
                                                boxShadow: [BoxShadows.primary],
                                                borderColor: isTinYes
                                                    ? const Color.fromRGBO(
                                                        0, 184, 148, 0.21)
                                                    : Colors.transparent,
                                                onTap: () {
                                                  isCRSreportable = true;
                                                  isTinYes = true;
                                                  isTinNo = false;
                                                  tinFocusBloc.add(
                                                    ButtonFocussedEvent(
                                                      isFocussed: isTinYes,
                                                      toggles: toggles,
                                                    ),
                                                  );
                                                  showTinTextField = true;
                                                  showTinDropdown = false;
                                                  applicationCrsBloc.add(
                                                    ApplicationCrsEvent(
                                                      showSelectCountry:
                                                          showSelectCountry,
                                                      showTinPrompt:
                                                          showTinPrompt,
                                                      showTinTextField:
                                                          showTinTextField,
                                                      showTinDropdown:
                                                          showTinDropdown,
                                                    ),
                                                  );
                                                  if (selectedReason == null) {
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
                                                width: (185 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                color: Colors.white,
                                                fontColor: AppColors.primary,
                                                boxShadow: [BoxShadows.primary],
                                                borderColor: isTinNo
                                                    ? const Color.fromRGBO(
                                                        0, 184, 148, 0.21)
                                                    : Colors.transparent,
                                                onTap: () {
                                                  isCRSreportable = false;
                                                  isTinYes = false;
                                                  isTinNo = true;
                                                  tinFocusBloc.add(
                                                    ButtonFocussedEvent(
                                                      isFocussed: isTinNo,
                                                      toggles: toggles,
                                                    ),
                                                  );
                                                  showTinTextField = false;
                                                  showTinDropdown = true;
                                                  applicationCrsBloc.add(
                                                    ApplicationCrsEvent(
                                                      showSelectCountry:
                                                          showSelectCountry,
                                                      showTinPrompt:
                                                          showTinPrompt,
                                                      showTinTextField:
                                                          showTinTextField,
                                                      showTinDropdown:
                                                          showTinDropdown,
                                                    ),
                                                  );
                                                  if (selectedReason == null) {
                                                    isShowButton = false;
                                                    showButtonBloc.add(
                                                      ShowButtonEvent(
                                                          show: isShowButton),
                                                    );
                                                  }
                                                },
                                                text: "No",
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizeBox();
                                }
                              },
                            ),
                            BlocBuilder<ApplicationCrsBloc,
                                ApplicationCrsState>(
                              builder: (context, state) {
                                if (showTinTextField) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizeBox(height: 20),
                                      Text(
                                        "TIN",
                                        style: TextStyles.primary.copyWith(
                                          color: const Color(0xFF636363),
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                      const SizeBox(height: 10),
                                      CustomTextField(
                                        controller: _tinController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (p0) {
                                          if (_tinController.text.isNotEmpty) {
                                            isTINvalid = true;
                                            isShowButton = true;
                                            showButtonBloc.add(
                                              ShowButtonEvent(
                                                  show: isShowButton),
                                            );
                                          } else {
                                            isTINvalid = false;
                                            isShowButton = false;
                                            showButtonBloc.add(
                                              ShowButtonEvent(
                                                  show: isShowButton),
                                            );
                                          }
                                        },
                                        hintText: "000000000",
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizeBox();
                                }
                              },
                            ),
                            BlocBuilder<ApplicationCrsBloc,
                                ApplicationCrsState>(
                              builder: (context, state) {
                                if (showTinDropdown) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizeBox(height: 20),
                                      Text(
                                        "Select a reason",
                                        style: TextStyles.primary.copyWith(
                                          color: const Color(0xFF636363),
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                      const SizeBox(height: 9),
                                      CustomDropDown(
                                        title: "Reason",
                                        items: items,
                                        value: selectedReason,
                                        onChanged: (value) {
                                          toggles++;
                                          isCountrySelected = true;
                                          selectedReason = value as String;
                                          applicationCrsBloc.add(
                                            ApplicationCrsEvent(
                                              showSelectCountry:
                                                  showSelectCountry,
                                              showTinPrompt: showTinPrompt,
                                              showTinTextField:
                                                  showTinTextField,
                                              showTinDropdown: showTinDropdown,
                                            ),
                                          );
                                          isShowButton = true;
                                          showButtonBloc.add(
                                            ShowButtonEvent(show: isShowButton),
                                          );
                                        },
                                      ),
                                      const SizeBox(height: 5),
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
                        SolidButton(
                          onTap: () {},
                          text: "Add more tax countries",
                          color: Colors.white,
                          boxShadow: [BoxShadows.primary],
                          fontColor: AppColors.primary,
                        ),
                        const SizeBox(height: 20),
                        GradientButton(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.applicationAccount);
                          },
                          text: "Continue",
                        ),
                        const SizeBox(height: 20),
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
    );
  }

  @override
  void dispose() {
    _tinController.dispose();
    super.dispose();
  }
}
