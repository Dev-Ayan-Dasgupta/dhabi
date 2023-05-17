import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransferAmountScreen extends StatefulWidget {
  const TransferAmountScreen({Key? key}) : super(key: key);

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  final TextEditingController _sendController =
      TextEditingController(text: "0");
  final TextEditingController _receiveController =
      TextEditingController(text: "0");

  final bool isBetweenAccounts = true;
  bool isShowButton = true;
  bool isNotZero = false;
  final double maxBalance = 1000;
  final double exchangeRate = 0.34304;

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
                    "Transfer Amount",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
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
                          CustomTextField(
                            controller: _sendController,
                            onChanged: onSendChanged,
                            keyboardType: TextInputType.number,
                            suffix: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "AED  ",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.black63,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                CustomCircleAvatar(
                                  imgUrl:
                                      "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
                                  width: (23 / Dimensions.designWidth).w,
                                  height: (23 / Dimensions.designWidth).w,
                                ),
                              ],
                            ),
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
                            suffix: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "USD  ",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.black63,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                CustomCircleAvatar(
                                  imgUrl:
                                      "https://t4.ftcdn.net/jpg/05/22/35/01/240_F_522350125_mPLuK4cNT6RNN6bvpuKZpLGjqbJr5EiL.jpg",
                                  width: (23 / Dimensions.designWidth).w,
                                  height: (23 / Dimensions.designWidth).w,
                                ),
                              ],
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
                const SizeBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildYouSend(BuildContext context, ShowButtonState state) {
    return Text(
      !isNotZero ? "You Send" : "You're Sending",
      style: TextStyles.primaryMedium.copyWith(
        color: AppColors.black63,
        fontSize: (16 / Dimensions.designWidth).w,
      ),
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
    if (double.parse(_sendController.text) > maxBalance) {
      isShowButton = false;
      showProceedButtonBloc.add(ShowButtonEvent(show: isShowButton));
    } else {
      isShowButton = true;
      showProceedButtonBloc.add(ShowButtonEvent(show: isShowButton));
    }
    _receiveController.text =
        (double.parse(p0) * exchangeRate).toStringAsFixed(2);
  }

  Widget buildSendError(BuildContext context, ShowButtonState state) {
    return Row(
      children: [
        Ternary(
          condition: isShowButton,
          truthy: const SizeBox(),
          falsy: SvgPicture.asset(
            ImageConstants.errorSolid,
            width: (30 / Dimensions.designWidth).w,
            height: (30 / Dimensions.designHeight).w,
          ),
        ),
        Text(
          isShowButton
              ? "Available to transfer AED 1000"
              : " Insufficient balance",
          style: TextStyles.primaryMedium.copyWith(
            color: isShowButton ? AppColors.dark50 : AppColors.red100,
            fontSize: (15 / Dimensions.designWidth).w,
          ),
        ),
      ],
    );
  }

  Widget buildExchangeRate(BuildContext context, ShowButtonState state) {
    return FeeExchangeRate(
      transferFeeCurrency: "USD",
      transferFee: isShowButton ? 5 : 0,
      exchangeRateSenderCurrency: "USD",
      exchangeRate: isShowButton ? exchangeRate : 0,
      exchangeRateReceiverCurrency: "AED",
    );
  }

  Widget buildYourReceive(BuildContext context, ShowButtonState state) {
    return Text(
      !isNotZero
          ? isBetweenAccounts
              ? "You Receive"
              : "They Receive"
          : isBetweenAccounts
              ? "You will receive"
              : "They will receive",
      style: TextStyles.primaryMedium.copyWith(
        color: AppColors.black63,
        fontSize: (16 / Dimensions.designWidth).w,
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isShowButton && isNotZero) {
      return GradientButton(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.transferConfirmation,
          );
        },
        text: labels[31]["labelText"],
      );
    } else {
      return const SizeBox();
    }
  }

  @override
  void dispose() {
    _sendController.dispose();
    _receiveController.dispose();
    super.dispose();
  }
}
