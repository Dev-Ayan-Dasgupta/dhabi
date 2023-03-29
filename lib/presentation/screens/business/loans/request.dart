import 'package:dialup_mobile_app/bloc/request/loan_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/request/loan_selected_event.dart';
import 'package:dialup_mobile_app/bloc/request/loan_selected_state.dart';
import 'package:dialup_mobile_app/bloc/request/request_bloc.dart';
import 'package:dialup_mobile_app/bloc/request/request_event.dart';
import 'package:dialup_mobile_app/bloc/request/request_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/radio_button.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool isEarlySettlement = false;
  bool isPartialSettlement = false;
  bool isLoanSelected = false;

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
    final LoanSelectedBloc loanSelectedBloc = context.read<LoanSelectedBloc>();
    loanSelectedBloc.add(
        LoanSelectedEvent(isLoanSelected: isLoanSelected, toggles: toggles));
    final RequestBloc requestBloc = context.read<RequestBloc>();
    requestBloc.add(RequestEvent(isEarly: false, isPartial: false));
    // print("init isEarlySettlement -> $isEarlySettlement");
    // print("init isPartialSettlement -> $isPartialSettlement");
  }

  @override
  Widget build(BuildContext context) {
    final RequestBloc requestBloc = context.read<RequestBloc>();
    final LoanSelectedBloc loanSelectedBloc = context.read<LoanSelectedBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (15 / Dimensions.designWidth).w,
              vertical: (15 / Dimensions.designWidth).w,
            ),
            child: SvgPicture.asset(ImageConstants.statement),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: (22 / Dimensions.designWidth).w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizeBox(height: 10),
                  Text(
                    "Request Type",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  BlocBuilder<RequestBloc, RequestState>(
                    builder: (context, state) {
                      return CustomRadioButton(
                        isSelected: isEarlySettlement,
                        text: "Early Settlement",
                        onTap: () {
                          isEarlySettlement = true;
                          isPartialSettlement = false;
                          requestBloc.add(
                            RequestEvent(
                              isEarly: isEarlySettlement,
                              isPartial: isPartialSettlement,
                            ),
                          );
                          // print("isEarlySettlement -> $isEarlySettlement");
                          // print("isPartialSettlement -> $isPartialSettlement");
                          // print("init state.isEarly -> ${state.isEarly}");
                          // print("init state.isPartial -> ${state.isPartial}");
                        },
                      );
                    },
                  ),
                  const SizeBox(height: 20),
                  BlocBuilder<RequestBloc, RequestState>(
                    builder: (context, state) {
                      return CustomRadioButton(
                        isSelected: isPartialSettlement,
                        text: "Place Partial Payment",
                        onTap: () {
                          isEarlySettlement = false;
                          isPartialSettlement = true;
                          requestBloc.add(
                            RequestEvent(
                              isEarly: isEarlySettlement,
                              isPartial: isPartialSettlement,
                            ),
                          );
                          // print("isEarlySettlement -> $isEarlySettlement");
                          // print("isPartialSettlement -> $isPartialSettlement");
                          // print("init state.isEarly -> ${state.isEarly}");
                          // print("init state.isPartial -> ${state.isPartial}");
                        },
                      );
                    },
                  ),
                  const SizeBox(height: 30),
                  Text(
                    "Loan Number",
                    style: TextStyles.primary.copyWith(
                      color: const Color(0XFF636363),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<LoanSelectedBloc, LoanSelectedState>(
                    builder: (context, state) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              const SizeBox(width: 5),
                              Expanded(
                                child: Text(
                                  "Select Loan Account Number",
                                  style: TextStyles.primary.copyWith(
                                    color:
                                        const Color.fromRGBO(29, 29, 29, 0.5),
                                    fontSize: (14 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          items: items
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyles.primary.copyWith(
                                      color: const Color(0xFF292929),
                                      fontSize: (14 / Dimensions.designWidth).w,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            // setState(() {
                            //   selectedValue = value as String;
                            // });
                            toggles++;
                            isLoanSelected = true;
                            selectedValue = value as String;
                            loanSelectedBloc.add(
                              LoanSelectedEvent(
                                isLoanSelected: isLoanSelected &&
                                    (isPartialSettlement || isEarlySettlement),
                                toggles: toggles,
                              ),
                            );
                          },
                          buttonStyleData: ButtonStyleData(
                            height: (50 / Dimensions.designWidth).w,
                            width: 90.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: (14 / Dimensions.designWidth).w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    (10 / Dimensions.designWidth).w),
                              ),
                              color: Colors.white,
                            ),
                            elevation: 2,
                          ),
                          iconStyleData: IconStyleData(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                            iconSize: (20 / Dimensions.designWidth).w,
                            iconEnabledColor: const Color(0XFF1C1B1F),
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: (300 / Dimensions.designWidth).w,
                            width: 90.w,
                            padding: null,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  (10 / Dimensions.designWidth).w),
                              color: Colors.white,
                            ),
                            elevation: 8,
                            offset: const Offset(0, -5),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: Radius.circular(
                                  (40 / Dimensions.designWidth).w),
                              thickness: MaterialStateProperty.all<double>(6),
                              thumbVisibility:
                                  MaterialStateProperty.all<bool>(true),
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: (40 / Dimensions.designWidth).w,
                            padding: EdgeInsets.symmetric(
                                horizontal: (14 / Dimensions.designWidth).w),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<LoanSelectedBloc, LoanSelectedState>(
                  builder: (context, state) {
                    if (state.isLoanSelected) {
                      return GradientButton(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.requestSuccess,
                          );
                        },
                        text: "Submit Request",
                      );
                    } else {
                      return const SizeBox();
                    }
                  },
                ),
                const SizeBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
