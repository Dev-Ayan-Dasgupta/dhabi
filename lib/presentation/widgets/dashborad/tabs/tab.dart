// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (20 / Dimensions.designWidth).w,
        vertical: (10 / Dimensions.designWidth).w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((10 / Dimensions.designWidth).w),
        ),
        color: const Color(0XFFE8EBEC),
      ),
      child: Text(title),
    );
  }
}
