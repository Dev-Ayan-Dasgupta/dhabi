import 'package:dialup_mobile_app/data/models/details_tile.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/summary_tile.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({Key? key}) : super(key: key);

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  List<DetailsTileModel> loanDetails = [
    DetailsTileModel(key: "Loan Account Number", value: "891011121"),
    DetailsTileModel(key: "Interest Rate", value: "8.99%"),
    DetailsTileModel(key: "Interest Rate Type", value: "Fixed"),
    DetailsTileModel(key: "Installment Amount", value: "USD 4,500.00"),
    DetailsTileModel(key: "Overdue Amount", value: "USD 0.00"),
    DetailsTileModel(key: "Balance Tenure", value: "10 months"),
    DetailsTileModel(key: "Next EMI Date", value: "28 Dec 2022"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: const [AppBarStatement()],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizeBox(height: 10),
            Text(
              "Loan Details",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            const LoanSummaryTile(
              currency: "USD",
              disbursedAmount: 45000,
              repaidAmount: 30120.50,
              outstandingAmount: 14879.50,
            ),
            const SizeBox(height: 20),
            Expanded(
              child: DetailsTile(length: 7, details: loanDetails),
            ),
          ],
        ),
      ),
    );
  }
}
