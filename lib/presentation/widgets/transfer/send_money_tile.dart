// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SendMoneyTile extends StatelessWidget {
  const SendMoneyTile({
    Key? key,
    required this.onTap,
    required this.iconPath,
    required this.text,
  }) : super(key: key);

  final VoidCallback onTap;
  final String iconPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((10 / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          boxShadow: [BoxShadows.primary],
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: (30 / Dimensions.designWidth).w,
                    height: (30 / Dimensions.designWidth).w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular((7 / Dimensions.designWidth).w),
                      ),
                      color: const Color.fromRGBO(0, 184, 48, 0.1),
                    ),
                    child: Center(
                      child: SvgPicture.asset(iconPath),
                    ),
                  ),
                  const SizeBox(width: 10),
                  Text(
                    text,
                    style: TextStyles.primaryMedium.copyWith(
                      fontSize: (18 / Dimensions.designWidth).w,
                      color: const Color(0XFF1A3C40),
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              ImageConstants.arrowForwardIos,
              width: (6.7 / Dimensions.designWidth).w,
              height: (11.3 / Dimensions.designWidth).w,
            ),
          ],
        ),
      ),
    );
  }
}