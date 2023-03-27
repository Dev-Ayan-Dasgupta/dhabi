// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_bloc.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_event.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/retail_dashboard.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/appBar/index.dart';
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

class _RetailDashboardScreenState extends State<RetailDashboardScreen> {
  late RetailDashboardArgumentModel retailDashboardArgumentModel;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  int _scrollIndex = 0;
  final bool hasOnboarded = true;

  @override
  void initState() {
    super.initState();
    retailDashboardArgumentModel =
        RetailDashboardArgumentModel.fromMap(widget.argument as dynamic ?? {});
    _scrollController.addListener(() {
      _scrollOffset = _scrollController.offset + 120;
      _scrollIndex = _scrollOffset ~/ 188;
      final SummaryTileBloc summaryTileBloc = context.read<SummaryTileBloc>();
      summaryTileBloc.add(SummaryTileEvent(scrollIndex: _scrollIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
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
              const SizeBox(height: 8),
              Padding(
                padding: EdgeInsets.only(left: (15 / Dimensions.designWidth).w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: (20 / Dimensions.designWidth).w,
                        vertical: (10 / Dimensions.designHeight).w,
                      ),
                      margin: EdgeInsets.only(
                        right: (20 / Dimensions.designWidth).w,
                        top: (10 / Dimensions.designHeight).w,
                        bottom: (10 / Dimensions.designHeight).w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular((10 / Dimensions.designWidth).w),
                        ),
                        color: const Color.fromRGBO(26, 60, 64, 0.1),
                      ),
                      child: Text(
                        "Home",
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color(0xFF000000),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, "");
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: (20 / Dimensions.designWidth).w,
                          vertical: (10 / Dimensions.designHeight).w,
                        ),
                        child: Text(
                          "Deposits",
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color(0xFF000000),
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, "");
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: (20 / Dimensions.designWidth).w,
                          vertical: (10 / Dimensions.designHeight).w,
                        ),
                        child: Text(
                          "Explore",
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color(0xFF000000),
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizeBox(height: 9.5),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: (15 / Dimensions.designWidth).w,
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
                    } else {
                      return AccountSummaryTile(
                        onTap: () {},
                        imgUrl: "",
                        accountType: "Savings",
                        currency: "USD",
                        amount: 0.00,
                        subText: "",
                        subImgUrl: "",
                      );
                    }
                  },
                ),
              ),
              const SizeBox(height: 10),
              BlocBuilder<SummaryTileBloc, SummaryTileState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 47.w -
                            ((6 - 1) * (6.5 / Dimensions.designWidth).w)),
                    child: SizedBox(
                      width: 90.w,
                      height: (9 / Dimensions.designWidth).w,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
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
              const SizeBox(height: 15),
              Expanded(
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
              const SizeBox(height: 15),
              hasOnboarded
                  ? const SizeBox(height: 265)
                  : DashboardOnboarding(
                      progress: (1 / 3),
                      stage1: true,
                      stage2: false,
                      stage3: false,
                      onTap1: () {
                        Navigator.pushNamed(context, Routes.verifyMobile);
                      },
                      onTap2: () {},
                      onTap3: () {},
                    ),
            ],
          ),
          !hasOnboarded
              ? const SizeBox(height: 265)
              : DraggableScrollableSheet(
                  initialChildSize: 0.33,
                  minChildSize: 0.33,
                  maxChildSize: 0.85,
                  builder: (context, scrollController) {
                    return Stack(
                      children: [
                        Container(
                          height: 85.h,
                          width: 100.w,
                          padding: EdgeInsets.symmetric(
                            horizontal: (10 / Dimensions.designWidth).w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular((20 / Dimensions.designWidth).w),
                            ),
                            boxShadow: const [BoxShadows.primary],
                            color: Colors.white,
                          ),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: 51,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return const SizeBox(height: 50);
                              }
                              return const DashboardTransactionListTile(
                                isCredit: true,
                                title:
                                    "Tax non filer debit Tax non filer debit",
                                name: "Alexander Doe",
                                amount: 50.23,
                                currency: "AED",
                                date: "Tue, Apr 1 2022",
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 44.w,
                          top: (10 / Dimensions.designWidth).w,
                          child: IgnorePointer(
                            child: Container(
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
                          ),
                        ),
                        Positioned(
                          left: (22 / Dimensions.designWidth).w,
                          top: (25 / Dimensions.designWidth).w,
                          child: IgnorePointer(
                            child: Text(
                              "Recent Transactions",
                              style: TextStyles.primary.copyWith(
                                color: const Color.fromRGBO(9, 9, 9, 0.4),
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                          ),
                        )
                      ],
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
    super.dispose();
  }
}
