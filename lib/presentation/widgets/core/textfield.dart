// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/dimensions.dart';
import 'package:dialup_mobile_app/utils/constants/textstyles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.width,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.borderColor,
    this.borderRadius,
    this.color,
    required this.controller,
    this.enabled,
    this.fontColor,
    this.hintColor,
    this.helperColor,
    this.prefix,
    this.suffix,
    this.obscureText,
    required this.onChanged,
    this.hintText,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.maxLength,
  }) : super(key: key);

  final double? width;
  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;
  final Color? borderColor;
  final double? borderRadius;
  final Color? color;
  final TextEditingController controller;
  final bool? enabled;
  final Color? fontColor;
  final Color? hintColor;
  final Color? helperColor;
  final Widget? prefix;
  final Widget? suffix;
  final bool? obscureText;
  final Function(String) onChanged;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 100.w,
      padding: EdgeInsets.only(
        left: (widget.leftPadding ?? 16 / Dimensions.designWidth).w,
        right: (widget.rightPadding ?? 16 / Dimensions.designWidth).w,
        top: widget.topPadding ?? (0 / Dimensions.designWidth).w,
        bottom: widget.bottomPadding ?? (0 / Dimensions.designWidth).w,
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
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefix: widget.prefix,
          suffix: widget.suffix,
          hintText: widget.hintText ?? "",
          hintStyle: TextStyles.primaryMedium.copyWith(
            color: widget.hintColor ?? const Color.fromRGBO(37, 37, 37, 0.5),
            fontSize: (16 / Dimensions.designWidth).w,
          ),
          helperStyle: TextStyles.primaryMedium.copyWith(
            color: widget.controller.text.length == widget.maxLength
                ? const Color(0XFFC94540)
                : widget.maxLength != null
                    ? widget.controller.text.length > (widget.maxLength! - 20)
                        ? Colors.orange
                        : widget.helperColor ??
                            const Color.fromRGBO(37, 37, 37, 0.5)
                    : const Color.fromRGBO(37, 37, 37, 0.5),
            fontSize: (14 / Dimensions.designWidth).w,
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
