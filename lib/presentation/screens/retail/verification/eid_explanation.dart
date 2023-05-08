import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:intl/intl.dart';

class EIDExplanationScreen extends StatefulWidget {
  const EIDExplanationScreen({Key? key}) : super(key: key);

  @override
  State<EIDExplanationScreen> createState() => _EIDExplanationScreenState();
}

class _EIDExplanationScreenState extends State<EIDExplanationScreen> {
  regula.MatchFacesImage image1 = regula.MatchFacesImage();

  Image img1 = Image.asset(ImageConstants.eidFront);

  String status = "";
  double progressValue = 0;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    const EventChannel('flutter_document_reader_api/event/completion')
        .receiveBroadcastStream()
        .listen(
          (jsonString) => handleCompletion(
            DocumentReaderCompletion.fromJson(
              json.decode(jsonString),
            )!,
          ),
        );
  }

  void handleCompletion(DocumentReaderCompletion completion) async {
    if (completion.action == DocReaderAction.COMPLETE) {
      DocumentReaderResults? results = completion.results;

      fullName = await results
          ?.textFieldValueByType(EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES);
      eiDNumber = await results
          ?.textFieldValueByType(EVisualFieldType.FT_IDENTITY_CARD_NUMBER);
      nationality =
          await results?.textFieldValueByType(EVisualFieldType.FT_NATIONALITY);
      nationalityCode = await results
          ?.textFieldValueByType(EVisualFieldType.FT_NATIONALITY_CODE);
      expiryDate = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_EXPIRY);
      dob = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_BIRTH);
      gender = await results?.textFieldValueByType(EVisualFieldType.FT_SEX);
      photo =
          results?.getGraphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT);
      if (photo != null) {
        image1.bitmap = base64Encode(base64Decode(photo!.replaceAll("\n", "")));
        image1.imageType = regula.ImageType.PRINTED;
        img1 = Image.memory(base64Decode(photo!.replaceAll("\n", "")));
      }
      docPhoto = results
          ?.getGraphicFieldImageByType(EGraphicFieldType.GF_DOCUMENT_IMAGE);

      // TODO: Run conditions for checks regarding Age, no. of tries, both sides match and expired ID

      bool result =
          await MapIfEidExists.mapIfEidExists({"eidNumber": eiDNumber}, token);
      log("If EID Exists API response -> $result");

      log("Doc Expired check -> ${DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000"))).difference(DateTime.now()).inDays}");
      log("Age check -> ${DateTime.now().difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000")))).inDays}");

      // ? Check for expired
      if (DateTime.parse(DateFormat('yyyy-MM-dd').format(
                  DateFormat('dd/MM/yyyy')
                      .parse(expiryDate ?? "1 January 1900")))
              .difference(DateTime.now())
              .inDays <
          0) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.errorSuccessScreen,
            arguments: ErrorArgumentModel(
              hasSecondaryButton: false,
              iconPath: ImageConstants.errorOutlined,
              title: messages[81]["messageText"],
              message: messages[29]["messageText"],
              buttonText: labels[1]["labelText"],
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.retailOnboardingStatus,
                  (route) => false,
                  arguments: OnboardingStatusArgumentModel(
                    stepsCompleted: 1,
                    isFatca: false,
                    isPassport: false,
                    isRetail: true,
                  ).toMap(),
                );
              },
              buttonTextSecondary: "",
              onTapSecondary: () {},
            ).toMap(),
          );
        }
      }

      // ? Check for age
      else if (DateTime.now()
              .difference(DateTime.parse(DateFormat('yyyy-MM-dd')
                  .format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000"))))
              .inDays <
          ((18 * 365) + 4)) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.errorSuccessScreen,
            arguments: ErrorArgumentModel(
              hasSecondaryButton: false,
              iconPath: ImageConstants.errorOutlined,
              title: messages[80]["messageText"],
              message: messages[33]["messageText"],
              buttonText: labels[1]["labelText"],
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.retailOnboardingStatus,
                  (route) => false,
                  arguments: OnboardingStatusArgumentModel(
                    stepsCompleted: 1,
                    isFatca: false,
                    isPassport: false,
                    isRetail: true,
                  ).toMap(),
                );
              },
              buttonTextSecondary: "",
              onTapSecondary: () {},
            ).toMap(),
          );
        }
      }

      // ? Check for previous existence
      else if (result) {
        if (context.mounted) {
          Navigator.pushNamed(context, Routes.errorSuccessScreen,
              arguments: ErrorArgumentModel(
                hasSecondaryButton: false,
                iconPath: ImageConstants.warningRed,
                title: messages[76]["messageText"],
                message: messages[23]["messageText"],
                buttonText: labels[205]["labelText"],
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.retailOnboardingStatus,
                    (route) => false,
                    arguments: OnboardingStatusArgumentModel(
                      stepsCompleted: 1,
                      isFatca: false,
                      isPassport: false,
                      isRetail: true,
                    ).toMap(),
                  );
                },
                buttonTextSecondary: "",
                onTapSecondary: () {},
              ).toMap());
        }
      } else {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.scannedDetails,
            arguments: ScannedDetailsArgumentModel(
              isEID: true,
              fullName: fullName,
              idNumber: eiDNumber,
              nationality: nationality,
              nationalityCode: nationalityCode,
              expiryDate: expiryDate,
              dob: dob,
              gender: gender,
              photo: photo,
              docPhoto: docPhoto,
              img1: img1,
              image1: image1,
            ).toMap(),
          );
        }
      }
    }

    if (completion.action == DocReaderAction.TIMEOUT) {
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          Routes.errorSuccessScreen,
          arguments: ErrorArgumentModel(
            hasSecondaryButton: false,
            iconPath: ImageConstants.warningRed,
            title: messages[73]["messageText"],
            message: "Your time has run out. Please try again.",
            // messages[35]["messageText"],
            buttonText: labels[1]["labelText"],
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.retailOnboardingStatus,
                (route) => false,
                arguments: OnboardingStatusArgumentModel(
                  stepsCompleted: 1,
                  isFatca: false,
                  isPassport: false,
                  isRetail: true,
                ).toMap(),
              );
            },
            buttonTextSecondary: "",
            onTapSecondary: () {},
          ).toMap(),
        );
      }
    }
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels[228]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    labels[229]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 80),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: (276 / Dimensions.designWidth).w,
                      height: (159 / Dimensions.designWidth).w,
                      child: Image.asset(ImageConstants.eidFront),
                    ),
                  ),
                  const SizeBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: (276 / Dimensions.designWidth).w,
                      height: (159 / Dimensions.designWidth).w,
                      child: Image.asset(ImageConstants.eidBack),
                    ),
                  ),
                  const SizeBox(height: 80),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      labels[230]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: promptUser,
                  text: labels[231]["labelText"],
                ),
                const SizeBox(height: 15),
                SolidButton(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.passportExplanation);
                  },
                  text: labels[232]["labelText"],
                  color: AppColors.primaryBright17,
                  fontColor: AppColors.primary,
                ),
                const SizeBox(height: PaddingConstants.bottomPadding),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[233]["labelText"],
          message: labels[234]["labelText"],
          auxWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  // Navigator.pushNamed(context, Routes.eidDetails);
                  isEidChosen = true;
                  DocumentReader.showScanner();
                  Navigator.pop(context);
                },
                text: "Allow Access",
              ),
              const SizeBox(height: 15),
            ],
          ),
          actionWidget: Column(
            children: [
              SolidButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: labels[235]["labelText"],
                color: AppColors.primaryBright17,
                fontColor: AppColors.primary,
              ),
              const SizeBox(height: PaddingConstants.bottomPadding),
            ],
          ),
        );
      },
    );
  }
}
