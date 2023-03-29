import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/statement_type_tile.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarStatement extends StatelessWidget {
  const AppBarStatement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              width: 100.w,
              height: (225 / Dimensions.designWidth).w,
              padding: EdgeInsets.all((30 / Dimensions.designWidth).w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((20 / Dimensions.designWidth).w),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Statement Type",
                    style: TextStyles.primary.copyWith(
                      color: const Color(0xFF333333),
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatementTypeTile(
                        onTap: () {},
                        iconPath: ImageConstants.checkCircleGreen,
                        text: "Loan",
                      ),
                      const SizeBox(width: 10),
                      StatementTypeTile(
                        onTap: () {},
                        iconPath: ImageConstants.document,
                        text: "Amortization",
                      ),
                      const SizeBox(width: 10),
                      StatementTypeTile(
                        onTap: () {},
                        iconPath: ImageConstants.article,
                        text: "Liability Letter",
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (15 / Dimensions.designWidth).w,
          vertical: (15 / Dimensions.designWidth).w,
        ),
        child: SvgPicture.asset(ImageConstants.statement),
      ),
    );
  }
}
