// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
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
      TextEditingController(text: "0");
  final TextEditingController _receiveController =
      TextEditingController(text: "0");

  bool isShowButton = true;
  bool isNotZero = false;

  // double exchangeRate = 0.34304;

  Color borderColor = const Color(0XFFEEEEEE);

  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
    exchangeRate = sendMoneyArgument.isBetweenAccounts ? 1 : 0.5;
    fees = sendMoneyArgument.isBetweenAccounts ? 0 : 5;
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
          ),
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
                                controller: _sendController,
                                onChanged: onSendChanged,
                                keyboardType: TextInputType.number,
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "$senderCurrency  ",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.black63,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    // CustomCircleAvatarMemory(
                                    //   bytes: ,
                                    //   width: (23 / Dimensions.designWidth).w,
                                    //   height: (23 / Dimensions.designWidth).w,
                                    // ),
                                    CircleAvatar(
                                      radius:
                                          ((23 / 2) / Dimensions.designWidth).w,
                                      backgroundImage:
                                          CachedMemoryImageProvider(
                                        const Uuid().v4(),
                                        bytes: base64Decode(senderCurrencyFlag),
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
                          CustomTextField(
                            controller: _receiveController,
                            onChanged: (p0) {},
                            enabled: false,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "$receiverCurrency  ",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.black63,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                // CustomCircleAvatarAsset(
                                //   imgUrl:
                                //       "https://t4.ftcdn.net/jpg/05/22/35/01/240_F_522350125_mPLuK4cNT6RNN6bvpuKZpLGjqbJr5EiL.jpg",
                                //   width: (23 / Dimensions.designWidth).w,
                                //   height: (23 / Dimensions.designWidth).w,
                                // ),
                                CircleAvatar(
                                  radius: ((23 / 2) / Dimensions.designWidth).w,
                                  backgroundImage: CachedMemoryImageProvider(
                                    const Uuid().v4(),
                                    bytes: base64Decode(receiverCurrencyFlag),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizeBox(height: 7),
                          Text(
                            sendMoneyArgument.isBetweenAccounts
                                ? "Expected arrival today"
                                : "some text",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.dark50,
                              fontSize: (12 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 10),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
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
    if (_sendController.text.isEmpty ||
        double.parse(_sendController.text) == 0) {
      isNotZero = false;
      toggleCaptionsBloc.add(ShowButtonEvent(show: isNotZero));
    } else {
      isNotZero = true;
      toggleCaptionsBloc.add(ShowButtonEvent(show: isNotZero));
    }
    if (double.parse(_sendController.text) > senderBalance) {
      isShowButton = false;
      borderColor = AppColors.red100;
      showProceedButtonBloc.add(ShowButtonEvent(show: isShowButton));
    } else {
      isShowButton = true;
      borderColor = const Color(0XFFEEEEEE);
      showProceedButtonBloc.add(ShowButtonEvent(show: isShowButton));
    }
    _receiveController.text =
        (double.parse(p0) * exchangeRate).toStringAsFixed(2);
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
              ? "Available to transfer $senderCurrency $senderBalance"
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
      transferFee: fees,
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
        const Asterisk(),
      ],
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isShowButton && isNotZero) {
      return GradientButton(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.transferConfirmation,
            arguments: SendMoneyArgumentModel(
              isBetweenAccounts: sendMoneyArgument.isBetweenAccounts,
              isWithinDhabi: sendMoneyArgument.isWithinDhabi,
              isRemittance: sendMoneyArgument.isRemittance,
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
  }

  @override
  void dispose() {
    _sendController.dispose();
    _receiveController.dispose();
    super.dispose();
  }
}
