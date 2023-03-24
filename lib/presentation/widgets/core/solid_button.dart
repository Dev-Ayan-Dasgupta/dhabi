import 'package:dialup_mobile_app/utils/constants/dimensions.dart';
import 'package:dialup_mobile_app/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SolidButton extends StatelessWidget {
  SolidButton({
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
  double? width;
  double? height;
  Color? borderColor;
  double? borderRadius;
  List<BoxShadow>? boxShadow;
  Color? color;
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
        height: height ?? (60 / Dimensions.designHeight).h,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? (10 / Dimensions.designWidth).w),
          ),
          boxShadow: boxShadow ?? [],
          color: color ?? const Color.fromRGBO(85, 85, 85, 0.2),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyles.primaryBold.copyWith(
              color: fontColor ?? Colors.white,
              fontSize: fontSize ?? (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
      ),
    );
  }
}
