// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dialup_mobile_app/bloc/request/request_bloc.dart';
import 'package:dialup_mobile_app/bloc/request/request_event.dart';
import 'package:dialup_mobile_app/bloc/request/request_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

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
    'Item8'
  ];

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    final DropdownSelectedBloc loanSelectedBloc =
        context.read<DropdownSelectedBloc>();
    loanSelectedBloc.add(DropdownSelectedEvent(
        isDropdownSelected: isLoanSelected, toggles: toggles));
    final RequestBloc requestBloc = context.read<RequestBloc>();
    requestBloc.add(RequestEvent(isEarly: false, isPartial: false));
  }

  @override
  Widget build(BuildContext context) {
    final RequestBloc requestBloc = context.read<RequestBloc>();
    final DropdownSelectedBloc loanSelectedBloc =
        context.read<DropdownSelectedBloc>();
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
                          loanSelectedBloc.add(
                            DropdownSelectedEvent(
                              isDropdownSelected: isLoanSelected &&
                                  (isPartialSettlement || isEarlySettlement),
                              toggles: toggles,
                            ),
                          );
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
                          loanSelectedBloc.add(
                            DropdownSelectedEvent(
                              isDropdownSelected: isLoanSelected &&
                                  (isPartialSettlement || isEarlySettlement),
                              toggles: toggles,
                            ),
                          );
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
                  BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    builder: (context, state) {
                      return CustomDropDown(
                        title: "Select a Loan Account",
                        items: items,
                        value: selectedValue,
                        onChanged: (value) {
                          toggles++;
                          isLoanSelected = true;
                          selectedValue = value as String;
                          loanSelectedBloc.add(
                            DropdownSelectedEvent(
                              isDropdownSelected: isLoanSelected &&
                                  (isPartialSettlement || isEarlySettlement),
                              toggles: toggles,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                  builder: (context, state) {
                    if (state.isDropdownSelected) {
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
