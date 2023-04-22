import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecipientDetailsScreen extends StatefulWidget {
  const RecipientDetailsScreen({Key? key}) : super(key: key);

  @override
  State<RecipientDetailsScreen> createState() => _RecipientDetailsScreenState();
}

class _RecipientDetailsScreenState extends State<RecipientDetailsScreen> {
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _recipientNameController =
      TextEditingController(text: "Au*******ui");
  bool isChecked = false;
  String buttonText = "Search";
  bool isProceed = false;
  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc proceedBloc = context.read<ShowButtonBloc>();
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
                    "Recipient Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  Text(
                    "IBAN / Account number",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.red,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  CustomTextField(
                    hintText: "Enter IBAN or Account Number",
                    keyboardType: TextInputType.number,
                    controller: _ibanController,
                    onChanged: (p0) {
                      proceedBloc.add(ShowButtonEvent(show: isProceed));
                    },
                  ),
                  const SizeBox(height: 20),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      if (isProceed) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Recipient Name",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.red,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 10),
                            CustomTextField(
                              enabled: false,
                              color: AppColors.blackEE,
                              controller: _recipientNameController,
                              onChanged: (p0) {},
                            ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (isProceed) {
                      return Row(
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
                      );
                    } else {
                      return const SizeBox();
                    }
                  },
                ),
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (_ibanController.text.isNotEmpty) {
                      return GradientButton(
                        onTap: () {
                          if (!isProceed) {
                            isProceed = true;
                            buttonText = "Proceed";
                            proceedBloc.add(ShowButtonEvent(show: isProceed));
                          } else {
                            Navigator.pushNamed(context, Routes.transferAmount);
                          }
                        },
                        text: buttonText,
                      );
                    } else {
                      return const SizeBox();
                    }
                  },
                ),
                const SizeBox(height: 20),
              ],
            )
          ],
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
    _ibanController.dispose();
    _recipientNameController.dispose();
    super.dispose();
  }
}
