import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/otp.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        promptUser();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(onTap: promptUser),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (22 / Dimensions.designWidth).w,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels[211]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 22),
                    Text(
                      labels[212]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.grey40,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    Text(
                      "Email",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0xFF636363),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _emailController,
                      suffix: BlocBuilder<ShowButtonBloc, ShowButtonState>(
                        builder: buildCheckCircle,
                      ),
                      onChanged: emailValidation,
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: buildErrorMessage,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildSubmitButton,
                  ),
                  const SizeBox(height: 10),
                  InkWell(
                    onTap: () {
                      // TODO: Add biometricPrompt
                      Navigator.pushNamed(context, Routes.loginUserId);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: '${labels[213]["labelText"]} ',
                        style: TextStyles.primary.copyWith(
                          color: AppColors.primary,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Log in',
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizeBox(height: 20),
                ],
              ),
            ],
          ),
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
          auxWidget: const SizeBox(),
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

  Widget buildCheckCircle(BuildContext context, ShowButtonState state) {
    if (!_isEmailValid) {
      return const SizedBox();
    } else {
      return Padding(
        padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
        child: SvgPicture.asset(
          ImageConstants.checkCircle,
          width: (20 / Dimensions.designWidth).w,
          height: (20 / Dimensions.designWidth).w,
        ),
      );
    }
  }

  void emailValidation(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    _isEmailValid = InputValidator.isEmailValid(p0);
    showButtonBloc.add(ShowButtonEvent(show: _isEmailValid || p0.length <= 5));
  }

  Widget buildErrorMessage(BuildContext context, ShowButtonState state) {
    if (_isEmailValid || _emailController.text.length <= 5) {
      return const SizeBox();
    } else {
      return Row(
        children: [
          SvgPicture.asset(
            ImageConstants.errorSolid,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "Invalid email",
            style: TextStyles.primaryMedium.copyWith(
              color: const Color(0xFFC94540),
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    }
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (!_isEmailValid) {
      return const SizeBox();
    } else {
      return GradientButton(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.otp,
            arguments: OTPArgumentModel(
              code: "123456",
              emailOrPhone: _emailController.text,
              isEmail: true,
              isBusiness: false,
            ).toMap(),
          );
        },
        text: labels[31]["labelText"],
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
