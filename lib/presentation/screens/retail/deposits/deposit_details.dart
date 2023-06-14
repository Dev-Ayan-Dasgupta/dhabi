// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class DepositDetailsScreen extends StatefulWidget {
  const DepositDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<DepositDetailsScreen> createState() => _DepositDetailsScreenState();
}

class _DepositDetailsScreenState extends State<DepositDetailsScreen> {
  List<DetailsTileModel> depositDetails = [
    // DetailsTileModel(key: "Deposit Account No.", value: "235437484001"),
    // DetailsTileModel(key: "Deposit Amount", value: "USD 10,000.00"),
    // DetailsTileModel(key: "Tenure", value: "13 months and 3 days"),
    // DetailsTileModel(key: "Interest Rate", value: "6.10%"),
    // DetailsTileModel(key: "Interest Amount", value: "USD 300"),
    // DetailsTileModel(key: "Interest Payout", value: "On maturity"),
    // DetailsTileModel(key: "Maturity Date", value: "9 November, 2023"),
    // DetailsTileModel(key: "Maturity Amount", value: "USD 10,300.00"),
  ];

  bool isFetchingData = true;

  late DepositDetailsArgumentModel depositDetailsArgumentModel;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getDepositDetails();
  }

  void argumentInitialization() {
    depositDetailsArgumentModel =
        DepositDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> getDepositDetails() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    try {
      var getFDDetailsResult = await MapCustomerFdDetails.mapCustomerFdDetails(
        {
          "accountNumber": depositDetailsArgumentModel.accountNumber,
        },
        token ?? "",
      );
      log("Get Fd Details Response -> $getFDDetailsResult");
      if (!(getFDDetailsResult["success"])) {
        depositDetails.clear();
        depositDetails.add(DetailsTileModel(
            key: "Deposit Account No.",
            value: getFDDetailsResult["depositAccountNo"]));
        depositDetails.add(DetailsTileModel(
            key: "Deposit Amount",
            value: "USD ${getFDDetailsResult["depositAmount"]}"));
        depositDetails.add(DetailsTileModel(
            key: "Tenure", value: "${getFDDetailsResult["tenure"] ?? "null"}"));
        depositDetails.add(DetailsTileModel(
            key: "Total Interest Earned",
            value: "USD ${getFDDetailsResult["interestAmount"]}"));
        depositDetails.add(DetailsTileModel(
            key: "Interest Payout",
            value: getFDDetailsResult["interestPayout"]));
        depositDetails.add(DetailsTileModel(
            key: "Payout Amount",
            value: "USD ${getFDDetailsResult["payoutAmount"].toString()}"));
        depositDetails.add(DetailsTileModel(
            key: "On Maturity", value: getFDDetailsResult["onMaturity"]));
        depositDetails.add(DetailsTileModel(
            key: "Maturity Amount",
            value: "USD ${getFDDetailsResult["maturityAmount"].toString()}"));
        depositDetails.add(DetailsTileModel(
            key: "Credit Account",
            value: getFDDetailsResult["creditAccountNo"]));
        depositDetails.add(DetailsTileModel(
            key: "Date of Maturity",
            value: DateFormat('dd-MMM-yyyy')
                .format(DateTime.parse(getFDDetailsResult["maturityDate"]))));
        depositDetails.add(DetailsTileModel(
            key: "Standing Instruction",
            value: getFDDetailsResult["standingInstruction"]));
      }

      isFetchingData = false;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingData));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (15 / Dimensions.designWidth).w,
              vertical: (15 / Dimensions.designWidth).w,
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.downloadStatement);
              },
              child: SvgPicture.asset(ImageConstants.statement),
            ),
          )
        ],
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
                    "Deposit Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Below are the details of your exisitng term deposit",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return Ternary(
                        condition: isFetchingData,
                        truthy: const ShimmerDepositDetails(),
                        falsy: Expanded(
                          child: DetailsTile(
                            length: depositDetails.length,
                            details: depositDetails,
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
                GradientButton(
                  onTap: promptUser,
                  text: labels[138]["labelText"],
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[250]["labelText"],
          message: labels[146]["labelText"],
          auxWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.prematureWithdrawal);
            },
            text: "Yes, I am sure",
          ),
          actionWidget: SolidButton(
            color: AppColors.primaryBright17,
            fontColor: AppColors.primary,
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[166]["labelText"],
          ),
        );
      },
    );
  }
}
