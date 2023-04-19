import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RetailOnboardingStatusScreen extends StatefulWidget {
  const RetailOnboardingStatusScreen({Key? key}) : super(key: key);

  @override
  State<RetailOnboardingStatusScreen> createState() =>
      _RetailOnboardingStatusScreenState();
}

class _RetailOnboardingStatusScreenState
    extends State<RetailOnboardingStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(ImageConstants.dhabiText),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizeBox(height: 20),
                  Text(
                    "Let's get your identification documents verified",
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color(0XFF1A3C40),
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  const OnboardingStatusRow(
                    isCompleted: true,
                    isCurrent: false,
                    iconPath: ImageConstants.envelope,
                    iconWidth: 10,
                    iconHeight: 14,
                    text: "Email Verification",
                    dividerHeight: 24,
                  ),
                  const OnboardingStatusRow(
                    isCompleted: false,
                    isCurrent: true,
                    iconPath: ImageConstants.idCard,
                    iconWidth: 10,
                    iconHeight: 14,
                    text: "Verify your ID",
                    dividerHeight: 24,
                  ),
                  const OnboardingStatusRow(
                    isCompleted: false,
                    isCurrent: false,
                    iconPath: ImageConstants.article,
                    iconWidth: 14,
                    iconHeight: 14,
                    text: "Enter your Details",
                    dividerHeight: 24,
                  ),
                  const OnboardingStatusRow(
                    isCompleted: false,
                    isCurrent: false,
                    iconPath: ImageConstants.mobile,
                    iconWidth: 14,
                    iconHeight: 18,
                    text: "Verify Mobile Number",
                    dividerHeight: 0,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.captureFace);
                  },
                  text: "Proceed",
                ),
                const SizeBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
