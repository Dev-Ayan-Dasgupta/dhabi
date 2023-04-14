import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({
    Key? key,
    required this.index,
    required this.isExpanded,
    required this.titleText,
    required this.childrenText,
    this.onExpansionChanged,
  }) : super(key: key);

  final int index;
  final bool isExpanded;
  final String titleText;
  final String childrenText;
  final void Function(bool)? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${index + 1}",
          style: TextStyles.primaryBold.copyWith(
            color: AppColors.primary,
            fontSize: (32 / Dimensions.designWidth).w,
          ),
        ),
        Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            onExpansionChanged: onExpansionChanged,
            childrenPadding: EdgeInsets.zero,
            tilePadding: EdgeInsets.zero,
            trailing: isExpanded
                ? SvgPicture.asset(
                    ImageConstants.xmark,
                    width: (32 / Dimensions.designWidth).w,
                    height: (32 / Dimensions.designWidth).w,
                  )
                : SvgPicture.asset(
                    ImageConstants.plus,
                    width: (32 / Dimensions.designWidth).w,
                    height: (32 / Dimensions.designWidth).w,
                  ),
            title: Text(
              titleText,
              style: TextStyles.primaryBold.copyWith(
                color: Colors.black,
                fontSize: (20 / Dimensions.designWidth).w,
              ),
            ),
            children: [
              Text(
                childrenText,
                style: TextStyles.primaryMedium.copyWith(
                  color: const Color.fromRGBO(60, 60, 67, 0.85),
                  fontSize: (18 / Dimensions.designWidth).w,
                ),
              ),
            ],
          ),
        ),
        const SizeBox(height: 10),
      ],
    );
  }
}
