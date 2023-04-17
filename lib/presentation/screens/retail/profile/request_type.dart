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
                      "Request Type",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Request Type",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.red,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 10),
                    BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                      builder: (context, state) {
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
                            showButtonBloc.add(ShowButtonEvent(
                                show: isRequestTypeSelected && isRemarkValid));
                          },
                        );
                      },
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Remarks",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.black63,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 10),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
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
                                  show: isRequestTypeSelected && isRemarkValid),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: (context, state) {
                  if (isRequestTypeSelected && isRemarkValid) {
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
      ),
    );
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }
}
