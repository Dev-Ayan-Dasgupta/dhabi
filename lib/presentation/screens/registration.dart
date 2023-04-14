import 'package:dialup_mobile_app/bloc/email/email_bloc.dart';
import 'package:dialup_mobile_app/bloc/email/email_events.dart';
import 'package:dialup_mobile_app/bloc/email/email_states.dart';
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
    final EmailValidationBloc emailValidationBloc =
        context.read<EmailValidationBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(
          onTap: () {
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
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (22 / Dimensions.designWidth).w,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizeBox(height: 10),
                    Text(
                      "Let's get started!",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 22),
                    Text(
                      "This email address will be used as your User ID for your account creation",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color.fromRGBO(0, 0, 0, 0.4),
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
                      suffix: BlocBuilder<EmailValidationBloc,
                          EmailValidationState>(
                        builder: (context, state) {
                          if (!_isEmailValid) {
                            return const SizedBox();
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: (10 / Dimensions.designWidth).w),
                              child: SvgPicture.asset(
                                ImageConstants.checkCircle,
                                width: (20 / Dimensions.designWidth).w,
                                height: (20 / Dimensions.designWidth).w,
                              ),
                            );
                          }
                        },
                      ),
                      onChanged: (p0) {
                        _isEmailValid = InputValidator.isEnailValid(p0);
                        _isEmailValid
                            ? emailValidationBloc
                                .add(EmailValidatedEvent(isValid: true))
                            : emailValidationBloc
                                .add(EmailInvalidatedEvent(isValid: false));
                      },
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<EmailValidationBloc, EmailValidationState>(
                      builder: (context, state) {
                        if (_isEmailValid) {
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
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  BlocBuilder<EmailValidationBloc, EmailValidationState>(
                      builder: (context, state) {
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
                        text: "Proceed",
                      );
                    }
                  }),
                  const SizeBox(height: 16),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.login);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an Account? ',
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
                  const SizeBox(height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
