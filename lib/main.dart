import 'package:dialup_mobile_app/data/bloc/email/email_bloc.dart';
import 'package:dialup_mobile_app/data/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/presentation/routers/app_router.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(
      appRouter: AppRouter(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      },
    );
  }
}
