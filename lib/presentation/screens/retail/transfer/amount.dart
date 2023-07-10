// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/dropdown_currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:uuid/uuid.dart';

class TransferAmountScreen extends StatefulWidget {
  const TransferAmountScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  final TextEditingController _sendController =
      TextEditingController(text: "0.00");
  final TextEditingController _receiveController = TextEditingController();

  bool isShowButton = true;
  bool isNotZero = false;

  String? selectedBearerReason;
  bool isBearerTypeSelected = false;

  Color borderColor = const Color(0XFFEEEEEE);

  DropDownCountriesModel selectedCurrency = DropDownCountriesModel(
    countryFlagBase64: receiverCurrencies[0].countryFlagBase64,
    countrynameOrCode: receiverCurrencies[0].countrynameOrCode,
  );

  int initLength = 4;

  bool isFetchingExchangeRate = false;

  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
    // exchangeRate = sendMoneyArgument.isBetweenAccounts ? 1 : 0.5;
    // fees = sendMoneyArgument.isBetweenAccounts ? 0 : 5;
    log("receiverCurrency -> $receiverCurrency");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          InkWell(
            onTap: () {
              if (sendMoneyArgument.isBetweenAccounts) {
                Navigator.pop(context);
                Navigator.pop(context);
              } else if (sendMoneyArgument.isWithinDhabi) {
                if (isNewWithinDhabiBeneficiary) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              } else {
                if (isNewRemittanceBeneficiary) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              }
            },
            child: Padding(
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
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labels[158]["labelText"],
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.primary,
                          fontSize: (28 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 10),
                      Text(
                        "Please fill the details below",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizeBox(height: 10),
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: buildYouSend,
                              ),
                              const SizeBox(height: 10),
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: (context, state) {
                                  return CustomTextField(
                                    borderColor: borderColor,
                                    hintText: "0",
                                    controller: _sendController,
                                    onChanged: onSendChanged,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "$senderCurrency  ",
                                          style:
                                              TextStyles.primaryMedium.copyWith(
                                            color: AppColors.black63,
                                            fontSize:
                                                (16 / Dimensions.designWidth).w,
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: ((23 / 2) /
                                                  Dimensions.designWidth)
                                              .w,
                                          backgroundImage:
                                              CachedMemoryImageProvider(
                                            const Uuid().v4(),
                                            bytes: base64Decode(
                                                senderCurrencyFlag),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizeBox(height: 7),
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: buildSendError,
                              ),
                              const SizeBox(height: 10),
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: buildExchangeRate,
                              ),
                              const SizeBox(height: 10),
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: buildYourReceive,
                              ),
                              const SizeBox(height: 10),
                              Stack(
                                children: [
                                  CustomTextField(
                                    controller: _receiveController,
                                    hintText: "0",
                                    onChanged: (p0) {},
                                    enabled: false,
                                    suffixIcon: Ternary(
                                      condition: receiverCurrencies.length > 1,
                                      truthy: const SizeBox(),
                                      falsy: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "$receiverCurrency  ",
                                            style: TextStyles.primaryMedium
                                                .copyWith(
                                              color: AppColors.black63,
                                              fontSize:
                                                  (16 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: ((23 / 2) /
                                                    Dimensions.designWidth)
                                                .w,
                                            backgroundImage:
                                                CachedMemoryImageProvider(
                                              const Uuid().v4(),
                                              bytes: base64Decode(
                                                  receiverCurrencyFlag),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: (7 / Dimensions.designWidth).w,
                                    right: (20 / Dimensions.designWidth).w,
                                    child: Ternary(
                                      condition: receiverCurrencies.length > 1,
                                      truthy: SizedBox(
                                        width: 12.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            CustomDropdownCurrencies(
                                              title: "",
                                              items: receiverCurrencies,
                                              value: selectedCurrency,
                                              onChanged: (value) async {
                                                if (!isFetchingExchangeRate) {
                                                  selectedCurrency = value
                                                      as DropDownCountriesModel;
                                                  for (var i = 0;
                                                      i <
                                                          receiverCurrencies
                                                              .length;
                                                      i++) {
                                                    if (selectedCurrency
                                                            .countrynameOrCode ==
                                                        receiverCurrencies[i]
                                                            .countrynameOrCode) {
                                                      receiverCurrency =
                                                          selectedCurrency
                                                              .countrynameOrCode!;
                                                      break;
                                                    }
                                                  }

                                                  isFetchingExchangeRate = true;
                                                  setState(() {
                                                    log("isFetchingExchangeRate -> $isFetchingExchangeRate");
                                                  });

                                                  var getExchRateApiResult =
                                                      await MapExchangeRate
                                                          .mapExchangeRate(
                                                    token ?? "",
                                                  );
                                                  log("getExchRateApiResult -> $getExchRateApiResult");

                                                  if (getExchRateApiResult[
                                                      "success"]) {
                                                    for (var fetchExchangeRate
                                                        in getExchRateApiResult[
                                                            "fetchExRates"]) {
                                                      if (fetchExchangeRate[
                                                              "exchangeCurrency"] ==
                                                          receiverCurrency) {
                                                        exchangeRate =
                                                            fetchExchangeRate[
                                                                    "exchangeRate"]
                                                                .toDouble();
                                                        log("exchangeRate -> $exchangeRate");
                                                        fees = double.parse(
                                                            fetchExchangeRate[
                                                                    "transferFee"]
                                                                .split(' ')
                                                                .last);
                                                        log("fees -> $fees");
                                                        expectedTime =
                                                            getExchRateApiResult[
                                                                "expectedTime"];
                                                        break;
                                                      }
                                                    }
                                                  } else {
                                                    if (context.mounted) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CustomDialog(
                                                            svgAssetPath:
                                                                ImageConstants
                                                                    .warning,
                                                            title: "Sorry!",
                                                            message: getExchRateApiResult[
                                                                    "message"] ??
                                                                "There was an error fetching exchange rate, please try again later.",
                                                            actionWidget:
                                                                GradientButton(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              text: labels[346]
                                                                  ["labelText"],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }

                                                  _receiveController
                                                      .text = _sendController
                                                          .text.isNotEmpty
                                                      ? (double.parse(
                                                                  _sendController
                                                                      .text) *
                                                              exchangeRate)
                                                          .toStringAsFixed(2)
                                                      : "";
                                                  senderAmount = _sendController
                                                          .text.isNotEmpty
                                                      ? double.parse(
                                                          _sendController.text)
                                                      : 0;
                                                  receiverAmount =
                                                      _sendController
                                                              .text.isNotEmpty
                                                          ? double.parse(
                                                              _receiveController
                                                                  .text)
                                                          : 0;

                                                  isFetchingExchangeRate =
                                                      false;
                                                  setState(() {
                                                    log("isFetchingExchangeRate -> $isFetchingExchangeRate");
                                                  });
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      falsy: const SizeBox(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizeBox(height: 7),
                              Text(
                                !(sendMoneyArgument.isRemittance)
                                    ? "Expected arrival today"
                                    : expectedTime,
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark50,
                                  fontSize: (12 / Dimensions.designWidth).w,
                                ),
                              ),
                              const SizeBox(height: 10),
                              Ternary(
                                condition: sendMoneyArgument.isRemittance,
                                truthy: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          labels[199]["labelText"],
                                          style:
                                              TextStyles.primaryMedium.copyWith(
                                            color: AppColors.dark80,
                                            fontSize:
                                                (14 / Dimensions.designWidth).w,
                                          ),
                                        ),
                                        const Asterisk(),
                                      ],
                                    ),
                                    const SizeBox(height: 10),
                                    BlocBuilder<ShowButtonBloc,
                                        ShowButtonState>(
                                      builder: (context, state) {
                                        return CustomDropDown(
                                          title: "Select who bears charges",
                                          items: const ["I Bear Charges"],
                                          value: selectedBearerReason,
                                          onChanged: (value) {
                                            final ShowButtonBloc
                                                showButtonBloc =
                                                context.read<ShowButtonBloc>();
                                            isBearerTypeSelected = true;
                                            selectedBearerReason =
                                                value as String;
                                            if (selectedBearerReason ==
                                                "I Bear Charges") {
                                              isSenderBearCharges = true;
                                            } else {
                                              isSenderBearCharges = false;
                                            }
                                            showButtonBloc.add(ShowButtonEvent(
                                                show: isBearerTypeSelected));
                                          },
                                        );
                                      },
                                    ),
                                    const SizeBox(height: 7),
                                    Text(
                                      "Receiver bearing or sharing charges will be applied only in case of feasibility.",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.dark50,
                                        fontSize:
                                            (12 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                                falsy: const SizeBox(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    const SizeBox(height: 10),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: buildSubmitButton,
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
          Ternary(
            condition: isFetchingExchangeRate,
            falsy: const SizeBox(),
            truthy: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(
                    color: AppColors.primary,
                    size: (50 / Dimensions.designWidth).w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildYouSend(BuildContext context, ShowButtonState state) {
    return Row(
      children: [
        Text(
          !isNotZero ? labels[159]["labelText"] : "You're sending",
          style: TextStyles.primaryMedium.copyWith(
            color: AppColors.dark80,
            fontSize: (14 / Dimensions.designWidth).w,
          ),
        ),
        const Asterisk(),
      ],
    );
  }

  void onSendChanged(String p0) {
    final ShowButtonBloc showProceedButtonBloc = context.read<ShowButtonBloc>();
    final ShowButtonBloc toggleCaptionsBloc = context.read<ShowButtonBloc>();

    if (_sendController.text.length < initLength) {
      _sendController.text =
          (double.parse(_sendController.text) / 10).toStringAsFixed(2);
      _sendController.selection = TextSelection.fromPosition(
          TextPosition(offset: _sendController.text.length));
      _receiveController.text =
          (double.parse(_sendController.text) * exchangeRate)
              .toStringAsFixed(2);
    } else {
      _sendController.text =
          (double.parse(_sendController.text) * 10).toStringAsFixed(2);
      _sendController.selection = TextSelection.fromPosition(
          TextPosition(offset: _sendController.text.length));
      _receiveController.text =
          (double.parse(_sendController.text) * exchangeRate)
              .toStringAsFixed(2);
    }

    initLength = _sendController.text.length;

    if (_sendController.text.isEmpty ||
        double.parse(_sendController.text) == 0 ||
        _sendController.text == "0.00") {
      if (_sendController.text.isEmpty) {
        _receiveController.clear();
      }
      isNotZero = false;
      toggleCaptionsBloc.add(ShowButtonEvent(show: isNotZero));
    } else {
      isNotZero = true;
      toggleCaptionsBloc.add(ShowButtonEvent(show: isNotZero));
    }
    if (isWalletSelected) {
      if (double.parse(_sendController.text) > 10000) {
        isShowButton = false;
        borderColor = AppColors.red100;
        showProceedButtonBloc.add(ShowButtonEvent(show: isShowButton));
      }
    }
    if (double.parse(_sendController.text) > senderBalance) {
      // ! abs()
      isShowButton = false;
      borderColor = AppColors.red100;
      showProceedButtonBloc.add(ShowButtonEvent(show: isShowButton));
    } else {
      isShowButton = true;
      borderColor = const Color(0XFFEEEEEE);
      showProceedButtonBloc.add(ShowButtonEvent(show: isShowButton));
    }

    senderAmount = double.parse(_sendController.text);
    receiverAmount = double.parse(_receiveController.text);
  }

  Widget buildSendError(BuildContext context, ShowButtonState state) {
    return Row(
      children: [
        Ternary(
          condition: isShowButton,
          truthy: const SizeBox(),
          falsy: SvgPicture.asset(
            ImageConstants.errorSolid,
            width: (20 / Dimensions.designWidth).w,
            height: (20 / Dimensions.designHeight).w,
          ),
        ),
        Text(
          isShowButton
              ? "Available to transfer $senderCurrency ${isWalletSelected ? senderBalance > 10000 ? 10000 : senderBalance : senderBalance}"
              : " ${messages[11]["messageText"]}",
          style: TextStyles.primaryMedium.copyWith(
            color: isShowButton ? AppColors.dark50 : AppColors.red100,
            fontSize: (12 / Dimensions.designWidth).w,
          ),
        ),
      ],
    );
  }

  Widget buildExchangeRate(BuildContext context, ShowButtonState state) {
    return FeeExchangeRate(
      transferFeeCurrency: senderCurrency,
      transferFee: sendMoneyArgument.isRemittance ? fees : 0,
      exchangeRateSenderCurrency: senderCurrency,
      exchangeRate: exchangeRate,
      exchangeRateReceiverCurrency: receiverCurrency,
    );
  }

  Widget buildYourReceive(BuildContext context, ShowButtonState state) {
    return Row(
      children: [
        Text(
          !isNotZero
              ? sendMoneyArgument.isBetweenAccounts
                  ? labels[163]["labelText"]
                  : labels[198]["labelText"]
              : sendMoneyArgument.isBetweenAccounts
                  ? "You will receive"
                  : "They will receive",
          style: TextStyles.primaryMedium.copyWith(
            color: AppColors.dark80,
            fontSize: (14 / Dimensions.designWidth).w,
          ),
        ),
        // const Asterisk(),
      ],
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isShowButton && isNotZero) {
      if (sendMoneyArgument.isRemittance) {
        if (isBearerTypeSelected) {
          return GradientButton(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.transferConfirmation,
                arguments: SendMoneyArgumentModel(
                  isBetweenAccounts: sendMoneyArgument.isBetweenAccounts,
                  isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                  isRemittance: sendMoneyArgument.isRemittance,
                  isRetail: sendMoneyArgument.isRetail,
                ).toMap(),
              );
            },
            text: labels[127]["labelText"],
          );
        } else {
          return SolidButton(
            onTap: () {},
            text: labels[127]["labelText"],
          );
        }
      } else {
        return GradientButton(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.transferConfirmation,
              arguments: SendMoneyArgumentModel(
                isBetweenAccounts: sendMoneyArgument.isBetweenAccounts,
                isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                isRemittance: sendMoneyArgument.isRemittance,
                isRetail: sendMoneyArgument.isRetail,
              ).toMap(),
            );
          },
          text: labels[127]["labelText"],
        );
      }
    } else {
      return SolidButton(
        onTap: () {},
        text: labels[127]["labelText"],
      );
    }
  }

  @override
  void dispose() {
    _sendController.dispose();
    _receiveController.dispose();
    super.dispose();
  }
}
