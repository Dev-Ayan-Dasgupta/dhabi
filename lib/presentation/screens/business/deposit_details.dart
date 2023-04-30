import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class BusinessDepositDetailsScreen extends StatefulWidget {
  const BusinessDepositDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDepositDetailsScreen> createState() =>
      _BusinessDepositDetailsScreenState();
}

class _BusinessDepositDetailsScreenState
    extends State<BusinessDepositDetailsScreen> {
  final TextEditingController _reasonController = TextEditingController();
  bool isReasonValid = false;

  List<DetailsTileModel> depositDetails = [
    DetailsTileModel(key: "Debit Account", value: "235437484001"),
    DetailsTileModel(key: "Deposit Amount", value: "USD 10,000.00"),
    DetailsTileModel(key: "Tenure", value: "13 months and 3 days"),
    DetailsTileModel(key: "Interest Rate", value: "6.10%"),
    DetailsTileModel(key: "Interest Amount", value: "USD 300"),
    DetailsTileModel(key: "Interest Payout", value: "On maturity"),
    DetailsTileModel(key: "On Maturity", value: "Auto Renewal"),
    DetailsTileModel(key: "Credit Account Number", value: "235437484001"),
    DetailsTileModel(key: "Date of Maturity", value: "October 10, 2024"),
    DetailsTileModel(key: "Status", value: "Pending Approval"),
  ];

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
                  Text(
                    "Deposit Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Please review the deposit details and click proceed to confirm",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: DetailsTile(
                      length: depositDetails.length,
                      details: depositDetails,
                      coloredIndex: depositDetails.length - 1,
                      fontColor: AppColors.amber,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: () {},
                  text: "Approve",
                ),
                const SizeBox(height: 20),
                SolidButton(
                  color: const Color.fromRGBO(34, 97, 105, 0.17),
                  fontColor: AppColors.primary,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Reject Reason",
                          message:
                              "Please provide the reason for rejection below",
                          auxWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizeBox(height: 20),
                              Text(
                                "Remarks",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: const Color(0xFF636363),
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const SizeBox(height: 10),
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: (context, state) {
                                  return CustomTextField(
                                    controller: _reasonController,
                                    hintText: "Type Your Remarks Here",
                                    bottomPadding:
                                        (16 / Dimensions.designWidth).w,
                                    minLines: 3,
                                    maxLines: 5,
                                    maxLength: 200,
                                    onChanged: (p0) {
                                      if (p0.length >= 20) {
                                        isReasonValid = true;
                                      } else {
                                        isReasonValid = false;
                                      }
                                      showButtonBloc.add(
                                        ShowButtonEvent(show: isReasonValid),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          actionWidget:
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              if (isReasonValid) {
                                return Column(
                                  children: [
                                    GradientButton(
                                      onTap: () {},
                                      text: labels[31]["labelText"],
                                    ),
                                    const SizeBox(height: 20),
                                  ],
                                );
                              } else {
                                return const SizeBox();
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                  text: "Reject",
                ),
                const SizeBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
