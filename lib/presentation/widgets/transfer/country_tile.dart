// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({
    Key? key,
    required this.onTap,
    required this.flagImgUrl,
    required this.country,
    required this.currencies,
  }) : super(key: key);

  final VoidCallback onTap;
  final String flagImgUrl;
  final String country;
  final List<String> currencies;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: (10 / Dimensions.designWidth).w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomCircleAvatarAsset(
                  imgUrl: flagImgUrl,
                  width: (30 / Dimensions.designWidth).w,
                  height: (30 / Dimensions.designWidth).w,
                ),
                const SizeBox(width: 20),
                Text(
                  country,
                  style: TextStyles.primaryMedium.copyWith(
                    color: const Color.fromRGBO(66, 66, 66, 0.7),
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
            Text(
              currencies.join(" • "),
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(66, 66, 66, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
