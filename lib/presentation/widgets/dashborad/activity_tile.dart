// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class DashboardActivityTile extends StatelessWidget {
  const DashboardActivityTile({
    Key? key,
    required this.iconPath,
    required this.activityText,
    required this.onTap,
  }) : super(key: key);

  final String iconPath;
  final String activityText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: (64 / Dimensions.designWidth).w,
            height: (64 / Dimensions.designWidth).w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadows.primary],
              color: Colors.white,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: (16 / Dimensions.designWidth).w,
                height: (16 / Dimensions.designWidth).w,
                colorFilter:
                    const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        const SizeBox(height: 10),
        Text(
          activityText,
          style: TextStyles.primary.copyWith(
            color: const Color(0xFFA1A1A1),
            fontSize: (14 / Dimensions.designWidth).w,
          ),
        ),
      ],
    );
  }
}
