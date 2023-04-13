import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfilePhoto extends StatelessWidget {
  const EditProfilePhoto({
    Key? key,
    required this.imgUrl,
    required this.onTap,
  }) : super(key: key);

  final String imgUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: (114 / Dimensions.designWidth).w,
          height: (114 / Dimensions.designWidth).w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadows.primary],
          ),
          child: Center(
            child: CustomCircleAvatar(
              imgUrl: imgUrl,
              width: (109 / Dimensions.designWidth).w,
              height: (109 / Dimensions.designWidth).w,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: (36 / Dimensions.designWidth).w,
              height: (36 / Dimensions.designWidth).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadows.primary],
              ),
              child: Center(
                child: SvgPicture.asset(
                  ImageConstants.addAPhoto,
                  width: (17 / Dimensions.designWidth).w,
                  height: (17 / Dimensions.designWidth).w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
