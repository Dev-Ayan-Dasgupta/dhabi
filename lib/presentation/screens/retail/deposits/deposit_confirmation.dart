import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/error.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DepositConfirmationScreen extends StatefulWidget {
  const DepositConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<DepositConfirmationScreen> createState() =>
      _DepositConfirmationScreenState();
}

class _DepositConfirmationScreenState extends State<DepositConfirmationScreen> {
  List<DetailsTileModel> depositDetails = [
    DetailsTileModel(key: "Debit Account", value: "235437484001"),
    DetailsTileModel(key: "Deposit Amount", value: "USD 12,400.00"),
    DetailsTileModel(key: "Tenure", value: "13 months and 3 days"),
    DetailsTileModel(key: "Interest Rate", value: "6.10%"),
    DetailsTileModel(key: "Interest Amount", value: "USD 300"),
    DetailsTileModel(key: "Interest Payout", value: "On maturity"),
    DetailsTileModel(key: "On Maturity", value: "Auto renewal"),
    DetailsTileModel(key: "Credit Account Number", value: "235437484001"),
    DetailsTileModel(key: "Date of Maturity", value: "12 December 2022"),
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
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizeBox(height: 10),
                  Text(
                    "Deposit Confirmation",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Please review the deposit details and click proceed to confirm",
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color(0xFF636363),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: DetailsTile(
                      length: depositDetails.length,
                      details: depositDetails,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
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
                            child: SvgPicture.asset(ImageConstants.checkedBox),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              isChecked = true;
                              triggerCheckBoxEvent(isChecked);
                            },
                            child:
                                SvgPicture.asset(ImageConstants.uncheckedBox),
                          );
                        }
                      },
                    ),
                    const SizeBox(width: 10),
                    Text(
                      "I've read all the terms and conditions",
                      style: TextStyles.primary.copyWith(
                        color: const Color(0XFF414141),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 20),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (isChecked) {
                      return GradientButton(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.errorScreen,
                            arguments: ErrorArgumentModel(
                              iconPath: ImageConstants.checkCircleOutlined,
                              title: "Congratulations!",
                              message:
                                  "Your deposit account has been created. Acc. 254455588800",
                              buttonText: "Home",
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ).toMap(),
                          );
                        },
                        text: "I Agree",
                      );
                    } else {
                      return SolidButton(
                        onTap: () {},
                        text: "I Agree",
                        color: Colors.black12,
                      );
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
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isChecked));
  }
}
