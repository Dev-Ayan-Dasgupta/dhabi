// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dialup_mobile_app/bloc/applicationCRS/application_crs_bloc.dart';
import 'package:dialup_mobile_app/bloc/applicationTax/application_tax_bloc.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/createPassword/create_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_bloc.dart';
import 'package:dialup_mobile_app/bloc/currencyPicker/currency_picker_bloc.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_bloc.dart';
import 'package:dialup_mobile_app/bloc/dateSelection/date_selection_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/email/email_bloc.dart';
import 'package:dialup_mobile_app/bloc/emailExists/email_exists_bloc.dart';
import 'package:dialup_mobile_app/bloc/errorMessage/error_message_bloc.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/multiSelect/multi_select_bloc.dart';
import 'package:dialup_mobile_app/bloc/otp/pinput/error_bloc.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_bloc.dart';
import 'package:dialup_mobile_app/bloc/request/request_bloc.dart';
import 'package:dialup_mobile_app/bloc/scrollDirection/scroll_direction_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/tabBar/tabbar_bloc.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/environment/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/routers/app_router.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';

import 'presentation/routers/routes.dart';
import 'utils/constants/index.dart';

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

late Timer _timer;
bool forceLogout = false;
final navigatorKey = GlobalKey<NavigatorState>();

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AppRoot(
      appRouter: appRouter,
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  final AppRouter appRouter;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    initEnvironment();
    _initializeTimer();
  }

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _logOutUser());
  }

  void _logOutUser() {
    // Log out the user if they're logged in, then cancel the timer.
    // You'll have to make sure to cancel the timer if the user manually logs out
    //   and to call _initializeTimer once the user logs in
    _timer.cancel();
    forceLogout = true;
  }

  // You'll probably want to wrap this function in a debounce
  void _handleUserInteraction([_]) {
    log("_handleUserInteraction");
    _timer.cancel();
    _initializeTimer();
  }

  void navToHomePage(BuildContext context) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routes.onboarding,
      (Route<dynamic> route) => false,
      arguments: OnboardingArgumentModel(isInitial: true).toMap(),
    );
  }

  Future<void> initEnvironment() async {
    try {
      // ? environment string
      String environment = const String.fromEnvironment(
        'ENVIRONMENT',
        defaultValue: Environment.dev,
      );

      // ? load environment file
      await dotenv.load(fileName: Environment.getName(environment));

      // ? initialize the config
      await Environment().initConfig(environment);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (forceLogout) {
      log("forceLogout -> $forceLogout");
      navToHomePage(context);
    }
    return FlutterSizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<EmailValidationBloc>(
              create: (context) => EmailValidationBloc(),
            ),
            BlocProvider<ShowPasswordBloc>(
              create: (context) => ShowPasswordBloc(),
            ),
            BlocProvider<PinputErrorBloc>(
              create: (context) => PinputErrorBloc(),
            ),
            BlocProvider<OTPTimerBloc>(
              create: (context) => OTPTimerBloc(),
            ),
            BlocProvider<EmailExistsBloc>(
              create: (context) => EmailExistsBloc(),
            ),
            BlocProvider<MatchPasswordBloc>(
              create: (context) => MatchPasswordBloc(),
            ),
            BlocProvider<ButtonFocussedBloc>(
              create: (context) => ButtonFocussedBloc(),
            ),
            BlocProvider<CheckBoxBloc>(
              create: (context) => CheckBoxBloc(),
            ),
            BlocProvider<CriteriaBloc>(
              create: (context) => CriteriaBloc(),
            ),
            BlocProvider<CreatePasswordBloc>(
              create: (context) => CreatePasswordBloc(),
            ),
            BlocProvider<SummaryTileBloc>(
              create: (context) => SummaryTileBloc(),
            ),
            BlocProvider<TabbarBloc>(
              create: (context) => TabbarBloc(),
            ),
            BlocProvider<RequestBloc>(
              create: (context) => RequestBloc(),
            ),
            BlocProvider<DropdownSelectedBloc>(
              create: (context) => DropdownSelectedBloc(),
            ),
            BlocProvider<ApplicationTaxBloc>(
              create: (context) => ApplicationTaxBloc(),
            ),
            BlocProvider<ApplicationCrsBloc>(
              create: (context) => ApplicationCrsBloc(),
            ),
            BlocProvider<ShowButtonBloc>(
              create: (context) => ShowButtonBloc(),
            ),
            BlocProvider<MultiSelectBloc>(
              create: (context) => MultiSelectBloc(),
            ),
            BlocProvider<ScrollDirectionBloc>(
              create: (context) => ScrollDirectionBloc(),
            ),
            BlocProvider<ErrorMessageBloc>(
              create: (context) => ErrorMessageBloc(),
            ),
            BlocProvider<DateSelectionBloc>(
              create: (context) => DateSelectionBloc(),
            ),
            BlocProvider<CurrencyPickerBloc>(
              create: (context) => CurrencyPickerBloc(),
            ),
          ],
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              _handleUserInteraction();
            },
            onScaleStart: _handleUserInteraction,
            onScaleEnd: _handleUserInteraction,
            onScaleUpdate: _handleUserInteraction,
            behavior: HitTestBehavior.opaque,
            child: MaterialApp(
              title: 'Dhabi',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: AppColors.primarySwatch,
                appBarTheme: const AppBarTheme(
                  color: Colors.transparent,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
                  ),
                ),
                scaffoldBackgroundColor: Colors.white,
              ),
              initialRoute: Routes.splash,
              onGenerateRoute: widget.appRouter.onGenerateRoute,
            ),
          ),
        );
        // CustomMultiBlocProvider(appRouter: widget.appRouter);
      },
    );
  }
}
