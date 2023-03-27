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
    required this.actionWidget,
  }) : super(key: key);

  final String svgAssetPath;
  final String title;
  final String message;
  // final String buttonText;
  // final VoidCallback buttonAction;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: (22 / Dimensions.designWidth).w,
          right: (22 / Dimensions.designWidth).w,
          bottom: (22 / Dimensions.designWidth).w,
          top: (150 / Dimensions.designWidth).w,
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
                  horizontal: (22 / Dimensions.designWidth).w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            svgAssetPath,
                            width: (147 / Dimensions.designWidth).w,
                            height: (147 / Dimensions.designWidth).w,
                          ),
                          const SizeBox(height: 40),
                          Text(
                            title,
                            style: TextStyles.primaryBold.copyWith(
                              color: const Color(0xFF252525),
                              fontSize: (24 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 20),
                          Text(
                            message,
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0xFF252525),
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     GradientButton(onTap: buttonAction, text: buttonText),
                  //     const SizeBox(height: 22),
                  //   ],
                  // )
                  actionWidget,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
