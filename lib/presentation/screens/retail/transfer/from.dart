// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/screens/business/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/vault_account_card.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:uuid/uuid.dart';

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

  final TextEditingController _sendCurrencyController = TextEditingController();
  final TextEditingController _receiveCurrencyController =
      TextEditingController();

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
                  SizedBox(
                    height: (400 / Dimensions.designHeight).h,
                    child: Column(
                      children: [
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
                              return BlocBuilder<ShowButtonBloc,
                                  ShowButtonState>(
                                builder: (context, state) {
                                  return VaultAccountCard(
                                    isVault: false,
                                    onTap: () {
                                      final ShowButtonBloc showButtonBloc =
                                          context.read<ShowButtonBloc>();
                                      selectedAccountIndex = index;
                                      senderCurrencyFlag = sendMoneyArgument
                                              .isRetail
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
                                      senderAccountNumber = sendMoneyArgument
                                              .isRetail
                                          ? accountDetails[index]
                                              ["accountNumber"]
                                          : sendMoneyArgument.isBetweenAccounts
                                              ? internalSeedAccounts[index]
                                                  .accountNumber
                                              : sendMoneyArgument.isWithinDhabi
                                                  ? dhabiSeedAccounts[index]
                                                      .accountNumber
                                                  : foreignSeedAccounts[index]
                                                      .accountNumber;
                                      senderCurrency = sendMoneyArgument
                                              .isRetail
                                          ? accountDetails[index]
                                              ["accountCurrency"]
                                          : sendMoneyArgument.isBetweenAccounts
                                              ? internalSeedAccounts[index]
                                                  .currency
                                              : sendMoneyArgument.isWithinDhabi
                                                  ? dhabiSeedAccounts[index]
                                                      .currency
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
                                                  : foreignSeedAccounts[index]
                                                      .bal;
                                      showButtonBloc.add(ShowButtonEvent(
                                          show: selectedAccountIndex == index));
                                    },
                                    title: accountDetails[index]
                                                ["productCode"] ==
                                            "1001"
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
                                        ? accountDetails[index]
                                            ["accountCurrency"]
                                        : sendMoneyArgument.isBetweenAccounts
                                            ? internalSeedAccounts[index]
                                                .currency
                                            : sendMoneyArgument.isWithinDhabi
                                                ? dhabiSeedAccounts[index]
                                                    .currency
                                                : foreignSeedAccounts[index]
                                                    .currency,
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
                                                : foreignSeedAccounts[index]
                                                    .bal,
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
                  Ternary(
                    condition: sendMoneyArgument.isRemittance,
                    truthy: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizeBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DashboardActivityTile(
                              iconPath: ImageConstants.percent,
                              activityText: "Exchange Rates",
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    final ShowButtonBloc showButtonBloc =
                                        context.read<ShowButtonBloc>();
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                (10 / Dimensions.designWidth)
                                                    .w),
                                            topRight: Radius.circular(
                                                (10 / Dimensions.designWidth)
                                                    .w),
                                          ),
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: (PaddingConstants
                                                      .horizontalPadding /
                                                  Dimensions.designWidth)
                                              .w,
                                          vertical:
                                              (PaddingConstants.bottomPadding /
                                                      Dimensions.designHeight)
                                                  .h,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // ! Clip widget for drag
                                            Center(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: (10 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                ),
                                                height:
                                                    (7 / Dimensions.designWidth)
                                                        .w,
                                                width: (50 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular((10 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w),
                                                  ),
                                                  color:
                                                      const Color(0xFFD9D9D9),
                                                ),
                                              ),
                                            ),
                                            const SizeBox(height: 15),
                                            Text(
                                              "1 USD = ",
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                color: AppColors.dark80,
                                                fontSize: (14 /
                                                        Dimensions.designWidth)
                                                    .w,
                                              ),
                                            ),
                                            const SizeBox(height: 15),
                                            CustomTextField(
                                              prefixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    radius: ((19 / 2) /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                    backgroundImage:
                                                        CachedMemoryImageProvider(
                                                      const Uuid().v4(),
                                                      bytes: base64Decode(
                                                          senderCurrencyFlag),
                                                    ),
                                                  ),
                                                  const SizeBox(width: 10),
                                                  Text(
                                                    senderCurrency,
                                                    style: TextStyles
                                                        .primaryMedium
                                                        .copyWith(
                                                      color: AppColors.dark50,
                                                      fontSize: (14 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                    ),
                                                  ),
                                                  const SizeBox(width: 10),
                                                  Text(
                                                    "|",
                                                    style: TextStyles
                                                        .primaryMedium
                                                        .copyWith(
                                                      color: AppColors.dark50,
                                                      fontSize: (14 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                    ),
                                                  ),
                                                  const SizeBox(width: 10),
                                                ],
                                              ),
                                              hintText: "Enter Amount",
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  _sendCurrencyController,
                                              onChanged: (p0) {
                                                _receiveCurrencyController
                                                        .text =
                                                    (double.parse(p0) * 10)
                                                        .toString();
                                              },
                                            ),
                                            const SizeBox(height: 10),
                                            CustomTextField(
                                              enabled: false,
                                              prefixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    radius: ((19 / 2) /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                    backgroundImage:
                                                        CachedMemoryImageProvider(
                                                      const Uuid().v4(),
                                                      bytes: base64Decode(
                                                          senderCurrencyFlag),
                                                    ),
                                                  ),
                                                  const SizeBox(width: 10),
                                                  Text(
                                                    senderCurrency,
                                                    style: TextStyles
                                                        .primaryMedium
                                                        .copyWith(
                                                      color: AppColors.dark50,
                                                      fontSize: (14 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                    ),
                                                  ),
                                                  const SizeBox(width: 10),
                                                  Text(
                                                    "|",
                                                    style: TextStyles
                                                        .primaryMedium
                                                        .copyWith(
                                                      color: AppColors.dark50,
                                                      fontSize: (14 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                    ),
                                                  ),
                                                  const SizeBox(width: 10),
                                                ],
                                              ),
                                              hintText: "0.00",
                                              controller:
                                                  _receiveCurrencyController,
                                              onChanged: (p0) {},
                                            ),
                                            const SizeBox(height: 15),
                                            Container(
                                              width: 100.w,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: PaddingConstants
                                                    .horizontalPadding,
                                                vertical: (10 /
                                                        Dimensions.designHeight)
                                                    .h,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    (10 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                                color: const Color(0XFFD9D9D9),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline_rounded,
                                                    size: (24 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                    color:
                                                        AppColors.primaryDark,
                                                  ),
                                                  const SizeBox(width: 10),
                                                  Text(
                                                    "Rates are indicated and subject to change",
                                                    style: TextStyles
                                                        .primaryMedium
                                                        .copyWith(
                                                      color:
                                                          AppColors.primaryDark,
                                                      fontSize: (16 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizeBox(height: 15),
                                            GradientButton(
                                                onTap: () {},
                                                text: "Get Exchange Rate"),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    falsy: const SizeBox(),
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

  @override
  void dispose() {
    _sendCurrencyController.dispose();
    _receiveCurrencyController.dispose();
    super.dispose();
  }
}
