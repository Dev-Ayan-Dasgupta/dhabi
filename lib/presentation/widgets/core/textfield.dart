// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/dimensions.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.width,
    this.horizontalPadding,
    this.verticalPadding,
    this.borderColor,
    this.borderRadius,
    required this.controller,
    this.suffix,
  }) : super(key: key);

  final double? width;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Color? borderColor;
  final double? borderRadius;
  final TextEditingController controller;
  final Widget? suffix;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 100.w,
      padding: EdgeInsets.symmetric(
        horizontal: (widget.horizontalPadding ?? 16 / Dimensions.designWidth).w,
        vertical: widget.verticalPadding ?? (0 / Dimensions.designWidth).w,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? const Color(0xFFEEEEEE),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            widget.borderRadius ?? (10 / Dimensions.designWidth).w,
          ),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          suffix: widget.suffix,
        ),
        style: TextStyles.primaryMedium.copyWith(
          color: const Color(0xFF252525),
          fontSize: (16 / Dimensions.designWidth).w,
        ),
      ),
    );
  }
}
