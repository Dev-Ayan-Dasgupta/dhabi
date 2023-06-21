// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_bloc.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_event.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/index.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_bloc.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_event.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/corporateAccounts/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/tabs/tab.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

List fdSeedAccounts = [];

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen>
    with SingleTickerProviderStateMixin {
  late RetailDashboardArgumentModel retailDashboardArgumentModel;

  late TabController tabController;
  int tabIndex = 0;

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  int _scrollIndex = 0;

  Map<String, dynamic> corpCustPermApiResult = {};

  List statementList = [];
  List displayStatementList = [];
  List fdStatementList = [];
  List displayFdStatementList = [];

  int savingsAccountCount = 0;
  int currentAccountCount = 0;
  List depositDetails = [];

  List<DetailsTileModel> rates = [];

  bool isShowFilter = false;
  bool isShowSort = false;
  bool isShowDepositFilter = false;
  bool isShowDepositSort = false;

  bool isAllSelected = false;
  bool isSentSelected = false;
  bool isReceivedSelected = false;

  bool isDateNewest = true;
  bool isDateOldest = false;
  bool isAmountHighest = false;
  bool isAmountLowest = false;
  bool isFdDateNewest = true;
  bool isFdDateOldest = false;
  bool isFdAmountHighest = false;
  bool isFdAmountLowest = false;

  String filterText = "All";
  String sortText = "Latest";
  String filterTextFD = "All";
  String sortTextFD = "Latest";

  bool isChangingAccount = false;

  bool isShowExplore = false;

  bool isFetchingAccountDetails = false;

  @override
  void initState() {
    super.initState();
    getApiData();
    argumentInitialization();
    tabbarInitialization();
  }

  void argumentInitialization() {
    retailDashboardArgumentModel =
        RetailDashboardArgumentModel.fromMap(widget.argument as dynamic ?? {});
    if (retailDashboardArgumentModel.isFirst && !persistBiometric!) {
      Future.delayed(const Duration(seconds: 1), promptBiometricSettings);
    }
  }

  void tabbarInitialization() {
    final TabbarBloc tabbarBloc = context.read<TabbarBloc>();
    tabController = TabController(length: 4, vsync: this);
    tabController.animation!.addListener(() {
      // print(
      //     "tabController animation value -> ${tabController.animation!.value}");
      // print(
      //     "tabController animation value round -> ${tabController.animation!.value.round()}");
      // print("tabIndex -> $tabIndex");
      // if (tabIndex != tabController.animation!.value) {
      //   tabIndex = tabController.animation!.value.round();
      //   tabbarBloc.add(TabbarEvent(index: tabIndex));
      // }

      if (tabController.indexIsChanging ||
          tabController.index != tabController.previousIndex) {
        tabIndex = tabController.index;
        tabbarBloc.add(TabbarEvent(index: tabIndex));
        _scrollOffset = 0;
        _scrollIndex = 0;
      }
    });
    _scrollController.addListener(() {
      _scrollOffset = _scrollController.offset + 120;
      _scrollIndex = _scrollOffset ~/ 188;

      final SummaryTileBloc summaryTileBloc = context.read<SummaryTileBloc>();
      summaryTileBloc.add(SummaryTileEvent(scrollIndex: _scrollIndex));
    });
  }

  void promptBiometricSettings() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warningGreen,
          title: messages[99]["messageText"],
          message:
              "Enhance Security with Biometric Authentication! You can enable/disable biometric authentication anytime by going to the profile menu.",
          actionWidget: SolidButton(
            onTap: () async {
              await storage.write(
                  key: "persistBiometric", value: false.toString());
              persistBiometric =
                  await storage.read(key: "persistBiometric") == "true";
              if (context.mounted) {
                Navigator.pop(context);
                showBiometricLater();
              }
            },
            text: labels[127]["labelText"],
            color: AppColors.primaryBright17,
            fontColor: AppColors.primary,
          ),
          auxWidget: GradientButton(
            onTap: () async {
              await storage.write(
                  key: "persistBiometric", value: true.toString());
              persistBiometric =
                  await storage.read(key: "persistBiometric") == "true";
              if (context.mounted) {
                Navigator.pop(context);
                showBiometricSuccess();
              }
            },
            text: "Enable Now",
          ),
        );
      },
    );
  }

  void showBiometricSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.checkCircleOutlined,
          title: "Successful",
          message:
              "Enjoy the added convenience and security in using the app with biometric authentication.",
          actionWidget: GradientButton(
            onTap: () async {
              await storage.write(
                  key: "persistBiometric", value: true.toString());
              persistBiometric =
                  await storage.read(key: "persistBiometric") == "true";
              if (context.mounted) {
                Navigator.pop(context);
                showBiometricSuccess();
              }
            },
            text: "Enable Now",
          ),
        );
      },
    );
  }

  void showBiometricLater() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.checkCircleOutlined,
          title: "Preference Saved",
          message:
              "You can enable biometric authentication anytime by going to the settings menu",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[293]["labelText"],
          ),
        );
      },
    );
  }

  Future<void> getApiData() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    isFetchingAccountDetails = true;
    showButtonBloc.add(ShowButtonEvent(show: isFetchingAccountDetails));
    await getCorporateCustomerPermissions();
    // await getCorporateCustomerAcountDetails();
    isFetchingAccountDetails = false;
    showButtonBloc.add(ShowButtonEvent(show: isFetchingAccountDetails));
    await getFdRates();
    fdRatesDates.clear();
    for (var rate in fdRates) {
      fdRatesDates.add(DateTime.parse(rate["maxMaturityDate"]));
    }
    log("fdRatesDates -> $fdRatesDates");
  }

  Future<void> getCorporateCustomerPermissions() async {
    try {
      corpCustPermApiResult =
          await MapCorporateCustomerPermissions.mapCorporateCustomerPermissions(
              token ?? "");
      log("Get Corp Acc Perm response -> $corpCustPermApiResult");

      if (corpCustPermApiResult["success"]) {
        fdSeedAccounts.clear();
        for (var permission in corpCustPermApiResult["permissions"]) {
          if (permission["canCreateFD"]) {
            fdSeedAccounts.add(
              FdSeedAccount(
                accountNumber: permission["accountNumber"],
                fdCreationThreshold:
                    permission["fdCreationThreshold"].toDouble(),
                currency: permission["currency"],
                bal: double.parse(permission["currentBalance"]
                        .split(" ")
                        .last
                        .replaceAll(',', ''))
                    .abs(),
                accountType: permission["accountType"],
              ),
            );
          }
        }

        // domesticFundTransferThreshold = corpCustPermApiResult["permissions"][0]
        //         ["domesticFundTransferThreshold"]
        //     .toDouble();
        // foreignFundTransferThreshold = corpCustPermApiResult["permissions"][0]
        //         ["foreignFundTransferThreshold"]
        //     .toDouble();
        // internalFundTransferThreshold = corpCustPermApiResult["permissions"][0]
        //         ["internalFundTransferThreshold"]
        //     .toDouble();

        // fdCreationThreshold = corpCustPermApiResult["permissions"][0]
        //         ["fdCreationThreshold"]
        //     .toDouble();

        // canTransferDomesticFund =
        //     corpCustPermApiResult["permissions"][0]["canTransferDomesticFund"];
        // canTransferInternationalFund = corpCustPermApiResult["permissions"][0]
        //     ["canTransferInternationalFund"];
        // canTransferInternalFund =
        //     corpCustPermApiResult["permissions"][0]["canTransferInternalFund"];

        // canCreateFD = corpCustPermApiResult["permissions"][0]["canCreateFD"];

        canCreateSavingsAccount =
            corpCustPermApiResult["canCreateSavingsAccount"];
        canCreateCurrentAccount =
            corpCustPermApiResult["canCreateCurrentAccount"];

        canChangeAddress = corpCustPermApiResult["canChangeAddress"];
        canChangeMobileNumber = corpCustPermApiResult["canChangeMobileNumber"];
        canChangeEmailId = corpCustPermApiResult["canChangeEmailId"];

        canUpdateKYC = corpCustPermApiResult["canUpdateKYC"];
        canCloseAccount = corpCustPermApiResult["canCloseAccount"];
        canRequestChequeBook = corpCustPermApiResult["canRequestChequeBook"];
        canRequestCertificate = corpCustPermApiResult["canRequestCertificate"];
        canRequestAccountStatement =
            corpCustPermApiResult["canRequestAccountStatement"];
        canRequestCard = corpCustPermApiResult["canRequestCard"];
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Error {200}",
                message:
                    "Error fetching account details, please try again later",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: labels[293]["labelText"],
                ),
              );
            },
          );
        }
      }
    } catch (e) {
      log("API error -> $e");
      rethrow;
    }
  }

  Future<void> getCorporateCustomerAcountDetails() async {
    try {
      var corpCustPermApiResult = await MapCorporateCustomerAccountDetails
          .mapCorporateCustomerAccountDetails(token ?? "");
      log("Get Corp Cust Acc Det Api response -> $corpCustPermApiResult");

      if (corpCustPermApiResult["success"]) {
        accountDetails = corpCustPermApiResult["crCustomerProfileRes"]["body"]
            ["accountDetails"];
        accountNumbers.clear();
        for (var account in accountDetails) {
          accountNumbers.add(account["accountNumber"]);
          if (account["productCode"] == "1001") {
            currentAccountCount++;
          } else {
            savingsAccountCount++;
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
                message: "Error fetching permissions, please try again later",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: labels[293]["labelText"],
                ),
              );
            },
          );
        }
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getFdRates() async {
    try {
      var getFdResult = await MapGetFds.mapGetFds(token ?? "");
      log("getFdResult -> $getFdResult");
      if (getFdResult["success"]) {
        fdRates = getFdResult["fdRates"];
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TabbarBloc tabbarBloc = context.read<TabbarBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: AppBarAvatar(
          imgUrl: retailDashboardArgumentModel.imgUrl,
          name: retailDashboardArgumentModel.name,
        ),
        title: SvgPicture.asset(ImageConstants.dhabiBusinessText),
        actions: const [AppBarAction()],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          if (isFetchingAccountDetails) {
            return const ShimmerDashboard();
          } else {
            return Stack(
              children: [
                Column(
                  children: [
                    DefaultTabController(
                      length: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: (PaddingConstants.horizontalPadding /
                                      Dimensions.designWidth)
                                  .w,
                            ),
                            // ! Upper tabs
                            child: BlocBuilder<TabbarBloc, TabbarState>(
                              builder: (context, state) {
                                return TabBar(
                                  splashFactory: NoSplash.splashFactory,
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.transparent,
                                  ),
                                  controller: tabController,
                                  onTap: (index) {
                                    final ShowButtonBloc showButtonBloc =
                                        context.read<ShowButtonBloc>();
                                    _scrollOffset = 0;
                                    _scrollIndex = 0;
                                    tabbarBloc.add(TabbarEvent(index: index));
                                    showButtonBloc
                                        .add(const ShowButtonEvent(show: true));
                                  },
                                  indicatorColor: Colors.transparent,
                                  tabs: [
                                    Tab(
                                      child: tabController.index == 0
                                          ? const CustomTab(title: "Home")
                                          : const Text("Home"),
                                    ),
                                    Tab(
                                      child: tabController.index == 1
                                          ? const CustomTab(title: "Deposits")
                                          : const Text("Deposits"),
                                    ),
                                    Tab(
                                      child: tabController.index == 2
                                          ? const CustomTab(title: "Loans")
                                          : const Text("Loans"),
                                    ),
                                    Tab(
                                      child: tabController.index == 3
                                          ? const CustomTab(title: "Explore")
                                          : const Text("Explore"),
                                    ),
                                  ],
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  labelStyle: TextStyles.primaryMedium.copyWith(
                                    color: const Color(0xFF000000),
                                    fontSize:
                                        (PaddingConstants.horizontalPadding /
                                                Dimensions.designWidth)
                                            .w,
                                  ),
                                  unselectedLabelColor: Colors.black,
                                  unselectedLabelStyle:
                                      TextStyles.primaryMedium.copyWith(
                                    color: const Color(0xFF000000),
                                    fontSize:
                                        (PaddingConstants.horizontalPadding /
                                                Dimensions.designWidth)
                                            .w,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: (277 / Dimensions.designWidth).w,
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                // ! Home Tab View
                                Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            top:
                                                (5 / Dimensions.designHeight).h,
                                            bottom:
                                                (13 / Dimensions.designHeight)
                                                    .h),
                                        controller: _scrollController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: (canCreateSavingsAccount ||
                                                canCreateCurrentAccount)
                                            ? corpCustPermApiResult[
                                                        "permissions"]
                                                    .length +
                                                1
                                            : corpCustPermApiResult[
                                                    "permissions"]
                                                .length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              left: (index == 0)
                                                  ? (PaddingConstants
                                                              .horizontalPadding /
                                                          Dimensions
                                                              .designWidth)
                                                      .w
                                                  : 0,
                                            ),
                                            child: index ==
                                                    corpCustPermApiResult[
                                                            "permissions"]
                                                        .length
                                                ? (canCreateSavingsAccount ||
                                                        canCreateCurrentAccount)
                                                    ? AccountSummaryTile(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                            context,
                                                            Routes
                                                                .applicationAccount,
                                                            arguments:
                                                                ApplicationAccountArgumentModel(
                                                              isInitial: false,
                                                              savingsAccountsCreated:
                                                                  savingsAccountCount,
                                                              currentAccountsCreated:
                                                                  currentAccountCount,
                                                            ).toMap(),
                                                          );
                                                        },
                                                        imgUrl: ImageConstants
                                                            .addAccount,
                                                        accountType: "",
                                                        currency:
                                                            "Open Account",
                                                        amount: "",
                                                        subText: "",
                                                        subImgUrl: "",
                                                        fontSize: 14,
                                                      )
                                                    : AccountSummaryTile(
                                                        onTap: () {},
                                                        imgUrl: corpCustPermApiResult[
                                                                            "permissions"]
                                                                        [index][
                                                                    "currency"] ==
                                                                "AED"
                                                            ? ImageConstants
                                                                .uaeFlag
                                                            : ImageConstants
                                                                .usaFlag,
                                                        accountType: corpCustPermApiResult[
                                                                            "permissions"]
                                                                        [index][
                                                                    "accountType"] ==
                                                                2
                                                            ? "Current"
                                                            : "Savings",
                                                        currency:
                                                            corpCustPermApiResult[
                                                                    "permissions"]
                                                                [
                                                                index]["currency"],
                                                        amount: corpCustPermApiResult[
                                                                        "permissions"]
                                                                    [index][
                                                                "currentBalance"]
                                                            .split(" ")
                                                            .last,
                                                        subText: "",
                                                        subImgUrl: "",
                                                      )
                                                : AccountSummaryTile(
                                                    onTap: () {},
                                                    imgUrl: corpCustPermApiResult[
                                                                        "permissions"]
                                                                    [index]
                                                                ["currency"] ==
                                                            "AED"
                                                        ? ImageConstants.uaeFlag
                                                        : ImageConstants
                                                            .usaFlag,
                                                    accountType: corpCustPermApiResult[
                                                                        "permissions"]
                                                                    [index][
                                                                "accountType"] ==
                                                            2
                                                        ? "Current"
                                                        : "Savings",
                                                    currency:
                                                        corpCustPermApiResult[
                                                                "permissions"]
                                                            [index]["currency"],
                                                    amount: corpCustPermApiResult[
                                                                    "permissions"]
                                                                [index]
                                                            ["currentBalance"]
                                                        .split(" ")
                                                        .last,
                                                    subText: "",
                                                    subImgUrl: "",
                                                  ),
                                          );
                                        },
                                      ),
                                    ),
                                    // const SizeBox(height: 10),
                                    BlocBuilder<SummaryTileBloc,
                                        SummaryTileState>(
                                      builder: (context, state) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 47.w -
                                                  ((corpCustPermApiResult[
                                                                  "permissions"]
                                                              .length -
                                                          1) *
                                                      (6.5 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w)),
                                          child: SizedBox(
                                            width: 90.w,
                                            height:
                                                (9 / Dimensions.designHeight).h,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: corpCustPermApiResult[
                                                      "permissions"]
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return ScrollIndicator(
                                                  isCurrent:
                                                      (index == _scrollIndex),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizeBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DashboardActivityTile(
                                          iconPath: ImageConstants.arrowOutward,
                                          activityText: labels[9]["labelText"],
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // ! Deposits Tab View
                                Column(
                                  children: [
                                    // const SizeBox(height: 9.5),
                                    Ternary(
                                      condition: canCreateFD,
                                      truthy: Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(
                                              top: (5 / Dimensions.designHeight)
                                                  .h,
                                              bottom:
                                                  (13 / Dimensions.designHeight)
                                                      .h),
                                          controller: _scrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: depositDetails.length + 1,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                left: (index == 0)
                                                    ? (PaddingConstants
                                                                .horizontalPadding /
                                                            Dimensions
                                                                .designWidth)
                                                        .w
                                                    : 0,
                                              ),
                                              child: index ==
                                                      depositDetails.length
                                                  ? AccountSummaryTile(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          Routes.createDeposits,
                                                          arguments:
                                                              CreateDepositArgumentModel(
                                                            isRetail: false,
                                                          ).toMap(),
                                                        );
                                                      },
                                                      imgUrl: ImageConstants
                                                          .addAccount,
                                                      accountType: "",
                                                      currency: labels[103]
                                                          ["labelText"],
                                                      amount: "",
                                                      subText: "",
                                                      subImgUrl: "",
                                                      fontSize: 14,
                                                    )
                                                  : AccountSummaryTile(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          Routes.depositDetails,
                                                          arguments:
                                                              DepositDetailsArgumentModel(
                                                            accountNumber:
                                                                depositDetails[
                                                                        index][
                                                                    "depositAccountNumber"],
                                                          ).toMap(),
                                                        );
                                                      },
                                                      imgUrl: depositDetails[
                                                                      index][
                                                                  "depositAccountCurrency"] ==
                                                              "AED"
                                                          ? ImageConstants
                                                              .uaeFlag
                                                          : ImageConstants
                                                              .usaFlag,
                                                      accountType:
                                                          "Fixed Deposit",
                                                      currency: depositDetails[
                                                                  index][
                                                              "depositPrincipalAmount"]
                                                          .split(" ")
                                                          .first,
                                                      amount: depositDetails[
                                                                  index][
                                                              "depositPrincipalAmount"]
                                                          .split(" ")
                                                          .last,
                                                      subText: "",
                                                      subImgUrl: "",
                                                    ),
                                            );
                                          },
                                        ),
                                      ),
                                      falsy: const SizeBox(height: 200),
                                    ),
                                    // const SizeBox(height: 10),
                                    BlocBuilder<SummaryTileBloc,
                                        SummaryTileState>(
                                      builder: (context, state) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 47.w -
                                                  ((depositDetails.length - 1) *
                                                      (6.5 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w)),
                                          child: SizedBox(
                                            width: 90.w,
                                            height:
                                                (9 / Dimensions.designWidth).w,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: depositDetails.length,
                                              itemBuilder: (context, index) {
                                                return ScrollIndicator(
                                                  isCurrent:
                                                      (index == _scrollIndex),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizeBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DashboardActivityTile(
                                          iconPath: ImageConstants.percent,
                                          activityText: "Rates",
                                          onTap: () {
                                            populateFdRates();
                                            promptUserForRates();
                                            // Navigator.pushNamed(
                                            //     context, Routes.interestRates);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // ! Loans Tab View
                                Column(
                                  children: [
                                    const SizeBox(height: 9.5),
                                    SizedBox(
                                      width: 100.w,
                                      height: (145 / Dimensions.designWidth).w,
                                      child: Expanded(
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 6,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                left: (index == 0)
                                                    ? (15 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w
                                                    : 0,
                                              ),
                                              child: AccountSummaryTile(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      Routes.loanDetails);
                                                },
                                                imgUrl:
                                                    "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
                                                accountType: "Savings",
                                                currency: "AED",
                                                amount: "0.00",
                                                subText: "Powered by FH",
                                                subImgUrl:
                                                    "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizeBox(height: 10),
                                    BlocBuilder<SummaryTileBloc,
                                        SummaryTileState>(
                                      builder: (context, state) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 47.w -
                                                  ((6 - 1) *
                                                      (6.5 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w)),
                                          child: SizedBox(
                                            width: 90.w,
                                            height:
                                                (9 / Dimensions.designWidth).w,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: 6,
                                              itemBuilder: (context, index) {
                                                return ScrollIndicator(
                                                  isCurrent:
                                                      (index == _scrollIndex),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizeBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DashboardActivityTile(
                                          iconPath: ImageConstants.warningSmall,
                                          activityText: "Service request",
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, Routes.request);
                                          },
                                        ),
                                        const SizeBox(width: 40),
                                        DashboardActivityTile(
                                          iconPath: ImageConstants.barChart,
                                          activityText: "Insights",
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // ! Explore Tab View
                                Column(
                                  children: [
                                    const SizeBox(height: 9.5),
                                    SizedBox(
                                      width: 100.w,
                                      height: (145 / Dimensions.designWidth).w,
                                      child: Expanded(
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 6,
                                          itemBuilder: (context, index) {
                                            if (index == 0) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  left: (15 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                ),
                                                child: AccountSummaryTile(
                                                  onTap: () {},
                                                  imgUrl:
                                                      "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
                                                  accountType: "Savings",
                                                  currency: "AED",
                                                  amount: "0.00",
                                                  subText: "Powered by FH",
                                                  subImgUrl:
                                                      "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
                                                ),
                                              );
                                            } else {
                                              return AccountSummaryTile(
                                                onTap: () {},
                                                imgUrl: "",
                                                accountType: "Savings",
                                                currency: "USD",
                                                amount: "0.00",
                                                subText: "",
                                                subImgUrl: "",
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizeBox(height: 10),
                                    BlocBuilder<SummaryTileBloc,
                                        SummaryTileState>(
                                      builder: (context, state) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 47.w -
                                                  ((6 - 1) *
                                                      (6.5 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w)),
                                          child: SizedBox(
                                            width: 90.w,
                                            height:
                                                (9 / Dimensions.designWidth).w,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: 6,
                                              itemBuilder: (context, index) {
                                                return ScrollIndicator(
                                                  isCurrent:
                                                      (index == _scrollIndex),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizeBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DashboardActivityTile(
                                          iconPath: ImageConstants.add,
                                          activityText: "Add Money",
                                          onTap: () {},
                                        ),
                                        const SizeBox(width: 40),
                                        DashboardActivityTile(
                                          iconPath: ImageConstants.arrowOutward,
                                          activityText: "Send Money",
                                          onTap: () {},
                                        ),
                                        const SizeBox(width: 40),
                                        DashboardActivityTile(
                                          iconPath: ImageConstants.barChart,
                                          activityText: "Insights",
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizeBox(height: 15),
                    InkWell(
                      onTap: () {
                        tabController.animateTo(1);
                      },
                      child: const DashboardBannerImage(
                        imgUrl: ImageConstants.banner3,
                      ),
                    ),
                    const SizeBox(height: 15),
                    const SizeBox(height: 265)
                  ],
                ),
                Ternary(
                  condition: isShowExplore,
                  truthy: const SizeBox(),
                  falsy: DraggableScrollableSheet(
                    initialChildSize: 0.39,
                    minChildSize: 0.39,
                    maxChildSize: 1,
                    builder: (context, scrollController) {
                      return Container(
                        height: 85.h,
                        width: 100.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: (PaddingConstants.horizontalPadding /
                                  Dimensions.designWidth)
                              .w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                (20 / Dimensions.designWidth).w),
                            topRight: Radius.circular(
                                (20 / Dimensions.designWidth).w),
                          ),
                          boxShadow: [BoxShadows.primary],
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const SizeBox(height: 15),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: (10 / Dimensions.designWidth).w,
                              ),
                              height: (7 / Dimensions.designWidth).w,
                              width: (50 / Dimensions.designWidth).w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      (10 / Dimensions.designWidth).w),
                                ),
                                color: const Color(0xFFD9D9D9),
                              ),
                            ),
                            const SizeBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  labels[10]["labelText"],
                                  style: TextStyles.primary.copyWith(
                                    color: AppColors.dark50,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      ImageConstants.download,
                                      width: (15 / Dimensions.designWidth).w,
                                      height: (15 / Dimensions.designWidth).w,
                                    ),
                                    const SizeBox(width: 10),
                                    Text(
                                      labels[89]["labelText"],
                                      style: TextStyles.primary.copyWith(
                                        color: AppColors.dark50,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizeBox(height: 15),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: (236 / Dimensions.designWidth).w,
                                    height: (39 / Dimensions.designHeight).h,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          34, 97, 105, 0.1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          (10 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstants.pyramid,
                                          width:
                                              (10 / Dimensions.designHeight).w,
                                          height:
                                              (10 / Dimensions.designHeight).h,
                                        ),
                                        const SizeBox(width: 10),
                                        Text(
                                          "Filter: ",
                                          style: TextStyles.primary.copyWith(
                                            color: AppColors.dark50,
                                            fontSize:
                                                (16 / Dimensions.designWidth).w,
                                          ),
                                        ),
                                        Text(
                                          "All",
                                          style:
                                              TextStyles.primaryMedium.copyWith(
                                            color: AppColors.primary,
                                            fontSize:
                                                (16 / Dimensions.designWidth).w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizeBox(width: 10),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: (150 / Dimensions.designWidth).w,
                                    height: (39 / Dimensions.designHeight).h,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          34, 97, 105, 0.1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          (10 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstants.pyramid,
                                          width:
                                              (10 / Dimensions.designHeight).w,
                                          height:
                                              (10 / Dimensions.designHeight).h,
                                        ),
                                        const SizeBox(width: 10),
                                        Text(
                                          "Sort: ",
                                          style: TextStyles.primary.copyWith(
                                            color: AppColors.dark50,
                                            fontSize:
                                                (16 / Dimensions.designWidth).w,
                                          ),
                                        ),
                                        Text(
                                          "Date",
                                          style:
                                              TextStyles.primaryMedium.copyWith(
                                            color: AppColors.primary,
                                            fontSize:
                                                (16 / Dimensions.designWidth).w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizeBox(height: 15),
                            Ternary(
                              condition: statementList.isEmpty,
                              truthy: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizeBox(height: 70),
                                  Text(
                                    "No transactions",
                                    style: TextStyles.primaryBold.copyWith(
                                      color: AppColors.dark30,
                                      fontSize: (24 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ],
                              ),
                              falsy: Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: statementList.length,
                                  itemBuilder: (context, index) {
                                    return DashboardTransactionListTile(
                                      onTap: () {},
                                      isCredit:
                                          // true,
                                          statementList[index]
                                                  ["creditAmount"] ==
                                              0,
                                      title:
                                          // "Tax non filer debit Tax non filer debit",
                                          statementList[index]
                                              ["transactionType"],
                                      name: "Alexander Doe",
                                      amount:
                                          // 50.23,
                                          (statementList[index]
                                                          ["creditAmount"] !=
                                                      0
                                                  ? statementList[index]
                                                      ["creditAmount"]
                                                  : statementList[index]
                                                      ["debitAmount"])
                                              .toDouble(),
                                      currency:
                                          // "AED",
                                          statementList[index]
                                              ["amountCurrency"],
                                      date:
                                          // "Tue, Apr 1 2022",
                                          DateFormat('EEE, MMM dd yyyy').format(
                                        DateTime.parse(
                                          statementList[index]["bookingDate"],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void populateFdRates() {
    rates.clear();
    for (var fdRate in fdRates) {
      rates.add(
          DetailsTileModel(key: fdRate["label"], value: "${fdRate["rate"]}%"));
    }
  }

  void promptUserForRates() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
                vertical: PaddingConstants.bottomPadding +
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Container(
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                  color: Colors.white,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: 52.5.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizeBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: (22 / Dimensions.designWidth).w,
                          ),
                          // vertical: (22 / Dimensions.designHeight).h),
                          child: Text(
                            labels[104]["labelText"],
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.primary,
                              fontSize: (28 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        const SizeBox(height: 20),
                        Expanded(
                          child:
                              DetailsTile(length: rates.length, details: rates),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }
}
