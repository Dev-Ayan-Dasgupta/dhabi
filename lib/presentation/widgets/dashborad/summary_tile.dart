// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class AccountSummaryTile extends StatelessWidget {
  const AccountSummaryTile({
    Key? key,
    required this.onTap,
    required this.imgUrl,
    required this.accountType,
    required this.currency,
    required this.amount,
    required this.subText,
    required this.subImgUrl,
  }) : super(key: key);

  final VoidCallback onTap;
  final String imgUrl;
  final String accountType;
  final String currency;
  final double amount;
  final String subText;
  final String subImgUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: (188 / Dimensions.designWidth).w,
        padding: EdgeInsets.symmetric(
          horizontal: (15 / Dimensions.designWidth).w,
          vertical: (20 / Dimensions.designWidth).w,
        ),
        margin: EdgeInsets.only(
          right: (15 / Dimensions.designWidth).w,
          top: (2 / Dimensions.designWidth).w,
          bottom: (2 / Dimensions.designWidth).w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((20 / Dimensions.designWidth).w),
          ),
          boxShadow: [BoxShadows.primary],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCircleAvatarAsset(imgUrl: imgUrl),
                Text(
                  accountType,
                  style: TextStyles.primary.copyWith(
                    color: const Color(0xFF9F9F9F),
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
            SizeBox(height: subText.isEmpty ? 41 : 15),
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
            Ternary(
              condition: subText.isNotEmpty,
              truthy: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subText,
                    style: TextStyles.primary.copyWith(
                      color: const Color.fromRGBO(9, 65, 72, 0.5),
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  Container(
                    width: (40 / Dimensions.designWidth).w,
                    height: (26 / Dimensions.designWidth).w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(subImgUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
              falsy: const SizeBox(),
            ),
          ],
        ),
      ),
    );
  }
}
