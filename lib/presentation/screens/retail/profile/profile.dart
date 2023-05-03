import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              "Profile",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 30),
            Text(
              "Personal Details",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: const Color(0XFFF8F8F8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Text(
                        "Multazam Sohail Ismail Siddiqui",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                  const SizeBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date of Birth",
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Text(
                        "12/08/1987",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Contact Details",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: const Color(0XFFF8F8F8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email ID",
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "multazam@mail.com",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(width: 20),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.asset(
                              ImageConstants.edit,
                              width: (18 / Dimensions.designWidth).w,
                              height: (18 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizeBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        labels[27]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "+971505470469",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(width: 20),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.asset(
                              ImageConstants.edit,
                              width: (18 / Dimensions.designWidth).w,
                              height: (18 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Contact Details",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: const Color(0XFFF8F8F8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labels[28]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 35.w,
                            child: Text(
                              "Orjowan Tower Zayed 1st Street, Khalidya Area - Abu Dhabi",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.primary,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizeBox(width: 20),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.updateAddress);
                            },
                            child: SvgPicture.asset(
                              ImageConstants.edit,
                              width: (18 / Dimensions.designWidth).w,
                              height: (18 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
