// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  String? fullName;
  String? eiDNumber;
  String? nationality;
  String? expiryDate;
  String? dob;
  String? gender;
  String? photo;

  late regula.MatchFacesImage image1;
  regula.MatchFacesImage image2 = regula.MatchFacesImage();

  late Image img1;
  Image img2 = Image.asset(ImageConstants.eidFront);

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
            isEID: false,
            fullName: fullName,
            idNumber: passportNumber,
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

  void liveliness() async {
    var value = await regula.FaceSDK.startLiveness();
    var result = regula.LivenessResponse.fromJson(json.decode(value));
    setState(
      () {
        image2.bitmap = base64Encode(
          base64Decode(
            result!.bitmap!.replaceAll("\n", ""),
          ),
        );
        image2.imageType = regula.ImageType.LIVE;
        img2 = Image.memory(base64Decode(result.bitmap!.replaceAll("\n", "")));
        // liveness = result.liveness == regula.LivenessStatus.PASSED
        //     ? "passed"
        //     : "unknown";
      },
    );
    if (context.mounted) {
      Navigator.pushNamed(
        context,
        Routes.faceCompare,
        arguments: FaceCompareArgumentModel(
          image1: image1,
          img1: img1,
          image2: image2,
          img2: img2,
        ).toMap(),
      );
    }
    // if (context.mounted) {
    //   Navigator.pushNamed(
    //     context,
    //     Routes.retailOnboardingStatus,
    //     arguments: OnboardingStatusArgumentModel(
    //       stepsCompleted: 2,
    //       isFatca: false,
    //       isPassport: false,
    //       isRetail: true,
    //     ).toMap(),
    //   );
    // }
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
              liveliness();
            },
            text: labels[246]["labelText"],
          ),
          const SizeBox(height: 15),
          SolidButton(
            onTap: () {
              DocumentReader.showScanner();
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
