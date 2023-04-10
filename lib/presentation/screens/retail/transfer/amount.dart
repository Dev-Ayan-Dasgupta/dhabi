import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

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
              "Cancel",
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
      body: GestureDetector(
        onTap: () {
          if (_sendController.text.isEmpty) {
            _sendController.text = "0";
          }
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (22 / Dimensions.designWidth).w,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizeBox(height: 10),
                    Text(
                      "Transfer Amount",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    Text(
                      "You Send",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF636363),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 10),
                    CustomTextField(
                      controller: _sendController,
                      onChanged: (p0) {},
                      keyboardType: TextInputType.number,
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "AED  ",
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0XFF636363),
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
                    Text(
                      "Available to transfer AED 1000",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF818181),
                        fontSize: (15 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 10),
                    const FeeExchangeRate(
                      transferFeeCurrency: "USD",
                      transferFee: 5,
                      exchangeRateSenderCurrency: "USD",
                      exchangeRate: 0.34304,
                      exchangeRateReceiverCurrency: "AED",
                    ),
                    const SizeBox(height: 10),
                    Text(
                      "You Receive",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF636363),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 10),
                    CustomTextField(
                      controller: _sendController,
                      onChanged: (p0) {},
                      enabled: false,
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "USD  ",
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0XFF636363),
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
                  ],
                ),
              ),
              Column(
                children: [
                  GradientButton(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.transferConfirmation,
                        );
                      },
                      text: "Proceed"),
                  const SizeBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sendController.dispose();
    _receiveController.dispose();
    super.dispose();
  }
}
