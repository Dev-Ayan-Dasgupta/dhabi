// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class ScannedDetailsScreen extends StatefulWidget {
  const ScannedDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ScannedDetailsScreen> createState() => _ScannedDetailsScreenState();
}

class _ScannedDetailsScreenState extends State<ScannedDetailsScreen> {
  late ScannedDetailsArgumentModel scannedDetailsArgument;

  List<DetailsTileModel> details = [];

  bool isChecked = false;

  late regula.MatchFacesImage image1;
  regula.MatchFacesImage image2 = regula.MatchFacesImage();

  late Image img1;
  Image img2 = Image.asset(ImageConstants.eidFront);

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    initializeArgument();
    initializeDetails();
    initializeFaceSdk();
    initPlatformState();
    if (scannedDetailsArgument.isEID) {
      const EventChannel('flutter_document_reader_api/event/completion')
          .receiveBroadcastStream()
          .listen(
            (jsonString) => handleEIDCompletion(
              DocumentReaderCompletion.fromJson(
                json.decode(jsonString),
              )!,
            ),
          );
    } else {
      const EventChannel('flutter_document_reader_api/event/completion')
          .receiveBroadcastStream()
          .listen(
            (jsonString) => handlePassportCompletion(
              DocumentReaderCompletion.fromJson(
                json.decode(jsonString),
              )!,
            ),
          );
    }
  }

  void initializeArgument() {
    scannedDetailsArgument =
        ScannedDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});

    image1 = scannedDetailsArgument.image1;
    img1 = scannedDetailsArgument.img1;

    fullName = scannedDetailsArgument.fullName;
    log("Full Name -> $fullName");

    if (scannedDetailsArgument.isEID) {
      eiDNumber = scannedDetailsArgument.idNumber;
      log("EID Number -> $eiDNumber");
    } else {
      passportNumber = scannedDetailsArgument.idNumber;
      log("Passport Number -> $passportNumber");
    }

    nationality = scannedDetailsArgument.nationality;
    log("Nationality -> $nationality");
    nationalityCode = scannedDetailsArgument.nationalityCode;
    log("Nationality Code -> $nationalityCode");

    expiryDate = scannedDetailsArgument.expiryDate;
    log("Expiry Date -> ${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000"))}");
    dob = scannedDetailsArgument.dob;
    log("DoB -> ${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000"))}");

    gender = scannedDetailsArgument.gender;
    log("Gender -> $gender");

    photo = scannedDetailsArgument.photo;
    log("Photo -> $photo");
    docPhoto = scannedDetailsArgument.docPhoto;
    log("DocPhoto -> $docPhoto");
  }

  void initializeDetails() {
    details = [
      DetailsTileModel(
          key: "Full Name", value: scannedDetailsArgument.fullName ?? "null"),
      DetailsTileModel(
        key: scannedDetailsArgument.isEID ? "EID No." : "Passport No.",
        value: scannedDetailsArgument.isEID
            ? scannedDetailsArgument.idNumber ?? "null"
            : scannedDetailsArgument.idNumber
                    ?.split("\n")
                    .last
                    .substring(0, 8) ??
                "null",
      ),
      DetailsTileModel(
          key: "Nationality",
          value: scannedDetailsArgument.nationality ?? "null"),
      DetailsTileModel(
        key: scannedDetailsArgument.isEID
            ? "EID Expiry Date"
            : "Passport Expiry Date",
        value: DateFormat('dd MMMM yyyy').format(
          DateFormat('dd/MM/yyyy')
              .parse(scannedDetailsArgument.expiryDate ?? "00/00/0000"),
        ),
      ),
      DetailsTileModel(
        key: "Date of Birth",
        value: DateFormat('dd MMMM yyyy').format(
          DateFormat('dd/MM/yyyy')
              .parse(scannedDetailsArgument.dob ?? "00/00/0000"),
        ),
      ),
      DetailsTileModel(
        key: "Gender",
        value: scannedDetailsArgument.gender == null
            ? "null"
            : scannedDetailsArgument.gender == "M"
                ? "Male"
                : "Female",
      ),
    ];
  }

  void initializeFaceSdk() {
    regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      if (!response["success"]) {
        // print("Init failed: ");
        // print(json);
      }
    });
    const EventChannel('flutter_face_api/event/video_encoder_completion')
        .receiveBroadcastStream()
        .listen((event) {
      var response = jsonDecode(event);
      String transactionId = response["transactionId"];
      bool success = response["success"];
      debugPrint("video_encoder_completion:");
      debugPrint("success: $success");
      debugPrint("transactionId: $transactionId");
    });
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
        "showBackgroundMask": true,
        "backgroundMaskAlpha": 0.6,
      },
      "processParams": {
        "dateFormat": "dd/MM/yyyy",
        "scenario": "MrzOrOcr",
        "multipageProcessing": true
      }
    });
  }

  void handleEIDCompletion(DocumentReaderCompletion completion) async {
    if (completion.action == DocReaderAction.COMPLETE ||
        completion.action == DocReaderAction.TIMEOUT) {
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
        setState(() {
          image1.bitmap =
              base64Encode(base64Decode(photo!.replaceAll("\n", "")));
          image1.imageType = regula.ImageType.PRINTED;
          img1 = Image.memory(base64Decode(photo!.replaceAll("\n", "")));
        });
      }
      docPhoto = results
          ?.getGraphicFieldImageByType(EGraphicFieldType.GF_DOCUMENT_IMAGE);

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

  void handlePassportCompletion(DocumentReaderCompletion completion) async {
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
      passportNumber =
          await results?.textFieldValueByType(EVisualFieldType.FT_MRZ_STRINGS);
      // passportNumber = ppMrz!.substring(0, 9);
      // print("passportNumber -> $passportNumber");
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
        setState(() {
          image1.bitmap =
              base64Encode(base64Decode(photo!.replaceAll("\n", "")));
          image1.imageType = regula.ImageType.PRINTED;
          img1 = Image.memory(base64Decode(photo!.replaceAll("\n", "")));
        });
      }
      docPhoto = results
          ?.getGraphicFieldImageByType(EGraphicFieldType.GF_DOCUMENT_IMAGE);

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

  void liveliness() async {
    // final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    var value = await regula.FaceSDK.startLiveness();
    var result = regula.LivenessResponse.fromJson(json.decode(value));
    selfiePhoto = result!.bitmap!.replaceAll("\n", "");
    setState(
      () {
        image2.bitmap = base64Encode(base64Decode(selfiePhoto));
        image2.imageType = regula.ImageType.LIVE;

        img2 = Image.memory(base64Decode(selfiePhoto));
      },
    );
    log("Selfie -> $selfiePhoto");

    await matchfaces();

    if (photoMatchScore > 80) {
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          Routes.retailOnboardingStatus,
          arguments: OnboardingStatusArgumentModel(
            stepsCompleted: 2,
            isFatca: false,
            isPassport: false,
            isRetail: true,
          ).toMap(),
        );
      }
    } else {
      // TODO: Show face match failed message in UI, take confirmation from FH team
    }
    // if (scannedDetailsArgument.isEID) {
    //   isUploading = true;
    //   showButtonBloc.add(ShowButtonEvent(show: isUploading));
    //   // var response = await MapUploadEid.mapUploadEid(
    //   //   {
    //   //     "eidDocumentImage": docPhoto,
    //   //     "eidUserPhoto": photo,
    //   //     "selfiePhoto": selfiePhoto,
    //   //     "photoMatchScore": photoMatchScore,
    //   //     "eidNumber": eiDNumber,
    //   //     "fullName": fullName,
    //   //     "dateOfBirth": DateFormat('yyyy-MM-dd')
    //   //         .format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000")),
    //   //     "nationalityCountryCode": nationalityCode,
    //   //     "genderId": gender == 'M' ? 1 : 2,
    //   //     "expiresOn": DateFormat('yyyy-MM-dd').format(
    //   //         DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000")),
    //   //     "isReKYC": false
    //   //   },
    //   //   token,
    //   // );
    //   // log("UploadEid API response -> $response");
    //   isUploading = false;
    //   showButtonBloc.add(ShowButtonEvent(show: isUploading));
    // } else {
    //   isUploading = true;
    //   showButtonBloc.add(ShowButtonEvent(show: isUploading));
    //   // var response = await MapUploadPassport.mapUploadPassport(
    //   //   {
    //   //     "passportDocumentImage": docPhoto,
    //   //     "passportUserPhoto": photo,
    //   //     "selfiePhoto": selfiePhoto,
    //   //     "photoMatchScore": photoMatchScore,
    //   //     "passportNumber": passportNumber,
    //   //     "fullName": fullName,
    //   //     "dateOfBirth": DateFormat('yyyy-MM-dd')
    //   //         .format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000")),
    //   //     "nationalityCountryCode": nationalityCode,
    //   //     "genderId": gender == 'M' ? 1 : 2,
    //   //     "expiresOn": DateFormat('yyyy-MM-dd').format(
    //   //         DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000")),
    //   //     "isReKYC": false
    //   //   },
    //   //   token,
    //   // );
    //   // log("UploadPassport API response -> $response");
    //   isUploading = false;
    //   showButtonBloc.add(ShowButtonEvent(show: isUploading));
    // }
  }

  matchfaces() async {
    regula.MatchFacesRequest request = regula.MatchFacesRequest();
    request.images = [image1, image2];
    var value = await regula.FaceSDK.matchFaces(jsonEncode(request));
    var response = regula.MatchFacesResponse.fromJson(json.decode(value));
    var str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
        jsonEncode(response!.results), 0.8);
    regula.MatchFacesSimilarityThresholdSplit? split =
        regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));

    photoMatchScore = split!.matchedFaces.isNotEmpty
        ? (split.matchedFaces[0]!.similarity! * 100)
        : 0;

    log("photoMatchScore -> $photoMatchScore");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (15 / Dimensions.designWidth).w,
                vertical: (15 / Dimensions.designWidth).w,
              ),
              child: SvgPicture.asset(
                ImageConstants.support,
                width: (50 / Dimensions.designWidth).w,
                height: (50 / Dimensions.designWidth).w,
              ),
            ),
          )
        ],
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
                    scannedDetailsArgument.isEID
                        ? labels[238]["labelText"]
                        : labels[255]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 15),
                  Text(
                    scannedDetailsArgument.isEID
                        ? labels[239]["labelText"]
                        : labels[256]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.black81,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 25),
                  Expanded(
                    child: DetailsTile(
                      length: details.length,
                      details: details,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: buildTC,
                    ),
                    const SizeBox(width: 10),
                    Expanded(
                      child: Text(
                        scannedDetailsArgument.isEID
                            ? labels[245]["labelText"]
                            : labels[259]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.black81,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 20),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildSubmitButton,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTC(BuildContext context, CheckBoxState state) {
    if (isChecked) {
      return InkWell(
        onTap: () {
          isChecked = false;
          triggerCheckBoxEvent(isChecked);
          triggerAllTrueEvent();
        },
        child: SvgPicture.asset(
          ImageConstants.checkedBox,
          width: (14 / Dimensions.designWidth).w,
          height: (14 / Dimensions.designWidth).w,
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          isChecked = true;
          triggerCheckBoxEvent(isChecked);
          triggerAllTrueEvent();
        },
        child: SvgPicture.asset(
          ImageConstants.uncheckedBox,
          width: (14 / Dimensions.designWidth).w,
          height: (14 / Dimensions.designWidth).w,
        ),
      );
    }
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  void triggerAllTrueEvent() {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isChecked));
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isChecked) {
      return Column(
        children: [
          GradientButton(
            onTap: () {
              if (!isUploading) {
                liveliness();
              }
            },
            text: isUploading
                ? "Uploading your details"
                : labels[246]["labelText"],
          ),
          const SizeBox(height: 15),
          SolidButton(
            onTap: () {
              if (!isUploading) {
                scannedDetailsArgument.isEID
                    ? isEidChosen = true
                    : isEidChosen = false;
                DocumentReader.showScanner();
              }
            },
            text: scannedDetailsArgument.isEID
                ? labels[247]["labelText"]
                : labels[260]["labelText"],
            color: AppColors.primaryBright17,
            fontColor: AppColors.primary,
          ),
          const SizeBox(height: 20),
        ],
      );
    } else {
      return const SizeBox();
    }
  }
}
