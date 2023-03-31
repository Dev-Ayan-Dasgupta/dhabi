// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/dimensions.dart';
import 'package:dialup_mobile_app/utils/constants/textstyles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.width,
    this.horizontalPadding,
    this.verticalPadding,
    this.borderColor,
    this.borderRadius,
    this.color,
    required this.controller,
    this.enabled,
    this.fontColor,
    this.prefix,
    this.suffix,
    this.obscureText,
    required this.onChanged,
    this.hintText,
    this.keyboardType,
  }) : super(key: key);

  final double? width;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Color? borderColor;
  final double? borderRadius;
  final Color? color;
  final TextEditingController controller;
  final bool? enabled;
  final Color? fontColor;
  final Widget? prefix;
  final Widget? suffix;
  final bool? obscureText;
  final Function(String) onChanged;
  final String? hintText;
  final TextInputType? keyboardType;

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
        color: widget.color ?? Colors.transparent,
      ),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefix: widget.prefix,
          suffix: widget.suffix,
          hintText: widget.hintText ?? "",
          hintStyle: TextStyles.primaryMedium.copyWith(
            color: widget.fontColor ?? const Color.fromRGBO(37, 37, 37, 0.5),
            fontSize: (16 / Dimensions.designWidth).w,
          ),
        ),
        style: TextStyles.primaryMedium.copyWith(
          color: widget.fontColor ?? const Color(0xFF252525),
          fontSize: (16 / Dimensions.designWidth).w,
        ),
        obscureText: widget.obscureText ?? false,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType ?? TextInputType.text,
      ),
    );
  }
}
