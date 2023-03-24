import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SelectAccountTypeScreen extends StatefulWidget {
  const SelectAccountTypeScreen({Key? key}) : super(key: key);

  @override
  State<SelectAccountTypeScreen> createState() =>
      _SelectAccountTypeScreenState();
}

class _SelectAccountTypeScreenState extends State<SelectAccountTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: (22 / Dimensions.designWidth).w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizeBox(height: 10),
                  Text(
                    "Select your account type",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 22),
                  Text(
                    "Please select the type of account you wish to open",
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color.fromRGBO(0, 0, 0, 0.4),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  SolidButton(
                    onTap: () {},
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(
                          (3 / Dimensions.designWidth).w,
                          (4 / Dimensions.designHeight).h,
                        ),
                        blurRadius: (3 / Dimensions.designWidth).w,
                        // spreadRadius: (2 / Dimensions.designWidth).w,
                      ),
                    ],
                    fontColor: AppColors.primary,
                    text: "Personal",
                  ),
                  const SizeBox(height: 30),
                  SolidButton(
                    onTap: () {},
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(
                          (3 / Dimensions.designWidth).w,
                          (4 / Dimensions.designHeight).h,
                        ),
                        blurRadius: (3 / Dimensions.designWidth).w,
                        // spreadRadius: (2 / Dimensions.designWidth).w,
                      ),
                    ],
                    fontColor: AppColors.primary,
                    text: "Business",
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.login);
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "login");
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an Account? ',
                          style: TextStyles.primary.copyWith(
                            color: AppColors.primary,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Log in',
                              style: TextStyles.primaryBold.copyWith(
                                color: AppColors.primary,
                                fontSize: (16 / Dimensions.designWidth).w,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizeBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
