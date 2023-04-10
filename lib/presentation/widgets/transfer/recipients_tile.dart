// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class RecipientsTile extends StatelessWidget {
  const RecipientsTile({
    Key? key,
    required this.isWithinDhabi,
    required this.onTap,
    required this.flagImgUrl,
    required this.name,
    required this.accountNumber,
    required this.currency,
  }) : super(key: key);

  final bool isWithinDhabi;
  final VoidCallback onTap;
  final String flagImgUrl;
  final String name;
  final String accountNumber;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: (10 / Dimensions.designWidth).w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: (36 / Dimensions.designWidth).w,
                  height: (46 / Dimensions.designWidth).w,
                  child: Stack(
                    children: [
                      Container(
                        width: (30 / Dimensions.designWidth).w,
                        height: (30 / Dimensions.designWidth).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular((7 / Dimensions.designWidth).w),
                          ),
                          color: const Color.fromRGBO(0, 184, 148, 0.1),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            ImageConstants.accountBalance,
                            width: (20 / Dimensions.designWidth).w,
                            height: (20 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                      Positioned(
                        left: (15 / Dimensions.designWidth).w,
                        top: (15 / Dimensions.designWidth).w,
                        child: CustomCircleAvatar(
                          imgUrl: flagImgUrl,
                          width: (21 / Dimensions.designWidth).w,
                          height: (21 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizeBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF414141),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 10),
                    Text(
                      isWithinDhabi
                          ? accountNumber
                          : "To IBAN **${accountNumber.substring(accountNumber.length - 4, accountNumber.length)}",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF414141),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              currency,
              style: TextStyles.primaryMedium.copyWith(
                color: const Color(0XFF414141),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
