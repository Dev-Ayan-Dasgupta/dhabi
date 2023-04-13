import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoanRequestSuccess extends StatelessWidget {
  const LoanRequestSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageConstants.checkCircleOutlined,
                    width: (214 / Dimensions.designWidth).w,
                    height: (214 / Dimensions.designWidth).w,
                  ),
                  const SizeBox(height: 40),
                  Text(
                    "Request Submitted Successfully",
                    style: TextStyles.primaryBold.copyWith(
                      color: const Color(0xFF252525),
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Our agent will contact you shortly. Request No.: 231056",
                    style: TextStyles.primary.copyWith(
                      color: const Color(0xFF252525),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: () {
                    // Navigator.pushReplacementNamed(
                    //     context, Routes.businessDashboard);
                    Navigator.pop(context);
                  },
                  text: "Home",
                ),
                const SizeBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
