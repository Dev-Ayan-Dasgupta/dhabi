import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ApplicationAddressScreen extends StatefulWidget {
  const ApplicationAddressScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationAddressScreen> createState() =>
      _ApplicationAddressScreenState();
}

class _ApplicationAddressScreenState extends State<ApplicationAddressScreen> {
  int progress = 1;

  final TextEditingController _countryController =
      TextEditingController(text: "United Arab Emirates");
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  bool isResidenceYearSelected = false;
  bool isAddress1Entered = false;
  bool isCityEntered = false;
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

  String? selectedValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DropdownSelectedBloc residenceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(
          onTap: () {
            residenceSelectedBloc.add(DropdownSelectedEvent(
                isDropdownSelected: false, toggles: toggles));
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
        ),
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
            Text(
              "Address Details",
              style: TextStyles.primary.copyWith(
                color: AppColors.primary,
                fontSize: (24 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Country",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.black63,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _countryController,
                      onChanged: (p0) {},
                      enabled: false,
                      color: const Color(0xFFF9F9F9),
                      fontColor: const Color(0xFFAAAAAA),
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Address Line 1 *",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.black63,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _address1Controller,
                      onChanged: (p0) {
                        if (_address1Controller.text.isEmpty) {
                          isAddress1Entered = false;
                        } else {
                          isAddress1Entered = true;
                        }
                        residenceSelectedBloc.add(
                          DropdownSelectedEvent(
                            isDropdownSelected: isResidenceYearSelected &&
                                (isAddress1Entered && isCityEntered),
                            toggles: toggles,
                          ),
                        );
                      },
                      hintText: "Address",
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Address Line 2",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.black63,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _address2Controller,
                      onChanged: (p0) {},
                      hintText: "Address",
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "City *",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.black63,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _cityController,
                      onChanged: (p0) {
                        if (_cityController.text.isEmpty) {
                          isCityEntered = false;
                        } else {
                          isCityEntered = true;
                        }
                        residenceSelectedBloc.add(
                          DropdownSelectedEvent(
                            isDropdownSelected: isResidenceYearSelected &&
                                (isAddress1Entered && isCityEntered),
                            toggles: toggles,
                          ),
                        );
                      },
                      hintText: "City",
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "State",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.black63,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _stateController,
                      onChanged: (p0) {},
                      hintText: "State",
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Zip/Postal Code",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.black63,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _zipController,
                      keyboardType: TextInputType.number,
                      onChanged: (p0) {},
                      hintText: "0000",
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Resident Since *",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.black63,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                      builder: (context, state) {
                        return CustomDropDown(
                          title: "Year",
                          items: items,
                          value: selectedValue,
                          onChanged: (value) {
                            toggles++;
                            isResidenceYearSelected = true;
                            selectedValue = value as String;
                            residenceSelectedBloc.add(
                              DropdownSelectedEvent(
                                isDropdownSelected: isResidenceYearSelected &&
                                    (isAddress1Entered && isCityEntered),
                                toggles: toggles,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizeBox(height: 30),
                  ],
                ),
              ),
            ),
            const SizeBox(height: 20),
            BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
              builder: (context, state) {
                if (state.isDropdownSelected) {
                  return Column(
                    children: [
                      GradientButton(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.applicationIncome);
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
    );
  }

  @override
  void dispose() {
    _countryController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }
}
