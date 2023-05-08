import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_reader_api/document_reader.dart';

class VerificationInitializingScreen extends StatefulWidget {
  const VerificationInitializingScreen({Key? key}) : super(key: key);

  @override
  State<VerificationInitializingScreen> createState() =>
      _VerificationInitializingScreenState();
}

class _VerificationInitializingScreenState
    extends State<VerificationInitializingScreen> {
  String status = "Downloading Database";

  double progressValue = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // const EventChannel('flutter_document_reader_api/event/completion')
    //     .receiveBroadcastStream()
    //     .listen(
    //       (jsonString) => handleCompletion(
    //         DocumentReaderCompletion.fromJson(
    //           json.decode(jsonString),
    //         )!,
    //       ),
    //     );
    const EventChannel('flutter_document_reader_api/event/database_progress')
        .receiveBroadcastStream()
        .listen(
      (progress) {
        // setState(
        //   () {
        //     progressValue = progress;
        //   },
        // );
      },
    );
  }

  Future<void> initPlatformState() async {
    var prepareDatabase = await DocumentReader.prepareDatabase("Full");
    log("prepareDatabase -> $prepareDatabase");
    setState(() {
      status = "Initializing";
    });
    ByteData byteData = await rootBundle.load("assets/regula.license");
    var documentReaderInitialization = await DocumentReader.initializeReader({
      "license": base64.encode(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)),
      "delayedNNLoad": true
    });
    log("documentReaderInitialization -> $documentReaderInitialization");
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
        "showBackgroundMask": true,
        "backgroundMaskAlpha": 0.6,
      },
      "processParams": {
        "dateFormat": "dd/MM/yyyy",
        "scenario": "MrzOrOcr",
        "timeout": 60.0,
        "timeoutFromFirstDetect": 45.0,
        "timeoutFromFirstDocType": 35.0,
        "multipageProcessing": false
      }
    });

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.eidExplanation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Initialization Status: ",
                  style: TextStyles.primaryBold.copyWith(color: Colors.black),
                ),
                Text(
                  status,
                  style: TextStyles.primaryMedium.copyWith(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
