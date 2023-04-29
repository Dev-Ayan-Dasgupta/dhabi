// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/utils/constants/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_face_api/face_api.dart';
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

  @override
  void initState() {
    super.initState();
    scannedDetailsArgument =
        ScannedDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});
    details = [
      DetailsTileModel(
          key: "Full Name", value: scannedDetailsArgument.fullName!),
      DetailsTileModel(
        key: scannedDetailsArgument.isEID ? "EID No." : "Passport No.",
        value: scannedDetailsArgument.isEID
            ? scannedDetailsArgument.idNumber!
            : scannedDetailsArgument.idNumber!.split("\n").last.substring(0, 8),
      ),
      DetailsTileModel(
          key: "Nationality", value: scannedDetailsArgument.nationality!),
      DetailsTileModel(
        key: scannedDetailsArgument.isEID
            ? "EID Expiry Date"
            : "Passport Expiry Date",
        value: DateFormat('dd MMMM yyyy').format(
          DateFormat('dd/MM/yyyy').parse(scannedDetailsArgument.expiryDate!),
        ),
      ),
      DetailsTileModel(
        key: "Date of Birth",
        value: DateFormat('dd MMMM yyyy').format(
          DateFormat('dd/MM/yyyy').parse(scannedDetailsArgument.dob!),
        ),
      ),
      DetailsTileModel(
          key: "Gender",
          value: scannedDetailsArgument.gender! == "M" ? "Male" : "Female"),
    ];
    FaceSDK.init().then((json) {
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

  void liveliness() async {
    // var value =
    await FaceSDK.startLiveness();
    // var result = LivenessResponse.fromJson(json.decode(value));
    // setState(
    //   () {
    //     image2.bitmap = base64Encode(
    //       base64Decode(
    //         result!.bitmap!.replaceAll("\n", ""),
    //       ),
    //     );
    //     image2.imageType = Regula.ImageType.LIVE;
    //     img2 = Image.memory(base64Decode(result.bitmap!.replaceAll("\n", "")));
    //     liveness = result.liveness == Regula.LivenessStatus.PASSED
    //         ? "passed"
    //         : "unknown";
    //   },
    // );
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
            onTap: () {},
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
