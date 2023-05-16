import 'dart:developer';

import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ApplicationIncomeScreen extends StatefulWidget {
  const ApplicationIncomeScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationIncomeScreen> createState() =>
      _ApplicationIncomeScreenState();
}

class _ApplicationIncomeScreenState extends State<ApplicationIncomeScreen> {
  int progress = 2;

  bool isIncomeSourceSelected = false;
  int toggles = 0;

  String? selectedValue;

  bool isUploading = false;

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
                    labels[270]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    labels[271]["labelText"],
                    style: TextStyles.primary.copyWith(
                      color: AppColors.dark80,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 9),
                  BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    builder: buildDropdown,
                  ),
                ],
              ),
            ),
            BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
              builder: buildSubmitButton,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc incomeSourceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return CustomDropDown(
      title: "Select",
      items: sourceOfIncomeDDs,
      value: selectedValue,
      onChanged: (value) {
        toggles++;
        isIncomeSourceSelected = true;
        selectedValue = value as String;
        incomeSourceSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isIncomeSourceSelected,
            toggles: toggles,
          ),
        );
      },
    );
  }

  Widget buildSubmitButton(BuildContext context, DropdownSelectedState state) {
    if (isIncomeSourceSelected) {
      return Column(
        children: [
          GradientButton(
            onTap: () async {
              final DropdownSelectedBloc showButtonBloc =
                  context.read<DropdownSelectedBloc>();
              isUploading = true;
              showButtonBloc.add(DropdownSelectedEvent(
                  isDropdownSelected: isUploading, toggles: toggles));
              await storage.write(key: "incomeSource", value: selectedValue);
              storageIncomeSource = await storage.read(key: "incomeSource");
              var result =
                  await MapAddOrUpdateIncomeSource.mapAddOrUpdateIncomeSource(
                {"incomeSource": selectedValue},
                token ?? "",
              );
              log("Income Source API response -> $result");
              if (context.mounted) {
                Navigator.pushNamed(context, Routes.applicationTaxFATCA);
              }
              isUploading = false;
              showButtonBloc.add(DropdownSelectedEvent(
                  isDropdownSelected: isUploading, toggles: toggles));

              await storage.write(key: "stepsCompleted", value: 6.toString());
              storageStepsCompleted =
                  int.parse(await storage.read(key: "stepsCompleted") ?? "0");
            },
            text: labels[127]["labelText"],
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
