import 'dart:developer';

import 'package:dialup_mobile_app/bloc/multiSelect/multi_select_bloc.dart';
import 'package:dialup_mobile_app/bloc/multiSelect/multi_select_event.dart';
import 'package:dialup_mobile_app/bloc/multiSelect/multi_select_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ApplicationAccountScreen extends StatefulWidget {
  const ApplicationAccountScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationAccountScreen> createState() =>
      _ApplicationAccountScreenState();
}

class _ApplicationAccountScreenState extends State<ApplicationAccountScreen> {
  int progress = 4;
  bool isCurrentSelected = false;
  bool isSavingsSelected = false;

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          Routes.applicationTaxCRS,
          arguments: TaxCrsArgumentModel(
            isUSFATCA: storageIsUSFATCA ?? true,
            ustin: storageUsTin ?? "",
          ).toMap(),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.applicationTaxCRS,
                arguments: TaxCrsArgumentModel(
                  isUSFATCA: storageIsUSFATCA ?? true,
                  ustin: storageUsTin ?? "",
                ).toMap(),
              );
            },
          ),
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
                      labels[261]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    ApplicationProgress(progress: progress),
                    const SizeBox(height: 30),
                    Text(
                      labels[195]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          labels[285]["labelText"],
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 20),
                    BlocBuilder<MultiSelectBloc, MultiSelectState>(
                      builder: buildCurrentButton,
                    ),
                    const SizeBox(height: 15),
                    BlocBuilder<MultiSelectBloc, MultiSelectState>(
                      builder: buildSavingsButton,
                    ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.error_rounded,
                          color: AppColors.dark50,
                          size: (13 / Dimensions.designWidth).w,
                        ),
                        const SizeBox(width: 5),
                        Text(
                          labels[286]["labelText"],
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark50,
                            fontSize: (12 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
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
      ),
    );
  }

  Widget buildCurrentButton(BuildContext context, MultiSelectState state) {
    final MultiSelectBloc multiSelectBloc = context.read<MultiSelectBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return MultiSelectButton(
      isSelected: isCurrentSelected,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labels[7]["labelText"],
            style: TextStyles.primary.copyWith(
              color: AppColors.primaryDark,
              fontSize: (18 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 7),
          Text(
            "For everyday banking transactions.",
            style: TextStyles.primary.copyWith(
              color: const Color.fromRGBO(1, 1, 1, 0.4),
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
        ],
      ),
      onTap: () {
        isCurrentSelected = !isCurrentSelected;
        accountType = isSavingsSelected
            ? isCurrentSelected
                ? 3
                : 1
            : isCurrentSelected
                ? 2
                : 0;
        log("accountType -> $accountType");
        multiSelectBloc.add(MultiSelectEvent(isSelected: isCurrentSelected));
        showButtonBloc
            .add(ShowButtonEvent(show: isCurrentSelected && isSavingsSelected));
      },
    );
  }

  Widget buildSavingsButton(BuildContext context, MultiSelectState state) {
    final MultiSelectBloc multiSelectBloc = context.read<MultiSelectBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return MultiSelectButton(
      isSelected: isSavingsSelected,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labels[92]["labelText"],
            style: TextStyles.primary.copyWith(
              color: AppColors.primaryDark,
              fontSize: (18 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 7),
          Text(
            "An interest-bearing deposit account.",
            style: TextStyles.primary.copyWith(
              color: const Color.fromRGBO(1, 1, 1, 0.4),
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
        ],
      ),
      onTap: () {
        isSavingsSelected = !isSavingsSelected;
        accountType = isCurrentSelected
            ? isSavingsSelected
                ? 3
                : 2
            : isSavingsSelected
                ? 1
                : 0;
        log("accountType -> $accountType");
        multiSelectBloc.add(MultiSelectEvent(isSelected: isSavingsSelected));
        showButtonBloc
            .add(ShowButtonEvent(show: isCurrentSelected && isSavingsSelected));
      },
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isCurrentSelected || isSavingsSelected) {
      return Column(
        children: [
          Text(
            "You will be receiving a free Prepaid Card! Available in the \"Cards\" tab.",
            style: TextStyles.primary.copyWith(
              color: const Color(0XFF252525),
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 10),
          GradientButton(
            onTap: () async {
              final ShowButtonBloc showButtonBloc =
                  context.read<ShowButtonBloc>();
              isUploading = true;
              showButtonBloc.add(ShowButtonEvent(show: isUploading));

              // TODO: Call relevant APIs

              var addressApiResult = await MapRegisterRetailCustomerAddress
                  .mapRegisterRetailCustomerAddress(
                {
                  "addressLine_1": storageAddressLine1,
                  "addressLine_2": storageAddressLine2,
                  "areaId": uaeDetails[emirates.indexOf(storageAddressEmirate!)]
                      ["areas"][0]["area_Id"],
                  "cityId": uaeDetails[emirates.indexOf(storageAddressEmirate!)]
                      ["city_Id"],
                  "stateId": 1,
                  "countryId": 1,
                  "pinCode": storageAddressPoBox
                },
                token ?? "",
              );
              log("RegisterRetailCustomerAddress API Response -> $addressApiResult");

              var incomeApiResult =
                  await MapAddOrUpdateIncomeSource.mapAddOrUpdateIncomeSource(
                {"incomeSource": storageIncomeSource},
                token ?? "",
              );
              log("Income Source API response -> $incomeApiResult");

              var taxApiResult =
                  await MapCustomerTaxInformation.mapCustomerTaxInformation(
                {
                  "isUSFATCA": storageIsUSFATCA,
                  "ustin": storageUsTin,
                  "internationalTaxes": [
                    {
                      "countryCode":
                          dhabiCountryNames.indexOf(storageTaxCountry!) == -1
                              // dhabiCountryNames.contains(-1)
                              ? "US"
                              : dhabiCountries[dhabiCountryNames
                                  .indexOf(storageTaxCountry!)]["shortCode"],
                      "isTIN": storageIsTinYes,
                      "tin": storageCrsTin,
                      "noTINReason": storageNoTinReason
                    }
                  ]
                },
                token ?? "",
              );
              log("Tax Information API response -> $taxApiResult");

              if (addressApiResult["success"] &&
                  incomeApiResult["success"] &&
                  taxApiResult["success"]) {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.retailOnboardingStatus,
                    arguments: OnboardingStatusArgumentModel(
                      stepsCompleted: 3,
                      isFatca: false,
                      isPassport: false,
                      isRetail: true,
                    ).toMap(),
                  );
                }
              }

              await storage.write(
                  key: "accountType", value: accountType.toString());
              storageAccountType =
                  int.parse(await storage.read(key: "accountType") ?? "1");

              isUploading = false;
              showButtonBloc.add(ShowButtonEvent(show: isUploading));

              await storage.write(key: "stepsCompleted", value: 9.toString());
              storageStepsCompleted =
                  int.parse(await storage.read(key: "stepsCompleted") ?? "0");
            },
            text: labels[288]["labelText"],
            auxWidget: isUploading ? const LoaderRow() : const SizeBox(),
          ),
          const SizeBox(height: PaddingConstants.bottomPadding),
        ],
      );
    } else {
      return Column(
        children: [
          SolidButton(onTap: () {}, text: labels[127]["labelText"]),
          const SizeBox(height: PaddingConstants.bottomPadding),
        ],
      );
    }
  }
}
