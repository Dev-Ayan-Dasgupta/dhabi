// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/map_customer_account_details.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:local_auth/local_auth.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/biometric.dart';

class TransferConfirmationScreen extends StatefulWidget {
  const TransferConfirmationScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TransferConfirmationScreen> createState() =>
      _TransferConfirmationScreenState();
}

class _TransferConfirmationScreenState
    extends State<TransferConfirmationScreen> {
  List<DetailsTileModel> transferConfirmation = [];

  bool isTransferring = false;

  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateDetails();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
    log("sendMoneyArgument -> $sendMoneyArgument");
    // exchangeRate = sendMoneyArgument.isBetweenAccounts ? 1 : 0;
  }

  void populateDetails() {
    transferConfirmation.add(DetailsTileModel(
        key: labels[155]["labelText"], value: senderAccountNumber));
    transferConfirmation.add(DetailsTileModel(
        key: labels[157]["labelText"], value: receiverAccountNumber));
    transferConfirmation.add(DetailsTileModel(
        key: labels[159]["labelText"],
        value: "$senderCurrency ${senderAmount.toStringAsFixed(2)}"));
    transferConfirmation.add(DetailsTileModel(
        key: sendMoneyArgument.isBetweenAccounts
            ? labels[163]["labelText"]
            : labels[198]["labelText"],
        value: "$receiverCurrency ${receiverAmount.toStringAsFixed(2)}"));
    transferConfirmation.add(DetailsTileModel(
        key: labels[165]["labelText"],
        value: "1 $senderCurrency = $exchangeRate $receiverCurrency"));
    transferConfirmation.add(DetailsTileModel(
        key: labels[168]["labelText"], value: "$senderCurrency $fees"));
    transferConfirmation.add(DetailsTileModel(
        key: labels[169]["labelText"],
        value: sendMoneyArgument.isBetweenAccounts ? "Today" : "something"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: (22 / Dimensions.designWidth).w,
              top: (20 / Dimensions.designWidth).w,
            ),
            child: Text(
              labels[166]["labelText"],
              style: TextStyles.primary.copyWith(
                color: const Color.fromRGBO(65, 65, 65, 0.5),
                fontSize: (16 / Dimensions.designWidth).w,
                fontWeight: FontWeight.w600,
              ),
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
                  const SizeBox(height: 10),
                  Text(
                    "Transfer Confirmation",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    "Please review the transfer details and click proceed to confirm",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: DetailsTile(
                      length: transferConfirmation.length,
                      details: transferConfirmation,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return GradientButton(
                      onTap: () async {
                        if (!isTransferring) {
                          final ShowButtonBloc showButtonBloc =
                              context.read<ShowButtonBloc>();
                          isTransferring = true;
                          showButtonBloc
                              .add(ShowButtonEvent(show: isTransferring));

                          if (sendMoneyArgument.isBetweenAccounts) {
                            log("Internal Transfer APi request -> ${{
                              "debitAccount": senderAccountNumber,
                              "creditAccount": receiverAccountNumber,
                              "debitAmount": senderAmount.toString(),
                              "currency": senderCurrency,
                            }}");
                            var makeInternalTransferApiResult =
                                await MapInternalMoneyTransfer
                                    .mapInternalMoneyTransfer(
                              {
                                "debitAccount": senderAccountNumber,
                                "creditAccount": receiverAccountNumber,
                                "debitAmount": senderAmount.toString(),
                                "currency": senderCurrency,
                              },
                              token ?? "",
                            );
                            log("Make Internal Transfer Response -> $makeInternalTransferApiResult");
                            if (makeInternalTransferApiResult["success"]) {
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.errorSuccessScreen,
                                  arguments: ErrorArgumentModel(
                                    hasSecondaryButton: true,
                                    iconPath:
                                        ImageConstants.checkCircleOutlined,
                                    title: "Success!",
                                    message:
                                        "Your transaction has been completed\n\nTransfer reference: ${makeInternalTransferApiResult["ftReferenceNumber"]}",
                                    buttonTextSecondary: "Go Home",
                                    onTapSecondary: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.retailDashboard,
                                        (route) => false,
                                        arguments: RetailDashboardArgumentModel(
                                          imgUrl: "",
                                          name: profileName ?? "",
                                          isFirst: storageIsFirstLogin == true
                                              ? false
                                              : true,
                                        ).toMap(),
                                      );
                                    },
                                    buttonText: "Make another transaction",
                                    onTap: () async {
                                      var result =
                                          await MapCustomerAccountDetails
                                              .mapCustomerAccountDetails(
                                                  token ?? "");
                                      if (result["success"]) {
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          accountDetails =
                                              result["crCustomerProfileRes"]
                                                  ["body"]["accountDetails"];
                                          Navigator.pushNamed(
                                            context,
                                            Routes.sendMoneyFrom,
                                            arguments: SendMoneyArgumentModel(
                                              isBetweenAccounts:
                                                  sendMoneyArgument
                                                      .isBetweenAccounts,
                                              isWithinDhabi: sendMoneyArgument
                                                  .isWithinDhabi,
                                              isRemittance: sendMoneyArgument
                                                  .isRemittance,
                                            ).toMap(),
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialog(
                                                svgAssetPath:
                                                    ImageConstants.warning,
                                                title: "Error {200}",
                                                message: result["message"][
                                                    "Something went wrong, please try again later"],
                                                actionWidget: GradientButton(
                                                  onTap: () {},
                                                  text: labels[346]
                                                      ["labelText"],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
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
                                      title: "Error {200}",
                                      message: makeInternalTransferApiResult[
                                              "message"] ??
                                          "Something went wrong while internal transfer, please try again later",
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
                          } else if (sendMoneyArgument.isRemittance) {
                            log("Remittance request -> ${{
                              "quotationId": "string",
                              "sourceCurrency": senderCurrency,
                              "targetCurrency": receiverCurrency,
                              "countryCode": beneficiaryCountryCode,
                              "debitAccount": senderAccountNumber,
                              "debitAmount": senderAmount,
                              "benBankCode": benBankCode,
                              "benMobileNo": benMobileNo,
                              "benSubBankCode": benSubBankCode,
                              "accountType": benAccountType,
                              "benIdType": benIdType,
                              "benIdNo": benIdNo,
                              "benIdExpiryDate": benIdExpiryDate,
                              "benBankName": benBankName,
                              "benAccountNo": receiverAccountNumber,
                              "benCustomerName": benCustomerName,
                              "address": benAddress,
                              "city": benCity,
                              "swiftCode": benSwiftCode,
                              "remittancePurpose": remittancePurpose ?? "",
                              "sourceOfFunds": sourceOfFunds ?? "",
                              "relation": relation ?? "",
                            }}");
                            var remittanceApiResult = await MapInter.mapInter(
                              {
                                "quotationId": "string",
                                "sourceCurrency": senderCurrency,
                                "targetCurrency": receiverCurrency,
                                "countryCode": beneficiaryCountryCode,
                                "debitAccount": senderAccountNumber,
                                "debitAmount": senderAmount.toString(),
                                "benBankCode": benBankCode,
                                "benMobileNo": benMobileNo,
                                "benSubBankCode": benSubBankCode,
                                "accountType": benAccountType,
                                "benIdType": benIdType,
                                "benIdNo": benIdNo,
                                "benIdExpiryDate": benIdExpiryDate,
                                "benBankName": benBankName,
                                "benAccountNo": receiverAccountNumber,
                                "benCustomerName": benCustomerName,
                                "address": benAddress,
                                "city": benCity,
                                "swiftCode": benSwiftCode,
                                "remittancePurpose": remittancePurpose ?? "",
                                "sourceOfFunds": sourceOfFunds ?? "",
                                "relation": relation ?? "",
                              },
                              token ?? "",
                            );
                            log("Remittance API Response -> $remittanceApiResult");
                            if (remittanceApiResult["success"]) {
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.errorSuccessScreen,
                                  arguments: ErrorArgumentModel(
                                    hasSecondaryButton: true,
                                    iconPath:
                                        ImageConstants.checkCircleOutlined,
                                    title: "Success!",
                                    message:
                                        "Your transaction has been completed\n\nTransfer reference: ${remittanceApiResult["ftReferenceNumber"]}",
                                    buttonTextSecondary: "Go Home",
                                    onTapSecondary: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.retailDashboard,
                                        (route) => false,
                                        arguments: RetailDashboardArgumentModel(
                                          imgUrl: "",
                                          name: profileName ?? "",
                                          isFirst: storageIsFirstLogin == true
                                              ? false
                                              : true,
                                        ).toMap(),
                                      );
                                    },
                                    buttonText: "Make another transaction",
                                    onTap: () async {
                                      var result =
                                          await MapCustomerAccountDetails
                                              .mapCustomerAccountDetails(
                                                  token ?? "");
                                      if (result["success"]) {
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          accountDetails =
                                              result["crCustomerProfileRes"]
                                                  ["body"]["accountDetails"];
                                          Navigator.pushNamed(
                                            context,
                                            Routes.sendMoneyFrom,
                                            arguments: SendMoneyArgumentModel(
                                              isBetweenAccounts:
                                                  sendMoneyArgument
                                                      .isBetweenAccounts,
                                              isWithinDhabi: sendMoneyArgument
                                                  .isWithinDhabi,
                                              isRemittance: sendMoneyArgument
                                                  .isRemittance,
                                            ).toMap(),
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialog(
                                                svgAssetPath:
                                                    ImageConstants.warning,
                                                title: "Error {200}",
                                                message: result["message"][
                                                    "Something went wrong, please try again later"],
                                                actionWidget: GradientButton(
                                                  onTap: () {},
                                                  text: labels[346]
                                                      ["labelText"],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
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
                                      title: "Error {200}",
                                      message: remittanceApiResult["message"] ??
                                          "Something went wrong while internal transfer, please try again later",
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
                          }

                          isTransferring = false;
                          showButtonBloc
                              .add(ShowButtonEvent(show: isTransferring));
                        }
                      },
                      text: labels[170]["labelText"],
                      auxWidget:
                          isTransferring ? const LoaderRow() : const SizeBox(),
                    );
                  },
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

  void biometricPrompt() async {
    bool isBiometricSupported = await LocalAuthentication().isDeviceSupported();

    if (!isBiometricSupported) {
      if (context.mounted) {
        Navigator.pushNamed(context, Routes.password);
      }
    } else {
      bool isAuthenticated = await BiometricHelper.authenticateUser();

      if (isAuthenticated) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.errorSuccessScreen,
            arguments: ErrorArgumentModel(
              hasSecondaryButton: true,
              iconPath: ImageConstants.checkCircleOutlined,
              title: "Success!",
              message:
                  "Your transaction has been completed\n\nTransfer reference: 254455588800",
              buttonText: "Home",
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              buttonTextSecondary: "Make another transaction",
              onTapSecondary: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ).toMap(),
          );
        }
      } else {
        // TODO: Verify from client if they want a dialog box to enable biometric

        // OpenSettings.openBiometricEnrollSetting();
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(
        //         'Biometric Authentication failed.',
        //         style: TextStyles.primary.copyWith(
        //           fontSize: (12 / Dimensions.designWidth).w,
        //         ),
        //       ),
        //     ),
        //   );
        // }
      }
    }
  }
}
