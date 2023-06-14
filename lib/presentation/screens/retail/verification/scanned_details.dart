// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
// import 'dart:math' as math;

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

  // late regula.MatchFacesImage image1;
  regula.MatchFacesImage image1 = regula.MatchFacesImage();
  regula.MatchFacesImage image2 = regula.MatchFacesImage();

  // late Image img1;
  Image img1 = Image.memory(base64Decode(
      storagePhoto != null ? storagePhoto!.replaceAll("\n", "") : ""));
  Image img2 = Image.asset(ImageConstants.eidFront);

  bool isFaceScanning = false;

  bool isDialogOpen = false;

  // int i = 5;

  @override
  void initState() {
    super.initState();
    initializeArgument();
    initializeDetails();
    initializeFaceSdk();
    // initPlatformState();
    if (scannedDetailsArgument.isEID) {
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
          // "logs": true,
          "dateFormat": "dd/MM/yyyy",
          "scenario": ScenarioIdentifier.SCENARIO_FULL_PROCESS,
          "timeout": 30.0,
          "timeoutFromFirstDetect": 30.0,
          "timeoutFromFirstDocType": 30.0,
          "multipageProcessing": true,
        }
      });
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
          // "logs": true,
          "dateFormat": "dd/MM/yyyy",
          "scenario": ScenarioIdentifier.SCENARIO_FULL_PROCESS,
          "timeout": 30.0,
          "timeoutFromFirstDetect": 30.0,
          "timeoutFromFirstDocType": 30.0,
          "multipageProcessing": false,
        }
      });
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

    image1.bitmap = base64Encode(base64Decode(
        storagePhoto != null ? storagePhoto!.replaceAll("\n", "") : ""));
    image1.imageType = regula.ImageType.PRINTED;

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
            : scannedDetailsArgument.idNumber ?? "null",
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
      if (!response["success"]) {}
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

  void handleEIDCompletion(DocumentReaderCompletion completion) async {
    if (completion.action == DocReaderAction.COMPLETE) {
      DocumentReaderResults? results = completion.results;

      fullName = await results?.textFieldValueByTypeLcidSource(
          EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES,
          LCID.LATIN,
          ERPRMResultType.RPRM_RESULT_TYPE_VISUAL_OCR_EXTENDED);
      await storage.write(key: "fullName", value: fullName);
      storageFullName = await storage.read(key: "fullName");

      eiDNumber = await results?.textFieldValueByTypeLcidSource(
          EVisualFieldType.FT_IDENTITY_CARD_NUMBER,
          LCID.LATIN,
          ERPRMResultType.RPRM_RESULT_TYPE_VISUAL_OCR_EXTENDED);
      await storage.write(key: "eiDNumber", value: eiDNumber);
      storageEidNumber = await storage.read(key: "eiDNumber");

      nationality = await results?.textFieldValueByTypeLcid(
        EVisualFieldType.FT_NATIONALITY,
        LCID.LATIN,
        // ERPRMResultType.RPRM_RESULT_TYPE_VISUAL_OCR_EXTENDED,
      );
      await storage.write(key: "nationality", value: nationality);
      storageNationality = await storage.read(key: "nationality");

      // nationalityCode = await results?.textFieldValueByTypeLcidSource(
      //     EVisualFieldType.FT_NATIONALITY_CODE,
      //     LCID.LATIN,
      //     ERPRMResultType.RPRM_RESULT_TYPE_MRZ_OCR_EXTENDED);
      // await storage.write(key: "nationalityCode", value: nationalityCode);
      String? nationalityUpper = nationality?.toUpperCase();
      for (var country in dhabiCountries) {
        if (nationalityUpper == country["countryName"]) {
          nationalityCode = country["shortCode"];
          break;
        }
      }
      storageNationalityCode = await storage.read(key: "nationalityCode");
      log("storageNationalityCode -> $storageNationalityCode");

      expiryDate = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_EXPIRY);
      await storage.write(key: "expiryDate", value: expiryDate);
      storageExpiryDate = await storage.read(key: "expiryDate");

      dob = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_BIRTH);
      await storage.write(key: "dob", value: dob);
      storageDob = await storage.read(key: "dob");

      gender = await results?.textFieldValueByTypeLcidSource(
          EVisualFieldType.FT_SEX,
          LCID.LATIN,
          ERPRMResultType.RPRM_RESULT_TYPE_VISUAL_OCR_EXTENDED);
      await storage.write(key: "gender", value: gender);
      storageGender = await storage.read(key: "gender");

      photo =
          results?.getGraphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT);
      if (photo != null) {
        log("photoString before -> $photo");
        image1.bitmap = base64Encode(base64Decode(photo!.replaceAll("\n", "")));
        image1.imageType = regula.ImageType.PRINTED;
        img1 = Image.memory(base64Decode(photo!.replaceAll("\n", "")));

        log("User photo Size before compress -> ${base64Decode(photo!.replaceAll("\n", "")).lengthInBytes / 1024} KB");
        var compressedPhoto = await FlutterImageCompress.compressWithList(
          base64Decode(photo!.replaceAll("\n", "")),
          quality: 30,
        );
        photo = base64Encode(compressedPhoto);
        // while (compressedPhoto.lengthInBytes / 1024 > 100) {
        //   compressedPhoto = await FlutterImageCompress.compressWithList(
        //     base64Decode(photo!.replaceAll("\n", "")),
        //     quality: math.Random.secure().nextInt(10) + 85,
        //     // 95 - i,
        //   );
        //   photo = base64Encode(compressedPhoto);
        // }
        // i = 5;

        log("User photo Size after compress -> ${compressedPhoto.lengthInBytes / 1024} KB");
        img1 = Image.memory(compressedPhoto);

        log("photoString after -> $photo");
      }
      await storage.write(key: "photo", value: photo);
      storagePhoto = await storage.read(key: "photo");

      docPhoto = results
          ?.getGraphicFieldImageByType(EGraphicFieldType.GF_DOCUMENT_IMAGE);
      var compressedDocPhoto = await FlutterImageCompress.compressWithList(
        base64Decode(docPhoto ?? ""),
        quality: 30,
      );
      docPhoto = base64Encode(compressedDocPhoto);
      // while (compressedDocPhoto.lengthInBytes / 1024 > 100) {
      //   compressedDocPhoto = await FlutterImageCompress.compressWithList(
      //     base64Decode(docPhoto ?? ""),
      //     quality: math.Random.secure().nextInt(10) + 85,
      //     // 95 - i,
      //   );
      //   docPhoto = base64Encode(compressedDocPhoto);
      // }
      // i = 5;

      log("Size after compress DocPhoto -> ${compressedDocPhoto.lengthInBytes / 1024} KB");

      await storage.write(key: "docPhoto", value: docPhoto);
      storageDocPhoto = await storage.read(key: "docPhoto");

      // TODO: Run conditions for checks regarding Age, no. of tries, both sides match and expired ID

      if (eiDNumber != null &&
          storageNationalityCode != null &&
          storageFullName != null &&
          storageNationality != null &&
          storageExpiryDate != null &&
          storageDob != null &&
          storageGender != null &&
          storagePhoto != null &&
          storageDocPhoto != null) {
        bool result = await MapIfEidExists.mapIfEidExists(
          {"eidNumber": eiDNumber},
          token ?? "",
        );

        log("If EID Exists API response -> $result");

        setState(() {
          isDialogOpen = true;
        });

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
                buttonText: "Go Home",
                // labels[1]["labelText"],
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
                .difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(
                    DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000"))))
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
                buttonText: "Go Home",
                // labels[1]["labelText"],
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
        else if (!(scannedDetailsArgument.isReKyc)) {
          if (result) {
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
                        Routes.loginUserId,
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
            await storage.write(key: "isEid", value: true.toString());
            // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
            storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
            if (!(scannedDetailsArgument.isReKyc)) {
              await storage.write(key: "stepsCompleted", value: 3.toString());
              storageStepsCompleted =
                  int.parse(await storage.read(key: "stepsCompleted") ?? "0");
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
                  nationalityCode: nationalityCode,
                  expiryDate: expiryDate,
                  dob: dob,
                  gender: gender,
                  photo: photo,
                  docPhoto: docPhoto,
                  isReKyc: scannedDetailsArgument.isReKyc,
                ).toMap(),
              );
            }
          }
        } else {
          await storage.write(key: "isEid", value: true.toString());
          // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
          storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
          if (!(scannedDetailsArgument.isReKyc)) {
            await storage.write(key: "stepsCompleted", value: 3.toString());
            storageStepsCompleted =
                int.parse(await storage.read(key: "stepsCompleted") ?? "0");
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
                nationalityCode: nationalityCode,
                expiryDate: expiryDate,
                dob: dob,
                gender: gender,
                photo: photo,
                docPhoto: docPhoto,
                isReKyc: scannedDetailsArgument.isReKyc,
              ).toMap(),
            );
          }
        }
      } else {
        if (context.mounted) {
          promptScanError("Emirates ID");
        }
      }
    } else if (completion.action == DocReaderAction.TIMEOUT) {
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
            buttonText: labels[88]["labelText"],
            // labels[1]["labelText"],
            onTap: () {
              Navigator.pop(context);
            },
            buttonTextSecondary: "",
            onTapSecondary: () {},
          ).toMap(),
        );
      }
    } else if (completion.action == DocReaderAction.ERROR) {
      if (context.mounted) {
        promptScanError("Emirates ID");
      }
    } else if (completion.action == DocReaderAction.CANCEL ||
        completion.action == DocReaderAction.MORE_PAGES_AVAILABLE ||
        completion.action == DocReaderAction.NOTIFICATION ||
        completion.action == DocReaderAction.PROCESS ||
        completion.action == DocReaderAction.PROCESSING_ON_SERVICE ||
        completion.action == DocReaderAction.PROCESS_IR_FRAME ||
        completion.action == DocReaderAction.PROCESS_WHITE_FLASHLIGHT ||
        completion.action == DocReaderAction.PROCESS_WHITE_UV_IMAGES) {
      // ! Don't do anthing for now
    } else {
      if (context.mounted) {
        promptScanError("Emirates ID");
      }
    }
  }

  void handlePassportCompletion(DocumentReaderCompletion completion) async {
    if (completion.action == DocReaderAction.COMPLETE) {
      DocumentReaderResults? results = completion.results;
      String? firstName =
          await results?.textFieldValueByType(EVisualFieldType.FT_GIVEN_NAMES);
      String? surname =
          await results?.textFieldValueByType(EVisualFieldType.FT_SURNAME);
      // fullName = await results
      //     ?.textFieldValueByType(EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES);
      fullName = "$firstName $surname";
      fullName = "$firstName $surname";
      await storage.write(key: "fullName", value: fullName);
      storageFullName = await storage.read(key: "fullName");

      String? tempPassportNumber =
          await results?.textFieldValueByType(EVisualFieldType.FT_MRZ_STRINGS);
      passportNumber = tempPassportNumber?.split("\n").last.split('<').first;
      await storage.write(key: "passportNumber", value: passportNumber);
      storagePassportNumber = await storage.read(key: "passportNumber");

      nationality = await results?.textFieldValueByTypeLcid(
          EVisualFieldType.FT_NATIONALITY, LCID.LATIN);
      await storage.write(key: "nationality", value: nationality);
      storageNationality = await storage.read(key: "nationality");

      String? tempNationalityCode = await results
          ?.textFieldValueByType(EVisualFieldType.FT_NATIONALITY_CODE);
      nationalityCode = LongToShortCode.longToShortCode(tempNationalityCode!);
      log("nationalityCode -> $nationalityCode");
      await storage.write(key: "nationalityCode", value: nationalityCode);
      storageNationalityCode = await storage.read(key: "nationalityCode");

      String? tempIssuingStateCode = await results
          ?.textFieldValueByType(EVisualFieldType.FT_ISSUING_STATE_CODE);
      issuingStateCode = LongToShortCode.longToShortCode(tempIssuingStateCode!);
      log("issuingState -> $issuingStateCode");
      await storage.write(key: "issuingStateCode", value: issuingStateCode);
      storageIssuingStateCode = await storage.read(key: "issuingStateCode");

      expiryDate = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_EXPIRY);
      await storage.write(key: "expiryDate", value: expiryDate);
      storageExpiryDate = await storage.read(key: "expiryDate");

      dob = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_BIRTH);
      await storage.write(key: "dob", value: dob);
      storageDob = await storage.read(key: "dob");

      gender = await results?.textFieldValueByType(EVisualFieldType.FT_SEX);
      await storage.write(key: "gender", value: gender);
      storageGender = await storage.read(key: "gender");

      photo =
          results?.getGraphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT);
      if (photo != null) {
        log("photoString before -> $photo");
        image1.bitmap = base64Encode(base64Decode(photo!.replaceAll("\n", "")));
        image1.imageType = regula.ImageType.PRINTED;
        img1 = Image.memory(base64Decode(photo!.replaceAll("\n", "")));

        log("Size before compress -> ${base64Decode(photo!.replaceAll("\n", "")).lengthInBytes}");
        var compressedPhoto = await FlutterImageCompress.compressWithList(
          base64Decode(photo!.replaceAll("\n", "")),
          quality: 30,
        );
        photo = base64Encode(compressedPhoto);
        // while (compressedPhoto.lengthInBytes / 1024 > 100) {
        //   compressedPhoto = await FlutterImageCompress.compressWithList(
        //     base64Decode(photo!.replaceAll("\n", "")),
        //     quality: math.Random.secure().nextInt(10) + 85,
        //     // 95 - i,
        //   );
        //   photo = base64Encode(compressedPhoto);
        // }
        // i = 5;

        log("User Photo Size after compress -> ${compressedPhoto.lengthInBytes / 1024} KB");
        img1 = Image.memory(compressedPhoto);

        log("photoString after -> $photo");
      }
      await storage.write(key: "photo", value: photo);
      storagePhoto = await storage.read(key: "photo");

      docPhoto = results
          ?.getGraphicFieldImageByType(EGraphicFieldType.GF_DOCUMENT_IMAGE);
      var compressedDocPhoto = await FlutterImageCompress.compressWithList(
        base64Decode(docPhoto ?? ""),
        quality: 30,
      );
      // docPhoto = base64Encode(compressedDocPhoto);
      // while (compressedDocPhoto.lengthInBytes / 1024 > 100) {
      //   compressedDocPhoto = await FlutterImageCompress.compressWithList(
      //     base64Decode(docPhoto ?? ""),
      //     quality: math.Random.secure().nextInt(10) + 85,
      //     // 95 - i,
      //   );
      //   docPhoto = base64Encode(compressedDocPhoto);
      // }
      // i = 5;

      log("Size after compress DocPhoto -> ${compressedDocPhoto.lengthInBytes / 1024} KB");

      await storage.write(key: "docPhoto", value: docPhoto);
      storageDocPhoto = await storage.read(key: "docPhoto");

      // TODO: Run conditions for checks regarding Age, no. of tries, both sides match and expired ID

      if (passportNumber != null &&
          storageNationalityCode != null &&
          storageFullName != null &&
          storageNationality != null &&
          storageExpiryDate != null &&
          storageDob != null &&
          storageGender != null &&
          storagePhoto != null &&
          storageDocPhoto != null &&
          storageIssuingStateCode != null) {
        var result = await MapIfPassportExists.mapIfPassportExists(
          {"passportNumber": passportNumber},
          token ?? "",
        );
        log("If Passport Exists API response -> $result");

        log("Doc Expired check -> ${DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000"))).difference(DateTime.now()).inDays}");
        log("Age check -> ${DateTime.now().difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000")))).inDays}");

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
                buttonText: "Go Home",
                // labels[1]["labelText"],
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
                .difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(
                    DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000"))))
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
                buttonText: "Go Home",
                // labels[1]["labelText"],
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
        else if (!(scannedDetailsArgument.isReKyc)) {
          if (result["exists"]) {
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
                        context,
                        Routes.loginUserId,
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
            await storage.write(key: "isEid", value: false.toString());
            // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
            storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
            if (!(scannedDetailsArgument.isReKyc)) {
              await storage.write(key: "stepsCompleted", value: 3.toString());
              storageStepsCompleted =
                  int.parse(await storage.read(key: "stepsCompleted") ?? "0");
            }
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
                  isReKyc: scannedDetailsArgument.isReKyc,
                ).toMap(),
              );
            }
          }
        } else {
          await storage.write(key: "isEid", value: false.toString());
          // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
          storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
          if (!(scannedDetailsArgument.isReKyc)) {
            await storage.write(key: "stepsCompleted", value: 3.toString());
            storageStepsCompleted =
                int.parse(await storage.read(key: "stepsCompleted") ?? "0");
          }
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
                isReKyc: scannedDetailsArgument.isReKyc,
              ).toMap(),
            );
          }
        }
      } else {
        if (context.mounted) {
          promptScanError("Passport");
        }
      }
    } else if (completion.action == DocReaderAction.TIMEOUT) {
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
            buttonText: messages[88]["messageText"],
            // labels[1]["labelText"],
            onTap: () {
              Navigator.pop(context);
            },
            buttonTextSecondary: "",
            onTapSecondary: () {},
          ).toMap(),
        );
      }
    } else if (completion.action == DocReaderAction.ERROR) {
      if (context.mounted) {
        promptScanError("Passport");
      }
    } else if (completion.action == DocReaderAction.CANCEL ||
        completion.action == DocReaderAction.MORE_PAGES_AVAILABLE ||
        completion.action == DocReaderAction.NOTIFICATION ||
        completion.action == DocReaderAction.PROCESS ||
        completion.action == DocReaderAction.PROCESSING_ON_SERVICE ||
        completion.action == DocReaderAction.PROCESS_IR_FRAME ||
        completion.action == DocReaderAction.PROCESS_WHITE_FLASHLIGHT ||
        completion.action == DocReaderAction.PROCESS_WHITE_UV_IMAGES) {
      // ! Don't do anthing for now
    } else {
      if (context.mounted) {
        promptScanError("Passport");
      }
    }
  }

  void liveliness() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    isFaceScanning = true;
    showButtonBloc.add(ShowButtonEvent(show: isFaceScanning));

    var value = await regula.FaceSDK.startLiveness();
    var result = regula.LivenessResponse.fromJson(json.decode(value));
    selfiePhoto = result!.bitmap!.replaceAll("\n", "");

    log("Selfie Photo before -> $selfiePhoto");
    log("Selfie size before compress -> ${base64Decode(selfiePhoto).lengthInBytes}");
    var compressedSelfie = await FlutterImageCompress.compressWithList(
      base64Decode(selfiePhoto),
      quality: 30,
    );
    selfiePhoto = base64Encode(compressedSelfie);

    // while (compressedSelfie.lengthInBytes / 1024 > 100) {
    //   compressedSelfie = await FlutterImageCompress.compressWithList(
    //     base64Decode(selfiePhoto),
    //     quality: math.Random.secure().nextInt(10) + 85,
    //     // 95 - i,
    //   );
    //   selfiePhoto = base64Encode(compressedSelfie);
    // }
    // i = 5;

    log("Selfie size after compress -> ${compressedSelfie.lengthInBytes / 1024} KB");

    log("Selfie photo after -> $selfiePhoto");

    await storage.write(key: "selfiePhoto", value: selfiePhoto);
    storageSelfiePhoto = await storage.read(key: "selfiePhoto");
    log("storageSelfiePhoto -> $storageSelfiePhoto");
    image2.bitmap = base64Encode(base64Decode(selfiePhoto));
    image2.imageType = regula.ImageType.LIVE;

    img2 = Image.memory(base64Decode(selfiePhoto));
    log("Selfie -> $selfiePhoto");

    await matchfaces();

    if (photoMatchScore > selfieScoreMatch) {
      Map<String, dynamic> response;
      if (storageIsEid == true) {
        response = await MapUploadEid.mapUploadEid(
          {
            "eidDocumentImage": storageDocPhoto,
            "eidUserPhoto": storagePhoto,
            "selfiePhoto": storageSelfiePhoto,
            "photoMatchScore": storagePhotoMatchScore,
            "eidNumber": storageEidNumber,
            "fullName": storageFullName,
            "dateOfBirth": DateFormat('yyyy-MM-dd').format(
                DateFormat('dd/MM/yyyy').parse(storageDob ?? "00/00/0000")),
            "nationalityCountryCode": storageNationalityCode,
            "genderId": storageGender == 'M' ? 1 : 2,
            "expiresOn": DateFormat('yyyy-MM-dd').format(
                DateFormat('dd/MM/yyyy')
                    .parse(storageExpiryDate ?? "00/00/0000")),
            "isReKYC": scannedDetailsArgument.isReKyc,
          },
          token ?? "",
        );

        log("UploadEid API response -> $response");
      } else {
        log("storageNationalityCode -> $storageNationalityCode");
        response = await MapUploadPassport.mapUploadPassport(
          {
            "passportDocumentImage": storageDocPhoto,
            "passportUserPhoto": storagePhoto,
            "selfiePhoto": storageSelfiePhoto,
            "photoMatchScore": storagePhotoMatchScore,
            "passportNumber": storagePassportNumber,
            "passportIssuingCountryCode": storageIssuingStateCode,
            "fullName": storageFullName,
            "dateOfBirth": DateFormat('yyyy-MM-dd').format(
                DateFormat('dd/MM/yyyy').parse(storageDob ?? "00/00/0000")),
            "nationalityCountryCode": storageNationalityCode,
            "genderId": storageGender == 'M' ? 1 : 2,
            "expiresOn": DateFormat('yyyy-MM-dd').format(
                DateFormat('dd/MM/yyyy')
                    .parse(storageExpiryDate ?? "00/00/0000")),
            "isReKYC": scannedDetailsArgument.isReKyc,
          },
          token ?? "",
        );
        log("UploadPassport API response -> $response");
      }

      if (response["success"]) {
        if (context.mounted) {
          if (scannedDetailsArgument.isReKyc) {
            Navigator.pushReplacementNamed(
              context,
              Routes.verifyMobile,
              arguments: VerifyMobileArgumentModel(
                isBusiness: false,
                isUpdate: false,
                isReKyc: true,
              ).toMap(),
            );
          } else {
            await storage.write(key: "stepsCompleted", value: 4.toString());
            storageStepsCompleted =
                int.parse(await storage.read(key: "stepsCompleted") ?? "0");

            if (context.mounted) {
              Navigator.pushReplacementNamed(
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
          }
        }
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Error",
                message: response["message"],
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: "Okay",
                ),
              );
            },
          );
        }
        if (storageIsEid == true) {
          log("Upload EID API error -> ${response["message"]}");
        } else {
          log("Upload Passport API error -> ${response["message"]}");
        }
      }

      isFaceScanning = false;
      showButtonBloc.add(ShowButtonEvent(show: isFaceScanning));
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CustomDialog(
              svgAssetPath: ImageConstants.warning,
              title: "Selfie Match Failed",
              message:
                  "Your selfie does not match with the photo from your scanned document",
              auxWidget: SolidButton(
                onTap: () {
                  isFaceScanning = false;
                  showButtonBloc.add(ShowButtonEvent(show: isFaceScanning));
                  Navigator.pop(context);
                },
                text: labels[347]["labelText"],
                color: AppColors.primaryBright17,
                fontColor: AppColors.primary,
              ),
              actionWidget: GradientButton(
                onTap: () {
                  Navigator.pop(context);
                  liveliness();
                },
                text: "Retake Selfie",
              ),
            );
          },
        );
      }
    }
  }

  matchfaces() async {
    // log("matchfaces executing");
    regula.MatchFacesRequest request = regula.MatchFacesRequest();
    request.images = [image1, image2];
    var value = await regula.FaceSDK.matchFaces(jsonEncode(request));
    var response = regula.MatchFacesResponse.fromJson(json.decode(value));
    var str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
        jsonEncode(response!.results), 0.8);
    regula.MatchFacesSimilarityThresholdSplit? split =
        regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
    // log("matched faces -> ${split!.matchedFaces}");
    photoMatchScore = split!.matchedFaces.isNotEmpty
        ? (split.matchedFaces[0]!.similarity! * 100)
        : 0;
    await storage.write(
        key: "photoMatchScore", value: photoMatchScore.toString());
    storagePhotoMatchScore =
        double.parse(await storage.read(key: "photoMatchScore") ?? "");

    log("photoMatchScore -> $photoMatchScore");
    log("storagePhotoMatchScore -> $storagePhotoMatchScore");
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
                      color: AppColors.dark50,
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
                    const SizeBox(width: 5),
                    Expanded(
                      child: Text(
                        scannedDetailsArgument.isEID
                            ? labels[245]["labelText"]
                            : labels[259]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
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
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.checkedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          isChecked = true;
          triggerCheckBoxEvent(isChecked);
          triggerAllTrueEvent();
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.uncheckedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
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
              if (!isFaceScanning) {
                liveliness();
              }
            },
            text: labels[246]["labelText"],
            auxWidget: isFaceScanning ? const LoaderRow() : const SizeBox(),
          ),
          const SizeBox(height: 15),
          SolidButton(
            onTap: () {
              setState(() {
                isDialogOpen = false;
              });
              if (!isFaceScanning) {
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
          const SizeBox(height: PaddingConstants.bottomPadding),
        ],
      );
    } else {
      return Column(
        children: [
          SolidButton(onTap: () {}, text: labels[246]["labelText"]),
          const SizeBox(height: 15),
          SolidButton(
            onTap: () {
              if (!isFaceScanning) {
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
          const SizeBox(height: PaddingConstants.bottomPadding),
        ],
      );
    }
  }

  void promptScanError(String docType) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Scanning Error",
          message:
              "There was an error while scanning your $docType. Please try again.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Try Again",
          ),
        );
      },
    );
  }
}
