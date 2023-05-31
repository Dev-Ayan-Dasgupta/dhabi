import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/notifications/notifications_tile.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificatonsScreen extends StatefulWidget {
  const NotificatonsScreen({Key? key}) : super(key: key);

  @override
  State<NotificatonsScreen> createState() => _NotificatonsScreenState();
}

class _NotificatonsScreenState extends State<NotificatonsScreen> {
  List<NotificationsTileModel> notifications = [
    NotificationsTileModel(
      title: "Your passport details are expired. Please update it.",
      message: "",
      dateTime: "Today at 9:42 AM",
      widget: GradientButton(
        height: (28 / Dimensions.designWidth).w,
        width: (66 / Dimensions.designWidth).w,
        borderRadius: (4 / Dimensions.designWidth).w,
        fontSize: (14 / Dimensions.designWidth).w,
        fontWeight: FontWeight.w400,
        onTap: () {},
        text: "Update",
      ),
    ),
    NotificationsTileModel(
      title: "Black Friday's here to stay",
      message: "Our offers and cashback will last longer",
      dateTime: "Yesterday at 11:42 PM",
      widget: const SizeBox(),
    ),
    NotificationsTileModel(
      title: "Invite friends, get paid",
      message: "You can earn upto \$200 for each friend you refer",
      dateTime: "Last Wednesday at 11:15 AM",
      widget: const SizeBox(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary10,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notifications",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            SizeBox(height: notifications.isEmpty ? 0 : 15),
            Ternary(
              condition: notifications.isEmpty,
              truthy: Column(
                children: [
                  const SizeBox(height: 225),
                  SvgPicture.asset(
                    ImageConstants.notificationsBlank,
                    width: (67.33 / Dimensions.designWidth).w,
                    height: (84.17 / Dimensions.designWidth).w,
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "You're all caught up",
                    style: TextStyles.primary.copyWith(
                      color: const Color(0XFF414141),
                      fontSize: (18 / Dimensions.designWidth).w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (34 / Dimensions.designWidth).w),
                    child: Text(
                      labels[66]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF414141),
                        fontSize: (18 / Dimensions.designWidth).w,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              falsy: Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    NotificationsTileModel item = notifications[index];
                    return NotificationsTile(
                      title: item.title,
                      message: item.message,
                      dateTime: item.dateTime,
                      widget: item.widget,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizeBox(height: 10);
                  },
                  itemCount: notifications.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
