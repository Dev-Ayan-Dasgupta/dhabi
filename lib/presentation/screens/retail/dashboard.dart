// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_bloc.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_event.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_state.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_bloc.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_event.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/retail_dashboard.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/tabs/tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

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
  double _scrollOffset = 0;
  int _scrollIndex = 0;

  final bool hasOnboarded = true;

  @override
  void initState() {
    super.initState();
    retailDashboardArgumentModel =
        RetailDashboardArgumentModel.fromMap(widget.argument as dynamic ?? {});
    final TabbarBloc tabbarBloc = context.read<TabbarBloc>();
    tabController = TabController(length: 3, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    final TabbarBloc tabbarBloc = context.read<TabbarBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: AppBarAvatar(
          imgUrl: retailDashboardArgumentModel.imgUrl,
          name: retailDashboardArgumentModel.name,
        ),
        title: SvgPicture.asset(ImageConstants.dhabiText),
        actions: const [AppBarAction()],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
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
                        horizontal: (15 / Dimensions.designWidth).w,
                      ),
                      child: BlocBuilder<TabbarBloc, TabbarState>(
                        builder: (context, state) {
                          return TabBar(
                            controller: tabController,
                            onTap: (index) {
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
                                              ? (15 / Dimensions.designWidth).w
                                              : 0,
                                        ),
                                        child: AccountSummaryTile(
                                          onTap: () {
                                            if (index == 2) {
                                              Navigator.pushNamed(
                                                  context, Routes.vault);
                                            }
                                          },
                                          imgUrl:
                                              "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
                                          accountType: "Savings",
                                          currency: "AED",
                                          amount: 0.00,
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
                              BlocBuilder<SummaryTileBloc, SummaryTileState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 47.w -
                                            ((6 - 1) *
                                                (6.5 / Dimensions.designWidth)
                                                    .w)),
                                    child: SizedBox(
                                      width: 90.w,
                                      height: (9 / Dimensions.designWidth).w,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 6,
                                        itemBuilder: (context, index) {
                                          return ScrollIndicator(
                                            isCurrent: (index == _scrollIndex),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizeBox(height: 12.5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // DashboardActivityTile(
                                  //   iconPath: ImageConstants.add,
                                  //   activityText: "Add Money",
                                  //   onTap: () {},
                                  // ),
                                  // const SizeBox(width: 40),
                                  DashboardActivityTile(
                                    iconPath: ImageConstants.arrowOutward,
                                    activityText: "Send Money",
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.sendMoney);
                                    },
                                  ),
                                  // const SizeBox(width: 40),
                                  // DashboardActivityTile(
                                  //   iconPath: ImageConstants.barChart,
                                  //   activityText: "Insights",
                                  //   onTap: () {
                                  //     Navigator.pushNamed(
                                  //         context, Routes.insights);
                                  //   },
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          // ! Deposits Tab View
                          Column(
                            children: [
                              const SizeBox(height: 9.5),
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 6,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: (index == 0)
                                            ? (15 / Dimensions.designWidth).w
                                            : 0,
                                      ),
                                      child: AccountSummaryTile(
                                        onTap: () {
                                          if (index == 0) {
                                            Navigator.pushNamed(
                                                context, Routes.createDeposits);
                                          }
                                          if (index == 1) {
                                            Navigator.pushNamed(
                                                context, Routes.depositDetails);
                                          }
                                        },
                                        imgUrl:
                                            "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
                                        accountType: "Savings",
                                        currency: "AED",
                                        amount: 0.00,
                                        subText: "Powered by FH",
                                        subImgUrl:
                                            "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizeBox(height: 10),
                              BlocBuilder<SummaryTileBloc, SummaryTileState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 47.w -
                                            ((6 - 1) *
                                                (6.5 / Dimensions.designWidth)
                                                    .w)),
                                    child: SizedBox(
                                      width: 90.w,
                                      height: (9 / Dimensions.designWidth).w,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 6,
                                        itemBuilder: (context, index) {
                                          return ScrollIndicator(
                                            isCurrent: (index == _scrollIndex),
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
                                    iconPath: ImageConstants.percent,
                                    activityText: "Rates",
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.interestRates);
                                    },
                                  ),
                                  const SizeBox(width: 40),
                                  DashboardActivityTile(
                                    iconPath: ImageConstants.barChart,
                                    activityText: "Insights",
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.insights);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // ! Explore Tab View
                          Column(
                            children: [
                              const SizeBox(height: 9.5),
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 6,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: (index == 0)
                                            ? (15 / Dimensions.designWidth).w
                                            : 0,
                                      ),
                                      child: AccountSummaryTile(
                                        onTap: () {},
                                        imgUrl:
                                            "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
                                        accountType: "Savings",
                                        currency: "AED",
                                        amount: 0.00,
                                        subText: "Powered by FH",
                                        subImgUrl:
                                            "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizeBox(height: 10),
                              BlocBuilder<SummaryTileBloc, SummaryTileState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 47.w -
                                          ((6 - 1) *
                                              (6.5 / Dimensions.designWidth).w),
                                    ),
                                    child: SizedBox(
                                      width: 90.w,
                                      height: (9 / Dimensions.designWidth).w,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 6,
                                        itemBuilder: (context, index) {
                                          return ScrollIndicator(
                                            isCurrent: (index == _scrollIndex),
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
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizeBox(height: 15),
              SizedBox(
                width: 100.w,
                height: (120 / Dimensions.designWidth).w,
                child: Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: (15 / Dimensions.designWidth).w,
                          ),
                          child: const DashboardBannerImage(
                            imgUrl: ImageConstants.dashboard,
                          ),
                        );
                      } else {
                        return const DashboardBannerImage(
                          imgUrl: ImageConstants.dashboard,
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizeBox(height: 15),
              const SizeBox(height: 265)
              // hasOnboarded
              //     ? const SizeBox(height: 265)
              //     : RetailDashboardOnboarding(
              //         progress: (1 / 3),
              //         stage1: true,
              //         stage2: false,
              //         stage3: false,
              //         onTap1: () {
              //           Navigator.pushNamed(
              //             context,
              //             Routes.verifyMobile,
              //             arguments:
              //                 VerifyMobileArgumentModel(isBusiness: false)
              //                     .toMap(),
              //           );
              //         },
              //         onTap2: () {},
              //         onTap3: () {
              //           Navigator.pushNamed(context, Routes.applicationAddress);
              //         },
              //       ),
            ],
          ),
          // !hasOnboarded
          //     ? const SizeBox(height: 265)
          //     :
          DraggableScrollableSheet(
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
                    topLeft: Radius.circular((20 / Dimensions.designWidth).w),
                    topRight: Radius.circular((20 / Dimensions.designWidth).w),
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
                          Radius.circular((10 / Dimensions.designWidth).w),
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
                              ImageConstants.add,
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
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 50,
                        itemBuilder: (context, index) {
                          return DashboardTransactionListTile(
                            onTap: () {},
                            isCredit: true,
                            title: "Tax non filer debit Tax non filer debit",
                            name: "Alexander Doe",
                            amount: 50.23,
                            currency: "AED",
                            date: "Tue, Apr 1 2022",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }
}

// class ExploreView extends StatelessWidget {
//   const ExploreView({
//     super.key,
//     required ScrollController scrollController,
//     required int scrollIndex,
//   })  : _scrollController = scrollController,
//         _scrollIndex = scrollIndex;

//   final ScrollController _scrollController;
//   final int _scrollIndex;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizeBox(height: 9.5),
//         Expanded(
//           child: ListView.builder(
//             controller: _scrollController,
//             scrollDirection: Axis.horizontal,
//             itemCount: 6,
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 return Padding(
//                   padding: EdgeInsets.only(
//                     left: (15 / Dimensions.designWidth).w,
//                   ),
//                   child: AccountSummaryTile(
//                     onTap: () {},
//                     imgUrl:
//                         "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
//                     accountType: "Savings",
//                     currency: "AED",
//                     amount: 0.00,
//                     subText: "Powered by FH",
//                     subImgUrl:
//                         "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
//                   ),
//                 );
//               } else {
//                 return AccountSummaryTile(
//                   onTap: () {},
//                   imgUrl: "",
//                   accountType: "Savings",
//                   currency: "USD",
//                   amount: 0.00,
//                   subText: "",
//                   subImgUrl: "",
//                 );
//               }
//             },
//           ),
//         ),
//         const SizeBox(height: 10),
//         BlocBuilder<SummaryTileBloc, SummaryTileState>(
//           builder: (context, state) {
//             return Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal:
//                       47.w - ((6 - 1) * (6.5 / Dimensions.designWidth).w)),
//               child: SizedBox(
//                 width: 90.w,
//                 height: (9 / Dimensions.designWidth).w,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: 6,
//                   itemBuilder: (context, index) {
//                     return ScrollIndicator(
//                       isCurrent: (index == _scrollIndex),
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//         const SizeBox(height: 15),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             DashboardActivityTile(
//               iconPath: ImageConstants.add,
//               activityText: "Add Money",
//               onTap: () {},
//             ),
//             const SizeBox(width: 40),
//             DashboardActivityTile(
//               iconPath: ImageConstants.arrowOutward,
//               activityText: "Send Money",
//               onTap: () {},
//             ),
//             const SizeBox(width: 40),
//             DashboardActivityTile(
//               iconPath: ImageConstants.barChart,
//               activityText: "Insights",
//               onTap: () {},
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class DepositsView extends StatelessWidget {
//   const DepositsView({
//     super.key,
//     required ScrollController scrollController,
//     required int scrollIndex,
//   })  : _scrollController = scrollController,
//         _scrollIndex = scrollIndex;

//   final ScrollController _scrollController;
//   final int _scrollIndex;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizeBox(height: 9.5),
//         Expanded(
//           child: ListView.builder(
//             controller: _scrollController,
//             scrollDirection: Axis.horizontal,
//             itemCount: 6,
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 return Padding(
//                   padding: EdgeInsets.only(
//                     left: (15 / Dimensions.designWidth).w,
//                   ),
//                   child: AccountSummaryTile(
//                     onTap: () {},
//                     imgUrl:
//                         "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
//                     accountType: "Savings",
//                     currency: "AED",
//                     amount: 0.00,
//                     subText: "Powered by FH",
//                     subImgUrl:
//                         "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
//                   ),
//                 );
//               } else {
//                 return AccountSummaryTile(
//                   onTap: () {},
//                   imgUrl: "",
//                   accountType: "Savings",
//                   currency: "USD",
//                   amount: 0.00,
//                   subText: "",
//                   subImgUrl: "",
//                 );
//               }
//             },
//           ),
//         ),
//         const SizeBox(height: 10),
//         BlocBuilder<SummaryTileBloc, SummaryTileState>(
//           builder: (context, state) {
//             return Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal:
//                       47.w - ((6 - 1) * (6.5 / Dimensions.designWidth).w)),
//               child: SizedBox(
//                 width: 90.w,
//                 height: (9 / Dimensions.designWidth).w,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: 6,
//                   itemBuilder: (context, index) {
//                     return ScrollIndicator(
//                       isCurrent: (index == _scrollIndex),
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//         const SizeBox(height: 15),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             DashboardActivityTile(
//               iconPath: ImageConstants.add,
//               activityText: "Add Money",
//               onTap: () {},
//             ),
//             const SizeBox(width: 40),
//             DashboardActivityTile(
//               iconPath: ImageConstants.arrowOutward,
//               activityText: "Send Money",
//               onTap: () {},
//             ),
//             const SizeBox(width: 40),
//             DashboardActivityTile(
//               iconPath: ImageConstants.barChart,
//               activityText: "Insights",
//               onTap: () {},
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class HomeView extends StatelessWidget {
//   const HomeView({
//     super.key,
//     required ScrollController scrollController,
//     required int scrollIndex,
//   })  : _scrollController = scrollController,
//         _scrollIndex = scrollIndex;

//   final ScrollController _scrollController;
//   final int _scrollIndex;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizeBox(height: 9.5),
//         Expanded(
//           child: ListView.builder(
//             controller: _scrollController,
//             scrollDirection: Axis.horizontal,
//             itemCount: 6,
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 return Padding(
//                   padding: EdgeInsets.only(
//                     left: (15 / Dimensions.designWidth).w,
//                   ),
//                   child: AccountSummaryTile(
//                     onTap: () {},
//                     imgUrl:
//                         "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
//                     accountType: "Savings",
//                     currency: "AED",
//                     amount: 0.00,
//                     subText: "Powered by FH",
//                     subImgUrl:
//                         "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
//                   ),
//                 );
//               } else {
//                 return AccountSummaryTile(
//                   onTap: () {},
//                   imgUrl: "",
//                   accountType: "Savings",
//                   currency: "USD",
//                   amount: 0.00,
//                   subText: "",
//                   subImgUrl: "",
//                 );
//               }
//             },
//           ),
//         ),
//         const SizeBox(height: 10),
//         BlocBuilder<SummaryTileBloc, SummaryTileState>(
//           builder: (context, state) {
//             return Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal:
//                       47.w - ((6 - 1) * (6.5 / Dimensions.designWidth).w)),
//               child: SizedBox(
//                 width: 90.w,
//                 height: (9 / Dimensions.designWidth).w,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: 6,
//                   itemBuilder: (context, index) {
//                     return ScrollIndicator(
//                       isCurrent: (index == _scrollIndex),
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//         const SizeBox(height: 15),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             DashboardActivityTile(
//               iconPath: ImageConstants.add,
//               activityText: "Add Money",
//               onTap: () {},
//             ),
//             const SizeBox(width: 40),
//             DashboardActivityTile(
//               iconPath: ImageConstants.arrowOutward,
//               activityText: "Send Money",
//               onTap: () {},
//             ),
//             const SizeBox(width: 40),
//             DashboardActivityTile(
//               iconPath: ImageConstants.barChart,
//               activityText: "Insights",
//               onTap: () {},
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
