// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecentTransferTile extends StatelessWidget {
  const RecentTransferTile({
    Key? key,
    required this.onTap,
    required this.name,
    required this.status,
    required this.amount,
    required this.currency,
    required this.cardNo,
  }) : super(key: key);

  final VoidCallback onTap;
  final String name;
  final String status;
  final double amount;
  final String currency;
  final String cardNo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (15 / Dimensions.designWidth).w,
          vertical: (5 / Dimensions.designWidth).w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyles.primaryMedium.copyWith(
                    color: const Color(0XFF1A3C40),
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 7),
                Row(
                  children: [
                    SvgPicture.asset(
                      status == "Success"
                          ? ImageConstants.checkCircleOutlined
                          : status == "Failed"
                              ? ImageConstants.cancel
                              : ImageConstants.hourglassBottom,
                      height: (13.33 / Dimensions.designWidth).w,
                    ),
                    const SizeBox(width: 10),
                    Text(
                      status,
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color.fromRGBO(1, 1, 1, 0.4),
                        fontSize: (12 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "- ${amount.toStringAsFixed(2)} $currency",
                  style: TextStyles.primary.copyWith(
                    color: status == "Success"
                        ? AppColors.primary
                        : status == "Failed"
                            ? const Color(0XFF1A3C40)
                            : const Color.fromRGBO(34, 97, 105, 0.5),
                    fontSize: (18 / Dimensions.designWidth).w,
                    fontWeight:
                        status == "Failed" ? FontWeight.w400 : FontWeight.w600,
                    decoration: status == "Failed"
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizeBox(height: 7),
                Text(
                  "**${cardNo.substring(cardNo.length - 4, cardNo.length)}",
                  style: TextStyles.primaryMedium.copyWith(
                    color: const Color(0XFF818181),
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
