import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dialup_mobile_app/data/models/arguments/onboarding_soft.dart';
import 'package:dialup_mobile_app/data/repositories/get_app_labels.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/utils/constants/images.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  // String? _deviceId;

  @override
  void initState() {
    super.initState();
    MapAppLabels.mapAppLabels();
    initPlatformState();
    navigate(context);
  }

  // Future<void> initPlatformState() async {
  //   String? deviceId;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     deviceId = await PlatformDeviceId.getDeviceId;
  //   } on PlatformException {
  //     deviceId = 'Failed to get deviceId.';
  //   }

  //   if (!mounted) return;

  //   _deviceId = deviceId;
  //   debugPrint("deviceId -> $_deviceId");
  // }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = DeviceInfoHelper.readWebBrowserInfo(
            await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData = DeviceInfoHelper.readAndroidBuildData(
              await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = DeviceInfoHelper.readIosDeviceInfo(
              await deviceInfoPlugin.iosInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    _deviceData = deviceData;
    log("_deviceData -> $_deviceData");
  }

  void navigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.onboarding,
          arguments: OnboardingArgumentModel(isInitial: true).toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstants.splashBackGround),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(ImageConstants.splashIcon),
        ),
      ),
    );
  }
}
