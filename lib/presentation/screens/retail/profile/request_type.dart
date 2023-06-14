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

class RequestTypeScreen extends StatefulWidget {
  const RequestTypeScreen({Key? key}) : super(key: key);

  @override
  State<RequestTypeScreen> createState() => _RequestTypeScreenState();
}

class _RequestTypeScreenState extends State<RequestTypeScreen> {
  final TextEditingController _remarkController = TextEditingController();

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

  int toggles = 0;
  bool isRequestTypeSelected = false;
  bool isRemarkValid = false;
  bool isNumberSelected = false;

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
                    labels[56]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        labels[56]["labelText"],
                        style: TextStyles.primary.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    builder: buildDropdownRequestType,
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Loan Number",
                        style: TextStyles.primary.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    builder: buildDropdownNumber,
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        labels[58]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildRemarks,
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

  Widget buildDropdownRequestType(
      BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc dropdownSelectedBloc =
        context.read<DropdownSelectedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomDropDown(
      title: "Select from the list",
      items: items,
      value: selectedValue,
      onChanged: (value) {
        toggles++;
        isRequestTypeSelected = true;
        selectedValue = value as String;
        dropdownSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isRequestTypeSelected,
            toggles: toggles,
          ),
        );
        showButtonBloc.add(
          ShowButtonEvent(show: isRequestTypeSelected && isRemarkValid),
        );
      },
    );
  }

  Widget buildDropdownNumber(
      BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc dropdownSelectedBloc =
        context.read<DropdownSelectedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomDropDown(
      title: "Select from the list",
      items: items,
      value: selectedValue,
      onChanged: (value) {
        toggles++;
        isNumberSelected = true;
        selectedValue = value as String;
        dropdownSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isNumberSelected,
            toggles: toggles,
          ),
        );
        showButtonBloc.add(
          ShowButtonEvent(
              show: isRequestTypeSelected && isRemarkValid && isNumberSelected),
        );
      },
    );
  }

  Widget buildRemarks(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomTextField(
      controller: _remarkController,
      hintText: "Type Your Remarks Here",
      bottomPadding: (16 / Dimensions.designWidth).w,
      minLines: 3,
      maxLines: 5,
      maxLength: 200,
      onChanged: (p0) {
        if (p0.length >= 20) {
          isRemarkValid = true;
        } else {
          isRemarkValid = false;
        }
        showButtonBloc.add(
          ShowButtonEvent(
              show: isRequestTypeSelected && isRemarkValid && isNumberSelected),
        );
      },
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isRequestTypeSelected && isRemarkValid && isNumberSelected) {
      return Column(
        children: [
          GradientButton(
            onTap: () {},
            text: labels[127]["labelText"],
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
            text: labels[127]["labelText"],
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.of(context).padding.bottom,
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }
}
