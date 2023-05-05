import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SolidButton extends StatelessWidget {
  const SolidButton({
    Key? key,
    required this.onTap,
    this.width,
    this.height,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
    this.color,
    required this.text,
    this.fontColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  final VoidCallback onTap;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? color;
  final String text;
  final Color? fontColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 100.w,
        height: height ?? (60 / Dimensions.designHeight).h,
        decoration: BoxDecoration(
          border:
              Border.all(color: borderColor ?? Colors.transparent, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? (10 / Dimensions.designWidth).w),
          ),
          boxShadow: boxShadow ?? [],
          color: color ?? AppColors.dark30,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyles.primaryBold.copyWith(
              color: fontColor ?? AppColors.dark50,
              fontSize: fontSize ?? (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
      ),
    );
  }
}
