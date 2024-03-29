// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/repositories/configurations/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class AddRecipientDetailsRemittanceScreen extends StatefulWidget {
  const AddRecipientDetailsRemittanceScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<AddRecipientDetailsRemittanceScreen> createState() =>
      _AddRecipientDetailsRemittanceScreenState();
}

class _AddRecipientDetailsRemittanceScreenState
    extends State<AddRecipientDetailsRemittanceScreen> {
  bool isChecked = false;

  bool isFetchingFields = false;

  late SendMoneyArgumentModel sendMoneyArgument;

  Map<String, dynamic> dynamicFields = {};

  List textEditingControllers = [];
  List<List<String>> dropDownLists = [];
  List<int> toggles = [];

  int textEditingControllersAdded = -1;
  // int dropDownListsAdded = -1;
  int togglesAdded = -1;
  int mandatoryFields = 0;
  int mandatorySatisfiedCount = 0;

  int dropDowns = 0;
  int dates = 0;

  int widgetsBuilt = 0;

  bool allValid = false;

  bool isFetchingExchangeRate = false;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getDynamicFields();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
    remittancePurpose = null;
    sourceOfFunds = null;
    relation = null;
  }

  Future<void> getDynamicFields() async {
    try {
      isFetchingFields = true;
      setState(() {});

      dynamicFields = await MapDynamicFields.mapDynamicFields({
        "countryShortCode": beneficiaryCountryCode,
      });
      log("dynamicFields -> $dynamicFields");

      if (dynamicFields["success"]) {
        textEditingControllers.clear();
        dropDownLists.clear();
        for (var field in dynamicFields["dynamicFields"]) {
          // if (field["type"] == "Text") {
          textEditingControllers.add(TextEditingController());
          // } else
          // if (field["type"] == "Dropdown") {
          if (field["dropdownValues"] != null) {
            dropDowns++;
          }
          dropDownLists.add([]);
          // }
        }
        log("dropDownLists length -> $dropDowns");
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry!",
                message: dynamicFields["message"] ??
                    "Error fetching dynamic fields.",
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

      isFetchingFields = false;
      setState(() {});
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
                    labels[194]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Ternary(
                    condition: isFetchingFields,
                    truthy: Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return const ShimmerAddRecipientDetailsTile();
                        },
                        separatorBuilder: (context, index) {
                          return const SizeBox(height: 10);
                        },
                        itemCount: 10,
                      ),
                    ),
                    falsy: Expanded(
                      child: ListView.builder(
                        itemCount: dynamicFields["dynamicFields"]?.length,
                        itemBuilder: (context, index) {
                          if (widgetsBuilt ==
                              dynamicFields["dynamicFields"]?.length) {
                            widgetsBuilt = 0;
                            textEditingControllersAdded = -1;
                            // dropDownListsAdded = -1;
                            togglesAdded = -1;
                          }
                          // if (dynamicFields["dynamicFields"][index]["type"] ==
                          // "Text") {
                          textEditingControllersAdded++;
                          log("textEditingControllersAdded -> $textEditingControllersAdded");
                          // } else
                          // if (dynamicFields["dynamicFields"][index]["type"] ==
                          //     "Dropdown") {
                          toggles.add(0);
                          togglesAdded++;
                          // dropDownListsAdded++;
                          // dropDownLists.add([]);
                          dropDownLists[index].clear();
                          // log("dropDownListsAdded -> $dropDownListsAdded");

                          if (dynamicFields["dynamicFields"][index]
                                  ["dropdownValues"] !=
                              null) {
                            jsonDecode(dynamicFields["dynamicFields"][index]
                                        ["dropdownValues"]
                                    .replaceAll('\\', ''))
                                .forEach((key, value) =>
                                    dropDownLists[index].add(value));
                          } else {}

                          // }

                          if (dynamicFields["dynamicFields"][index]
                              ["isManadatory"]) {
                            mandatoryFields++;

                            widgetsBuilt++;
                            log("widgetsBuilt -> $widgetsBuilt");
                          }

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    dynamicFields["dynamicFields"][index]
                                        ["label"],
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: AppColors.dark80,
                                      fontSize: (14 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                  dynamicFields["dynamicFields"][index]
                                          ["isManadatory"]
                                      ? const Asterisk()
                                      : const SizeBox(),
                                ],
                              ),
                              const SizeBox(height: 7),
                              dynamicFields["dynamicFields"][index]["type"] ==
                                      "Text"
                                  ? CustomTextField(
                                      controller: textEditingControllers[index],
                                      // maxLength: dynamicFields["dynamicFields"]
                                      //     [index]["maxLength"],
                                      onChanged: (p0) {
                                        final ShowButtonBloc showButtonBloc =
                                            context.read<ShowButtonBloc>();
                                        mapControllerToFieldId(index, p0);
                                        if (dynamicFields["dynamicFields"]
                                            [index]["isManadatory"]) {
                                          for (var i = 0;
                                              i <
                                                  dynamicFields["dynamicFields"]
                                                      .length;
                                              i++) {
                                            if (textEditingControllers[i]
                                                        .text
                                                        .length <
                                                    dynamicFields[
                                                            "dynamicFields"][i]
                                                        ["minLength"] ||
                                                textEditingControllers[i]
                                                        .text
                                                        .length >
                                                    dynamicFields[
                                                            "dynamicFields"][i]
                                                        ["maxLength"]) {
                                              allValid = false;
                                              break;
                                            }
                                            allValid = true;
                                          }
                                          // if (p0.length == 1) {
                                          //   mandatorySatisfiedCount++;
                                          //   log("mandatorySatisfiedCount -> $mandatorySatisfiedCount");
                                          // } else if (p0.length <
                                          //     dynamicFields["dynamicFields"]
                                          //         [index]["minLength"]) {
                                          //   mandatorySatisfiedCount--;
                                          //   log("mandatorySatisfiedCount -> $mandatorySatisfiedCount");
                                          // }
                                        }

                                        showButtonBloc.add(
                                            const ShowButtonEvent(show: true));
                                      },
                                      hintText: dynamicFields["dynamicFields"]
                                          [index]["label"],
                                    )
                                  : dynamicFields["dynamicFields"][index]
                                              ["type"] ==
                                          "Dropdown"
                                      ? BlocBuilder<DropdownSelectedBloc,
                                          DropdownSelectedState>(
                                          builder: (context, state) {
                                            return CustomDropDown(
                                              title:
                                                  dynamicFields["dynamicFields"]
                                                      [index]["label"],
                                              items: dropDownLists[index],
                                              value: dynamicFields[
                                                              "dynamicFields"]
                                                          [index]["fieldId"] ==
                                                      "RemittancePurpose"
                                                  ? remittancePurpose
                                                  : dynamicFields["dynamicFields"]
                                                                  [index]
                                                              ["fieldId"] ==
                                                          "SourceOfFunds"
                                                      ? sourceOfFunds
                                                      : relation,
                                              onChanged: (value) {
                                                final ShowButtonBloc
                                                    showButtonBloc = context
                                                        .read<ShowButtonBloc>();
                                                if (remittancePurpose == null ||
                                                    sourceOfFunds == null ||
                                                    relation == null) {
                                                  mandatorySatisfiedCount++;
                                                }
                                                log("mandatorySatisfiedCount -> $mandatorySatisfiedCount");
                                                toggles[togglesAdded]++;
                                                mapDropdowntoFieldId(
                                                    value, index);

                                                setState(() {});
                                                showButtonBloc.add(
                                                    const ShowButtonEvent(
                                                        show: true));
                                              },
                                            );
                                          },
                                        )
                                      : const SizeBox(),
                              const SizeBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizeBox(height: 10),
                Row(
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: (context, state) {
                        if (isChecked) {
                          return InkWell(
                            onTap: () {
                              isChecked = false;
                              isAddRemBeneficiary = isChecked;
                              triggerCheckBoxEvent(isChecked);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  (5 / Dimensions.designWidth).w),
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
                              isAddRemBeneficiary = isChecked;
                              triggerCheckBoxEvent(isChecked);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  (5 / Dimensions.designWidth).w),
                              child: SvgPicture.asset(
                                ImageConstants.uncheckedBox,
                                width: (14 / Dimensions.designWidth).w,
                                height: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizeBox(width: 5),
                    Text(
                      labels[126]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF414141),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (allValid &&
                        mandatorySatisfiedCount == (dropDowns + dates)) {
                      return GradientButton(
                        onTap: () async {
                          if (!isFetchingExchangeRate) {
                            final ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isFetchingExchangeRate = true;
                            showButtonBloc.add(
                                ShowButtonEvent(show: isFetchingExchangeRate));

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
                                  exchangeRate =
                                      fetchExchangeRate["exchangeRate"]
                                          .toDouble();
                                  log("exchangeRate -> $exchangeRate");
                                  fees = double.parse(
                                      fetchExchangeRate["transferFee"]
                                          .split(' ')
                                          .last);
                                  log("fees -> $fees");
                                  expectedTime =
                                      getExchRateApiResult["expectedTime"];
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
                                    isWithinDhabi:
                                        sendMoneyArgument.isWithinDhabi,
                                    isRemittance:
                                        sendMoneyArgument.isRemittance,
                                    isRetail: sendMoneyArgument.isRetail,
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
                                      message: getExchRateApiResult[
                                              "message"] ??
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
                            showButtonBloc.add(
                                ShowButtonEvent(show: isFetchingExchangeRate));
                          }
                        },
                        text: labels[127]["labelText"],
                        auxWidget: isFetchingExchangeRate
                            ? const LoaderRow()
                            : const SizeBox(),
                      );
                    } else {
                      return SolidButton(
                        onTap: () {},
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

  void mapControllerToFieldId(int indx, String p0) {
    switch (dynamicFields["dynamicFields"][indx]["fieldId"]) {
      case "BenBankName":
        benBankName = p0;
        log("benBankName -> $benBankName");
        break;
      case "BenAccountNo":
        receiverAccountNumber = p0;
        log("receiverAccountNumber -> $receiverAccountNumber");
        break;
      case "BenBankCode":
        benBankCode = p0;
        log("benBankCode -> $benBankCode");
        break;
      case "BenSubBankCode":
        benSubBankCode = p0;
        log("benSubBankCode -> $benSubBankCode");
        break;
      case "BenCustomerName":
        benCustomerName = p0;
        log("benCustomerName -> $benCustomerName");
        break;
      case "Address":
        benAddress = p0;
        log("benAddress -> $benAddress");
        break;
      case "City":
        benCity = p0;
        log("benCity -> $benCity");
        break;
      case "SwiftCode":
        benSwiftCode = p0;
        log("benSwiftCode -> $benSwiftCode");
        break;
      default:
    }
  }

  void mapDropdowntoFieldId(Object? val, int indx) {
    switch (dynamicFields["dynamicFields"][indx]["fieldId"]) {
      case "RemittancePurpose":
        remittancePurpose = val as String;
        log("remittancePurpose -> $remittancePurpose");
        break;
      case "SourceOfFunds":
        sourceOfFunds = val as String;
        log("sourceOfFunds -> $sourceOfFunds");
        break;
      case "Relation":
        relation = val as String;
        log("relation -> $relation");
        break;
      default:
    }
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  @override
  void dispose() {
    remittancePurpose = null;
    sourceOfFunds = null;
    relation = null;
    super.dispose();
  }
}
