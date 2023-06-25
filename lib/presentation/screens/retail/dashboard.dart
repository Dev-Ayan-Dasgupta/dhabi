// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/tabs/tab.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

class RetailDashboardScreen extends StatefulWidget {
  const RetailDashboardScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RetailDashboardScreen> createState() => _RetailDashboardScreenState();
}

class _RetailDashboardScreenState extends State<RetailDashboardScreen>
    with SingleTickerProviderStateMixin {
  late RetailDashboardArgumentModel retailDashboardArgumentModel;

  late TabController tabController;
  int tabIndex = 0;

  final ScrollController _scrollController = ScrollController();
  final ScrollController myScrollController = ScrollController();
  double _scrollOffset = 0;
  int _scrollIndex = 0;

  final DraggableScrollableController _dsController =
      DraggableScrollableController();

  bool isFetchingAccountDetails = false;

  int savingsAccountCount = 0;
  int currentAccountCount = 0;
  List depositDetails = [];

  List statementList = [];
  List displayStatementList = [];
  List fdStatementList = [];
  List displayFdStatementList = [];

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
  bool isChangingDepositAccount = false;

  bool isShowExplore = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {});
    getApiData();
    argumentInitialization();
    tabbarInitialization();
  }

  void argumentInitialization() async {
    retailDashboardArgumentModel =
        RetailDashboardArgumentModel.fromMap(widget.argument as dynamic ?? {});
    log("isFirst -> ${retailDashboardArgumentModel.isFirst}");
    if (retailDashboardArgumentModel.isFirst && !persistBiometric!) {
      List availableBiometrics =
          await LocalAuthentication().getAvailableBiometrics();
      log("availableBiometrics -> $availableBiometrics");
      if (availableBiometrics.isNotEmpty) {
        Future.delayed(const Duration(seconds: 1), promptBiometricSettings);
      }
    }
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
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[293]["labelText"],
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

  void tabbarInitialization() {
    final TabbarBloc tabbarBloc = context.read<TabbarBloc>();
    tabController = TabController(length: 3, vsync: this);
    tabController.animation!.addListener(() {
      final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
      // print(
      //     "tabController animation value -> ${tabController.animation!.value}");
      // print(
      //     "tabController animation value round -> ${tabController.animation!.value.round()}");

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
      log("tabIndex -> $tabIndex");
      log("tabController.index -> ${tabController.index}");

      showButtonBloc.add(const ShowButtonEvent(show: true));
    });
    _scrollController.addListener(() {
      _scrollOffset = _scrollController.offset + 120;
      _scrollIndex = _scrollOffset ~/ 188;

      final SummaryTileBloc summaryTileBloc = context.read<SummaryTileBloc>();
      summaryTileBloc.add(SummaryTileEvent(scrollIndex: _scrollIndex));
    });
  }

  Future<void> getApiData() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    isFetchingAccountDetails = true;
    showButtonBloc.add(ShowButtonEvent(show: isFetchingAccountDetails));
    await getCustomerAcountDetails();
    await getCustomerAccountStatement();
    await getCustomerFdAccountStatement();
    isFetchingAccountDetails = false;
    showButtonBloc.add(ShowButtonEvent(show: isFetchingAccountDetails));
    await getFdRates();
    fdRatesDates.clear();
    for (var rate in fdRates) {
      fdRatesDates.add(DateTime.parse(rate["maxMaturityDate"]));
    }
    log("fdRatesDates -> $fdRatesDates");
  }

  Future<void> getCustomerAcountDetails() async {
    try {
      log("token -> $token");
      customerDetails =
          await MapCustomerAccountDetails.mapCustomerAccountDetails(
              token ?? "");
      log("Customer Account Details API response -> $customerDetails");
      if (customerDetails["success"]) {
        accountDetails =
            customerDetails["crCustomerProfileRes"]["body"]["accountDetails"];
        accountNumbers.clear();
        for (var account in accountDetails) {
          accountNumbers.add(account["accountNumber"]);
          if (account["productCode"] == "1001") {
            currentAccountCount++;
          } else {
            savingsAccountCount++;
          }
        }
        log("Current Accounts -> $currentAccountCount");
        log("Savings Accounts -> $savingsAccountCount");
        depositDetails =
            customerDetails["crCustomerProfileRes"]["body"]["depositDetails"];
        depositAccountNumbers.clear();
        for (var deposit in depositDetails) {
          depositAccountNumbers.add(deposit["depositAccountNumber"]);
        }
        log("depositAccountNumbers -> $depositAccountNumbers");
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Error {200}",
                message: customerDetails["message"] ??
                    "Error while getting customer details, please try again later",
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
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getCustomerAccountStatement() async {
    try {
      customerStatement =
          await MapCustomerAccountStatement.mapCustomerAccountStatement(
        {
          "accountNumber": accountDetails[storageChosenAccount ?? 0]
              ["accountNumber"],
          "startDate": DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(const Duration(days: 90))),
          "endDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
        token ?? "",
      );
      log("Customer Account Statement API response -> $customerStatement");
      if (customerStatement["flexiAccountStatementRes"]["body"] != null) {
        statementList = customerStatement["flexiAccountStatementRes"]["body"]
            ["statementList"];
        displayStatementList.clear();
        displayStatementList.addAll(statementList);
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getCustomerFdAccountStatement() async {
    try {
      if (depositDetails.isNotEmpty) {
        var customerFdAccountApiResult =
            await MapCustomerFdAccountStatement.mapCustomerFdAccountStatement(
          {
            "accountNumber": depositDetails[storageChosenFdAccount ?? 0]
                ["depositAccountNumber"],
            "startDate": DateFormat('yyyy-MM-dd')
                .format(DateTime.now().subtract(const Duration(days: 90))),
            "endDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          },
          token ?? "",
        );
        log("Customer FD Account Statement API response -> $customerFdAccountApiResult");
        fdStatementList = customerFdAccountApiResult["transactionList"];
        displayFdStatementList.clear();
        displayFdStatementList.addAll(fdStatementList);
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
        title: SvgPicture.asset(
          ImageConstants.appBarLogo,
          // height: (40 / Dimensions.designHeight).h,
        ),
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
                      length: 3,
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
                            child: Row(
                              children: [
                                BlocBuilder<TabbarBloc, TabbarState>(
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
                                        tabbarBloc
                                            .add(TabbarEvent(index: index));
                                        showButtonBloc.add(
                                            const ShowButtonEvent(show: true));
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
                                              ? const CustomTab(
                                                  title: "Deposits")
                                              : const Text("Deposits"),
                                        ),
                                        Tab(
                                          child: tabController.index == 2
                                              ? const CustomTab(
                                                  title: "Explore")
                                              : const Text("Explore"),
                                        ),
                                      ],
                                      isScrollable: true,
                                      labelColor: Colors.black,
                                      labelStyle:
                                          TextStyles.primaryMedium.copyWith(
                                        color: const Color(0xFF000000),
                                        fontSize: (PaddingConstants
                                                    .horizontalPadding /
                                                Dimensions.designWidth)
                                            .w,
                                      ),
                                      unselectedLabelColor: Colors.black,
                                      unselectedLabelStyle:
                                          TextStyles.primaryMedium.copyWith(
                                        color: const Color(0xFF000000),
                                        fontSize: (PaddingConstants
                                                    .horizontalPadding /
                                                Dimensions.designWidth)
                                            .w,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: (277 / Dimensions.designHeight).h,
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
                                        itemCount: (accountDetails.length) + 1,
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
                                                    accountDetails.length
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
                                                    currency: "Open Account",
                                                    amount: "",
                                                    subText: "",
                                                    subImgUrl: "",
                                                    fontSize: 14,
                                                  )
                                                : AccountSummaryTile(
                                                    onTap: () {},
                                                    imgUrl: accountDetails[
                                                                    index][
                                                                "accountCurrency"] ==
                                                            "AED"
                                                        ? ImageConstants.uaeFlag
                                                        : ImageConstants
                                                            .usaFlag,
                                                    accountType: accountDetails[
                                                                    index][
                                                                "productCode"] ==
                                                            "1001"
                                                        ? labels[7]["labelText"]
                                                        : labels[92]
                                                            ["labelText"],
                                                    currency:
                                                        accountDetails[index]
                                                            ["accountCurrency"],
                                                    amount: accountDetails[
                                                                index]
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
                                                  ((accountDetails.length - 1) *
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
                                              itemCount: accountDetails.length,
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
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, Routes.sendMoney);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // ! Deposits Tab View
                                Column(
                                  children: [
                                    // const SizeBox(height: 9.5),
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
                                                          isRetail: true,
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
                                                        ? ImageConstants.uaeFlag
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
                                // ! Explore Tab View
                                Column(
                                  children: [
                                    const SizeBox(height: 15),
                                    InkWell(
                                      onTap: () {
                                        final ShowButtonBloc showButtonBloc =
                                            context.read<ShowButtonBloc>();
                                        tabController.animateTo(1);
                                        showButtonBloc.add(
                                            const ShowButtonEvent(show: true));
                                      },
                                      child: const DashboardBannerImage(
                                        imgUrl: ImageConstants.banner3,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Ternary(
                      condition: tabController.index == 2,
                      truthy: const SizeBox(),
                      falsy: Column(
                        children: [
                          const SizeBox(height: 15),
                          // ! Banner image
                          InkWell(
                            onTap: () {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              tabController.animateTo(1);
                              showButtonBloc
                                  .add(const ShowButtonEvent(show: true));
                            },
                            child: const DashboardBannerImage(
                              imgUrl: ImageConstants.banner3,
                            ),
                          ),
                          const SizeBox(height: 15),
                        ],
                      ),
                    ),
                    // const SizeBox(height: 265)
                  ],
                ),
                tabController.index == 2
                    ? const SizeBox()
                    : DraggableScrollableSheet(
                        initialChildSize: 0.39,
                        minChildSize: 0.39,
                        maxChildSize: 1,
                        controller: _dsController,
                        builder: (context, scrollController) {
                          return ListView(
                            controller: scrollController,
                            children: [
                              // ! Outer Container
                              Container(
                                height: 90.h,
                                width: 100.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      (PaddingConstants.horizontalPadding /
                                              Dimensions.designWidth)
                                          .w,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: const Color(0XFFEEEEEE)),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        (20 / Dimensions.designWidth).w),
                                    topRight: Radius.circular(
                                        (20 / Dimensions.designWidth).w),
                                  ),
                                  color: const Color(0xFFFFFFFF),
                                ),
                                child: Column(
                                  children: [
                                    const SizeBox(height: 15),
                                    // ! Clip widget for drag
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            (10 / Dimensions.designWidth).w,
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

                                    BlocBuilder<ShowButtonBloc,
                                        ShowButtonState>(
                                      builder: (context, state) {
                                        return Ternary(
                                          condition: tabController.index == 0,
                                          // ! Home tab related draggable listview UI
                                          truthy: BlocBuilder<ShowButtonBloc,
                                              ShowButtonState>(
                                            builder: (context, state) {
                                              return Ternary(
                                                condition: !isShowFilter &&
                                                    !isShowSort,
                                                truthy: SizedBox(
                                                  height: 85.h,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            labels[10]
                                                                ["labelText"],
                                                            style: TextStyles
                                                                .primary
                                                                .copyWith(
                                                              color: AppColors
                                                                  .dark50,
                                                              fontSize: (16 /
                                                                      Dimensions
                                                                          .designWidth)
                                                                  .w,
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                Routes
                                                                    .downloadStatement,
                                                                arguments:
                                                                    DownloadStatementArgumentModel(
                                                                  accountNumber:
                                                                      accountDetails[
                                                                              0]
                                                                          [
                                                                          "accountNumber"],
                                                                ).toMap(),
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  ImageConstants
                                                                      .download,
                                                                  width: (15 /
                                                                          Dimensions
                                                                              .designWidth)
                                                                      .w,
                                                                  height: (15 /
                                                                          Dimensions
                                                                              .designWidth)
                                                                      .w,
                                                                ),
                                                                const SizeBox(
                                                                    width: 10),
                                                                Text(
                                                                  labels[89][
                                                                      "labelText"],
                                                                  style: TextStyles
                                                                      .primary
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .dark50,
                                                                    fontSize:
                                                                        (16 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizeBox(height: 15),
                                                      Container(
                                                        width: 100.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular((10 /
                                                                    Dimensions
                                                                        .designWidth)
                                                                .w),
                                                          ),
                                                          color: AppColors
                                                              .primary10,
                                                        ),
                                                        padding: EdgeInsets.all(
                                                          (10 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  builder:
                                                                      (context) {
                                                                    return Container(
                                                                      width:
                                                                          100.w,
                                                                      height: (10
                                                                              .h) *
                                                                          accountDetails
                                                                              .length,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                        vertical:
                                                                            (PaddingConstants.horizontalPadding / Dimensions.designHeight).h,
                                                                        horizontal:
                                                                            (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular((10 / Dimensions.designWidth).w),
                                                                          topRight:
                                                                              Radius.circular((10 / Dimensions.designWidth).w),
                                                                        ),
                                                                      ),
                                                                      child: BlocBuilder<
                                                                          ShowButtonBloc,
                                                                          ShowButtonState>(
                                                                        builder:
                                                                            (context1,
                                                                                state) {
                                                                          return Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Ternary(
                                                                                condition: isChangingAccount,
                                                                                truthy: Center(
                                                                                  child: SpinKitFadingCircle(
                                                                                    color: AppColors.primary,
                                                                                    size: (50 / Dimensions.designWidth).w,
                                                                                  ),
                                                                                ),
                                                                                falsy: Expanded(
                                                                                  child: ListView.builder(
                                                                                    itemCount: accountDetails.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return ListTile(
                                                                                        dense: true,
                                                                                        onTap: () async {
                                                                                          final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
                                                                                          isChangingAccount = true;
                                                                                          showButtonBloc.add(
                                                                                            ShowButtonEvent(show: isChangingAccount),
                                                                                          );
                                                                                          await storage.write(key: "chosenAccount", value: index.toString());
                                                                                          storageChosenAccount = int.parse(await storage.read(key: "chosenAccount") ?? "0");
                                                                                          log("storageChosenAccount -> $storageChosenAccount");

                                                                                          getCustomerAccountStatement();

                                                                                          isChangingAccount = false;
                                                                                          showButtonBloc.add(
                                                                                            ShowButtonEvent(show: isChangingAccount),
                                                                                          );
                                                                                          if (context1.mounted) {
                                                                                            Navigator.pop(context1);
                                                                                          }
                                                                                        },
                                                                                        leading: const CustomCircleAvatarAsset(imgUrl: ImageConstants.uaeFlag),
                                                                                        title: Text(
                                                                                          accountDetails[index]["accountNumber"],
                                                                                          style: TextStyles.primaryBold.copyWith(color: AppColors.primary, fontSize: (16 / Dimensions.designWidth).w),
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          accountDetails[index]["productCode"] == "1001" ? labels[7]["labelText"] : labels[92]["labelText"],
                                                                                          style: TextStyles.primaryMedium.copyWith(color: AppColors.dark50, fontSize: (14 / Dimensions.designWidth).w),
                                                                                        ),
                                                                                        trailing: Text(
                                                                                          accountDetails[index]["currentBalance"],
                                                                                          style: TextStyles.primaryMedium.copyWith(color: AppColors.dark50, fontSize: (14 / Dimensions.designWidth).w),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Account: ",
                                                                    style: TextStyles
                                                                        .primaryMedium
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .dark50,
                                                                      fontSize:
                                                                          (14 / Dimensions.designWidth)
                                                                              .w,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${accountDetails[storageChosenAccount ?? 0]["productCode"] == "1001" ? labels[7]["labelText"] : labels[92]["labelText"]} ****${accountDetails[storageChosenAccount ?? 0]["accountNumber"].substring(accountDetails[storageChosenAccount ?? 0]["accountNumber"].length - 4, accountDetails[storageChosenAccount ?? 0]["accountNumber"].length)}",
                                                                    style: TextStyles
                                                                        .primaryMedium
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .primary,
                                                                      fontSize:
                                                                          (14 / Dimensions.designWidth)
                                                                              .w,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_drop_down_rounded,
                                                                    color: AppColors
                                                                        .dark80,
                                                                    size: (20 /
                                                                            Dimensions.designWidth)
                                                                        .w,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizeBox(
                                                                width: 5),
                                                            Text(
                                                              "|",
                                                              style: TextStyles
                                                                  .primaryMedium
                                                                  .copyWith(
                                                                color: AppColors
                                                                    .dark50,
                                                                fontSize: (16 /
                                                                        Dimensions
                                                                            .designWidth)
                                                                    .w,
                                                              ),
                                                            ),
                                                            const SizeBox(
                                                                width: 10),
                                                            InkWell(
                                                              onTap: () {
                                                                final ShowButtonBloc
                                                                    showButtonBloc =
                                                                    context.read<
                                                                        ShowButtonBloc>();
                                                                isShowFilter =
                                                                    true;
                                                                showButtonBloc
                                                                    .add(
                                                                  ShowButtonEvent(
                                                                      show:
                                                                          isShowFilter),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    ImageConstants
                                                                        .filter,
                                                                    width: (12 /
                                                                            Dimensions.designHeight)
                                                                        .w,
                                                                    height: (12 /
                                                                            Dimensions.designWidth)
                                                                        .w,
                                                                  ),
                                                                  const SizeBox(
                                                                      width: 5),
                                                                  Text(
                                                                    filterText,
                                                                    style: TextStyles
                                                                        .primaryMedium
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .primary,
                                                                      fontSize:
                                                                          (14 / Dimensions.designWidth)
                                                                              .w,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizeBox(
                                                                width: 10),
                                                            Text(
                                                              "|",
                                                              style: TextStyles
                                                                  .primaryMedium
                                                                  .copyWith(
                                                                color: AppColors
                                                                    .dark50,
                                                                fontSize: (16 /
                                                                        Dimensions
                                                                            .designWidth)
                                                                    .w,
                                                              ),
                                                            ),
                                                            const SizeBox(
                                                                width: 10),
                                                            InkWell(
                                                              onTap: () {
                                                                final ShowButtonBloc
                                                                    showButtonBloc =
                                                                    context.read<
                                                                        ShowButtonBloc>();
                                                                isShowSort =
                                                                    true;
                                                                showButtonBloc
                                                                    .add(
                                                                  ShowButtonEvent(
                                                                      show:
                                                                          isShowSort),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    ImageConstants
                                                                        .sort,
                                                                    width: (10 /
                                                                            Dimensions.designHeight)
                                                                        .w,
                                                                    height: (10 /
                                                                            Dimensions.designWidth)
                                                                        .w,
                                                                  ),
                                                                  const SizeBox(
                                                                      width: 5),
                                                                  Text(
                                                                    sortText,
                                                                    style: TextStyles
                                                                        .primaryMedium
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .primary,
                                                                      fontSize:
                                                                          (14 / Dimensions.designWidth)
                                                                              .w,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizeBox(height: 15),
                                                      Ternary(
                                                        condition:
                                                            displayStatementList
                                                                .isEmpty,
                                                        truthy: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizeBox(
                                                                height: 70),
                                                            Text(
                                                              "No transactions",
                                                              style: TextStyles
                                                                  .primaryBold
                                                                  .copyWith(
                                                                color: AppColors
                                                                    .dark30,
                                                                fontSize: (24 /
                                                                        Dimensions
                                                                            .designWidth)
                                                                    .w,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        falsy: Expanded(
                                                          child:
                                                              ListView.builder(
                                                            controller:
                                                                scrollController,
                                                            itemCount:
                                                                displayStatementList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return DashboardTransactionListTile(
                                                                onTap: () {},
                                                                isCredit:
                                                                    // true,
                                                                    displayStatementList[index]
                                                                            [
                                                                            "debitAmount"] ==
                                                                        0,
                                                                title:
                                                                    // "Tax non filer debit Tax non filer debit",
                                                                    displayStatementList[
                                                                            index]
                                                                        [
                                                                        "transactionType"],
                                                                name:
                                                                    "Alexander Doe",
                                                                amount:
                                                                    // 50.23,
                                                                    (displayStatementList[index]["creditAmount"] !=
                                                                                0
                                                                            ? displayStatementList[index]["creditAmount"]
                                                                            : displayStatementList[index]["debitAmount"])
                                                                        .toDouble(),
                                                                currency:
                                                                    // "AED",
                                                                    displayStatementList[
                                                                            index]
                                                                        [
                                                                        "amountCurrency"],
                                                                date:
                                                                    // "Tue, Apr 1 2022",
                                                                    DateFormat(
                                                                            'EEE, MMM dd yyyy')
                                                                        .format(
                                                                  DateTime
                                                                      .parse(
                                                                    displayStatementList[
                                                                            index]
                                                                        [
                                                                        "bookingDate"],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                falsy: Ternary(
                                                  condition: isShowFilter,
                                                  truthy: SizedBox(
                                                    height:
                                                        // _dsController.size,
                                                        29.h,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Filter",
                                                                    style: TextStyles
                                                                        .primaryBold
                                                                        .copyWith(
                                                                            color:
                                                                                AppColors.dark50,
                                                                            fontSize: (20 / Dimensions.designWidth).w),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizeBox(
                                                                  height: 20),
                                                              Text(
                                                                "Transaction type",
                                                                style: TextStyles
                                                                    .primaryMedium
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .dark50,
                                                                        fontSize:
                                                                            (16 / Dimensions.designWidth).w),
                                                              ),
                                                              const SizeBox(
                                                                  height: 15),
                                                              Row(
                                                                children: [
                                                                  SolidButton(
                                                                    width: (118 /
                                                                            Dimensions.designWidth)
                                                                        .w,
                                                                    color: Colors
                                                                        .white,
                                                                    fontColor:
                                                                        AppColors
                                                                            .primary,
                                                                    boxShadow: [
                                                                      BoxShadows
                                                                          .primary
                                                                    ],
                                                                    borderColor: isAllSelected
                                                                        ? const Color.fromRGBO(
                                                                            0,
                                                                            184,
                                                                            148,
                                                                            0.21)
                                                                        : Colors
                                                                            .transparent,
                                                                    onTap: () {
                                                                      final ShowButtonBloc
                                                                          showButtonBloc =
                                                                          context
                                                                              .read<ShowButtonBloc>();
                                                                      isAllSelected =
                                                                          true;
                                                                      isSentSelected =
                                                                          false;
                                                                      isReceivedSelected =
                                                                          false;
                                                                      filterText =
                                                                          "All";
                                                                      populateDisplayStatementList(
                                                                        isAllSelected,
                                                                        isSentSelected,
                                                                        isReceivedSelected,
                                                                      );
                                                                      sortDisplayStatementList(
                                                                        isDateNewest,
                                                                        isDateOldest,
                                                                        isAmountHighest,
                                                                        isAmountLowest,
                                                                      );
                                                                      showButtonBloc
                                                                          .add(
                                                                        ShowButtonEvent(
                                                                          show: isAllSelected &&
                                                                              isSentSelected &&
                                                                              isReceivedSelected,
                                                                        ),
                                                                      );
                                                                    },
                                                                    text: "All",
                                                                  ),
                                                                  const SizeBox(
                                                                      width:
                                                                          15),
                                                                  SolidButton(
                                                                    width: (118 /
                                                                            Dimensions.designWidth)
                                                                        .w,
                                                                    color: Colors
                                                                        .white,
                                                                    fontColor:
                                                                        AppColors
                                                                            .primary,
                                                                    boxShadow: [
                                                                      BoxShadows
                                                                          .primary
                                                                    ],
                                                                    borderColor: isSentSelected
                                                                        ? const Color.fromRGBO(
                                                                            0,
                                                                            184,
                                                                            148,
                                                                            0.21)
                                                                        : Colors
                                                                            .transparent,
                                                                    onTap: () {
                                                                      final ShowButtonBloc
                                                                          showButtonBloc =
                                                                          context
                                                                              .read<ShowButtonBloc>();
                                                                      isAllSelected =
                                                                          false;
                                                                      isSentSelected =
                                                                          true;
                                                                      isReceivedSelected =
                                                                          false;
                                                                      filterText =
                                                                          "Sent";
                                                                      populateDisplayStatementList(
                                                                        isAllSelected,
                                                                        isSentSelected,
                                                                        isReceivedSelected,
                                                                      );
                                                                      sortDisplayStatementList(
                                                                        isDateNewest,
                                                                        isDateOldest,
                                                                        isAmountHighest,
                                                                        isAmountLowest,
                                                                      );
                                                                      showButtonBloc
                                                                          .add(
                                                                        ShowButtonEvent(
                                                                          show: isAllSelected &&
                                                                              isSentSelected &&
                                                                              isReceivedSelected,
                                                                        ),
                                                                      );
                                                                    },
                                                                    text:
                                                                        "Sent",
                                                                  ),
                                                                  const SizeBox(
                                                                      width:
                                                                          15),
                                                                  SolidButton(
                                                                    width: (118 /
                                                                            Dimensions.designWidth)
                                                                        .w,
                                                                    color: Colors
                                                                        .white,
                                                                    fontColor:
                                                                        AppColors
                                                                            .primary,
                                                                    boxShadow: [
                                                                      BoxShadows
                                                                          .primary
                                                                    ],
                                                                    borderColor: isReceivedSelected
                                                                        ? const Color.fromRGBO(
                                                                            0,
                                                                            184,
                                                                            148,
                                                                            0.21)
                                                                        : Colors
                                                                            .transparent,
                                                                    onTap: () {
                                                                      final ShowButtonBloc
                                                                          showButtonBloc =
                                                                          context
                                                                              .read<ShowButtonBloc>();
                                                                      isAllSelected =
                                                                          false;
                                                                      isSentSelected =
                                                                          false;
                                                                      isReceivedSelected =
                                                                          true;
                                                                      filterText =
                                                                          "Received";
                                                                      populateDisplayStatementList(
                                                                        isAllSelected,
                                                                        isSentSelected,
                                                                        isReceivedSelected,
                                                                      );
                                                                      sortDisplayStatementList(
                                                                        isDateNewest,
                                                                        isDateOldest,
                                                                        isAmountHighest,
                                                                        isAmountLowest,
                                                                      );
                                                                      showButtonBloc
                                                                          .add(
                                                                        ShowButtonEvent(
                                                                          show: isAllSelected &&
                                                                              isSentSelected &&
                                                                              isReceivedSelected,
                                                                        ),
                                                                      );
                                                                    },
                                                                    text:
                                                                        "Received",
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        GradientButton(
                                                          onTap: () {
                                                            final ShowButtonBloc
                                                                showButtonBloc =
                                                                context.read<
                                                                    ShowButtonBloc>();
                                                            isShowFilter =
                                                                false;
                                                            showButtonBloc.add(
                                                              ShowButtonEvent(
                                                                show:
                                                                    isShowFilter,
                                                              ),
                                                            );
                                                          },
                                                          text:
                                                              "Show ${displayStatementList.length} transactions",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  falsy: SizedBox(
                                                    height:
                                                        // _dsController.size,
                                                        85.h,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Sort",
                                                                    style: TextStyles
                                                                        .primaryBold
                                                                        .copyWith(
                                                                            color:
                                                                                AppColors.dark50,
                                                                            fontSize: (20 / Dimensions.designWidth).w),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizeBox(
                                                                  height: 20),
                                                              Text(
                                                                "Date",
                                                                style: TextStyles
                                                                    .primaryMedium
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .dark50,
                                                                        fontSize:
                                                                            (16 / Dimensions.designWidth).w),
                                                              ),
                                                              const SizeBox(
                                                                  height: 15),
                                                              MultiSelectButton(
                                                                isSelected:
                                                                    isDateNewest,
                                                                content: Text(
                                                                  "Newest first",
                                                                  style: TextStyles
                                                                      .primaryMedium
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .primaryDark,
                                                                    fontSize:
                                                                        (18 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  final ShowButtonBloc
                                                                      showButtonBloc =
                                                                      context.read<
                                                                          ShowButtonBloc>();
                                                                  isDateNewest =
                                                                      true;
                                                                  isDateOldest =
                                                                      false;
                                                                  isAmountHighest =
                                                                      false;
                                                                  isAmountLowest =
                                                                      false;
                                                                  sortText =
                                                                      "Latest";
                                                                  sortDisplayStatementList(
                                                                    isDateNewest,
                                                                    isDateOldest,
                                                                    isAmountHighest,
                                                                    isAmountLowest,
                                                                  );
                                                                  isShowSort =
                                                                      false;
                                                                  showButtonBloc
                                                                      .add(
                                                                    ShowButtonEvent(
                                                                      show: isDateNewest &&
                                                                          isDateOldest &&
                                                                          isAmountHighest &&
                                                                          isAmountLowest,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              const SizeBox(
                                                                  height: 10),
                                                              MultiSelectButton(
                                                                isSelected:
                                                                    isDateOldest,
                                                                content: Text(
                                                                  "Oldest first",
                                                                  style: TextStyles
                                                                      .primaryMedium
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .primaryDark,
                                                                    fontSize:
                                                                        (18 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  final ShowButtonBloc
                                                                      showButtonBloc =
                                                                      context.read<
                                                                          ShowButtonBloc>();
                                                                  isDateNewest =
                                                                      false;
                                                                  isDateOldest =
                                                                      true;
                                                                  isAmountHighest =
                                                                      false;
                                                                  isAmountLowest =
                                                                      false;
                                                                  sortText =
                                                                      "Oldest";
                                                                  sortDisplayStatementList(
                                                                    isDateNewest,
                                                                    isDateOldest,
                                                                    isAmountHighest,
                                                                    isAmountLowest,
                                                                  );
                                                                  isShowSort =
                                                                      false;
                                                                  showButtonBloc
                                                                      .add(
                                                                    ShowButtonEvent(
                                                                      show: isDateNewest &&
                                                                          isDateOldest &&
                                                                          isAmountHighest &&
                                                                          isAmountLowest,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              const SizeBox(
                                                                  height: 20),
                                                              Text(
                                                                "Amount",
                                                                style: TextStyles
                                                                    .primaryMedium
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .dark50,
                                                                        fontSize:
                                                                            (16 / Dimensions.designWidth).w),
                                                              ),
                                                              const SizeBox(
                                                                  height: 15),
                                                              MultiSelectButton(
                                                                isSelected:
                                                                    isAmountHighest,
                                                                content: Text(
                                                                  "Highest amount first",
                                                                  style: TextStyles
                                                                      .primaryMedium
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .primaryDark,
                                                                    fontSize:
                                                                        (18 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  final ShowButtonBloc
                                                                      showButtonBloc =
                                                                      context.read<
                                                                          ShowButtonBloc>();
                                                                  isDateNewest =
                                                                      false;
                                                                  isDateOldest =
                                                                      false;
                                                                  isAmountHighest =
                                                                      true;
                                                                  isAmountLowest =
                                                                      false;
                                                                  sortText =
                                                                      "Highest";
                                                                  sortDisplayStatementList(
                                                                    isDateNewest,
                                                                    isDateOldest,
                                                                    isAmountHighest,
                                                                    isAmountLowest,
                                                                  );
                                                                  isShowSort =
                                                                      false;
                                                                  showButtonBloc
                                                                      .add(
                                                                    ShowButtonEvent(
                                                                      show: isDateNewest &&
                                                                          isDateOldest &&
                                                                          isAmountHighest &&
                                                                          isAmountLowest,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              const SizeBox(
                                                                  height: 10),
                                                              MultiSelectButton(
                                                                isSelected:
                                                                    isAmountLowest,
                                                                content: Text(
                                                                  "Lowest amount first",
                                                                  style: TextStyles
                                                                      .primaryMedium
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .primaryDark,
                                                                    fontSize:
                                                                        (18 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  final ShowButtonBloc
                                                                      showButtonBloc =
                                                                      context.read<
                                                                          ShowButtonBloc>();
                                                                  isDateNewest =
                                                                      false;
                                                                  isDateOldest =
                                                                      false;
                                                                  isAmountHighest =
                                                                      false;
                                                                  isAmountLowest =
                                                                      true;
                                                                  sortText =
                                                                      "Lowest";
                                                                  sortDisplayStatementList(
                                                                    isDateNewest,
                                                                    isDateOldest,
                                                                    isAmountHighest,
                                                                    isAmountLowest,
                                                                  );
                                                                  isShowSort =
                                                                      false;
                                                                  showButtonBloc
                                                                      .add(
                                                                    ShowButtonEvent(
                                                                      show: isDateNewest &&
                                                                          isDateOldest &&
                                                                          isAmountHighest &&
                                                                          isAmountLowest,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // GradientButton(
                                                        //   onTap: () {
                                                        //     final ShowButtonBloc
                                                        //         showButtonBloc = context
                                                        //             .read<ShowButtonBloc>();
                                                        //     isShowSort = false;
                                                        //     showButtonBloc.add(
                                                        //       ShowButtonEvent(
                                                        //         show: isShowFilter,
                                                        //       ),
                                                        //     );
                                                        //   },
                                                        //   text:
                                                        //       "Show ${displayStatementList.length} transactions",
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          // ! Deposit tab related draggable listview UI
                                          falsy: BlocBuilder<ShowButtonBloc,
                                              ShowButtonState>(
                                            builder: (context, state) {
                                              return Ternary(
                                                condition:
                                                    !isShowDepositFilter &&
                                                        !isShowDepositSort,
                                                truthy: SizedBox(
                                                  height: 85.h,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          // ! Recent Transactions
                                                          Text(
                                                            labels[10]
                                                                ["labelText"],
                                                            style: TextStyles
                                                                .primary
                                                                .copyWith(
                                                              color: AppColors
                                                                  .dark50,
                                                              fontSize: (16 /
                                                                      Dimensions
                                                                          .designWidth)
                                                                  .w,
                                                            ),
                                                          ),
                                                          // ! Download statement
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                Routes
                                                                    .downloadStatement,
                                                                arguments:
                                                                    DownloadStatementArgumentModel(
                                                                  accountNumber:
                                                                      accountDetails[
                                                                              0]
                                                                          [
                                                                          "accountNumber"],
                                                                ).toMap(),
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  ImageConstants
                                                                      .download,
                                                                  width: (15 /
                                                                          Dimensions
                                                                              .designWidth)
                                                                      .w,
                                                                  height: (15 /
                                                                          Dimensions
                                                                              .designWidth)
                                                                      .w,
                                                                ),
                                                                const SizeBox(
                                                                    width: 10),
                                                                Text(
                                                                  labels[89][
                                                                      "labelText"],
                                                                  style: TextStyles
                                                                      .primary
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .dark50,
                                                                    fontSize:
                                                                        (16 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizeBox(height: 15),
                                                      // ! Account number, sort and filter bar
                                                      Container(
                                                        width: 100.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular((10 /
                                                                    Dimensions
                                                                        .designWidth)
                                                                .w),
                                                          ),
                                                          color: AppColors
                                                              .primary10,
                                                        ),
                                                        padding: EdgeInsets.all(
                                                          (10 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // ! pick subaccount
                                                            InkWell(
                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  builder:
                                                                      (context) {
                                                                    return Container(
                                                                      width:
                                                                          100.w,
                                                                      height: (10
                                                                              .h) *
                                                                          depositDetails
                                                                              .length,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                        vertical:
                                                                            (PaddingConstants.horizontalPadding / Dimensions.designHeight).h,
                                                                        horizontal:
                                                                            (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular((10 / Dimensions.designWidth).w),
                                                                          topRight:
                                                                              Radius.circular((10 / Dimensions.designWidth).w),
                                                                        ),
                                                                      ),
                                                                      child: BlocBuilder<
                                                                          ShowButtonBloc,
                                                                          ShowButtonState>(
                                                                        builder:
                                                                            (context1,
                                                                                state) {
                                                                          return Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Ternary(
                                                                                condition: isChangingDepositAccount,
                                                                                truthy: Center(
                                                                                  child: SpinKitFadingCircle(
                                                                                    color: AppColors.primary,
                                                                                    size: (50 / Dimensions.designWidth).w,
                                                                                  ),
                                                                                ),
                                                                                falsy: Expanded(
                                                                                  child: ListView.builder(
                                                                                    itemCount: depositDetails.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return ListTile(
                                                                                        dense: true,
                                                                                        onTap: () async {
                                                                                          final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
                                                                                          isChangingDepositAccount = true;
                                                                                          showButtonBloc.add(
                                                                                            ShowButtonEvent(show: isChangingDepositAccount),
                                                                                          );
                                                                                          await storage.write(key: "chosenFdAccount", value: index.toString());
                                                                                          storageChosenFdAccount = int.parse(await storage.read(key: "chosenFdAccount") ?? "0");
                                                                                          log("storageChosenFdAccount -> $storageChosenFdAccount");

                                                                                          getCustomerFdAccountStatement();

                                                                                          isChangingDepositAccount = false;
                                                                                          showButtonBloc.add(
                                                                                            ShowButtonEvent(show: isChangingDepositAccount),
                                                                                          );
                                                                                          if (context1.mounted) {
                                                                                            Navigator.pop(context1);
                                                                                          }
                                                                                        },
                                                                                        leading: const CustomCircleAvatarAsset(imgUrl: ImageConstants.uaeFlag),
                                                                                        title: Text(
                                                                                          depositDetails[index]["depositAccountNumber"],
                                                                                          style: TextStyles.primaryBold.copyWith(color: AppColors.primary, fontSize: (16 / Dimensions.designWidth).w),
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          // accountDetails[index]["productCode"] == "1001" ? labels[7]["labelText"] : labels[92]["labelText"],
                                                                                          "Fixed Deposit",
                                                                                          style: TextStyles.primaryMedium.copyWith(color: AppColors.dark50, fontSize: (14 / Dimensions.designWidth).w),
                                                                                        ),
                                                                                        trailing: Text(
                                                                                          depositDetails[index]["depositPrincipalAmount"],
                                                                                          style: TextStyles.primaryMedium.copyWith(color: AppColors.dark50, fontSize: (14 / Dimensions.designWidth).w),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child:
                                                                  const SizeBox(),
                                                              // const Row(
                                                              //   children: [
                                                              //     // Text(
                                                              //     //   "Account: ",
                                                              //     //   style: TextStyles
                                                              //     //       .primaryMedium
                                                              //     //       .copyWith(
                                                              //     //     color: AppColors
                                                              //     //         .dark50,
                                                              //     //     fontSize: (14 /
                                                              //     //             Dimensions
                                                              //     //                 .designWidth)
                                                              //     //         .w,
                                                              //     //   ),
                                                              //     // ),
                                                              //     // Text(
                                                              //     //   // "${accountDetails[storageChosenAccount ?? 0]["productCode"] == "1001" ? labels[7]["labelText"] : labels[92]["labelText"]} ****${accountDetails[storageChosenAccount ?? 0]["accountNumber"].substring(accountDetails[storageChosenAccount ?? 0]["accountNumber"].length - 4, accountDetails[storageChosenAccount ?? 0]["accountNumber"].length)}",
                                                              //     //   "Fixed ****${depositDetails[storageChosenFdAccount ?? 0]["depositAccountNumber"].substring(depositDetails[storageChosenFdAccount ?? 0]["depositAccountNumber"].length - 4, depositDetails[storageChosenFdAccount ?? 0]["depositAccountNumber"].length)}",
                                                              //     //   style: TextStyles
                                                              //     //       .primaryMedium
                                                              //     //       .copyWith(
                                                              //     //     color: AppColors
                                                              //     //         .primary,
                                                              //     //     fontSize: (14 /
                                                              //     //             Dimensions
                                                              //     //                 .designWidth)
                                                              //     //         .w,
                                                              //     //   ),
                                                              //     // ),
                                                              //     // Icon(
                                                              //     //   Icons
                                                              //     //       .arrow_drop_down_rounded,
                                                              //     //   color: AppColors
                                                              //     //       .dark80,
                                                              //     //   size: (20 /
                                                              //     //           Dimensions
                                                              //     //               .designWidth)
                                                              //     //       .w,
                                                              //     // ),
                                                              //   ],
                                                              // ),
                                                            ),
                                                            // const SizeBox(width: 5),
                                                            // Text(
                                                            //   "|",
                                                            //   style: TextStyles
                                                            //       .primaryMedium
                                                            //       .copyWith(
                                                            //     color:
                                                            //         AppColors.dark50,
                                                            //     fontSize: (16 /
                                                            //             Dimensions
                                                            //                 .designWidth)
                                                            //         .w,
                                                            //   ),
                                                            // ),
                                                            // const SizeBox(width: 10),
                                                            InkWell(
                                                              onTap: () {
                                                                // final ShowButtonBloc
                                                                //     showButtonBloc =
                                                                //     context.read<
                                                                //         ShowButtonBloc>();
                                                                // isShowFilter = true;
                                                                // showButtonBloc.add(
                                                                //   ShowButtonEvent(
                                                                //       show:
                                                                //           isShowFilter),
                                                                // );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    ImageConstants
                                                                        .filter,
                                                                    width: (12 /
                                                                            Dimensions.designHeight)
                                                                        .w,
                                                                    height: (12 /
                                                                            Dimensions.designWidth)
                                                                        .w,
                                                                  ),
                                                                  const SizeBox(
                                                                      width: 5),
                                                                  Text(
                                                                    filterTextFD,
                                                                    style: TextStyles
                                                                        .primaryMedium
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .primary,
                                                                      fontSize:
                                                                          (14 / Dimensions.designWidth)
                                                                              .w,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizeBox(
                                                                width: 10),
                                                            Text(
                                                              "|",
                                                              style: TextStyles
                                                                  .primaryMedium
                                                                  .copyWith(
                                                                color: AppColors
                                                                    .dark50,
                                                                fontSize: (16 /
                                                                        Dimensions
                                                                            .designWidth)
                                                                    .w,
                                                              ),
                                                            ),
                                                            const SizeBox(
                                                                width: 10),
                                                            InkWell(
                                                              onTap: () {
                                                                final ShowButtonBloc
                                                                    showButtonBloc =
                                                                    context.read<
                                                                        ShowButtonBloc>();
                                                                isShowDepositSort =
                                                                    true;
                                                                showButtonBloc
                                                                    .add(
                                                                  ShowButtonEvent(
                                                                      show:
                                                                          isShowSort),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    ImageConstants
                                                                        .sort,
                                                                    width: (10 /
                                                                            Dimensions.designHeight)
                                                                        .w,
                                                                    height: (10 /
                                                                            Dimensions.designWidth)
                                                                        .w,
                                                                  ),
                                                                  const SizeBox(
                                                                      width: 5),
                                                                  Text(
                                                                    sortTextFD,
                                                                    style: TextStyles
                                                                        .primaryMedium
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .primary,
                                                                      fontSize:
                                                                          (14 / Dimensions.designWidth)
                                                                              .w,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizeBox(height: 15),
                                                      Ternary(
                                                        condition:
                                                            displayFdStatementList
                                                                .isEmpty,
                                                        truthy: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizeBox(
                                                                height: 70),
                                                            Text(
                                                              "No FD transactions",
                                                              style: TextStyles
                                                                  .primaryBold
                                                                  .copyWith(
                                                                color: AppColors
                                                                    .dark30,
                                                                fontSize: (24 /
                                                                        Dimensions
                                                                            .designWidth)
                                                                    .w,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        falsy: Expanded(
                                                          child:
                                                              ListView.builder(
                                                            controller:
                                                                scrollController,
                                                            itemCount:
                                                                displayFdStatementList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return DashboardTransactionListTile(
                                                                onTap: () {},
                                                                isCredit: true,
                                                                title: displayFdStatementList[
                                                                        index][
                                                                    "description"],
                                                                name: displayFdStatementList[
                                                                        index][
                                                                    "customerName"],
                                                                amount: double.parse(
                                                                    displayFdStatementList[
                                                                            index]
                                                                        [
                                                                        "amount"]),
                                                                currency: displayFdStatementList[
                                                                        index][
                                                                    "amountCurrency"],
                                                                date: DateFormat(
                                                                        'EEE, MMM dd yyyy')
                                                                    .format(
                                                                  DateTime
                                                                      .parse(
                                                                    displayFdStatementList[
                                                                            index]
                                                                        [
                                                                        "bookingDate"],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                falsy: Ternary(
                                                  condition:
                                                      isShowDepositFilter,
                                                  truthy: const SizedBox(
                                                      // height:
                                                      //     // _dsController.size,
                                                      //     29.h,
                                                      // child: Column(
                                                      //   crossAxisAlignment:
                                                      //       CrossAxisAlignment.start,
                                                      //   children: [
                                                      //     Expanded(
                                                      //       child: Column(
                                                      //         crossAxisAlignment:
                                                      //             CrossAxisAlignment
                                                      //                 .start,
                                                      //         children: [
                                                      //           Row(
                                                      //             mainAxisAlignment:
                                                      //                 MainAxisAlignment
                                                      //                     .spaceBetween,
                                                      //             children: [
                                                      //               Text(
                                                      //                 "Filter",
                                                      //                 style: TextStyles
                                                      //                     .primaryBold
                                                      //                     .copyWith(
                                                      //                         color: AppColors
                                                      //                             .dark50,
                                                      //                         fontSize:
                                                      //                             (20 / Dimensions.designWidth)
                                                      //                                 .w),
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //           const SizeBox(
                                                      //               height: 20),
                                                      //           Text(
                                                      //             "Transaction type",
                                                      //             style: TextStyles
                                                      //                 .primaryMedium
                                                      //                 .copyWith(
                                                      //                     color: AppColors
                                                      //                         .dark50,
                                                      //                     fontSize: (16 /
                                                      //                             Dimensions
                                                      //                                 .designWidth)
                                                      //                         .w),
                                                      //           ),
                                                      //           const SizeBox(
                                                      //               height: 15),
                                                      //           Row(
                                                      //             children: [
                                                      //               SolidButton(
                                                      //                 width: (118 /
                                                      //                         Dimensions
                                                      //                             .designWidth)
                                                      //                     .w,
                                                      //                 color:
                                                      //                     Colors.white,
                                                      //                 fontColor:
                                                      //                     AppColors
                                                      //                         .primary,
                                                      //                 boxShadow: [
                                                      //                   BoxShadows
                                                      //                       .primary
                                                      //                 ],
                                                      //                 borderColor: isAllSelected
                                                      //                     ? const Color
                                                      //                             .fromRGBO(
                                                      //                         0,
                                                      //                         184,
                                                      //                         148,
                                                      //                         0.21)
                                                      //                     : Colors
                                                      //                         .transparent,
                                                      //                 onTap: () {
                                                      //                   final ShowButtonBloc
                                                      //                       showButtonBloc =
                                                      //                       context.read<
                                                      //                           ShowButtonBloc>();
                                                      //                   isAllSelected =
                                                      //                       true;
                                                      //                   isSentSelected =
                                                      //                       false;
                                                      //                   isReceivedSelected =
                                                      //                       false;
                                                      //                   filterText =
                                                      //                       "All";
                                                      //                   populateDisplayStatementList(
                                                      //                     isAllSelected,
                                                      //                     isSentSelected,
                                                      //                     isReceivedSelected,
                                                      //                   );
                                                      //                   sortDisplayStatementList(
                                                      //                     isDateNewest,
                                                      //                     isDateOldest,
                                                      //                     isAmountHighest,
                                                      //                     isAmountLowest,
                                                      //                   );
                                                      //                   showButtonBloc
                                                      //                       .add(
                                                      //                     ShowButtonEvent(
                                                      //                       show: isAllSelected &&
                                                      //                           isSentSelected &&
                                                      //                           isReceivedSelected,
                                                      //                     ),
                                                      //                   );
                                                      //                 },
                                                      //                 text: "All",
                                                      //               ),
                                                      //               const SizeBox(
                                                      //                   width: 15),
                                                      //               SolidButton(
                                                      //                 width: (118 /
                                                      //                         Dimensions
                                                      //                             .designWidth)
                                                      //                     .w,
                                                      //                 color:
                                                      //                     Colors.white,
                                                      //                 fontColor:
                                                      //                     AppColors
                                                      //                         .primary,
                                                      //                 boxShadow: [
                                                      //                   BoxShadows
                                                      //                       .primary
                                                      //                 ],
                                                      //                 borderColor: isSentSelected
                                                      //                     ? const Color
                                                      //                             .fromRGBO(
                                                      //                         0,
                                                      //                         184,
                                                      //                         148,
                                                      //                         0.21)
                                                      //                     : Colors
                                                      //                         .transparent,
                                                      //                 onTap: () {
                                                      //                   final ShowButtonBloc
                                                      //                       showButtonBloc =
                                                      //                       context.read<
                                                      //                           ShowButtonBloc>();
                                                      //                   isAllSelected =
                                                      //                       false;
                                                      //                   isSentSelected =
                                                      //                       true;
                                                      //                   isReceivedSelected =
                                                      //                       false;
                                                      //                   filterText =
                                                      //                       "Sent";
                                                      //                   populateDisplayStatementList(
                                                      //                     isAllSelected,
                                                      //                     isSentSelected,
                                                      //                     isReceivedSelected,
                                                      //                   );
                                                      //                   sortDisplayStatementList(
                                                      //                     isDateNewest,
                                                      //                     isDateOldest,
                                                      //                     isAmountHighest,
                                                      //                     isAmountLowest,
                                                      //                   );
                                                      //                   showButtonBloc
                                                      //                       .add(
                                                      //                     ShowButtonEvent(
                                                      //                       show: isAllSelected &&
                                                      //                           isSentSelected &&
                                                      //                           isReceivedSelected,
                                                      //                     ),
                                                      //                   );
                                                      //                 },
                                                      //                 text: "Sent",
                                                      //               ),
                                                      //               const SizeBox(
                                                      //                   width: 15),
                                                      //               SolidButton(
                                                      //                 width: (118 /
                                                      //                         Dimensions
                                                      //                             .designWidth)
                                                      //                     .w,
                                                      //                 color:
                                                      //                     Colors.white,
                                                      //                 fontColor:
                                                      //                     AppColors
                                                      //                         .primary,
                                                      //                 boxShadow: [
                                                      //                   BoxShadows
                                                      //                       .primary
                                                      //                 ],
                                                      //                 borderColor: isReceivedSelected
                                                      //                     ? const Color
                                                      //                             .fromRGBO(
                                                      //                         0,
                                                      //                         184,
                                                      //                         148,
                                                      //                         0.21)
                                                      //                     : Colors
                                                      //                         .transparent,
                                                      //                 onTap: () {
                                                      //                   final ShowButtonBloc
                                                      //                       showButtonBloc =
                                                      //                       context.read<
                                                      //                           ShowButtonBloc>();
                                                      //                   isAllSelected =
                                                      //                       false;
                                                      //                   isSentSelected =
                                                      //                       false;
                                                      //                   isReceivedSelected =
                                                      //                       true;
                                                      //                   filterText =
                                                      //                       "Received";
                                                      //                   populateDisplayStatementList(
                                                      //                     isAllSelected,
                                                      //                     isSentSelected,
                                                      //                     isReceivedSelected,
                                                      //                   );
                                                      //                   sortDisplayStatementList(
                                                      //                     isDateNewest,
                                                      //                     isDateOldest,
                                                      //                     isAmountHighest,
                                                      //                     isAmountLowest,
                                                      //                   );
                                                      //                   showButtonBloc
                                                      //                       .add(
                                                      //                     ShowButtonEvent(
                                                      //                       show: isAllSelected &&
                                                      //                           isSentSelected &&
                                                      //                           isReceivedSelected,
                                                      //                     ),
                                                      //                   );
                                                      //                 },
                                                      //                 text: "Received",
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //     GradientButton(
                                                      //       onTap: () {
                                                      //         final ShowButtonBloc
                                                      //             showButtonBloc =
                                                      //             context.read<
                                                      //                 ShowButtonBloc>();
                                                      //         isShowFilter = false;
                                                      //         showButtonBloc.add(
                                                      //           ShowButtonEvent(
                                                      //             show: isShowFilter,
                                                      //           ),
                                                      //         );
                                                      //       },
                                                      //       text:
                                                      //           "Show ${displayStatementList.length} transactions",
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      ),
                                                  falsy: SizedBox(
                                                    height: 85.h,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Sort",
                                                                    style: TextStyles
                                                                        .primaryBold
                                                                        .copyWith(
                                                                            color:
                                                                                AppColors.dark50,
                                                                            fontSize: (20 / Dimensions.designWidth).w),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizeBox(
                                                                  height: 20),
                                                              Text(
                                                                "Date",
                                                                style: TextStyles
                                                                    .primaryMedium
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .dark50,
                                                                        fontSize:
                                                                            (16 / Dimensions.designWidth).w),
                                                              ),
                                                              const SizeBox(
                                                                  height: 15),
                                                              MultiSelectButton(
                                                                isSelected:
                                                                    isFdDateNewest,
                                                                content: Text(
                                                                  "Newest first",
                                                                  style: TextStyles
                                                                      .primaryMedium
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .primaryDark,
                                                                    fontSize:
                                                                        (18 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  final ShowButtonBloc
                                                                      showButtonBloc =
                                                                      context.read<
                                                                          ShowButtonBloc>();
                                                                  isFdDateNewest =
                                                                      true;
                                                                  isFdDateOldest =
                                                                      false;
                                                                  isFdAmountHighest =
                                                                      false;
                                                                  isFdAmountLowest =
                                                                      false;
                                                                  sortTextFD =
                                                                      "Latest";
                                                                  sortDisplayFdStatementList(
                                                                    isFdDateNewest,
                                                                    isFdDateOldest,
                                                                    isFdAmountHighest,
                                                                    isFdAmountLowest,
                                                                  );
                                                                  isShowDepositSort =
                                                                      false;
                                                                  showButtonBloc
                                                                      .add(
                                                                    ShowButtonEvent(
                                                                      show: isFdDateNewest &&
                                                                          isFdDateOldest &&
                                                                          isFdAmountHighest &&
                                                                          isFdAmountLowest,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              const SizeBox(
                                                                  height: 10),
                                                              MultiSelectButton(
                                                                isSelected:
                                                                    isFdDateOldest,
                                                                content: Text(
                                                                  "Oldest first",
                                                                  style: TextStyles
                                                                      .primaryMedium
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .primaryDark,
                                                                    fontSize:
                                                                        (18 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  final ShowButtonBloc
                                                                      showButtonBloc =
                                                                      context.read<
                                                                          ShowButtonBloc>();
                                                                  isFdDateNewest =
                                                                      false;
                                                                  isFdDateOldest =
                                                                      true;
                                                                  isFdAmountHighest =
                                                                      false;
                                                                  isFdAmountLowest =
                                                                      false;
                                                                  sortTextFD =
                                                                      "Oldest";
                                                                  sortDisplayFdStatementList(
                                                                    isFdDateNewest,
                                                                    isFdDateOldest,
                                                                    isFdAmountHighest,
                                                                    isFdAmountLowest,
                                                                  );
                                                                  isShowDepositSort =
                                                                      false;
                                                                  showButtonBloc
                                                                      .add(
                                                                    ShowButtonEvent(
                                                                      show: isFdDateNewest &&
                                                                          isFdDateOldest &&
                                                                          isFdAmountHighest &&
                                                                          isFdAmountLowest,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              const SizeBox(
                                                                  height: 20),
                                                              Text(
                                                                "Amount",
                                                                style: TextStyles
                                                                    .primaryMedium
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .dark50,
                                                                        fontSize:
                                                                            (16 / Dimensions.designWidth).w),
                                                              ),
                                                              const SizeBox(
                                                                  height: 15),
                                                              MultiSelectButton(
                                                                isSelected:
                                                                    isFdAmountHighest,
                                                                content: Text(
                                                                  "Highest amount first",
                                                                  style: TextStyles
                                                                      .primaryMedium
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .primaryDark,
                                                                    fontSize:
                                                                        (18 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  final ShowButtonBloc
                                                                      showButtonBloc =
                                                                      context.read<
                                                                          ShowButtonBloc>();
                                                                  isFdDateNewest =
                                                                      false;
                                                                  isFdDateOldest =
                                                                      false;
                                                                  isFdAmountHighest =
                                                                      true;
                                                                  isFdAmountLowest =
                                                                      false;
                                                                  sortTextFD =
                                                                      "Highest";
                                                                  sortDisplayFdStatementList(
                                                                    isFdDateNewest,
                                                                    isFdDateOldest,
                                                                    isFdAmountHighest,
                                                                    isFdAmountLowest,
                                                                  );
                                                                  isShowDepositSort =
                                                                      false;
                                                                  showButtonBloc
                                                                      .add(
                                                                    ShowButtonEvent(
                                                                      show: isFdDateNewest &&
                                                                          isFdDateOldest &&
                                                                          isFdAmountHighest &&
                                                                          isFdAmountLowest,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              const SizeBox(
                                                                  height: 10),
                                                              MultiSelectButton(
                                                                isSelected:
                                                                    isFdAmountLowest,
                                                                content: Text(
                                                                  "Lowest amount first",
                                                                  style: TextStyles
                                                                      .primaryMedium
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .primaryDark,
                                                                    fontSize:
                                                                        (18 / Dimensions.designWidth)
                                                                            .w,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  final ShowButtonBloc
                                                                      showButtonBloc =
                                                                      context.read<
                                                                          ShowButtonBloc>();
                                                                  isFdDateNewest =
                                                                      false;
                                                                  isFdDateOldest =
                                                                      false;
                                                                  isFdAmountHighest =
                                                                      false;
                                                                  isFdAmountLowest =
                                                                      true;
                                                                  sortTextFD =
                                                                      "Lowest";
                                                                  sortDisplayFdStatementList(
                                                                    isFdDateNewest,
                                                                    isFdDateOldest,
                                                                    isFdAmountHighest,
                                                                    isFdAmountLowest,
                                                                  );
                                                                  isShowDepositSort =
                                                                      false;
                                                                  showButtonBloc
                                                                      .add(
                                                                    ShowButtonEvent(
                                                                      show: isFdDateNewest &&
                                                                          isFdDateOldest &&
                                                                          isFdAmountHighest &&
                                                                          isFdAmountLowest,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // GradientButton(
                                                        //   onTap: () {
                                                        //     final ShowButtonBloc
                                                        //         showButtonBloc = context
                                                        //             .read<ShowButtonBloc>();
                                                        //     isShowSort = false;
                                                        //     showButtonBloc.add(
                                                        //       ShowButtonEvent(
                                                        //         show: isShowFilter,
                                                        //       ),
                                                        //     );
                                                        //   },
                                                        //   text:
                                                        //       "Show ${displayStatementList.length} transactions",
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ],
            );
          }
        },
      ),
    );
  }

  void populateDisplayStatementList(bool isAll, bool isSent, bool isReceived) {
    displayStatementList.clear();
    if (isAll) {
      displayStatementList.addAll(statementList);
    }
    if (isSent) {
      for (var statement in statementList) {
        if (statement["creditAmount"] != 0) {
          displayStatementList.add(statement);
        }
      }
    }
    if (isReceived) {
      for (var statement in statementList) {
        if (statement["creditAmount"] == 0) {
          displayStatementList.add(statement);
        }
      }
    }
  }

  void sortDisplayStatementList(
      bool isNewest, bool isOldest, bool isHighest, bool isLowest) {
    if (isNewest) {
      displayStatementList.sort((a, b) => DateTime.parse(b["bookingDate"])
          .compareTo(DateTime.parse(a["bookingDate"])));
    }
    if (isOldest) {
      displayStatementList.sort((a, b) => DateTime.parse(a["bookingDate"])
          .compareTo(DateTime.parse(b["bookingDate"])));
    }
    if (isHighest) {
      displayStatementList.sort((a, b) => (double.parse(b["creditAmount"])
          .compareTo(double.parse(a["creditAmount"]))));
    }
    if (isLowest) {
      displayStatementList.sort((a, b) => (double.parse(a["creditAmount"])
          .compareTo(double.parse(b["creditAmount"]))));
    }
  }

  void sortDisplayFdStatementList(
      bool isNewest, bool isOldest, bool isHighest, bool isLowest) {
    if (isNewest) {
      displayFdStatementList.sort((a, b) => DateTime.parse(b["bookingDate"])
          .compareTo(DateTime.parse(a["bookingDate"])));
    }
    if (isOldest) {
      displayFdStatementList.sort((a, b) => DateTime.parse(a["bookingDate"])
          .compareTo(DateTime.parse(b["bookingDate"])));
    }
    if (isHighest) {
      displayFdStatementList.sort((a, b) =>
          (double.parse(b["amount"]).compareTo(double.parse(a["amount"]))));
    }
    if (isLowest) {
      displayFdStatementList.sort((a, b) =>
          (double.parse(a["amount"]).compareTo(double.parse(b["amount"]))));
    }
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
