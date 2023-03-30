// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class ApplicationTaxScreen extends StatefulWidget {
  const ApplicationTaxScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationTaxScreen> createState() => _ApplicationTaxScreenState();
}

class _ApplicationTaxScreenState extends State<ApplicationTaxScreen> {
  int progress = 3;
  bool isUS = false;
  bool isPPonly = true;
  bool isTINvalid = false;
  bool isCRS = false;
  bool hasTIN = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (22 / Dimensions.designWidth).w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizeBox(height: 10),
              Text(
                "Application Details",
                style: TextStyles.primaryBold.copyWith(
                  color: AppColors.primary,
                  fontSize: (28 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 30),
              ApplicationProgress(progress: progress),
              const SizeBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "FATCA",
                            style: TextStyles.primary.copyWith(
                              color: AppColors.primary,
                              fontSize: (24 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(width: 10),
                          HelpSnippet(onTap: () {}),
                        ],
                      ),
                      const SizeBox(height: 30),
                      RichText(
                        text: TextSpan(
                          text: 'Press ',
                          style: TextStyles.primary.copyWith(
                            color: const Color(0xFF636363),
                            fontSize: (15 / Dimensions.designWidth).w,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Yes',
                              style: TextStyles.primaryBold.copyWith(
                                color: const Color(0xFF636363),
                                fontSize: (15 / Dimensions.designWidth).w,
                              ),
                            ),
                            TextSpan(
                              text: ' if:',
                              style: TextStyles.primary.copyWith(
                                color: const Color(0xFF636363),
                                fontSize: (15 / Dimensions.designWidth).w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizeBox(height: 10),
                      Text(
                        "You are a U.S. Citizen or Resident?",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0xFF636363),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SolidButton(
                            width: (185 / Dimensions.designWidth).w,
                            color: Colors.white,
                            fontColor: AppColors.primary,
                            boxShadow: [BoxShadows.primary],
                            onTap: () {},
                            text: "Yes",
                          ),
                          SolidButton(
                            width: (185 / Dimensions.designWidth).w,
                            color: Colors.white,
                            fontColor: AppColors.primary,
                            boxShadow: [BoxShadows.primary],
                            onTap: () {},
                            text: "No",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizeBox(height: 20),
              Column(
                children: [
                  GradientButton(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.applicationIncome);
                    },
                    text: "Continue",
                  ),
                  const SizeBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpSnippet extends StatelessWidget {
  const HelpSnippet({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        ImageConstants.help,
        width: (16.67 / Dimensions.designWidth).w,
        height: (16.67 / Dimensions.designWidth).w,
      ),
    );
  }
}
