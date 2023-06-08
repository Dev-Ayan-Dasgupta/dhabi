// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';

class AppBarAvatar extends StatelessWidget {
  const AppBarAvatar({
    Key? key,
    required this.imgUrl,
    required this.name,
  }) : super(key: key);

  final String imgUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: (16 / Dimensions.designWidth).w,
        top: (11 / Dimensions.designWidth).w,
        bottom: (11 / Dimensions.designWidth).w,
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.profileHome);
        },
        child: CircleAvatar(
          backgroundColor: const Color(0xFFECECEC),
          backgroundImage: storageProfilePhotoBase64 != null
              ? MemoryImage(base64Decode(storageProfilePhotoBase64 ?? ""))
              : null,
          child: storageProfilePhotoBase64 != null
              ? const SizeBox()
              : Text(
                  "${name[0]}${name.split(' ').last[0]}",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
        ),
      ),
    );
  }
}
