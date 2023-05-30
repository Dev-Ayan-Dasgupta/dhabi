// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_bloc.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_event.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_bloc.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_event.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/tabs/tab.dart';
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

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen>
    with SingleTickerProviderStateMixin {
  late RetailDashboardArgumentModel retailDashboardArgumentModel;

  late TabController tabController;
  int tabIndex = 0;

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  int _scrollIndex = 0;

  List accountDetails = [];
  List statementList = [];

  bool isShowExplore = false;

  @override
  void initState() {
    super.initState();
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
          message: messages[58]["messageText"],
          actionWidget: SolidButton(
            onTap: () {
              Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final TabbarBloc tabbarBloc = context.read<TabbarBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarMenu(),
        title: SvgPicture.asset(ImageConstants.dhabiBusinessText),
        actions: const [AppBarAction()],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
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
                            horizontal: (15 / Dimensions.designWidth).w,
                          ),
                          child: BlocBuilder<TabbarBloc, TabbarState>(
                            builder: (context, state) {
                              return TabBar(
                                controller: tabController,
                                onTap: (index) {
                                  if (index == 3) {
                                    setState(() {
                                      isShowExplore = true;
                                    });
                                    Navigator.pushNamed(
                                        context, Routes.exploreBusiness);
                                  }
                                  _scrollOffset = 0;
                                  _scrollIndex = 0;
                                  tabbarBloc.add(TabbarEvent(index: index));
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
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                                unselectedLabelColor: Colors.black,
                                unselectedLabelStyle:
                                    TextStyles.primaryMedium.copyWith(
                                  color: const Color(0xFF000000),
                                  fontSize: (16 / Dimensions.designWidth).w,
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
                                                  ? (PaddingConstants
                                                              .horizontalPadding /
                                                          Dimensions
                                                              .designWidth)
                                                      .w
                                                  : 0,
                                            ),
                                            child: AccountSummaryTile(
                                              onTap: () {},
                                              imgUrl: accountDetails[index]
                                                          ["accountCurrency"] ==
                                                      "AED"
                                                  ? ImageConstants.uaeFlag
                                                  : ImageConstants.usaFlag,
                                              accountType: accountDetails[index]
                                                          ["productCode"] ==
                                                      "1001"
                                                  ? "Current"
                                                  : "Savings",
                                              currency: "",
                                              // accountDetails[index]
                                              //     ["accountCurrency"],
                                              amount: accountDetails[index]
                                                  ["currentBalance"],
                                              subText: "",
                                              subImgUrl: "",
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
                                  const SizeBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              // ! Deposits Tab View
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
                                                        Dimensions.designWidth)
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              Routes.businessDepositDetails);
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                        Dimensions.designWidth)
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          topLeft:
                              Radius.circular((20 / Dimensions.designWidth).w),
                          topRight:
                              Radius.circular((20 / Dimensions.designWidth).w),
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
                                      fontSize: (16 / Dimensions.designWidth).w,
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
                                    color:
                                        const Color.fromRGBO(34, 97, 105, 0.1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        (10 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        ImageConstants.pyramid,
                                        width: (10 / Dimensions.designHeight).w,
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
                                    color:
                                        const Color.fromRGBO(34, 97, 105, 0.1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        (10 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        ImageConstants.pyramid,
                                        width: (10 / Dimensions.designHeight).w,
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
                                        statementList[index]["creditAmount"] ==
                                            0,
                                    title:
                                        // "Tax non filer debit Tax non filer debit",
                                        statementList[index]["transactionType"],
                                    name: "Alexander Doe",
                                    amount:
                                        // 50.23,
                                        (statementList[index]["creditAmount"] !=
                                                    0
                                                ? statementList[index]
                                                    ["creditAmount"]
                                                : statementList[index]
                                                    ["debitAmount"])
                                            .toDouble(),
                                    currency:
                                        // "AED",
                                        statementList[index]["amountCurrency"],
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
        },
      ),
    );
  }
}
