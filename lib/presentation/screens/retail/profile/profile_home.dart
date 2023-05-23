// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/profile/edit_profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  String? version;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPackageInfo();
      setState(() {});
    });
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

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
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizeBox(height: 30),
                  EditProfilePhoto(
                    imgUrl:
                        "https://media.gettyimages.com/id/492789142/photo/square-portrait-of-arab-man-in-traditional-clothing.jpg?s=1024x1024&w=gi&k=20&c=bRiHaqExbaNcOdyLTlrFpK-z04tH6npOz7SCR2yF7Ug=",
                    onTap: () {},
                  ),
                  const SizeBox(height: 10),
                  Text(
                    "Ahmed Nasir",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: (20 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  TopicTile(
                    color: const Color(0XFFFAFAFA),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.profile);
                    },
                    iconPath: ImageConstants.settingsAccountBox,
                    text: "Profile",
                  ),
                  const SizeBox(height: 10),
                  TopicTile(
                    color: const Color(0XFFFAFAFA),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.security);
                    },
                    iconPath: ImageConstants.security,
                    text: "Security",
                  ),
                  const SizeBox(height: 10),
                  TopicTile(
                    color: const Color(0XFFFAFAFA),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.requestType);
                    },
                    iconPath: ImageConstants.handshake,
                    text: "Service Request",
                  ),
                  const SizeBox(height: 10),
                  TopicTile(
                    color: const Color(0XFFFAFAFA),
                    onTap: promptUserContactUs,
                    iconPath: ImageConstants.atTheRate,
                    text: "Contact Us",
                  ),
                  const SizeBox(height: 10),
                  TopicTile(
                    color: const Color(0XFFFAFAFA),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.faq);
                    },
                    iconPath: ImageConstants.faq,
                    text: "FAQs",
                  ),
                ],
              ),
            ),
            Column(
              children: [
                TopicTile(
                  color: const Color(0XFFFAFAFA),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.selectAccount);
                  },
                  iconPath: ImageConstants.rotate,
                  text: "Switch Entities",
                ),
                const SizeBox(height: 10),
                TopicTile(
                  color: const Color(0XFFFAFAFA),
                  onTap: promptUserLogout,
                  iconPath: ImageConstants.logout,
                  text: "Logout",
                  fontColor: AppColors.red100,
                  highlightColor: const Color.fromRGBO(201, 69, 64, 0.1),
                ),
                const SizeBox(height: 20),
                Text(
                  "App Version $version",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark50,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 45),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void promptUserContactUs() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.sentimentSatisfied,
          title: "Hey, there!",
          message:
              "Please check FAQs.\nIf you do not find your query,\nContact us at +971 200 0000",
          actionWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: "Back",
              ),
              const SizeBox(height: 22),
            ],
          ),
        );
      },
    );
  }

  void promptUserLogout() {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[250]["labelText"],
          message: "If you log out you would need to re-login again",
          actionWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    Routes.onboarding,
                    arguments: OnboardingArgumentModel(
                      isInitial: true,
                    ).toMap(),
                  );
                },
                text: "Yes, I am sure",
              ),
              const SizeBox(height: 22),
            ],
          ),
        );
      },
    );
  }
}
