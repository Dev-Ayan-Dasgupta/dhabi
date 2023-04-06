// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';

class VaultAccountCard extends StatelessWidget {
  const VaultAccountCard({
    Key? key,
    required this.isVault,
    required this.onTap,
    required this.title,
    this.imgUrl,
    required this.accountNo,
    required this.currency,
    required this.amount,
  }) : super(key: key);

  final bool isVault;
  final VoidCallback onTap;
  final String title;
  final String? imgUrl;
  final String accountNo;
  final String currency;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          color: Colors.white,
          boxShadow: [BoxShadows.primary],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "$title ",
                      style: TextStyles.primaryBold.copyWith(
                        fontSize: (18 / Dimensions.designWidth).w,
                        color: const Color(0XFF1A3C40),
                      ),
                    ),
                    isVault
                        ? SizedBox(
                            width: (31 / Dimensions.designWidth).w,
                            height: (18 / Dimensions.designWidth).w,
                            child: Image.network(imgUrl!, fit: BoxFit.fill),
                          )
                        : const SizeBox(),
                  ],
                ),
                const SizeBox(height: 15),
                Text(
                  isVault
                      ? "**${accountNo.substring(accountNo.length - 4, accountNo.length)}"
                      : accountNo,
                  style: TextStyles.primaryMedium.copyWith(
                    fontSize: (16 / Dimensions.designWidth).w,
                    color: const Color(0XFF094148),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$currency ${amount.toStringAsFixed(2)}",
                  style: TextStyles.primaryBold.copyWith(
                    fontSize: (18 / Dimensions.designWidth).w,
                    color: const Color(0XFF1A3C40),
                  ),
                ),
                const SizeBox(height: 15),
                Text(
                  "Available Balance",
                  style: TextStyles.primaryMedium.copyWith(
                    fontSize: (16 / Dimensions.designWidth).w,
                    color: const Color.fromRGBO(26, 60, 64, 0.2),
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
