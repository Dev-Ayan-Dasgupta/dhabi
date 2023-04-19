// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dialup_mobile_app/bloc/request/request_bloc.dart';
import 'package:dialup_mobile_app/bloc/request/request_event.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final TextEditingController _remarkController = TextEditingController();

  bool isRequestTypeSelected = false;
  bool isLoanSelected = false;
  bool isRemarkValid = false;

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

  String? selectedRequestType;
  String? selectedLoan;

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
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Request Type",
                            style: TextStyles.primary.copyWith(
                              color: AppColors.black63,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 10),
                          BlocBuilder<DropdownSelectedBloc,
                              DropdownSelectedState>(
                            builder: (context, state) {
                              return CustomDropDown(
                                title: "Select a Request Type",
                                items: items,
                                value: selectedRequestType,
                                onChanged: (value) {
                                  toggles++;
                                  isRequestTypeSelected = true;
                                  selectedRequestType = value as String;
                                  loanSelectedBloc.add(
                                    DropdownSelectedEvent(
                                      isDropdownSelected: isRequestTypeSelected,
                                      toggles: toggles,
                                    ),
                                  );
                                  showButtonBloc.add(ShowButtonEvent(
                                      show: isRequestTypeSelected));
                                },
                              );
                            },
                          ),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              if (isRequestTypeSelected) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizeBox(height: 20),
                                    Text(
                                      "Loan Number",
                                      style: TextStyles.primary.copyWith(
                                        color: AppColors.black63,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    const SizeBox(height: 10),
                                    BlocBuilder<DropdownSelectedBloc,
                                        DropdownSelectedState>(
                                      builder: (context, state) {
                                        return CustomDropDown(
                                          title: "Select a Loan Account",
                                          items: items,
                                          value: selectedLoan,
                                          onChanged: (value) {
                                            toggles++;
                                            isLoanSelected = true;
                                            selectedLoan = value as String;
                                            loanSelectedBloc.add(
                                              DropdownSelectedEvent(
                                                isDropdownSelected:
                                                    isLoanSelected,
                                                toggles: toggles,
                                              ),
                                            );
                                            showButtonBloc.add(ShowButtonEvent(
                                                show: isLoanSelected));
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return const SizeBox();
                              }
                            },
                          ),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              if (isLoanSelected) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizeBox(height: 20),
                                    Text(
                                      "Remarks",
                                      style: TextStyles.primary.copyWith(
                                        color: AppColors.black63,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    const SizeBox(height: 10),
                                    CustomTextField(
                                      controller: _remarkController,
                                      hintText: "Type Your Remarks Here",
                                      bottomPadding:
                                          (16 / Dimensions.designWidth).w,
                                      minLines: 3,
                                      maxLines: 5,
                                      maxLength: 200,
                                      onChanged: (p0) {
                                        if (p0.length >= 5) {
                                          isRemarkValid = true;
                                        } else {
                                          isRemarkValid = false;
                                        }
                                        showButtonBloc.add(
                                          ShowButtonEvent(show: isRemarkValid),
                                        );
                                      },
                                    )
                                  ],
                                );
                              } else {
                                return const SizeBox();
                              }
                            },
                          ),
                          const SizeBox(height: 20),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (isRemarkValid) {
                      return GradientButton(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.errorSuccessScreen,
                            arguments: ErrorArgumentModel(
                              hasSecondaryButton: false,
                              iconPath: ImageConstants.checkCircleOutlined,
                              title: "Request Submitted Successfully",
                              message: "",
                              buttonText: "Home",
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              buttonTextSecondary: "",
                              onTapSecondary: () {},
                            ).toMap(),
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

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }
}
