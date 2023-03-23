import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
          padding:
              EdgeInsets.symmetric(horizontal: (22 / Dimensions.designWidth).w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizeBox(height: 10),
              Text(
                "Login",
                style: TextStyles.primaryBold.copyWith(
                  color: AppColors.primary,
                  fontSize: (28 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 30),
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
              const SizeBox(height: 9),
              CustomTextField(
                controller: _emailController,
                suffix: Padding(
                  padding:
                      EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
                  child: SvgPicture.asset(ImageConstants.checkCircle),
                ),
              ),
              const SizeBox(height: 15),
              Text(
                "Password",
                style: TextStyles.primaryMedium.copyWith(
                  color: const Color(0xFF636363),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 9),
              CustomTextField(
                controller: _emailController,
                suffix: Padding(
                  padding:
                      EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
                  child: SvgPicture.asset(ImageConstants.checkCircle),
                ),
              ),
              const SizeBox(height: 30),
              GradientButton(
                onTap: () {},
                text: "Login",
              ),
              const SizeBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot your email ID or password?",
                  style: TextStyles.primaryMedium.copyWith(
                    color: const Color.fromRGBO(34, 97, 105, 0.5),
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
