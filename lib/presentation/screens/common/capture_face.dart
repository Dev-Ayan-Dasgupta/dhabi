import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CaptureFaceScreen extends StatefulWidget {
  const CaptureFaceScreen({Key? key}) : super(key: key);

  @override
  State<CaptureFaceScreen> createState() => _CaptureFaceScreenState();
}

class _CaptureFaceScreenState extends State<CaptureFaceScreen> {
  int faceDetectedCount = 0;

  // ? Create face detector object
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(onTap: promptUser),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcOut,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin:
                        EdgeInsets.only(top: (50 / Dimensions.designWidth).w),
                    height: (500 / Dimensions.designWidth).w,
                    width: (350 / Dimensions.designWidth).w,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.elliptical((200 / Dimensions.designWidth).w,
                            (300 / Dimensions.designWidth).w),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizeBox(height: 600),
              Text(
                "Move Closer",
                style: TextStyles.primary.copyWith(
                  color: AppColors.black25,
                  fontSize: (24 / Dimensions.designWidth).w,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizeBox(height: 7),
              SizedBox(
                width: (300 / Dimensions.designWidth).w,
                child: Text(
                  "Keep your face positioned in the\ncenter of the screen",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.black63,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Are you sure?",
          message:
              "Going to the previous screen will make you repeat this step.",
          auxWidget: const SizeBox(),
          actionWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                text: "Go Back",
              ),
              const SizeBox(height: 22),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }
}
