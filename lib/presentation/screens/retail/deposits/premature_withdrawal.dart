// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class PrematureWithdrawalScreen extends StatefulWidget {
  const PrematureWithdrawalScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<PrematureWithdrawalScreen> createState() =>
      _PrematureWithdrawalScreenState();
}

class _PrematureWithdrawalScreenState extends State<PrematureWithdrawalScreen> {
  List<DetailsTileModel> prematureDetails = [];

  bool isChecked = true;
  bool isFetchingData = true;

  bool isWithdrawing = false;

  late DepositDetailsArgumentModel prematureWithdrawalArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getFdPrematureWithdrawalDetails();
  }

  void argumentInitialization() {
    prematureWithdrawalArgument =
        DepositDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> getFdPrematureWithdrawalDetails() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    try {
      log("Api Request -> ${{
        "accountNo": prematureWithdrawalArgument.accountNumber,
        "maturityDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      }}");
      var apiResult =
          await MapFDPrematureWithdrawalDetails.mapFDPrematureWithdrawalDetails(
        {
          "accountNo": prematureWithdrawalArgument.accountNumber,
          "maturityDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
        token ?? "",
      );
      log("Get PremWdrwl API response -> $apiResult");

      if (apiResult["success"]) {
        prematureDetails.clear();

        prematureDetails.add(DetailsTileModel(
            key: "Debit Acount",
            value: prematureWithdrawalArgument.accountNumber));
        prematureDetails.add(DetailsTileModel(
            key: "Deposit Number",
            value: apiResult["depositAccountNumber"] ?? ""));
        prematureDetails.add(DetailsTileModel(
            key: "Deposit Amount",
            value:
                "USD ${NumberFormat('#,000.00').format(double.parse(apiResult["fdAmount"]))}"));
        prematureDetails.add(DetailsTileModel(
            key: "Open Date",
            value: DateFormat('dd MMMM yyyy')
                .format(DateTime.parse(apiResult["fdOpenDate"]))));
        prematureDetails.add(DetailsTileModel(
            key: "Closure Date",
            value: DateFormat('dd MMMM yyyy')
                .format(DateTime.parse(apiResult["closureDate"]))));
        prematureDetails.add(DetailsTileModel(
            key: "Interest Amount",
            value: "USD ${apiResult["fdIntAmount"].toString()}"));
        prematureDetails.add(DetailsTileModel(
            key: "Interest Rate", value: "${apiResult["interestRate"]} %"));
        prematureDetails.add(DetailsTileModel(
            key: "Credit Account", value: apiResult["creditAccount"] ?? ""));
        prematureDetails.add(DetailsTileModel(
            key: "Maturity Date",
            value: DateFormat('dd MMMM yyyy').format(
                DateTime.parse(apiResult["fdMaturityDate"] ?? "1900-01-01"))));
        prematureDetails.add(DetailsTileModel(
            key: "Credit Amount",
            value:
                "USD ${NumberFormat('#,000.00').format(apiResult["creditAmount"])}"));
        prematureDetails.add(DetailsTileModel(
            key: "Penalty Rate",
            value: "${apiResult["penaltyRate"].toString()} %"));
        prematureDetails.add(DetailsTileModel(
            key: "Penalty Amount",
            value: "USD ${apiResult["penaltyAmount"] ?? ""}"));
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Error",
                message: apiResult["message"] ??
                    "There was an error in fetching your premature withdraw deposit details, please try again later",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: labels[346]["labelText"],
                ),
              );
            },
          );
        }
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
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.symmetric(
        //       horizontal: (15 / Dimensions.designWidth).w,
        //       vertical: (15 / Dimensions.designWidth).w,
        //     ),
        //     child: InkWell(
        //       onTap: () {
        //         // Navigator.pushNamed(context, Routes.downloadStatement);
        //       },
        //       child: SvgPicture.asset(ImageConstants.certificate),
        //     ),
        //   )
        // ],
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
                    labels[138]["labelText"],
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
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return Ternary(
                        condition: isFetchingData,
                        truthy: const ShimmerDepositDetails(),
                        falsy: Expanded(
                          child: DetailsTile(
                            length: prematureDetails.length,
                            details: prematureDetails,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.checkedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          isChecked = true;
          triggerCheckBoxEvent(isChecked);
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.uncheckedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
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
            onTap: () async {
              if (!isWithdrawing) {
                final ShowButtonBloc showButtonBloc =
                    context.read<ShowButtonBloc>();
                isWithdrawing = true;
                showButtonBloc.add(ShowButtonEvent(show: isWithdrawing));

                var premWdrwApiResult =
                    await MapFDPrematureWithdraw.mapFDPrematureWithdraw(
                  {
                    "accountNo": prematureWithdrawalArgument.accountNumber,
                    "maturityDate":
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  },
                  token ?? "",
                );
                log("PremWithdraw API response -> $premWdrwApiResult");

                if (premWdrwApiResult["success"]) {
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.retailDashboard,
                      (route) => false,
                      arguments: RetailDashboardArgumentModel(
                        imgUrl: "",
                        name: storageFullName ?? "",
                        isFirst: false,
                      ).toMap(),
                    );
                  }
                } else {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Sorry!",
                          message: premWdrwApiResult["message"] ??
                              "There was an error in premature withdrawal of your FD, please try again later",
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

                isWithdrawing = false;
                showButtonBloc.add(ShowButtonEvent(show: isWithdrawing));
              }
            },
            text: labels[148]["labelText"],
            auxWidget: isWithdrawing ? const LoaderRow() : const SizeBox(),
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.of(context).padding.bottom,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SolidButton(
            onTap: () {},
            text: labels[148]["labelText"],
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.paddingOf(context).bottom,
          ),
        ],
      );
    }
  }
}
