import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SelectAccountScreen extends StatefulWidget {
  const SelectAccountScreen({Key? key}) : super(key: key);

  @override
  State<SelectAccountScreen> createState() => _SelectAccountScreenState();
}

class _SelectAccountScreenState extends State<SelectAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select an Account",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Please select from the company account you wish to reset the password",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.grey40,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SolidButton(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.businessDashboard);
                        },
                        text: "Company ${index + 1}",
                        color: Colors.white,
                        boxShadow: [BoxShadows.primary],
                        fontColor: AppColors.primary,
                      ),
                      const SizeBox(height: 10),
                    ],
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizeBox(height: 20),
                Text(
                  "Please select from the personal account you wish to reset the password",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.grey40,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 10),
                SolidButton(
                  onTap: () {},
                  text: "Personal Account",
                  color: Colors.white,
                  boxShadow: [BoxShadows.primary],
                  fontColor: AppColors.primary,
                ),
                const SizeBox(height: 560 - (3 * 70)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
