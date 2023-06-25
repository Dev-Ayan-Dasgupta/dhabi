// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/search_box.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SelectRecipientScreen extends StatefulWidget {
  const SelectRecipientScreen({
    Key? key,
    this.argument,
  }) : super(key: key);
  final Object? argument;
  @override
  State<SelectRecipientScreen> createState() => _SelectRecipientScreenState();
}

class _SelectRecipientScreenState extends State<SelectRecipientScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RecipientModel> recipients = [];
  List<RecipientModel> filteredRecipients = [];

  bool isShowAll = true;

  bool isFetchingBeneficiaries = false;

  Map<String, dynamic> getBeneficiariesApiResult = {};

  bool isFetchingExchangeRate = false;

  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getBeneficiaries();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> getBeneficiaries() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    try {
      isFetchingBeneficiaries = true;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingBeneficiaries));
      getBeneficiariesApiResult =
          await MapGetBeneficiaries.mapGetBeneficiaries(token ?? "");
      log("getBeneficiariesApiResult -> $getBeneficiariesApiResult");

      if (getBeneficiariesApiResult["success"]) {
        recipients.clear();
        for (var beneficiary in getBeneficiariesApiResult["beneficiaries"]) {
          if (beneficiary["beneficiaryType"] == 2) {
            recipients.add(
              RecipientModel(
                beneficiaryId: beneficiary["beneficiaryId"],
                swiftReference: beneficiary["swiftReference"],
                flagImgUrl: beneficiary["countryCodeFlagBase64"],
                name: beneficiary["name"],
                accountNumber: beneficiary["accountNumber"],
                currency: beneficiary["targetCurrency"],
                address: beneficiary["address"],
                accountType: beneficiary["accountType"],
                countryShortCode: beneficiary["countryShortCode"],
                benBankCode: beneficiary["benBankCode"] ?? "",
                benMobileNo: beneficiary["benMobileNo"] ?? "",
                benSubBankCode: beneficiary["benSubBankCode"] ?? "",
                benIdType: beneficiary["benIdType"] ?? "",
                benIdNo: beneficiary["benIdNo"] ?? "",
                benIdExpiryDate: beneficiary["benIdExpiryDate"] ?? "",
                benBankName: beneficiary["benBankName"] ?? "",
                benSwiftCode: beneficiary["benSwiftCodeText"] ?? "",
                benCity: beneficiary["city"] ?? "",
                remittancePurpose: beneficiary["remittancePurpose"] ?? "",
                sourceOfFunds: beneficiary["sourceOfFunds"] ?? "",
                relation: beneficiary["relation"] ?? "",
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Error {200}",
                message: getBeneficiariesApiResult["message"] ??
                    "There was an error fetching your beneficiary details, please try again after some time.",
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
      isFetchingBeneficiaries = false;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingBeneficiaries));
    } catch (_) {
      rethrow;
    }
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
                //  const SizeBox(height: 10),
                Text(
                  labels[172]["labelText"],
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 10),
                Text(
                  labels[173]["labelText"],
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark50,
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 30),
                InkWell(
                  onTap: () {
                    isNewBeneficiary = true;
                    Navigator.pushNamed(
                      context,
                      Routes.selectCountry,
                      arguments: SendMoneyArgumentModel(
                        isBetweenAccounts: sendMoneyArgument.isBetweenAccounts,
                        isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                        isRemittance: sendMoneyArgument.isRemittance,
                      ).toMap(),
                    );
                  },
                  child: Container(
                    width: 100.w,
                    height: (50 / Dimensions.designHeight).h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular((10 / Dimensions.designWidth).w),
                      ),
                      color: Colors.white,
                      boxShadow: [BoxShadows.primary],
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: (16 / Dimensions.designHeight).h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline_outlined,
                          color: AppColors.primary,
                          size: (20 / Dimensions.designWidth).w,
                        ),
                        const SizeBox(width: 10),
                        Text(
                          "Add New Recipient",
                          style: TextStyles.primaryBold.copyWith(
                            color: AppColors.primary,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizeBox(height: 30),
                CustomSearchBox(
                  hintText: labels[174]["labelText"],
                  controller: _searchController,
                  onChanged: onSearchChanged,
                ),
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return Ternary(
                      condition: isFetchingBeneficiaries,
                      truthy: const SizeBox(),
                      falsy: Row(
                        children: [
                          Text(
                            "Search through your ",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.dark50,
                              fontSize: (12 / Dimensions.designWidth).w,
                            ),
                          ),
                          Text(
                            "${recipients.length} ",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark50,
                              fontSize: (12 / Dimensions.designWidth).w,
                            ),
                          ),
                          Text(
                            "International Recipients.",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.dark50,
                              fontSize: (12 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizeBox(height: 20),

                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildRecipientList,
                ),
                const SizeBox(height: 20),
              ],
            ),
          ),
          isFetchingExchangeRate
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCircle(
                        color: AppColors.primary,
                        size: (50 / Dimensions.designWidth).w,
                      ),
                    ],
                  ),
                )
              : const SizeBox(),
        ],
      ),
    );
  }

  void onSearchChanged(String p0) {
    final ShowButtonBloc recipientListBloc = context.read<ShowButtonBloc>();
    searchRecipient(recipients, p0);
    if (p0.isEmpty) {
      isShowAll = true;
    } else {
      isShowAll = false;
    }
    recipientListBloc.add(ShowButtonEvent(show: isShowAll));
  }

  void searchRecipient(List<RecipientModel> recipients, String matcher) {
    filteredRecipients.clear();
    for (RecipientModel recipient in recipients) {
      if (recipient.name.toLowerCase().contains(matcher.toLowerCase())) {
        filteredRecipients.add(recipient);
      }
    }
  }

  Widget buildRecipientList(BuildContext context, ShowButtonState state) {
    return Ternary(
      condition: isFetchingBeneficiaries,
      truthy: Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return const ShimmerSelectRecipientTile();
          },
          separatorBuilder: (context, index) {
            return const SizeBox(height: 10);
          },
          itemCount: 12,
        ),
      ),
      falsy: Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) {
            RecipientModel item =
                isShowAll ? recipients[index] : filteredRecipients[index];

            return RecipientsTile(
              onTap: () async {
                if (!isFetchingExchangeRate) {
                  isFetchingExchangeRate = true;
                  setState(() {});

                  receiverCurrencyFlag = item.flagImgUrl;
                  receiverAccountNumber = item.accountNumber;
                  benCustomerName = item.name;
                  benAddress = item.address;
                  benAccountType = item.accountType.toString();
                  beneficiaryCountryCode = item.countryShortCode;
                  receiverCurrency = item.currency;
                  benBankCode = item.benBankCode;
                  benMobileNo = item.benMobileNo;
                  benSubBankCode = item.benSubBankCode;
                  benIdType = item.benIdType;
                  benIdNo = item.benIdNo;
                  benIdExpiryDate = item.benIdExpiryDate;
                  benBankName = item.benBankName;
                  benSwiftCode = item.benSwiftCode;
                  benCity = item.benCity;
                  remittancePurpose = item.remittancePurpose;
                  sourceOfFunds = item.sourceOfFunds;
                  relation = item.relation;

                  var getExchRateApiResult =
                      await MapExchangeRate.mapExchangeRate(
                    token ?? "",
                  );
                  log("getExchRateApiResult -> $getExchRateApiResult");

                  if (getExchRateApiResult["success"]) {
                    for (var fetchExchangeRate
                        in getExchRateApiResult["fetchExRates"]) {
                      if (fetchExchangeRate["exchangeCurrency"] ==
                          receiverCurrency) {
                        exchangeRate = fetchExchangeRate["exchangeRate"];
                        log("exchangeRate -> $exchangeRate");
                        fees = double.parse(
                            fetchExchangeRate["transferFee"].split(' ').last);
                        log("fees -> $fees");
                        expectedTime = getExchRateApiResult["expectedTime"];
                        break;
                      }
                    }

                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        Routes.transferAmount,
                        arguments: SendMoneyArgumentModel(
                          isBetweenAccounts:
                              sendMoneyArgument.isBetweenAccounts,
                          isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                          isRemittance: sendMoneyArgument.isRemittance,
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
                            message: getExchRateApiResult["message"] ??
                                "There was an error fetching exchange rate, please try again later.",
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

                  isFetchingExchangeRate = false;
                  setState(() {});
                }
              },
              flagImgUrl: item.flagImgUrl,
              name: item.name,
              accountNumber: item.accountNumber,
              currency: item.currency,
              bankName: "State Bank of India",
            );
          },
          separatorBuilder: (context, index) {
            return const SizeBox();
          },
          itemCount: isShowAll ? recipients.length : filteredRecipients.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
