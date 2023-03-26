import 'package:dialup_mobile_app/utils/constants/dimensions.dart';
import 'package:dialup_mobile_app/utils/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarAction extends StatelessWidget {
  const AppBarAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: (15 / Dimensions.designWidth).w),
      child: InkWell(
        onTap: () {},
        child: SvgPicture.asset(ImageConstants.notifications),
      ),
    );
  }
}
