// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/routers/app_router.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

import 'presentation/routers/routes.dart';

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

// Timer? _rootTimer;

bool forceLogout = false;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  final sessionStateStream = StreamController<SessionState>();
  // final _navigatorKey = GlobalKey<NavigatorState>();
  // NavigatorState get _navigator => _navigatorKey.currentState!;

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final sessionConfig = SessionConfig(
      // invalidateSessionForAppLostFocus: const Duration(seconds: 15),
      invalidateSessionForUserInactivity: const Duration(seconds: 10),
    );

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        // handle user  inactive timeout

        log("Timeout occured");
        navigatorKey.currentState?.pushNamed(
          Routes.onboarding,
          // (Route<dynamic> route) => false,
          arguments: OnboardingArgumentModel(isInitial: true).toMap(),
        );

        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return CustomDialog(
        //       svgAssetPath: ImageConstants.warning,
        //       title: "Session Timeout",
        //       message: "Your session has timed out.\nPlease login again.",
        //       actionWidget: GradientButton(
        //         onTap: () {
        //           navigatorKey.currentState?.pushNamedAndRemoveUntil(
        //             Routes.onboarding,
        //             (Route<dynamic> route) => false,
        //             arguments: OnboardingArgumentModel(isInitial: true).toMap(),
        //           );
        //         },
        //         text: "Login",
        //       ),
        //     );
        //   },
        // );
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        // handle user  app lost focus timeout
        // Navigator.of(context).pushNamed("/auth");
        log("Timeout occured");
        navigatorKey.currentState?.pushNamed(
          Routes.onboarding,
          // (Route<dynamic> route) => false,
          arguments: OnboardingArgumentModel(isInitial: true).toMap(),
        );
      }
    });
    return SessionTimeoutManager(
      userActivityDebounceDuration: const Duration(seconds: 1),
      sessionConfig: sessionConfig,
      sessionStateStream: sessionStateStream.stream,
      child: FlutterSizer(
        builder: (context, orientation, screenType) {
          return CustomMultiBlocProvider(appRouter: appRouter);
        },
      ),
    );
  }
}
