// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    Key? key,
    this.width,
    this.height,
    required this.imgUrl,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? (35 / Dimensions.designWidth).w,
      height: height ?? (35 / Dimensions.designWidth).w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imgUrl.isEmpty
              ? const NetworkImage(
                  "https://www.flagsimporter.com/static/frontend/Mgs/orson/en_US/Magefan_Blog/images/default-no-image.png")
              : NetworkImage(imgUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
