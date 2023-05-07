import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/long_to_short_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:intl/intl.dart';

class PassportExplanationScreen extends StatefulWidget {
  const PassportExplanationScreen({Key? key}) : super(key: key);

  @override
  State<PassportExplanationScreen> createState() =>
      _PassportExplanationScreenState();
}

class _PassportExplanationScreenState extends State<PassportExplanationScreen> {
  regula.MatchFacesImage image1 = regula.MatchFacesImage();

  Image img1 = Image.asset(ImageConstants.eidFront);

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

  // Future<void> initPlatformState() async {
  //   await DocumentReader.prepareDatabase("Full");
  //   ByteData byteData = await rootBundle.load("assets/regula.license");
  //   await DocumentReader.initializeReader({
  //     "license": base64.encode(byteData.buffer
  //         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)),
  //     "delayedNNLoad": true
  //   });
  //   DocumentReader.setConfig({
  //     "functionality": {
  //       "showCaptureButton": true,
  //       "showCaptureButtonDelayFromStart": 2,
  //       "showCaptureButtonDelayFromDetect": 1,
  //       "showCloseButton": true,
  //       "showTorchButton": true,
  //     },
  //     "customization": {
  //       "status": "Searching for document",
  //       "showBackgroundMask": true,
  //       "backgroundMaskAlpha": 0.6,
  //     },
  //     "processParams": {
  //       "dateFormat": "dd/MM/yyyy",
  //       "scenario": "MrzOrOcr",
  //       "multipageProcessing": true
  //     }
  //   });
  // }

  void handleCompletion(DocumentReaderCompletion completion) async {
    // TODO: Remove Timeout condition for this screen
    if (completion.action == DocReaderAction.COMPLETE) {
      DocumentReaderResults? results = completion.results;
      String? firstName =
          await results?.textFieldValueByType(EVisualFieldType.FT_GIVEN_NAMES);
      String? surname =
          await results?.textFieldValueByType(EVisualFieldType.FT_SURNAME);
      // fullName = await results
      //     ?.textFieldValueByType(EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES);
      fullName = "$firstName $surname";
      passportNumber =
          await results?.textFieldValueByType(EVisualFieldType.FT_MRZ_STRINGS);
      // passportNumber = ppMrz!.substring(0, 9);
      // print("passportNumber -> $passportNumber");
      nationality =
          await results?.textFieldValueByType(EVisualFieldType.FT_NATIONALITY);
      String? tempNationalityCode = await results
          ?.textFieldValueByType(EVisualFieldType.FT_NATIONALITY_CODE);
      nationalityCode = LongToShortCode.longToShortCode(tempNationalityCode!);
      // String?
      String? tempIssuingStateCode = await results
          ?.textFieldValueByType(EVisualFieldType.FT_ISSUING_STATE_CODE);
      issuingStateCode = LongToShortCode.longToShortCode(tempIssuingStateCode!);
      log("issuingState -> $issuingStateCode");
      String? issuingPlace = await results
          ?.textFieldValueByType(EVisualFieldType.FT_PLACE_OF_ISSUE);
      log("issuingPlace -> $issuingPlace");
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
      // results?.graphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT);

      // TODO: Run conditions for checks regarding Age, no. of tries, both sides match and expired ID

      log("Doc Expired check -> ${DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000"))).difference(DateTime.now()).inDays}");
      log("Age check -> ${DateTime.now().difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000")))).inDays}");

      bool result = await MapIfPassportExists.mapIfPassportExists(
          {"passportNumber": passportNumber}, token);
      log("If Passport Exists API response -> $result");

      // ? Check for expired
      if (DateTime.parse(DateFormat('yyyy-MM-dd').format(
                  DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000")))
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
                    context, Routes.registration, (route) => false);
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
                    context, Routes.registration, (route) => false);
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
                message: messages[21]["messageText"],
                buttonText: labels[205]["labelText"],
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.loginUserId, (route) => false);
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
              isEID: false,
              fullName: fullName,
              idNumber: passportNumber,
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
                  context, Routes.registration, (route) => false);
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
                    labels[252]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Scan the first page of your passport.",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: (280 / Dimensions.designWidth).w,
                      height: (384 / Dimensions.designWidth).w,
                      child: Image.asset(ImageConstants.passport),
                    ),
                  ),
                  const SizeBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      labels[254]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                      textAlign: TextAlign.center,
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
                    Navigator.pushNamed(
                      context,
                      Routes.retailOnboardingStatus,
                      arguments: OnboardingStatusArgumentModel(
                        stepsCompleted: 1,
                        isFatca: false,
                        isPassport: false,
                        isRetail: true,
                      ).toMap(),
                    );
                  },
                  text: labels[235]["labelText"],
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
                  isEidChosen = false;
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
