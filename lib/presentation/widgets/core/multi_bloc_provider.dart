import 'dart:async';
import 'dart:developer';

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
import 'package:dialup_mobile_app/environment/setup.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/app_router.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomMultiBlocProvider extends StatefulWidget {
  const CustomMultiBlocProvider({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  @override
  State<CustomMultiBlocProvider> createState() =>
      _CustomMultiBlocProviderState();
}

Timer? _timer;

class _CustomMultiBlocProviderState extends State<CustomMultiBlocProvider> {
  @override
  void initState() {
    super.initState();
    initEnvironment();
    _initializeTimer();
  }

  Future<void> initEnvironment() async {
    try {
      // ? environment string
      String environment = const String.fromEnvironment(
        'ENVIRONMENT',
        defaultValue: Environment.prod,
      );

      // ? load environment file
      await dotenv.load(fileName: Environment.getName(environment));

      // ? initialize the config
      await Environment().initConfig(environment);
    } catch (_) {}
  }

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3000), (timer) {
      log("_timer -> ${_timer?.tick}");
      _logOutUser();
    });
  }

  void _logOutUser() {
    log("logout called");
    _timer?.cancel();
    setState(() {
      forceLogout = true;
    });

    // navToHomePage(context);
  }

  // You'll probably want to wrap this function in a debounce
  void _handleUserInteraction([_]) {
    log("_handleUserInteraction");
    if (_timer != null && !_timer!.isActive) {
      // This means the user has logged out
      return;
    }
    _timer?.cancel();
    _initializeTimer();
  }

  void navToHomePage() {
    log("Navigation to home page called");

    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Session Timeout",
          message: "Your session has timed out.\nPlease login again.",
          actionWidget: GradientButton(
            onTap: () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                Routes.onboarding,
                (Route<dynamic> route) => false,
                arguments: OnboardingArgumentModel(isInitial: true).toMap(),
              );
              _initializeTimer();
            },
            text: labels[205]["labelText"],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (forceLogout) {
      log("forceLogout -> $forceLogout");
      navToHomePage();
    }
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
      child: Listener(
        onPointerDown: _handleUserInteraction,
        onPointerMove: _handleUserInteraction,
        onPointerUp: _handleUserInteraction,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _handleUserInteraction();
          },
          behavior: HitTestBehavior.opaque,
          child: MaterialApp(
            title: 'Dhabi',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: ThemeData(
              primarySwatch: AppColors.primarySwatch,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
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
      ),
    );
  }
}
