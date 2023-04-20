// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_ml_vision/google_ml_vision.dart';

// class FaceDetection extends StatefulWidget {
//   const FaceDetection({Key? key}) : super(key: key);

//   @override
//   State<FaceDetection> createState() => _FaceDetectionState();
// }

// class _FaceDetectionState extends State<FaceDetection> {
//   FaceDetector _faceDetector;
//   Stopwatch stopwatch;
//   Stopwatch blinkStopwatch;
//   DetectionEnum detectionMode = DetectionEnum.BLINK;

//   var options = const FaceDetectorOptions(
//         enableClassification: true, enableTracking: false, minFaceSize: 0.95);
//     _faceDetector = GoogleVision.instance.faceDetector(options);

//   onImageStreamed(
//       CameraImage image, CameraDescription cameraDescription) async {
//     faceUnavailableStopwatch.start();

//     if (_isDetecting) return;
//     _isDetecting = true;

//     if (!allowStreaming) {
//       await Future.delayed(const Duration(milliseconds: 3000), () {
//         allowStreaming = true;
//       });
//     }

//     if (faceUnavailableStopwatch.isRunning &&
//         faceUnavailableStopwatch.elapsedMilliseconds >= selfieTakeImageTimer) {
//       handleInsufficientBlinking();
//     }

//     if (stopwatch != null) {
//       var elapsed = stopwatch.elapsedMilliseconds;
//       if (elapsed > maxBlinkDetectionTimeInMilisecond) {
//         print('here...');
//         stopwatch = Stopwatch();
//         //we go from the beginning, else continue

//         setState(() {
//           _isDetectingBlinkActive = false;
//           isDataCaptured = false;
//           isOCRComplete = false;
//           _isDetectingBlinkActive = false;
//           _eyesClosedDetected = false;
//           _faceDetected = false;
//         });
//       }
//     }

//     try {
//       var result = await _idCardProvider.getFace(
//           image, cameraDescription, _faceDetector);
//       _faceDetected = result != null;

//       if (_faceDetected) {
//         var faceIsStraight =
//             result.headEulerAngleY > -15 && result.headEulerAngleY < 15;
//         faceIsStraight = faceIsStraight &&
//             result.headEulerAngleZ > -15 &&
//             result.headEulerAngleZ < 15;
//         faceIsStraight = faceIsStraight &&
//             result.leftEyeOpenProbability != null &&
//             result.rightEyeOpenProbability != null;

//         if (faceIsStraight) {
// //          _logger.i(
// //              'face straight ${result.headEulerAngleY} ${result.headEulerAngleZ}');

//           if (!_isDetectingBlinkActive) {
//             await Future.delayed(const Duration(milliseconds: 1000));
//           }
//           setState(() {
//             _isDetectingBlinkActive = true;
//             stopwatch = Stopwatch();
//             stopwatch.start();
//           });
//         }

//         if (faceIsStraight) {
//           //we can change diferent algorithms here
//           var isBlinkDetected =
//               detectEyesClosed(image, cameraDescription, result);
//           if (isBlinkDetected &&
//               result.leftEyeOpenProbability > 0.8 &&
//               result.rightEyeOpenProbability > 0.8) {
//             //if we detected both, now we ask for eyes opened again. If it's OK, then we save it and go on
//             var tmp = result.leftEyeOpenProbability > 0.8 &&
//                 result.rightEyeOpenProbability > 0.8;
//             _logger.i(
//                 "Blink detected, sending file ${result.leftEyeOpenProbability} {}");
//             if (tmp) {
//               var elapsed = stopwatch.elapsedMilliseconds;
//               if (elapsed > maxBlinkDetectionTimeInMilisecond) {
//                 stopwatch = Stopwatch();
//                 stopwatch.start();
//                 //we go from the beginning, else continue
//                 setState(() {
//                   _isDetectingBlinkActive = false;
//                   isDataCaptured = false;
//                   isOCRComplete = false;
//                   _isDetectingBlinkActive = false;
//                   _eyesClosedDetected = false;
//                   _faceDetected = false;
//                 });

//                 stopwatch.stop();
//                 stopwatch.reset();
//                 stopwatch.start();
//               } else {
//                 _logger.i("Sending file");
//                 setState(() {
//                   isOCRComplete = true;
//                 });
//                 final p = await getTemporaryDirectory();
//                 final name = DateTime.now();
//                 final path = "${p.path}/Onboarding_Selfie_$name.png";

// //                var fullImage = convertCameraImageStandard(image);
// //                var _snapShot = img.encodePng(fullImage);

//                 var _snapShot = await convertImagetoPng(
//                     image, cameraDescription, false,
//                     shouldOverrideRotation: Platform.isIOS);

//                 var file = await saveFile(path, _snapShot);

//                 _logger.i("Trying to match");
//                 if (widget.scanningWithCard) {
//                   takeSelfieWithCardAndMatch(file, context);
//                 } else {
//                   takeSelfieAndMatch(file, context);
//                 }
//               }
//             }
//           }
//         }
//       } else {
//         _eyesOpenedDetected = false;
//         _eyesClosedDetected = false;

//         if (blinkStopwatch != null && blinkStopwatch.isRunning) {
//           blinkStopwatch.stop();
//           print('here...');
//           stopwatch = Stopwatch();
//           //we go from the beginning, else continue
//           setState(() {
//             _isDetectingBlinkActive = false;
//             isDataCaptured = false;
//             isOCRComplete = false;
//             _isDetectingBlinkActive = false;
//             _eyesClosedDetected = false;
//             _faceDetected = false;
//           });
//         }
//       }
//     } catch (e) {
//       _logger.e(e);
//     } finally {
//       _isDetecting = false;
//     }
//   }

//   Future<Face> getFace(CameraImage image, CameraDescription cameraDescription,
//       FaceDetector faceDetector) async {
//     ImageRotation rotation = rotationIntToImageRotation(
//       cameraDescription.sensorOrientation,
//     );

//     try {
//       var resultFaceTmp =
//           await detect(image, faceDetector.processImage, rotation);
//       List<Face> resultFace = resultFaceTmp as List<Face>;

//       return resultFace?.length == 1 ? resultFace[0] : null;
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<dynamic> detect(
//     CameraImage image,
//     HandleDetection handleDetection,
//     ImageRotation rotation,
//   ) async {
//     return handleDetection(
//       GoogleVisionImage.fromBytes(
//         concatenatePlanes(image.planes),
//         buildMetaData(image, rotation),
//       ),
//     );
//   }

//   Uint8List concatenatePlanes(List<Plane> planes) {
//     final WriteBuffer allBytes = WriteBuffer();
//     planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
//     return allBytes.done().buffer.asUint8List();
//   }

//   GoogleVisionImageMetadata buildMetaData(
//     CameraImage image,
//     ImageRotation rotation,
//   ) {
//     return GoogleVisionImageMetadata(
//       rawFormat: image.format.raw,
//       size: Size(image.width.toDouble(), image.height.toDouble()),
//       rotation: rotation,
//       planeData: image.planes.map(
//         (Plane plane) {
//           return GoogleVisionImagePlaneMetadata(
//             bytesPerRow: plane.bytesPerRow,
//             height: plane.height,
//             width: plane.width,
//           );
//         },
//       ).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
