import 'package:dialup_mobile_app/data/bloc/email/email_bloc.dart';
import 'package:dialup_mobile_app/data/bloc/emailExists/email_exists_bloc.dart';
import 'package:dialup_mobile_app/data/bloc/matchPassword/match_password_bloc.dart';
import 'package:dialup_mobile_app/data/bloc/otp/pinput/error_bloc.dart';
import 'package:dialup_mobile_app/data/bloc/otp/timer/timer_bloc.dart';
import 'package:dialup_mobile_app/data/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/presentation/routers/app_router.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomMultiBlocProvider extends StatelessWidget {
  const CustomMultiBlocProvider({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
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
      ],
      child: MaterialApp(
        title: 'Dhabi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Routes.splash,
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }
}
