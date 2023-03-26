// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/circle_avatar.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class AccountSummaryTile extends StatelessWidget {
  const AccountSummaryTile({
    Key? key,
    required this.onTap,
    required this.imgUrl,
    required this.accountType,
    required this.currency,
    required this.amount,
  }) : super(key: key);

  final VoidCallback onTap;
  final String imgUrl;
  final String accountType;
  final String currency;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (15 / Dimensions.designWidth).w,
          vertical: (20 / Dimensions.designWidth).w,
        ),
        margin: EdgeInsets.only(
          right: (15 / Dimensions.designWidth).w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((20 / Dimensions.designWidth).w),
          ),
          boxShadow: const [BoxShadows.primary],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCircleAvatar(
                  imgUrl: imgUrl,
                ),
                const SizeBox(width: 75),
                Text(
                  accountType,
                  style: TextStyles.primary.copyWith(
                    color: const Color(0xFF9F9F9F),
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
            const SizeBox(height: 20),
            RichText(
              text: TextSpan(
                text: "$currency ",
                style: TextStyles.primary.copyWith(
                  color: AppColors.primary,
                  fontSize: (20 / Dimensions.designWidth).w,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: amount.toStringAsFixed(2),
                    style: TextStyles.primary.copyWith(
                        color: AppColors.primary,
                        fontSize: (20 / Dimensions.designWidth).w,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
