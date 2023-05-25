// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.svgAssetPath,
    required this.title,
    required this.message,
    this.auxWidget,
    required this.actionWidget,
  }) : super(key: key);

  final String svgAssetPath;
  final String title;
  final String message;
  final Widget? auxWidget;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          right:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          bottom: (22 / Dimensions.designHeight).h,
          top: ((auxWidget == null ? 510 : 440) / Dimensions.designHeight)
              .h, // TODO: might have to change these to 1051 : 925 (500 : 440)
        ),
        child: Container(
          width: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular((24 / Dimensions.designWidth).w)),
            color: Colors.white,
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (22 / Dimensions.designWidth).w,
                  vertical: (22 / Dimensions.designHeight).h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        svgAssetPath,
                        width: (111 / Dimensions.designHeight).h,
                        height: (111 / Dimensions.designHeight).h,
                      ),
                      const SizeBox(height: 20),
                      Text(
                        title,
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.black25,
                          fontSize: (20 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 20),
                      Text(
                        message,
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizeBox(height: auxWidget != null ? 20 : 0),
                      auxWidget ?? const SizeBox(),
                      const SizeBox(height: 20),
                      actionWidget,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
