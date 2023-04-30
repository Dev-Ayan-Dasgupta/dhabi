import 'dart:convert';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_face_api/face_api.dart' as regula;

class EIDExplanationScreen extends StatefulWidget {
  const EIDExplanationScreen({Key? key}) : super(key: key);

  @override
  State<EIDExplanationScreen> createState() => _EIDExplanationScreenState();
}

class _EIDExplanationScreenState extends State<EIDExplanationScreen> {
  String? fullName;
  String? eiDNumber;
  String? nationality;
  String? expiryDate;
  String? dob;
  String? gender;
  String? photo;

  regula.MatchFacesImage image1 = regula.MatchFacesImage();

  Image img1 = Image.asset(ImageConstants.eidFront);

  String status = "";
  double progress = 0;

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
    const EventChannel('flutter_document_reader_api/event/database_progress')
        .receiveBroadcastStream()
        .listen(
          (progress) => setState(
            () {
              progress = progress;
            },
          ),
        );
  }

  Future<void> initPlatformState() async {
    var prepareDatabase = await DocumentReader.prepareDatabase("Full");
    print("prepareDatabase -> $prepareDatabase");
    setState(() {
      status = "Initializing";
    });
    ByteData byteData = await rootBundle.load("assets/regula.license");
    var documentReaderInitialization = await DocumentReader.initializeReader({
      "license": base64.encode(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)),
      "delayedNNLoad": true
    });
    print("documentReaderInitialization -> $documentReaderInitialization");
    setState(() {
      status = "Ready";
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

      fullName = await results
          ?.textFieldValueByType(EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES);
      eiDNumber = await results
          ?.textFieldValueByType(EVisualFieldType.FT_IDENTITY_CARD_NUMBER);
      nationality =
          await results?.textFieldValueByType(EVisualFieldType.FT_NATIONALITY);
      expiryDate = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_EXPIRY);
      dob = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_BIRTH);
      gender = await results?.textFieldValueByType(EVisualFieldType.FT_SEX);
      photo =
          results?.getGraphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT);
      if (photo != null) {
        setState(() {
          image1.bitmap =
              base64Encode(base64Decode(photo!.replaceAll("\n", "")));
          image1.imageType = regula.ImageType.PRINTED;
          img1 = Image.memory(base64Decode(photo!.replaceAll("\n", "")));
        });
      }

      if (context.mounted) {
        Navigator.pushNamed(
          context,
          Routes.scannedDetails,
          arguments: ScannedDetailsArgumentModel(
            isEID: true,
            fullName: fullName,
            idNumber: eiDNumber,
            nationality: nationality,
            expiryDate: expiryDate,
            dob: dob,
            gender: gender,
            photo: photo,
            img1: img1,
            image1: image1,
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
                    labels[228]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    labels[229]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.black81,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 100),
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
                  const SizeBox(height: 100),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      labels[230]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.blackD9,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text("Database downloaded: $progress%"),
                  const SizeBox(height: 10),
                  Text("Status: $status"),
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
