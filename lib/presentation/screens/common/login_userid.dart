import 'package:dialup_mobile_app/bloc/emailExists/email_exists_bloc.dart';
import 'package:dialup_mobile_app/bloc/emailExists/email_exists_event.dart';
import 'package:dialup_mobile_app/bloc/emailExists/email_exists_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginUserIdScreen extends StatefulWidget {
  const LoginUserIdScreen({Key? key}) : super(key: key);

  @override
  State<LoginUserIdScreen> createState() => _LoginUserIdScreenState();
}

class _LoginUserIdScreenState extends State<LoginUserIdScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool isEmailValid = false;
  bool emailExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(onTap: promptUser),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
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
            RichText(
              text: TextSpan(
                text: 'User ID ',
                style: TextStyles.primary.copyWith(
                  color: const Color(0xFF636363),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '(Email address)',
                    style: TextStyles.primary.copyWith(
                      color: const Color.fromRGBO(99, 99, 99, 0.5),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                ],
              ),
            ),
            const SizeBox(height: 10),
            CustomTextField(
              controller: _emailController,
              suffix: Padding(
                padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
                child: InkWell(
                  onTap: () {
                    _emailController.clear();
                  },
                  child: SvgPicture.asset(
                    ImageConstants.deleteText,
                    width: (17.5 / Dimensions.designWidth).w,
                    height: (17.5 / Dimensions.designWidth).w,
                  ),
                ),
              ),
              onChanged: emailValidation,
            ),

            BlocBuilder<EmailExistsBloc, EmailExistsState>(
              builder: buildErrorMessage,
            ),
            const SizeBox(height: 15),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: buildProceedButton,
            ),
            // const SizeBox(height: 10),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: InkWell(
            //     onTap: onForgotEmailPwd,
            //     child: Text(
            //       "Forgot your email ID or password?",
            //       style: TextStyles.primaryMedium.copyWith(
            //         color: const Color.fromRGBO(34, 97, 105, 0.5),
            //         fontSize: (16 / Dimensions.designWidth).w,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Are you sure?",
          message:
              "Going to the previous screen will make you repeat this step.",
          actionWidget: Column(
            children: [
              GradientButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                text: "Go Back",
              ),
              const SizeBox(height: 22),
            ],
          ),
        );
      },
    );
  }

  void emailValidation(String p0) {
    final EmailExistsBloc emailExistsBloc = context.read<EmailExistsBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (InputValidator.isEmailValid(p0)) {
      if (p0 != "ADasgupta@aspire-infotech.net") {
        emailExists = false;
        isEmailValid = true;
        emailExistsBloc.add(EmailExistsEvent(emailExists: emailExists));
        showButtonBloc.add(ShowButtonEvent(show: emailExists && isEmailValid));
      } else {
        emailExists = true;
        isEmailValid = true;
        emailExistsBloc.add(EmailExistsEvent(emailExists: emailExists));
        showButtonBloc.add(ShowButtonEvent(show: emailExists && isEmailValid));
      }
    } else {
      emailExists = false;
      isEmailValid = false;
      emailExistsBloc.add(EmailExistsEvent(emailExists: emailExists));
      showButtonBloc.add(ShowButtonEvent(show: emailExists && isEmailValid));
    }
  }

  Widget buildErrorMessage(BuildContext context, EmailExistsState state) {
    if (state.emailExists == false) {
      return Column(
        children: [
          const SizeBox(height: 7),
          Text(
            "Email ID does not exist",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.red100,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildProceedButton(BuildContext context, ShowButtonState state) {
    if (emailExists && isEmailValid) {
      return GradientButton(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.loginPassword,
            arguments: LoginPasswordArgumentModel(
              userId: _emailController.text,
            ).toMap(),
          );
        },
        text: labels[31]["labelText"],
      );
    } else {
      return const SizeBox();
    }
  }

  // void onForgotEmailPwd() {
  //   // TODO: call API
  // }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
