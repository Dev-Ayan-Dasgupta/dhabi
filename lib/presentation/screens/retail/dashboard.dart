// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/data/models/arguments/retail_dashboard.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    retailDashboardArgumentModel =
        RetailDashboardArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
      body: SizedBox(
        width: 100.w,
        height: 100.h - kToolbarHeight - MediaQuery.of(context).viewPadding.top,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizeBox(height: 10),
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
            const SizeBox(height: 20),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
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
                      ),
                    );
                  } else {
                    return AccountSummaryTile(
                      onTap: () {},
                      imgUrl: "",
                      accountType: "Savings",
                      currency: "USD",
                      amount: 0.00,
                    );
                  }
                },
              ),
            ),
            const SizeBox(height: 30),
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
            const SizeBox(height: 30),
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
            const SizeBox(height: 30),
            DashboardOnboarding(
              progress: (1 / 3),
              stage1: true,
              stage2: false,
              stage3: false,
              onTap1: () {},
              onTap2: () {},
              onTap3: () {},
            ),
          ],
        ),
      ),
    );
  }
}
