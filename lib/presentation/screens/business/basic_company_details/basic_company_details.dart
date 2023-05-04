import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
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

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8'
  ];

  String? selectedCountry;

  bool isCompany = false;
  bool isCountrySelected = false;
  bool isTradeLicense = false;

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
                    "Please provide your basic company details to proceed with the onboarding",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Company Name",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.black63,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
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
                  Text(
                    labels[297]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.black63,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 7),
                  BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    builder: (context, state) {
                      return CustomDropDown(
                        title: "Select a Country",
                        items: items,
                        value: selectedCountry,
                        onChanged: (value) {
                          toggles++;
                          isCountrySelected = true;
                          selectedCountry = value as String;
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
                  Text(
                    "Trade License Number",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.black63,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 7),
                  CustomTextField(
                    controller: _tradeLicenseController,
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
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.verifyMobile,
                            arguments:
                                VerifyMobileArgumentModel(isBusiness: true)
                                    .toMap(),
                          );
                        },
                        text: labels[31]["labelText"],
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
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _tradeLicenseController.dispose();
    super.dispose();
  }
}
