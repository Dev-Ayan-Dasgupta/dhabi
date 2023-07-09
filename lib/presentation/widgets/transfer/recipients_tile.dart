// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:uuid/uuid.dart';

class RecipientsTile extends StatelessWidget {
  const RecipientsTile({
    Key? key,
    // required this.isWithinDhabi,
    required this.onTap,
    required this.flagImgUrl,
    required this.name,
    required this.accountNumber,
    required this.currency,
    required this.bankName,
  }) : super(key: key);

  // final bool isWithinDhabi;
  final VoidCallback onTap;
  final String flagImgUrl;
  final String name;
  final String accountNumber;
  final String currency;
  final String bankName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: (5 / Dimensions.designHeight).h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: (36 / Dimensions.designWidth).w,
                  height: (46 / Dimensions.designHeight).h,
                  child: Stack(
                    children: [
                      Container(
                        width: (35 / Dimensions.designWidth).w,
                        height: (35 / Dimensions.designWidth).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular((7 / Dimensions.designWidth).w),
                          ),
                          color: const Color.fromRGBO(0, 184, 148, 0.1),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: ((15 / 2) / Dimensions.designWidth).w,
                            backgroundImage: CachedMemoryImageProvider(
                              const Uuid().v4(),
                              bytes: base64Decode(flagImgUrl),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizeBox(width: 15),
                SizedBox(
                  width: 55.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizeBox(height: 7),
                      Text(
                        bankName,
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  accountNumber,
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark50,
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 7),
                Text(
                  currency,
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark50,
                    fontSize: (12 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
