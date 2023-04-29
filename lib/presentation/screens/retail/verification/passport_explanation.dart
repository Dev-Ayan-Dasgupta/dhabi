import 'dart:convert';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/constants/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class PassportExplanationScreen extends StatefulWidget {
  const PassportExplanationScreen({Key? key}) : super(key: key);

  @override
  State<PassportExplanationScreen> createState() =>
      _PassportExplanationScreenState();
}

class _PassportExplanationScreenState extends State<PassportExplanationScreen> {
  String? fullName;
  String? passportNumber;
  String? nationality;
  String? expiryDate;
  String? dob;
  String? gender;
  String? photo;

  @override
  void initState() {
    super.initState();
    initPlatformState();
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

  Future<void> initPlatformState() async {
    await DocumentReader.prepareDatabase("Full");
    ByteData byteData = await rootBundle.load("assets/regula.license");
    await DocumentReader.initializeReader({
      "license": base64.encode(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)),
      "delayedNNLoad": true
    });
    DocumentReader.setConfig({
      "functionality": {
        "showCaptureButton": true,
        "showCaptureButtonDelayFromStart": 2,
        "showCaptureButtonDelayFromDetect": 1,
        "showCloseButton": true,
        "showTorchButton": true,
      },
      "customization": {
        "status": "Searching for document",
      },
      "processParams": {
        "dateFormat": "dd/MM/yyyy",
        "scenario": "MrzOrOcr",
        "multipageProcessing": true
      }
    });
  }

  void handleCompletion(DocumentReaderCompletion completion) async {
    if (completion.action == DocReaderAction.COMPLETE ||
        completion.action == DocReaderAction.TIMEOUT) {
      DocumentReaderResults? results = completion.results;
      String? firstName =
          await results?.textFieldValueByType(EVisualFieldType.FT_GIVEN_NAMES);
      String? surname =
          await results?.textFieldValueByType(EVisualFieldType.FT_SURNAME);
      // fullName = await results
      //     ?.textFieldValueByType(EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES);
      fullName = "$firstName $surname";
      String? passportNumber =
          await results?.textFieldValueByType(EVisualFieldType.FT_MRZ_STRINGS);
      // passportNumber = ppMrz!.substring(0, 9);
      // print("passportNumber -> $passportNumber");
      nationality =
          await results?.textFieldValueByType(EVisualFieldType.FT_NATIONALITY);
      expiryDate = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_EXPIRY);
      dob = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_BIRTH);
      gender = await results?.textFieldValueByType(EVisualFieldType.FT_SEX);
      photo =
          results?.getGraphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT);

      if (context.mounted) {
        Navigator.pushNamed(
          context,
          Routes.scannedDetails,
          arguments: ScannedDetailsArgumentModel(
            isEID: false,
            fullName: fullName,
            idNumber: passportNumber,
            nationality: nationality,
            expiryDate: expiryDate,
            dob: dob,
            gender: gender,
            photo: photo,
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
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels[252]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    "Scan the first page of your passport.",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.black81,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 67),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: (280 / Dimensions.designWidth).w,
                      height: (384 / Dimensions.designWidth).w,
                      child: Image.asset(ImageConstants.passport),
                    ),
                  ),
                  const SizeBox(height: 67),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      labels[254]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.blackD9,
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
                const SizeBox(height: 20),
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
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[233]["labelText"],
          message: labels[234]["labelText"],
          auxWidget: const SizeBox(),
          actionWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  // TODO: call function to launch regula document scanner here
                  // Navigator.pushNamed(context, Routes.eidDetails);

                  DocumentReader.showScanner();
                  Navigator.pop(context);
                },
                text: "Allow Access",
              ),
              const SizeBox(height: 15),
              SolidButton(
                onTap: () {},
                text: labels[235]["labelText"],
                color: AppColors.primaryBright17,
                fontColor: AppColors.primary,
              ),
              const SizeBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
