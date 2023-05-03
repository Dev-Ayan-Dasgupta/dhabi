// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class BusinessOnboardingStatusScreen extends StatefulWidget {
  const BusinessOnboardingStatusScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BusinessOnboardingStatusScreen> createState() =>
      _BusinessOnboardingStatusScreenState();
}

class _BusinessOnboardingStatusScreenState
    extends State<BusinessOnboardingStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(ImageConstants.dhabiBusinessText),
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
                    labels[223]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  OnboardingStatusRow(
                    isCompleted: true,
                    isCurrent: false,
                    iconPath: ImageConstants.envelope,
                    iconWidth: 10,
                    iconHeight: 14,
                    text: labels[224]["labelText"],
                    dividerHeight: 24,
                  ),
                  const OnboardingStatusRow(
                    isCompleted: false,
                    isCurrent: true,
                    iconPath: ImageConstants.building,
                    iconWidth: 10,
                    iconHeight: 14,
                    text: "Basic Company Details",
                    dividerHeight: 24,
                  ),
                  OnboardingStatusRow(
                    isCompleted: false,
                    isCurrent: false,
                    iconPath: ImageConstants.mobile,
                    iconWidth: 14,
                    iconHeight: 18,
                    text: labels[227]["labelText"],
                    dividerHeight: 0,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.basicCompanyDetails);
                  },
                  text: labels[31]["labelText"],
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
