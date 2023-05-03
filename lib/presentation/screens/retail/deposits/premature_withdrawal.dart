import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrematureWithdrawalScreen extends StatefulWidget {
  const PrematureWithdrawalScreen({Key? key}) : super(key: key);

  @override
  State<PrematureWithdrawalScreen> createState() =>
      _PrematureWithdrawalScreenState();
}

class _PrematureWithdrawalScreenState extends State<PrematureWithdrawalScreen> {
  List<DetailsTileModel> prematureDetails = [
    DetailsTileModel(key: "Deposit Account No.", value: "235437484001"),
    DetailsTileModel(key: "Deposit Amount", value: "USD 10,000.00"),
    DetailsTileModel(key: "Maturity Date", value: "9 November, 2023"),
    DetailsTileModel(key: "Interest Rate", value: "6.10%"),
    DetailsTileModel(key: "Credit Account", value: "110156884301"),
    DetailsTileModel(key: "Closure Date", value: "17 November 2023"),
    DetailsTileModel(key: "Credit Amount", value: "USD 300"),
    DetailsTileModel(key: "Penal Rate", value: "1%"),
  ];

  bool isChecked = false;

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
                    "Premature Withdrawal",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Below are the details of your Premature withdrawal",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: DetailsTile(
                      length: prematureDetails.length,
                      details: prematureDetails,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: buildTC,
                    ),
                    const SizeBox(width: 10),
                    RichText(
                      text: TextSpan(
                        text: 'I agree to the ',
                        style: TextStyles.primary.copyWith(
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyles.primary.copyWith(
                              color: AppColors.primary,
                              fontSize: (14 / Dimensions.designWidth).w,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: TextStyles.primary.copyWith(
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyles.primary.copyWith(
                              color: AppColors.primary,
                              fontSize: (14 / Dimensions.designWidth).w,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildSubmitButton,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTC(BuildContext context, CheckBoxState state) {
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
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isChecked));
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isChecked) {
      return Column(
        children: [
          GradientButton(
            onTap: () {
              if (isChecked) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            text: "Withdraw and close deposit",
            fontColor: Colors.white,
          ),
          const SizeBox(height: 20),
        ],
      );
    } else {
      return const SizeBox();
    }
  }
}
