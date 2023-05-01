import 'package:dialup_mobile_app/bloc/matchPassword/match_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_event.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_state.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/login/attempts.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class LoginPasswordScreen extends StatefulWidget {
  const LoginPasswordScreen({Key? key}) : super(key: key);

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = false;

  bool isMatch = true;

  int matchPasswordErrorCount = 0;
  int toggle = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Log in",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Enter Password",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.black63,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
              builder: buildShowHidePassword,
            ),
            const SizeBox(height: 7),
            BlocBuilder<MatchPasswordBloc, MatchPasswordState>(
              builder: buildErrorMessage,
            ),
            const SizeBox(height: 15),
            BlocBuilder<MatchPasswordBloc, MatchPasswordState>(
              builder: buildLoginButton,
            ),
            const SizeBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onForgotEmailPwd,
                child: Text(
                  "Forgot password?",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.primaryBright50,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShowHidePassword(BuildContext context, ShowPasswordState state) {
    if (showPassword) {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: hidePassword,
            child: Icon(
              Icons.visibility_off_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: onChanged,
        obscureText: !showPassword,
      );
    } else {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: showsPassword,
            child: Icon(
              Icons.visibility_outlined,
              color: AppColors.primaryBright50,
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: onChanged,
        obscureText: !showPassword,
      );
    }
  }

  void hidePassword() {
    final ShowPasswordBloc showPasswordBloc = context.read<ShowPasswordBloc>();
    showPasswordBloc
        .add(HidePasswordEvent(showPassword: false, toggle: ++toggle));
    showPassword = !showPassword;
  }

  void showsPassword() {
    final ShowPasswordBloc showPasswordBloc = context.read<ShowPasswordBloc>();
    showPasswordBloc
        .add(DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
    showPassword = !showPassword;
  }

  void onChanged(String p0) {
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    if (p0 == "AyanDg16@#") {
      isMatch = true;
      matchPasswordBloc.add(
          MatchPasswordEvent(isMatch: isMatch, count: matchPasswordErrorCount));
    } else {
      isMatch = true;
      matchPasswordBloc.add(
          MatchPasswordEvent(isMatch: isMatch, count: matchPasswordErrorCount));
    }
  }

  void onSubmit() {
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    // TODO: Use API to conduct validation, for now testing with mock static data
    if (_passwordController.text != "AyanDg16@#") {
      matchPasswordErrorCount++;
      isMatch = false;
      matchPasswordBloc.add(
          MatchPasswordEvent(isMatch: isMatch, count: matchPasswordErrorCount));
    } else {
      // TODO: Call Navigation to next page, testing for now, API later
      Navigator.pushNamed(
        context,
        Routes.retailDashboard,
        arguments: RetailDashboardArgumentModel(
          imgUrl:
              "https://images.unsplash.com/photo-1619895862022-09114b41f16f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
          name: "ADasgupta@aspire-infotech.net",
        ).toMap(),
      );
    }
  }

  Widget buildErrorMessage(BuildContext context, MatchPasswordState state) {
    if (isMatch == false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Incorrect Password",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.red,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 22),
          Ternary(
            condition:
                matchPasswordErrorCount < 3 && matchPasswordErrorCount > 0,
            truthy: Center(
              child: LoginAttempt(
                message:
                    "Incorrect password - ${3 - matchPasswordErrorCount} attempts left",
              ),
            ),
            falsy: Ternary(
              condition: matchPasswordErrorCount == 0,
              truthy: const SizeBox(),
              falsy: const LoginAttempt(
                message:
                    "Your account credentials are temporarily blocked. Use ''Forgot Password'' to reset your credentials",
              ),
            ),
          )
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildLoginButton(BuildContext context, MatchPasswordState state) {
    if (matchPasswordErrorCount < 3) {
      return GradientButton(
        onTap: onSubmit,
        text: labels[205]["labelText"],
      );
    } else {
      return const SizeBox();
    }
  }

  void onForgotEmailPwd() {
    // TODO: call API
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
