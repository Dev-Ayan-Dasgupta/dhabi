// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class NotificationsTile extends StatelessWidget {
  const NotificationsTile({
    Key? key,
    required this.title,
    required this.message,
    required this.dateTime,
    required this.widget,
  }) : super(key: key);

  final String title;
  final String message;
  final String dateTime;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: (5 / Dimensions.designWidth).w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.primary.copyWith(
              color: const Color(0XFF1A1F36),
              fontSize: (16 / Dimensions.designWidth).w,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
          ),
          const SizeBox(height: 7),
          Text(
            message,
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.dark50,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
            maxLines: 3,
          ),
          const SizeBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateTime,
                style: TextStyles.primaryMedium.copyWith(
                  color: const Color(0XFFA5ACB8),
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              widget,
            ],
          ),
        ],
      ),
    );
  }
}
