// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';

class AppBarAvatar extends StatelessWidget {
  const AppBarAvatar({
    Key? key,
    required this.imgUrl,
    required this.name,
  }) : super(key: key);

  final String imgUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: (12 / Dimensions.designWidth).w,
          top: (7 / Dimensions.designWidth).w),
      child: Container(
        margin: EdgeInsets.all((7 / Dimensions.designWidth).w),
        width: (33 / Dimensions.designWidth).w,
        height: (33 / Dimensions.designWidth).w,
        decoration: imgUrl.isNotEmpty
            ? BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imgUrl),
                  fit: BoxFit.fill,
                ),
              )
            : const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFECECEC),
              ),
        child: imgUrl.isNotEmpty
            ? const SizeBox()
            : Center(
                child: Text(
                  name[0].toUpperCase(),
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
              ),
      ),
    );
  }
}
