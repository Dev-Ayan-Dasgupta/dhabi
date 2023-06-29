// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/screens/business/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/vault_account_card.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SendMoneyFromScreen extends StatefulWidget {
  const SendMoneyFromScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SendMoneyFromScreen> createState() => _SendMoneyFromScreenState();
}

class _SendMoneyFromScreenState extends State<SendMoneyFromScreen> {
  late SendMoneyArgumentModel sendMoneyArgument;

  int selectedAccountIndex = -1;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

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
                    labels[155]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    "Please select an option from the list below",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  // Text(
                  //   labels[4]["labelText"],
                  //   style: TextStyles.primaryMedium.copyWith(
                  //     color: AppColors.dark80,
                  //     fontSize: (14 / Dimensions.designWidth).w,
                  //   ),
                  // ),
                  // const SizeBox(height: 10),
                  // VaultAccountCard(
                  //   isVault: true,
                  //   onTap: () {
                  //     Navigator.pushNamed(context, Routes.sendMoneyTo);
                  //   },
                  //   title: "Vault",
                  //   imgUrl:
                  //       "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
                  //   accountNo: "1234567890987654",
                  //   currency: "AED",
                  //   amount: 25000,
                  //   isSelected: false,
                  // ),
                  // const SizeBox(height: 30),
                  Row(
                    children: [
                      Text(
                        labels[156]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: sendMoneyArgument.isRetail
                          ? accountDetails.length
                          : sendMoneyArgument.isBetweenAccounts
                              ? internalSeedAccounts.length
                              : sendMoneyArgument.isWithinDhabi
                                  ? dhabiSeedAccounts.length
                                  : foreignSeedAccounts.length,
                      separatorBuilder: (context, index) {
                        return const SizeBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return BlocBuilder<ShowButtonBloc, ShowButtonState>(
                          builder: (context, state) {
                            return VaultAccountCard(
                              isVault: false,
                              onTap: () {
                                final ShowButtonBloc showButtonBloc =
                                    context.read<ShowButtonBloc>();
                                selectedAccountIndex = index;
                                senderCurrencyFlag = sendMoneyArgument.isRetail
                                    ? accountDetails[index]
                                        ["currencyFlagBase64"]
                                    : sendMoneyArgument.isBetweenAccounts
                                        ? internalSeedAccounts[index]
                                            .currencyFlag
                                        : sendMoneyArgument.isWithinDhabi
                                            ? dhabiSeedAccounts[index]
                                                .currencyFlag
                                            : foreignSeedAccounts[index]
                                                .currencyFlag;
                                senderAccountNumber = sendMoneyArgument.isRetail
                                    ? accountDetails[index]["accountNumber"]
                                    : sendMoneyArgument.isBetweenAccounts
                                        ? internalSeedAccounts[index]
                                            .accountNumber
                                        : sendMoneyArgument.isWithinDhabi
                                            ? dhabiSeedAccounts[index]
                                                .accountNumber
                                            : foreignSeedAccounts[index]
                                                .accountNumber;
                                senderCurrency = sendMoneyArgument.isRetail
                                    ? accountDetails[index]["accountCurrency"]
                                    : sendMoneyArgument.isBetweenAccounts
                                        ? internalSeedAccounts[index].currency
                                        : sendMoneyArgument.isWithinDhabi
                                            ? dhabiSeedAccounts[index].currency
                                            : foreignSeedAccounts[index]
                                                .currency;
                                senderBalance = sendMoneyArgument.isRetail
                                    ? double.parse(accountDetails[index]
                                            ["currentBalance"]
                                        .split(" ")
                                        .last
                                        .replaceAll(",", ""))
                                    : sendMoneyArgument.isBetweenAccounts
                                        ? internalSeedAccounts[index].bal
                                        : sendMoneyArgument.isWithinDhabi
                                            ? dhabiSeedAccounts[index].bal
                                            : foreignSeedAccounts[index].bal;
                                showButtonBloc.add(ShowButtonEvent(
                                    show: selectedAccountIndex == index));
                              },
                              title:
                                  accountDetails[index]["productCode"] == "1001"
                                      ? labels[7]["labelText"]
                                      : labels[92]["labelText"],
                              accountNo: sendMoneyArgument.isRetail
                                  ? accountDetails[index]["accountNumber"]
                                  : sendMoneyArgument.isBetweenAccounts
                                      ? internalSeedAccounts[index]
                                          .accountNumber
                                      : sendMoneyArgument.isWithinDhabi
                                          ? dhabiSeedAccounts[index]
                                              .accountNumber
                                          : foreignSeedAccounts[index]
                                              .accountNumber,
                              currency: sendMoneyArgument.isRetail
                                  ? accountDetails[index]["accountCurrency"]
                                  : sendMoneyArgument.isBetweenAccounts
                                      ? internalSeedAccounts[index].currency
                                      : sendMoneyArgument.isWithinDhabi
                                          ? dhabiSeedAccounts[index].currency
                                          : foreignSeedAccounts[index].currency,
                              amount: sendMoneyArgument.isRetail
                                  ? double.parse(accountDetails[index]
                                          ["currentBalance"]
                                      .split(" ")
                                      .last
                                      .replaceAll(",", ""))
                                  : sendMoneyArgument.isBetweenAccounts
                                      ? internalSeedAccounts[index].bal
                                      : sendMoneyArgument.isWithinDhabi
                                          ? dhabiSeedAccounts[index].bal
                                          : foreignSeedAccounts[index].bal,
                              isSelected: selectedAccountIndex == index,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (selectedAccountIndex == -1 ||
                        accountDetails.length == 1) {
                      return SolidButton(
                          onTap: () {}, text: labels[127]["labelText"]);
                    } else {
                      return GradientButton(
                        onTap: () {
                          if (sendMoneyArgument.isBetweenAccounts) {
                            Navigator.pushNamed(
                              context,
                              Routes.sendMoneyTo,
                              arguments: SendMoneyArgumentModel(
                                isBetweenAccounts: true,
                                isWithinDhabi: false,
                                isRemittance: false,
                                isRetail: sendMoneyArgument.isRetail,
                              ).toMap(),
                            );
                          } else if (sendMoneyArgument.isRemittance) {
                            Navigator.pushNamed(
                              context,
                              Routes.selectRecipient,
                              arguments: SendMoneyArgumentModel(
                                isBetweenAccounts: false,
                                isWithinDhabi: false,
                                isRemittance: true,
                                isRetail: sendMoneyArgument.isRetail,
                              ).toMap(),
                            );
                          } else {
                            Navigator.pushNamed(
                              context,
                              Routes.selectRecipient,
                              arguments: SendMoneyArgumentModel(
                                isBetweenAccounts: false,
                                isWithinDhabi: true,
                                isRemittance: false,
                                isRetail: sendMoneyArgument.isRetail,
                              ).toMap(),
                            );
                          }
                        },
                        text: labels[127]["labelText"],
                      );
                    }
                  },
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
