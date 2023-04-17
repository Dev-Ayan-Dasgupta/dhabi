import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
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
import 'package:flutter_svg/flutter_svg.dart';

class AddRecipientDetailsRemittanceScreen extends StatefulWidget {
  const AddRecipientDetailsRemittanceScreen({Key? key}) : super(key: key);

  @override
  State<AddRecipientDetailsRemittanceScreen> createState() =>
      _AddRecipientDetailsRemittanceScreenState();
}

class _AddRecipientDetailsRemittanceScreenState
    extends State<AddRecipientDetailsRemittanceScreen> {
  bool isChecked = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _bicController = TextEditingController();

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

  String? selectedAccType;
  String? selectedReason;

  int toggles = 0;
  bool isAccountTypeSelected = false;
  bool isReasonSelected = false;

  bool isFirstName = false;
  bool isLastName = false;
  bool isAddress = false;
  bool isIban = false;
  bool isBic = false;

  @override
  Widget build(BuildContext context) {
    final DropdownSelectedBloc accountTypeBloc =
        context.read<DropdownSelectedBloc>();
    final DropdownSelectedBloc reasonTypeBloc =
        context.read<DropdownSelectedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
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
                    Text(
                      "Add Recipient Details",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "First Name",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 7),
                          CustomTextField(
                            hintText: "e.g., Muhammad",
                            controller: _firstNameController,
                            onChanged: (p0) {
                              if (p0.isEmpty) {
                                isFirstName = false;
                              } else {
                                isFirstName = true;
                              }
                              showButtonBloc.add(
                                ShowButtonEvent(
                                  show: isFirstName &&
                                      isLastName &&
                                      isAddress &&
                                      isIban &&
                                      isAccountTypeSelected &&
                                      isBic &&
                                      isReasonSelected,
                                ),
                              );
                            },
                          ),
                          const SizeBox(height: 15),
                          Text(
                            "Last Name",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 7),
                          CustomTextField(
                            hintText: "e.g., Al Mansoori",
                            controller: _lastNameController,
                            onChanged: (p0) {
                              if (p0.isEmpty) {
                                isLastName = false;
                              } else {
                                isLastName = true;
                              }
                              showButtonBloc.add(
                                ShowButtonEvent(
                                  show: isFirstName &&
                                      isLastName &&
                                      isAddress &&
                                      isIban &&
                                      isAccountTypeSelected &&
                                      isBic &&
                                      isReasonSelected,
                                ),
                              );
                            },
                          ),
                          const SizeBox(height: 15),
                          Text(
                            "Address *",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 7),
                          CustomTextField(
                            hintText: "e.g., YAS Island",
                            controller: _addressController,
                            onChanged: (p0) {
                              if (p0.isEmpty) {
                                isAddress = false;
                              } else {
                                isAddress = true;
                              }
                              showButtonBloc.add(
                                ShowButtonEvent(
                                  show: isFirstName &&
                                      isLastName &&
                                      isAddress &&
                                      isIban &&
                                      isAccountTypeSelected &&
                                      isBic &&
                                      isReasonSelected,
                                ),
                              );
                            },
                          ),
                          const SizeBox(height: 15),
                          Text(
                            "IBAN / Account Number",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 7),
                          CustomTextField(
                            hintText: "Enter IBAN / Account Number",
                            keyboardType: TextInputType.number,
                            controller: _ibanController,
                            onChanged: (p0) {
                              if (p0.isEmpty) {
                                isIban = false;
                              } else {
                                isIban = true;
                              }
                              showButtonBloc.add(
                                ShowButtonEvent(
                                  show: isFirstName &&
                                      isLastName &&
                                      isAddress &&
                                      isIban &&
                                      isAccountTypeSelected &&
                                      isBic &&
                                      isReasonSelected,
                                ),
                              );
                            },
                          ),
                          const SizeBox(height: 15),
                          Text(
                            "Account Type",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 7),
                          BlocBuilder<DropdownSelectedBloc,
                              DropdownSelectedState>(
                            builder: (context, state) {
                              return CustomDropDown(
                                title: "e.g., Savings",
                                items: items,
                                value: selectedAccType,
                                onChanged: (value) {
                                  toggles++;
                                  isAccountTypeSelected = true;
                                  selectedAccType = value as String;
                                  accountTypeBloc.add(
                                    DropdownSelectedEvent(
                                      isDropdownSelected: isAccountTypeSelected,
                                      toggles: toggles,
                                    ),
                                  );
                                  showButtonBloc.add(
                                    ShowButtonEvent(
                                      show: isFirstName &&
                                          isLastName &&
                                          isAddress &&
                                          isIban &&
                                          isAccountTypeSelected &&
                                          isBic &&
                                          isReasonSelected,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizeBox(height: 15),
                          Text(
                            "BIC / SWIFT Code",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 7),
                          CustomTextField(
                            hintText: "Enter BIC / SWIFT Code",
                            controller: _bicController,
                            onChanged: (p0) {
                              if (p0.isEmpty) {
                                isBic = false;
                              } else {
                                isBic = true;
                              }
                              showButtonBloc.add(
                                ShowButtonEvent(
                                  show: isFirstName &&
                                      isLastName &&
                                      isAddress &&
                                      isIban &&
                                      isAccountTypeSelected &&
                                      isBic &&
                                      isReasonSelected,
                                ),
                              );
                            },
                          ),
                          const SizeBox(height: 15),
                          Text(
                            "Reason for Sending",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 7),
                          BlocBuilder<DropdownSelectedBloc,
                              DropdownSelectedState>(
                            builder: (context, state) {
                              return CustomDropDown(
                                title: "e.g., Family Support",
                                items: items,
                                value: selectedReason,
                                onChanged: (value) {
                                  toggles++;
                                  isReasonSelected = true;
                                  selectedReason = value as String;
                                  reasonTypeBloc.add(
                                    DropdownSelectedEvent(
                                      isDropdownSelected: isReasonSelected,
                                      toggles: toggles,
                                    ),
                                  );
                                  showButtonBloc.add(
                                    ShowButtonEvent(
                                      show: isFirstName &&
                                          isLastName &&
                                          isAddress &&
                                          isIban &&
                                          isAccountTypeSelected &&
                                          isBic &&
                                          isReasonSelected,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizeBox(height: 20),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: (context, state) {
                  if (isFirstName &&
                      isLastName &&
                      isAddress &&
                      isIban &&
                      isAccountTypeSelected &&
                      isBic &&
                      isReasonSelected) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizeBox(height: 20),
                        Row(
                          children: [
                            BlocBuilder<CheckBoxBloc, CheckBoxState>(
                              builder: (context, state) {
                                if (isChecked) {
                                  return InkWell(
                                    onTap: () {
                                      isChecked = false;
                                      triggerCheckBoxEvent(isChecked);
                                    },
                                    child: SvgPicture.asset(
                                      ImageConstants.checkedBox,
                                      width: (14 / Dimensions.designWidth).w,
                                      height: (14 / Dimensions.designWidth).w,
                                    ),
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      isChecked = true;
                                      triggerCheckBoxEvent(isChecked);
                                    },
                                    child: SvgPicture.asset(
                                      ImageConstants.uncheckedBox,
                                      width: (14 / Dimensions.designWidth).w,
                                      height: (14 / Dimensions.designWidth).w,
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizeBox(width: 10),
                            Text(
                              "Add this person to my recipient list",
                              style: TextStyles.primaryMedium.copyWith(
                                color: const Color(0XFF414141),
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                          ],
                        ),
                        const SizeBox(height: 10),
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
      ),
    );
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _ibanController.dispose();
    _bicController.dispose();
    super.dispose();
  }
}
