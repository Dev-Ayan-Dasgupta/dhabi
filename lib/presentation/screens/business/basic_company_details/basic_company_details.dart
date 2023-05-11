import 'dart:developer';

import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/corporateOnboarding/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class BasicCompanyDetailsScreen extends StatefulWidget {
  const BasicCompanyDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BasicCompanyDetailsScreen> createState() =>
      _BasicCompanyDetailsScreenState();
}

class _BasicCompanyDetailsScreenState extends State<BasicCompanyDetailsScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _tradeLicenseController = TextEditingController();

  int toggles = 0;

  String? selectedCountry;
  int dhabiCountryIndex = -1;

  bool isCompany = false;
  bool isCountrySelected = false;
  bool isTradeLicense = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final DropdownSelectedBloc countrySelectedBloc =
        context.read<DropdownSelectedBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Basic Company Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    labels[295]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Company Name",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.black63,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 7),
                  CustomTextField(
                    controller: _companyNameController,
                    onChanged: (p0) {
                      if (p0.isEmpty) {
                        isCompany = false;
                      } else {
                        isCompany = true;
                      }
                      showButtonBloc.add(
                        ShowButtonEvent(
                          show:
                              isCompany && isCountrySelected && isTradeLicense,
                        ),
                      );
                    },
                  ),
                  const SizeBox(height: 10),
                  Row(
                    children: [
                      Text(
                        labels[297]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.black63,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 7),
                  BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    builder: (context, state) {
                      return CustomDropDown(
                        title: "Select a Country",
                        items: dhabiCountryNames,
                        value: selectedCountry,
                        onChanged: (value) {
                          toggles++;
                          isCountrySelected = true;
                          selectedCountry = value as String;
                          dhabiCountryIndex =
                              dhabiCountryNames.indexOf(selectedCountry!);
                          log("dhabiCountryIndex -> $dhabiCountryIndex");
                          countrySelectedBloc.add(
                            DropdownSelectedEvent(
                              isDropdownSelected: isCountrySelected,
                              toggles: toggles,
                            ),
                          );
                          showButtonBloc.add(
                            ShowButtonEvent(
                              show: isCompany &&
                                  isCountrySelected &&
                                  isTradeLicense,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizeBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Trade License Number",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.black63,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 7),
                  CustomTextField(
                    controller: _tradeLicenseController,
                    // keyboardType: TextInputType.number,
                    onChanged: (p0) {
                      if (p0.isEmpty) {
                        isTradeLicense = false;
                      } else {
                        isTradeLicense = true;
                      }
                      showButtonBloc.add(
                        ShowButtonEvent(
                          show:
                              isCompany && isCountrySelected && isTradeLicense,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                if (isCompany && isCountrySelected && isTradeLicense) {
                  return Column(
                    children: [
                      GradientButton(
                        onTap: () async {
                          final ShowButtonBloc showButtonBloc =
                              context.read<ShowButtonBloc>();
                          isLoading = true;
                          showButtonBloc.add(ShowButtonEvent(show: isLoading));

                          var tLResult = await MapIfTradeLicenseExists
                              .mapIfTradeLicenseExists(
                            {
                              "tradeLicenseNumber":
                                  _tradeLicenseController.text,
                              "countryOfRegistrationShortCode":
                                  dhabiCountryIndex == -1
                                      ? "US"
                                      : dhabiCountries[dhabiCountryIndex]
                                          ["shortCode"],
                            },
                            token,
                          );
                          log("Trade License API resonse -> $tLResult");
                          if (tLResult) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    svgAssetPath: ImageConstants.warning,
                                    title: "Trade license exists",
                                    message:
                                        "The given trade license number already exist in your database",
                                    auxWidget: Column(
                                      children: [
                                        SolidButton(
                                          onTap: () {},
                                          text: "Close",
                                          color: AppColors.primaryBright17,
                                          fontColor: AppColors.primary,
                                        ),
                                        const SizeBox(height: 15),
                                      ],
                                    ),
                                    actionWidget: Column(
                                      children: [
                                        GradientButton(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              Routes.loginUserId,
                                            );
                                          },
                                          text: "Try Log In",
                                        ),
                                        const SizeBox(
                                          height:
                                              PaddingConstants.bottomPadding,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          } else {
                            var regResult = await MapRegister.mapRegister(
                              {
                                "companyName": _companyNameController.text,
                                "tradeLicenseNumber":
                                    _tradeLicenseController.text,
                                "countryOfRegistrationShortCode":
                                    dhabiCountryIndex == -1
                                        ? "US"
                                        : dhabiCountries[dhabiCountryIndex]
                                            ["shortCode"],
                              },
                              token,
                            );
                            log("regResult -> $regResult");
                            if (context.mounted) {
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
                            }
                          }
                        },
                        text: labels[31]["labelText"],
                        auxWidget:
                            isLoading ? const LoaderRow() : const SizeBox(),
                      ),
                      SizeBox(
                        height: PaddingConstants.bottomPadding +
                            MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SolidButton(
                        onTap: () {},
                        text: labels[31]["labelText"],
                      ),
                      SizeBox(
                        height: PaddingConstants.bottomPadding +
                            MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  );
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
    _companyNameController.dispose();
    _tradeLicenseController.dispose();
    super.dispose();
  }
}
