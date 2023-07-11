// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/summary_tile.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  List<DetailsTileModel> loanDetails = [];

  bool isFetchingLoanDetails = false;

  Map<String, dynamic> getLoanDetailsApiResult = {};

  late LoanDetailsArgumentModel loanDetailsArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getLoanDetails();
  }

  void argumentInitialization() {
    loanDetailsArgument =
        LoanDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> getLoanDetails() async {
    try {
      final ShowButtonBloc showButtonBloc = context.read();

      isFetchingLoanDetails = true;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingLoanDetails));

      log("getLoanDetailsApi Request -> ${{
        "accountNumber": loanDetailsArgument.accountNumber,
      }}");
      getLoanDetailsApiResult = await MapLoanDetails.mapLoanDetails(
        {
          "accountNumber": loanDetailsArgument.accountNumber,
        },
        token ?? "",
      );
      log("getLoanDetailsApiResult -> $getLoanDetailsApiResult");

      if (getLoanDetailsApiResult["success"]) {
        loanDetails.clear();
        loanDetails.add(DetailsTileModel(
            key: "Loan Account Number",
            value: loanDetailsArgument.accountNumber));
        loanDetails.add(DetailsTileModel(
            key: "Interest Rate",
            value: "${getLoanDetailsApiResult["interestRate"].toString()}%"));
        loanDetails.add(DetailsTileModel(
            key: "Interest Rate Type",
            value: "${getLoanDetailsApiResult["interestRateType"]}"));
        loanDetails.add(DetailsTileModel(
            key: "Instalment Amount",
            value:
                "${loanDetailsArgument.currency} ${double.parse(getLoanDetailsApiResult["installmentAmount"]) > 1000 ? NumberFormat('#,000.00').format(double.parse(getLoanDetailsApiResult["installmentAmount"])) : double.parse(getLoanDetailsApiResult["installmentAmount"]).toStringAsFixed(2)}"));
        loanDetails.add(DetailsTileModel(
            key: "Overdue Amount",
            value:
                "${loanDetailsArgument.currency} ${double.parse(getLoanDetailsApiResult["overdueAmount"]) > 1000 ? NumberFormat('#,000.00').format(double.parse(getLoanDetailsApiResult["overdueAmount"])) : double.parse(getLoanDetailsApiResult["overdueAmount"]).toStringAsFixed(2)}"));
        loanDetails.add(DetailsTileModel(
            key: "Balance Tenure",
            value: "${getLoanDetailsApiResult["balanceTenor"]} months"));
        loanDetails.add(DetailsTileModel(
            key: "Next EMI Date",
            value: DateFormat('dd MMM yyyy').format(DateTime.parse(
                getLoanDetailsApiResult["nextEMIDate"] ?? "1900-05-05"))));
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry!",
                message: getLoanDetailsApiResult["message"] ??
                    "Error while getting loan details, please try again later",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: labels[346]["labelText"],
                ),
              );
            },
          );
        }
      }

      isFetchingLoanDetails = false;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingLoanDetails));
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
          AppBarStatement(
            onTapLoan: () async {
              try {
                log("loanStmntApi Request -> ${{
                  "accountNumber": loanDetailsArgument.accountNumber,
                }}");
                var loanStmntApiResult =
                    await MapLoanStatement.mapLoanStatement(
                  {
                    "accountNumber": loanDetailsArgument.accountNumber,
                  },
                  token ?? "",
                );
                log("loanStmntApiResult -> $loanStmntApiResult");
              } catch (_) {
                rethrow;
              }
            },
            onTapAmortization: () {},
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labels[304]["labelText"],
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                return Ternary(
                  condition: isFetchingLoanDetails,
                  truthy: const ShimmerLoanDetails(),
                  falsy: LoanSummaryTile(
                    currency: loanDetailsArgument.currency,
                    disbursedAmount: double.parse(
                        getLoanDetailsApiResult["disbursedAmount"] ?? "0"),
                    repaidAmount: double.parse(
                            getLoanDetailsApiResult["disbursedAmount"] ?? "0") -
                        double.parse(
                            getLoanDetailsApiResult["outstandingAmount"] ??
                                "0"),
                    outstandingAmount: double.parse(
                        getLoanDetailsApiResult["outstandingAmount"] ?? "0"),
                  ),
                );
              },
            ),
            const SizeBox(height: 30),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                return Ternary(
                  condition: isFetchingLoanDetails,
                  truthy: const ShimmerDepositDetails(),
                  falsy: Expanded(
                    child: DetailsTile(
                      length: loanDetails.length,
                      details: loanDetails,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
