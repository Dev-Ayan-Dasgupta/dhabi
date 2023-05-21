import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dialup_mobile_app/presentation/routers/app_router.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

List<CameraDescription> cameras = [];

const storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return FlutterSizer(
      builder: (context, orientation, screenType) {
        return CustomMultiBlocProvider(appRouter: appRouter);
      },
    );
  }
}
