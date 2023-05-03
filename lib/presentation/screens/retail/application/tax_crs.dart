// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/arguments/tax_crs.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

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

class ApplicationTaxCRSScreen extends StatefulWidget {
  const ApplicationTaxCRSScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

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

  String? selectedCountry;
  int dhabiCountryIndex = -1;

  String? selectedReason;

  bool isCountrySelected = false;
  bool isReasonSelected = false;

  bool hasTIN = false;
  bool isTinYes = false;
  bool isTinNo = false;

  bool isTINvalid = false;

  final TextEditingController _tinController = TextEditingController();

  bool isUploading = false;

  late TaxCrsArgumentModel taxCrsArgument;

  @override
  void initState() {
    super.initState();
    initializeArgument();
  }

  void initializeArgument() {
    taxCrsArgument =
        TaxCrsArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
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
                    labels[261]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  ApplicationProgress(progress: progress),
                  const SizeBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  labels[277]["labelText"],
                                  style: TextStyles.primaryBold.copyWith(
                                    color: AppColors.primary,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizeBox(height: 20),
                          Text(
                            labels[278]["labelText"],
                            style: TextStyles.primary.copyWith(
                              color: AppColors.black63,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocBuilder<ButtonFocussedBloc,
                                  ButtonFocussedState>(
                                builder: buildResidentYes,
                              ),
                              BlocBuilder<ButtonFocussedBloc,
                                  ButtonFocussedState>(
                                builder: buildResidentNo,
                              ),
                            ],
                          ),
                          BlocBuilder<ApplicationCrsBloc, ApplicationCrsState>(
                            builder: buildCountryDropdown,
                          ),
                          BlocBuilder<ApplicationCrsBloc, ApplicationCrsState>(
                            builder: buildTINSection,
                          ),
                          BlocBuilder<ApplicationCrsBloc, ApplicationCrsState>(
                            builder: buildTINTextField,
                          ),
                          BlocBuilder<ApplicationCrsBloc, ApplicationCrsState>(
                            builder: buildNoTINReasonDropdown,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: buildSubmitButton,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResidentYes(BuildContext context, ButtonFocussedState state) {
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    final ButtonFocussedBloc crsFocusBloc = context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return SolidButton(
      width: (185 / Dimensions.designWidth).w,
      color: Colors.white,
      fontColor: AppColors.primary,
      boxShadow: [BoxShadows.primary],
      borderColor: isCRSyes
          ? const Color.fromRGBO(0, 184, 148, 0.21)
          : Colors.transparent,
      onTap: () {
        toggles++;
        isCRSreportable = true;
        isCRSyes = true;
        isCRSno = false;
        crsFocusBloc.add(
          ButtonFocussedEvent(isFocussed: isCRSyes, toggles: toggles),
        );
        showSelectCountry = true;
        applicationCrsBloc.add(
          ApplicationCrsEvent(
            showSelectCountry: showSelectCountry,
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
  }

  Widget buildResidentNo(BuildContext context, ButtonFocussedState state) {
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    final ButtonFocussedBloc crsFocusBloc = context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return SolidButton(
      width: (185 / Dimensions.designWidth).w,
      color: Colors.white,
      fontColor: AppColors.primary,
      boxShadow: [BoxShadows.primary],
      borderColor: isCRSno
          ? const Color.fromRGBO(0, 184, 148, 0.21)
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
              showSelectCountry: showSelectCountry,
              showTinPrompt: showTinPrompt,
              showTinTextField: showTinTextField,
              showTinDropdown: showTinDropdown),
        );
        isShowButton = true;
        showButtonBloc.add(
          ShowButtonEvent(show: isShowButton),
        );
      },
      text: "No",
    );
  }

  Widget buildCountryDropdown(BuildContext context, ApplicationCrsState state) {
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    if (showSelectCountry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 20),
          Text(
            "Select Country",
            style: TextStyles.primary.copyWith(
              color: AppColors.black63,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 10),
          CustomDropDown(
            title: labels[264]["labelText"],
            items: dhabiCountryNames,
            value: selectedCountry,
            onChanged: (value) {
              toggles++;
              isCountrySelected = true;
              selectedCountry = value as String;
              dhabiCountryIndex = dhabiCountryNames.indexOf(selectedCountry!);
              log("dhabiCountryIndex -> $dhabiCountryIndex");
              isCountrySelected = true;
              showTinPrompt = true;
              applicationCrsBloc.add(
                ApplicationCrsEvent(
                  showSelectCountry: showSelectCountry,
                  showTinPrompt: showTinPrompt,
                  showTinTextField: showTinTextField,
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
  }

  Widget buildTINSection(BuildContext context, ApplicationCrsState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ButtonFocussedBloc tinFocusBloc = context.read<ButtonFocussedBloc>();
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    if (showTinPrompt) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                labels[281]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.black63,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(width: 10),
              HelpSnippet(onTap: () {}),
            ],
          ),
          const SizeBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinYes
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
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
                          showSelectCountry: showSelectCountry,
                          showTinPrompt: showTinPrompt,
                          showTinTextField: showTinTextField,
                          showTinDropdown: showTinDropdown,
                        ),
                      );
                      if (selectedReason == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinNo
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
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
                          showSelectCountry: showSelectCountry,
                          showTinPrompt: showTinPrompt,
                          showTinTextField: showTinTextField,
                          showTinDropdown: showTinDropdown,
                        ),
                      );
                      if (selectedReason == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
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
  }

  Widget buildTINTextField(BuildContext context, ApplicationCrsState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showTinTextField) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 20),
          Text(
            "TIN",
            style: TextStyles.primary.copyWith(
              color: AppColors.black63,
              fontSize: (16 / Dimensions.designWidth).w,
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
                  ShowButtonEvent(show: isShowButton),
                );
              } else {
                isTINvalid = false;
                isShowButton = false;
                showButtonBloc.add(
                  ShowButtonEvent(show: isShowButton),
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
  }

  Widget buildNoTINReasonDropdown(
      BuildContext context, ApplicationCrsState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    if (showTinDropdown) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 20),
          Text(
            labels[282]["labelText"],
            style: TextStyles.primary.copyWith(
              color: AppColors.black63,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 9),
          CustomDropDown(
            title: "Reason",
            items: noTinReasonDDs,
            value: selectedReason,
            onChanged: (value) {
              toggles++;
              isCountrySelected = true;
              selectedReason = value as String;
              applicationCrsBloc.add(
                ApplicationCrsEvent(
                  showSelectCountry: showSelectCountry,
                  showTinPrompt: showTinPrompt,
                  showTinTextField: showTinTextField,
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
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isShowButton) {
      return Column(
        children: [
          const SizeBox(height: 20),
          SolidButton(
            onTap: () {},
            text: labels[284]["labelText"],
            color: Colors.white,
            boxShadow: [BoxShadows.primary],
            fontColor: AppColors.primary,
          ),
          const SizeBox(height: 20),
          GradientButton(
            onTap: () async {
              final ShowButtonBloc showButtonBloc =
                  context.read<ShowButtonBloc>();
              isUploading = true;
              showButtonBloc.add(ShowButtonEvent(show: isUploading));
              // log("countryCode -> ${dhabiCountries[dhabiCountryIndex]["shortCode"]}");
              log("noTINReason -> ${selectedReason ?? ""}");
              var result =
                  await MapCustomerTaxInformation.mapCustomerTaxInformation(
                {
                  "isUSFATCA": taxCrsArgument.isUSFATCA,
                  "ustin": taxCrsArgument.ustin,
                  "internationalTaxes": [
                    {
                      "countryCode": dhabiCountryIndex == -1
                          ? "US"
                          : dhabiCountries[dhabiCountryIndex]["shortCode"],
                      "isTIN": isTinYes,
                      "tin": _tinController.text,
                      "noTINReason": selectedReason ?? ""
                    }
                  ]
                },
                token,
              );
              log("Tax Information API response -> $result");
              if (context.mounted) {
                Navigator.pushNamed(context, Routes.applicationAccount);
              }
            },
            text: labels[127]["labelText"],
            auxWidget: isUploading ? const LoaderRow() : const SizeBox(),
          ),
          const SizeBox(height: 20),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  @override
  void dispose() {
    _tinController.dispose();
    super.dispose();
  }
}
