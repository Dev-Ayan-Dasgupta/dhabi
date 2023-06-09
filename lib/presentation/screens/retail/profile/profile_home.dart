// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/profile/edit_profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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

  bool isUploading = false;

  bool hasProfilePicUpdated = false;

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
    return WillPopScope(
      onWillPop: () async {
        if (hasProfilePicUpdated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.retailDashboard,
            (route) => false,
            arguments: RetailDashboardArgumentModel(
              imgUrl: "",
              name: profileName ?? "",
              isFirst: storageIsFirstLogin == true ? false : true,
            ).toMap(),
          );
        } else {
          Navigator.pop(context);
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              if (hasProfilePicUpdated) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.retailDashboard,
                  (route) => false,
                  arguments: RetailDashboardArgumentModel(
                    imgUrl: "",
                    name: profileName ?? "",
                    isFirst: storageIsFirstLogin == true ? false : true,
                  ).toMap(),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizeBox(height: 10),
                        EditProfilePhoto(
                          isMemoryImage: profilePhotoBase64 != null,
                          bytes: base64Decode(profilePhotoBase64 ?? ""),
                          onTap: showImageUploadOptions,
                        ),
                        const SizeBox(height: 10),
                        Text(
                          profileName ?? "",
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
                            Navigator.pushNamed(
                                context, Routes.termsAndConditions);
                          },
                          iconPath: ImageConstants.termsAndConditions,
                          text: "Terms & Conditions",
                        ),
                        const SizeBox(height: 10),
                        TopicTile(
                          color: const Color(0XFFFAFAFA),
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.privacyStatement);
                          },
                          iconPath: ImageConstants.privacyPolicy,
                          text: "Privacy Policy",
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
                        const SizeBox(height: 10),
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
                          highlightColor:
                              const Color.fromRGBO(201, 69, 64, 0.1),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizeBox(height: 20),
                      Text(
                        "App Version $version",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      SizeBox(
                        height: PaddingConstants.bottomPadding +
                            MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Ternary(
              condition: isUploading,
              truthy: SpinKitFadingCircle(
                color: AppColors.primary,
                size: (50 / Dimensions.designWidth).w,
              ),
              falsy: const SizeBox(),
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
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Back",
          ),
        );
      },
    );
  }

  void promptUserLogout() {
    // showDialog(
    //   context: context,
    //   // barrierDismissible: false,
    //   builder: (context) {
    //     return CustomDialog(
    //       svgAssetPath: ImageConstants.warning,
    //       title: labels[250]["labelText"],
    //       message: "If you log out you would need to re-login again",
    //       actionWidget: GradientButton(
    //         onTap: () {
    //           Navigator.pop(context);
    //           Navigator.pop(context);
    //           Navigator.pushNamed(
    //             context,
    //             Routes.onboarding,
    //             arguments: OnboardingArgumentModel(
    //               isInitial: true,
    //             ).toMap(),
    //           );
    //         },
    //         text: "Yes, I am sure",
    //       ),
    //     );
    //   },
    // );
  }

  void showImageUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: (120 / Dimensions.designHeight).h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular((10 / Dimensions.designWidth).w),
              topRight: Radius.circular((10 / Dimensions.designWidth).w),
            ),
          ),
          child: Column(
            children: [
              const SizeBox(height: 10),
              ListTile(
                dense: true,
                onTap: () {
                  uploadImage(ImageSource.camera);
                },
                leading: Container(
                  width: (30 / Dimensions.designWidth).w,
                  height: (30 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: AppColors.primary,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: (15 / Dimensions.designWidth).w,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  "Camera",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ),
              ListTile(
                dense: true,
                onTap: () async {
                  uploadImage(ImageSource.gallery);
                },
                leading: Container(
                  width: (30 / Dimensions.designWidth).w,
                  height: (30 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: AppColors.primary,
                    ),
                  ),
                  child: Icon(
                    Icons.collections_rounded,
                    size: (15 / Dimensions.designWidth).w,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  "Gallery",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void promptUploadPhotoError() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Image Upload Failed",
          message: "Your attempt to upload your profile photo failed.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[347]["labelText"],
          ),
        );
      },
    );
  }

  void uploadImage(ImageSource source) async {
    Navigator.pop(context);
    isUploading = true;
    setState(() {});
    XFile? pickedImageFile = await ImagePicker().pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedImageFile != null) {
      CroppedFile? croppedImageFile = await ImageCropper().cropImage(
        sourcePath: pickedImageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      );

      if (croppedImageFile != null) {
        String photoBase64 = base64Encode(await croppedImageFile.readAsBytes());

        var uploadPPResult = await MapUploadProfilePhoto.mapUploadProfilePhoto(
          {
            "photoBase64": photoBase64,
          },
          token ?? "",
        );
        log("Upload Profile Photo response -> $uploadPPResult");

        if (uploadPPResult["success"]) {
          var getProfileDataResult =
              await MapProfileData.mapProfileData(token ?? "");
          if (getProfileDataResult["success"]) {
            profilePhotoBase64 = getProfileDataResult["profileImageBase64"];
            await storage.write(
                key: "profilePhotoBase64", value: profilePhotoBase64);
            storageProfilePhotoBase64 =
                await storage.read(key: "profilePhotoBase64");
            hasProfilePicUpdated = true;
          }
        } else {
          promptUploadPhotoError();
        }
        isUploading = false;
        setState(() {});
      } else {
        isUploading = false;
        setState(() {});
      }
    } else {
      isUploading = false;
      setState(() {});
    }
  }
}
