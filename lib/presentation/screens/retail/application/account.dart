import 'package:dialup_mobile_app/bloc/multiSelect/multi_select_bloc.dart';
import 'package:dialup_mobile_app/bloc/multiSelect/multi_select_event.dart';
import 'package:dialup_mobile_app/bloc/multiSelect/multi_select_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/create_account.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
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
  @override
  Widget build(BuildContext context) {
    final MultiSelectBloc multiSelectBloc = context.read<MultiSelectBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
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
                  const SizeBox(height: 10),
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
                    "Account Type",
                    style: TextStyles.primary.copyWith(
                      color: AppColors.primary,
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  Text(
                    "USD Accounts",
                    style: TextStyles.primary.copyWith(
                      color: AppColors.primary,
                      fontSize: (18 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    "Minimum one selection required",
                    style: TextStyles.primary.copyWith(
                      color: AppColors.black63,
                      fontSize: (18 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  BlocBuilder<MultiSelectBloc, MultiSelectState>(
                    builder: (context, state) {
                      return MultiSelectButton(
                        isSelected: isCurrentSelected,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current",
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
                          multiSelectBloc.add(
                              MultiSelectEvent(isSelected: isCurrentSelected));
                          showButtonBloc.add(ShowButtonEvent(
                              show: isCurrentSelected && isSavingsSelected));
                        },
                      );
                    },
                  ),
                  const SizeBox(height: 20),
                  BlocBuilder<MultiSelectBloc, MultiSelectState>(
                    builder: (context, state) {
                      return MultiSelectButton(
                        isSelected: isSavingsSelected,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Savings",
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
                          multiSelectBloc.add(
                              MultiSelectEvent(isSelected: isSavingsSelected));
                          showButtonBloc.add(ShowButtonEvent(
                              show: isCurrentSelected && isSavingsSelected));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
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
                      const SizeBox(height: 20),
                      GradientButton(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.termsAndConditions,
                            arguments: CreateAccountArgumentModel(
                                    email: "ayan@qolarisdata.com",
                                    isRetail: true)
                                .toMap(),
                          );
                        },
                        text: "Create Account",
                      ),
                      const SizeBox(height: 32),
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
}
