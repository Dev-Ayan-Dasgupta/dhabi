import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/email_validation.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
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
                      suffix: !_isEmailValid
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                  left: (10 / Dimensions.designWidth).w),
                              child:
                                  SvgPicture.asset(ImageConstants.checkCircle),
                            ),
                      onChanged: (p0) {
                        setState(() {
                          _isEmailValid = EmailValidator.isValid(p0);
                        });
                      },
                    ),
                    const SizeBox(height: 9),
                    _isEmailValid
                        ? const SizeBox()
                        : Row(
                            children: [
                              SvgPicture.asset(ImageConstants.errorSolid),
                              const SizeBox(width: 5),
                              Text(
                                "Invalid email",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: const Color(0xFFC94540),
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              Column(
                children: [
                  !_isEmailValid
                      ? const SizeBox()
                      : GradientButton(
                          onTap: () {
                            setState(() {});
                          },
                          text: "Proceed",
                        ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
