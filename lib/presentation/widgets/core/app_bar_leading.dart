import 'package:dialup_mobile_app/utils/constants/dimensions.dart';
import 'package:dialup_mobile_app/utils/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarLeading extends StatelessWidget {
  const AppBarLeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: (22 / Dimensions.designWidth).w),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: SvgPicture.asset(
          ImageConstants.arrowBack,
        ),
      ),
    );
  }
}
