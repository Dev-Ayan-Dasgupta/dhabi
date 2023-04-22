import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class UpdateAddressScreen extends StatefulWidget {
  const UpdateAddressScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final TextEditingController _countryController =
      TextEditingController(text: "United Arab Emirates");
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _poBoxController = TextEditingController();

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

  String? selectedValue;

  bool isShowButton = true;
  bool isEmirateSelected = true;

  int toggles = 0;

  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final DropdownSelectedBloc dropdownSelectedBloc =
        context.read<DropdownSelectedBloc>();
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
                    "Update Address",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Address Details",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Country",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.black63,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 10),
                            CustomTextField(
                              enabled: false,
                              color: const Color(0xFFEEEEEE),
                              fontColor: const Color.fromRGBO(34, 34, 34, 0.5),
                              controller: _countryController,
                              onChanged: (p0) {},
                            ),
                            const SizeBox(height: 20),
                            Text(
                              "Address line 1*",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.black63,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 10),
                            CustomTextField(
                              hintText: "Address",
                              controller: _address1Controller,
                              onChanged: (p0) {
                                if (p0.isEmpty) {
                                  isShowButton = false;
                                  showButtonBloc.add(
                                    ShowButtonEvent(show: isShowButton),
                                  );
                                } else {
                                  isShowButton = true;
                                  showButtonBloc.add(
                                    ShowButtonEvent(show: isShowButton),
                                  );
                                }
                              },
                            ),
                            const SizeBox(height: 20),
                            Text(
                              "Address line 2",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.black63,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 10),
                            CustomTextField(
                              hintText: "Address",
                              controller: _address2Controller,
                              onChanged: (p0) {},
                            ),
                            const SizeBox(height: 20),
                            Text(
                              "Emirates",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.black63,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 10),
                            BlocBuilder<DropdownSelectedBloc,
                                DropdownSelectedState>(
                              builder: (context, state) {
                                return CustomDropDown(
                                  title: "Select from the list",
                                  items: items,
                                  value: selectedValue,
                                  onChanged: (value) {
                                    toggles++;
                                    isEmirateSelected = true;
                                    selectedValue = value as String;
                                    dropdownSelectedBloc.add(
                                      DropdownSelectedEvent(
                                        isDropdownSelected: isEmirateSelected,
                                        toggles: toggles,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizeBox(height: 20),
                            Text(
                              "P.O. Box",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.black63,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 10),
                            CustomTextField(
                              hintText: "0000",
                              controller: _address2Controller,
                              onChanged: (p0) {},
                            ),
                            const SizeBox(height: 20),
                          ],
                        ),
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
                      GradientButton(
                        onTap: () {},
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
    _poBoxController.dispose();
    super.dispose();
  }
}
