// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class LoaderRow extends StatelessWidget {
  const LoaderRow({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.strokeWidth,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizeBox(width: 10),
        SizedBox(
          width: ((width ?? 15) / Dimensions.designWidth).w,
          height: ((height ?? 15) / Dimensions.designWidth).w,
          child: CircularProgressIndicator(
            color: color ?? Colors.white,
            strokeWidth: ((strokeWidth ?? 2) / Dimensions.designWidth).w,
          ),
        ),
      ],
    );
  }
}
