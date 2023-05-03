import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/tabs/tab.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExploreDashboardScreen extends StatefulWidget {
  const ExploreDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ExploreDashboardScreen> createState() => _ExploreDashboardScreenState();
}

class _ExploreDashboardScreenState extends State<ExploreDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all((20 / Dimensions.designWidth).w),
          child: SvgPicture.asset(ImageConstants.menu),
        ),
        title: SvgPicture.asset(ImageConstants.dhabiText),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (20 / Dimensions.designWidth).w,
              vertical: (15 / Dimensions.designWidth).w,
            ),
            child: GradientButton(
              width: (90 / Dimensions.designWidth).w,
              height: (40 / Dimensions.designWidth).w,
              fontSize: (16 / Dimensions.designWidth).w,
              borderRadius: (5 / Dimensions.designWidth).w,
              onTap: () {
                Navigator.pushNamed(context, Routes.registration);
              },
              text: "Register",
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: tabController,
                indicatorColor: Colors.transparent,
                tabs: const [
                  Tab(child: CustomTab(title: "Accounts")),
                  Tab(child: Text("Loans")),
                  Tab(child: Text("Deposits")),
                ],
                isScrollable: true,
                labelColor: Colors.black,
                labelStyle: TextStyles.primaryMedium.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: TextStyles.primaryMedium.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              SizedBox(
                width: 100.w,
                height: (145 / Dimensions.designWidth).w,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: (index == 0)
                                  ? (20 / Dimensions.designWidth).w
                                  : 0,
                            ),
                            child: AccountSummaryTile(
                              onTap: () {
                                if (index == 2) {
                                  Navigator.pushNamed(context, Routes.vault);
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
                  ],
                ),
              ),
              const SizeBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      47.w - ((3 - 1) * (6.5 / Dimensions.designWidth).w),
                ),
                child: SizedBox(
                  width: 90.w,
                  height: (9 / Dimensions.designWidth).w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ScrollIndicator(
                        isCurrent: (index == 0),
                      );
                    },
                  ),
                ),
              ),
              const SizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashboardActivityTile(
                    iconPath: ImageConstants.arrowOutward,
                    activityText: "Send Money",
                    onTap: () {},
                  ),
                ],
              ),
              const SizeBox(height: 20),
              SizedBox(
                width: 100.w,
                height: (120 / Dimensions.designWidth).w,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: (20 / Dimensions.designWidth).w,
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
                  ],
                ),
              ),
              const SizeBox(height: 20),
            ],
          ),
          DraggableScrollableSheet(
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
                      boxShadow: [BoxShadows.primary],
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 51,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizeBox(height: 50);
                        }
                        return const SizeBox();
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
                            Radius.circular((10 / Dimensions.designWidth).w),
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
          InkWell(
            onTap: promptUser,
            child: SizeBox(
              width: 100.w,
              height: 100.h,
            ),
          )
        ],
      ),
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.checkCircleOutlined,
          title: "Done exploring?",
          message: "Register now and enjoy the world of digital banking!",
          actionWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.registration, (route) => false);
                },
                text: "Register Now",
              ),
              const SizeBox(height: 22),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
