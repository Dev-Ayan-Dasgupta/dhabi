// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/recent_transfers_tile.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final DraggableScrollableController _dsController =
      DraggableScrollableController();

  late SendMoneyArgumentModel sendMoneyArgument;

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
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labels[9]["labelText"],
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
                TopicTile(
                  onTap: () {
                    receiverCurrencies.clear();
                    receiverCurrencies.add(DropDownCountriesModel(
                        countrynameOrCode: "", countryFlagBase64: ""));
                    Navigator.pushNamed(
                      context,
                      Routes.sendMoneyFrom,
                      arguments: SendMoneyArgumentModel(
                        isBetweenAccounts: true,
                        isWithinDhabi: false,
                        isRemittance: false,
                        isRetail: sendMoneyArgument.isRetail,
                      ).toMap(),
                    );
                  },
                  iconPath: ImageConstants.moveDown,
                  text: labels[149]["labelText"],
                ),
                const SizeBox(height: 10),
                TopicTile(
                  onTap: () {
                    receiverCurrencies.clear();
                    receiverCurrencies.add(DropDownCountriesModel(
                        countrynameOrCode: "", countryFlagBase64: ""));
                    Navigator.pushNamed(
                      context,
                      Routes.sendMoneyFrom,
                      arguments: SendMoneyArgumentModel(
                        isBetweenAccounts: false,
                        isWithinDhabi: true,
                        isRemittance: false,
                        isRetail: sendMoneyArgument.isRetail,
                      ).toMap(),
                    );
                  },
                  iconPath: ImageConstants.accountBalance,
                  text: labels[150]["labelText"],
                ),
                const SizeBox(height: 10),
                // TopicTile(
                //   onTap: () {
                //     Navigator.pushNamed(context, Routes.addRecipDetUae);
                //   },
                //   iconPath: ImageConstants.flagCircle,
                //   text: labels[151]["labelText"],
                // ),
                // const SizeBox(height: 10),
                TopicTile(
                  onTap: () {
                    receiverCurrencies.clear();
                    receiverCurrencies.add(DropDownCountriesModel(
                        countrynameOrCode: "", countryFlagBase64: ""));
                    Navigator.pushNamed(
                      context,
                      Routes.sendMoneyFrom,
                      arguments: SendMoneyArgumentModel(
                        isBetweenAccounts: false,
                        isWithinDhabi: false,
                        isRemittance: true,
                        isRetail: sendMoneyArgument.isRetail,
                      ).toMap(),
                    );
                  },
                  iconPath: ImageConstants.public,
                  text: labels[152]["labelText"],
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.50,
            minChildSize: 0.50,
            maxChildSize: 1,
            controller: _dsController,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: [
                  Container(
                    height: 90.h,
                    width: 100.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: (PaddingConstants.horizontalPadding /
                              Dimensions.designWidth)
                          .w,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: const Color(0XFFEEEEEE)),
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular((20 / Dimensions.designWidth).w),
                        topRight:
                            Radius.circular((20 / Dimensions.designWidth).w),
                      ),
                      color: const Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        const SizeBox(height: 15),
                        // ! Clip widget for drag
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: (10 / Dimensions.designWidth).w,
                          ),
                          height: (7 / Dimensions.designWidth).w,
                          width: (50 / Dimensions.designWidth).w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular((10 / Dimensions.designWidth).w),
                            ),
                            color: const Color(0xFFD9D9D9),
                          ),
                        ),
                        const SizeBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              labels[10]["labelText"],
                              style: TextStyles.primary.copyWith(
                                color: AppColors.dark50,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                          ],
                        ),
                        const SizeBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: 50,
                            itemBuilder: (context, index) {
                              return RecentTransferTile(
                                onTap: () {},
                                iconPath: ImageConstants.accountBalance,
                                name: "Sanjay Talreja",
                                status: "Pending",
                                amount: 50000,
                                currency: "AED",
                                accountNumber: "5040098712342534",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
