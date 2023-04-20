import 'package:camera/camera.dart';
import 'package:dialup_mobile_app/data/models/arguments/onboarding_status.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CaptureFaceScreen extends StatefulWidget {
  const CaptureFaceScreen({Key? key}) : super(key: key);

  @override
  State<CaptureFaceScreen> createState() => _CaptureFaceScreenState();
}

class _CaptureFaceScreenState extends State<CaptureFaceScreen> {
  int faceDetectedCount = 0;

  CameraController? _controller;

  // ? Declaration of InputImage goes here

  // declare instance of camera

  // final camera = const CameraDescription(
  //   name: "Selfie Camera",
  //   lensDirection: CameraLensDirection.front,
  //   sensorOrientation: 0,
  // );

  int _cameraIndex = 0;

  void initCameraLens() {
    if (cameras.any(
      (element) =>
          element.lensDirection == CameraLensDirection.front &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == CameraLensDirection.front &&
            element.sensorOrientation == 90),
      );
    } else {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.front,
        ),
      );
    }
  }

  Future<void> startLive() async {
    final camera = cameras[_cameraIndex];
    // setup camera controller
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // start streaming using camera
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      // process camera image to get an instance of input image
      _controller?.startImageStream(_processCameraImage);

      setState(() {});
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();

    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final camera = cameras[_cameraIndex];

    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    final planeData = image.planes.map((Plane plane) {
      return InputImagePlaneMetadata(
        bytesPerRow: plane.bytesPerRow,
        height: plane.height,
        width: plane.width,
      );
    }).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    // ? Create face detector object
    final FaceDetector faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableLandmarks: true,
        enableTracking: true,
        minFaceSize: 0.1,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    // process the input image
    final List<Face> faces = await faceDetector.processImage(inputImage);
    print("No. of faces detected -> ${faces.length}");

    for (Face face in faces) {
      // face.landmarks[FaceLandmarkType.bottomMouth].position
    }

    print("Head turned up or down -> ${faces[0].headEulerAngleX} degrees");
    print("Head turned left or right -> ${faces[0].headEulerAngleY} degrees");
    print(
        "Head turned clockwise or counter-clockwise -> ${faces[0].headEulerAngleZ} degrees");
    print("Smiling probability -> ${faces[0].smilingProbability}");
    print("Left eye open probability -> ${faces[0].leftEyeOpenProbability}");
    print("Right eye open probability -> ${faces[0].rightEyeOpenProbability}");

    if (faces[0].landmarks[FaceLandmarkType.bottomMouth] != null) {
      final bottomMouthPos =
          faces[0].landmarks[FaceLandmarkType.bottomMouth]?.position;
      print("bottomMouthPos -> $bottomMouthPos");
    }
    if (faces[0].landmarks[FaceLandmarkType.leftMouth] != null) {
      final leftMouthPos =
          faces[0].landmarks[FaceLandmarkType.leftMouth]?.position;
      print("leftMouthPos -> $leftMouthPos");
    }
    if (faces[0].landmarks[FaceLandmarkType.rightCheek] != null) {
      final rightCheekPos =
          faces[0].landmarks[FaceLandmarkType.rightCheek]?.position;
      print("rightCheekPos -> $rightCheekPos");
    }

    if (faces[0].smilingProbability == 0.80) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
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
      }
    }
  }

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
    _controller?.dispose();
    super.dispose();
  }
}
