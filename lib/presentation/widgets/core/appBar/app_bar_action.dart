import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarAction extends StatelessWidget {
  const AppBarAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.notifications);
        },
        child: SvgPicture.asset(
          ImageConstants.notifications,
          width: (22 / Dimensions.designWidth).w,
          height: (27.5 / Dimensions.designWidth).w,
        ),
      ),
    );
  }
}
