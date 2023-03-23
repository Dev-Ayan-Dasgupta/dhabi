import 'package:dialup_mobile_app/utils/constants/dimensions.dart';
import 'package:dialup_mobile_app/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class GradientButton extends StatelessWidget {
  GradientButton({
    Key? key,
    required this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.gradient,
    required this.text,
    this.fontColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  final VoidCallback onTap;
  double? width;
  double? height;
  double? borderRadius;
  Gradient? gradient;
  final String text;
  Color? fontColor;
  String? fontFamily;
  double? fontSize;
  FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 100.w,
        height: height ?? (50 / Dimensions.designHeight).h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? (10 / Dimensions.designHeight).h),
          ),
          gradient: gradient ??
              const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A3C40),
                  Color(0xFF236269),
                  Color(0xFF1A3C40),
                ],
              ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyles.primaryBold.copyWith(
                fontSize: fontSize ?? (20 / Dimensions.designWidth).w),
          ),
        ),
      ),
    );
  }
}