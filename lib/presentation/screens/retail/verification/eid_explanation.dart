// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:intl/intl.dart';

class EIDExplanationScreen extends StatefulWidget {
  const EIDExplanationScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<EIDExplanationScreen> createState() => _EIDExplanationScreenState();
}

class _EIDExplanationScreenState extends State<EIDExplanationScreen> {
  regula.MatchFacesImage image1 = regula.MatchFacesImage();

  Image img1 = Image.asset(ImageConstants.eidFront);

  bool isScanning = false;

  bool isDialogOpen = false;
  // int i = 5;

  late VerificationInitializationArgumentModel eidReKycArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    // initPlatformState();
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
          (jsonString) => handleCompletion(
            DocumentReaderCompletion.fromJson(
              json.decode(jsonString),
            )!,
          ),
        );
  }

  void argumentInitialization() {
    eidReKycArgument = VerificationInitializationArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
    log("eidReKycArgument -> ${eidReKycArgument.toMap()}");
  }

  void handleCompletion(DocumentReaderCompletion completion) async {
    if (completion.action == DocReaderAction.COMPLETE) {
      DocumentReaderResults? results = completion.results;

      fullName = await results?.textFieldValueByTypeLcid(
        EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES,
        LCID.LATIN,
      );
      await storage.write(key: "fullName", value: fullName);
      storageFullName = await storage.read(key: "fullName");

      eiDNumber = await results?.textFieldValueByTypeLcidSource(
        EVisualFieldType.FT_IDENTITY_CARD_NUMBER,
        LCID.LATIN,
        ERPRMResultType.RPRM_RESULT_TYPE_VISUAL_OCR_EXTENDED,
      );
      await storage.write(key: "eiDNumber", value: eiDNumber);
      storageEidNumber = await storage.read(key: "eiDNumber");

      nationality = await results?.textFieldValueByTypeLcid(
        EVisualFieldType.FT_NATIONALITY,
        LCID.LATIN,
      );
      await storage.write(key: "nationality", value: nationality);
      storageNationality = await storage.read(key: "nationality");

      // nationalityCode = await results?.textFieldValueByTypeLcidSource(
      //     EVisualFieldType.FT_NATIONALITY_CODE,
      //     LCID.LATIN,
      //     ERPRMResultType.RPRM_RESULT_TYPE_MRZ_OCR_EXTENDED);
      String? nationalityUpper = nationality?.toUpperCase();
      for (var country in dhabiCountries) {
        if (nationalityUpper == country["countryName"]) {
          nationalityCode = country["shortCode"];
          break;
        }
      }
      await storage.write(key: "nationalityCode", value: nationalityCode);
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

        log("User photo Size before compress -> ${base64Decode(photo!.replaceAll("\n", "")).lengthInBytes}");
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

      log("Size after compress doc photo -> ${compressedDocPhoto.lengthInBytes / 1024} KB");

      await storage.write(key: "docPhoto", value: docPhoto);
      storageDocPhoto = await storage.read(key: "docPhoto");

      // TODO: Run conditions for checks regarding Age, no. of tries, both sides match and expired ID

      log("Request -> ${{"eidNumber": eiDNumber}}");

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
        else if (!(eidReKycArgument.isReKyc)) {
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
            await storage.write(key: "isEid", value: true.toString());
            // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
            storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
            if (!(eidReKycArgument.isReKyc)) {
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
                  isReKyc: eidReKycArgument.isReKyc,
                ).toMap(),
              );
            }
          }
        } else {
          await storage.write(key: "isEid", value: true.toString());
          // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
          storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
          if (!(eidReKycArgument.isReKyc)) {
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
                isReKyc: eidReKycArgument.isReKyc,
              ).toMap(),
            );
          }
        }
      } else {
        if (context.mounted) {
          promptScanError();
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
    } else if (completion.action == DocReaderAction.ERROR) {
      if (context.mounted) {
        promptScanError();
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
      log("Big else executing");
      if (context.mounted) {
        promptScanError();
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
                  const SizeBox(height: 70),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: (276 / Dimensions.designWidth).w,
                      height: (159 / Dimensions.designHeight).h,
                      child: Image.asset(ImageConstants.eidFront),
                    ),
                  ),
                  const SizeBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: (276 / Dimensions.designWidth).w,
                      height: (159 / Dimensions.designHeight).h,
                      child: Image.asset(ImageConstants.eidBack),
                    ),
                  ),
                  const SizeBox(height: 70),
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
                  onTap: () {
                    setState(() {
                      isDialogOpen = false;
                    });
                    if (!isScanning) {
                      final ShowButtonBloc showButtonBloc =
                          context.read<ShowButtonBloc>();
                      isScanning = true;
                      showButtonBloc.add(ShowButtonEvent(show: isScanning));
                      promptUser();
                      isScanning = false;
                      showButtonBloc.add(ShowButtonEvent(show: isScanning));
                    }
                  },
                  text: labels[231]["labelText"],
                ),
                const SizeBox(height: 15),
                SolidButton(
                  onTap: () {
                    log("eidReKycArgument.isReKyc -> ${eidReKycArgument.isReKyc}");
                    Navigator.pushNamed(
                      context,
                      Routes.passportExplanation,
                      arguments: VerificationInitializationArgumentModel(
                        isReKyc: eidReKycArgument.isReKyc,
                      ).toMap(),
                    );
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

  void promptScanError() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Scanning Error",
          message:
              "There was an error while scanning your EID. Please try again.",
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

  void promptUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[233]["labelText"],
          message: labels[234]["labelText"],
          auxWidget: GradientButton(
            onTap: () {
              // Navigator.pushNamed(context, Routes.eidDetails);
              isEidChosen = true;
              DocumentReader.showScanner();
              Navigator.pop(context);
            },
            text: "Allow Access",
          ),
          actionWidget: SolidButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[235]["labelText"],
            color: AppColors.primaryBright17,
            fontColor: AppColors.primary,
          ),
        );
      },
    );
  }
}
