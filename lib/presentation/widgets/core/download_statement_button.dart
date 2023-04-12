// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class DownloadStatementButton extends StatelessWidget {
  const DownloadStatementButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w)),
          boxShadow: [BoxShadows.primary],
          color: Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color.fromRGBO(0, 184, 148, 0.21)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyles.primary.copyWith(
                color: isSelected
                    ? const Color(0XFF252525)
                    : const Color.fromRGBO(0, 0, 0, 0.4),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary,
              size: (20 / Dimensions.designWidth).w,
            ),
          ],
        ),
      ),
    );
  }
}
