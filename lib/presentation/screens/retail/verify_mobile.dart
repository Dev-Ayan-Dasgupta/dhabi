import 'package:dialup_mobile_app/bloc/email/email_bloc.dart';
import 'package:dialup_mobile_app/bloc/email/email_events.dart';
import 'package:dialup_mobile_app/bloc/email/email_states.dart';
import 'package:dialup_mobile_app/data/models/arguments/otp.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/circle_avatar.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerifyMobileScreen extends StatefulWidget {
  const VerifyMobileScreen({Key? key}) : super(key: key);

  @override
  State<VerifyMobileScreen> createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;
  @override
  Widget build(BuildContext context) {
    final EmailValidationBloc emailValidationBloc =
        context.read<EmailValidationBloc>();
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
                      "Verify Mobile Number",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 22),
                    Text(
                      "Mobile Number",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0xFF636363),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _phoneController,
                      prefix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomCircleAvatar(
                            width: (25 / Dimensions.designWidth).w,
                            height: (25 / Dimensions.designWidth).w,
                            imgUrl:
                                "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
                          ),
                          const SizeBox(width: 7),
                          Text(
                            "+971",
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0xFF636363),
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(width: 7),
                        ],
                      ),
                      suffix: BlocBuilder<EmailValidationBloc,
                          EmailValidationState>(
                        builder: (context, state) {
                          if (!_isPhoneValid) {
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
                        _isPhoneValid = InputValidator.isPhoneValid("+971$p0");
                        _isPhoneValid
                            ? emailValidationBloc
                                .add(EmailValidatedEvent(isValid: true))
                            : emailValidationBloc
                                .add(EmailInvalidatedEvent(isValid: false));
                      },
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<EmailValidationBloc, EmailValidationState>(
                      builder: (context, state) {
                        if (_isPhoneValid) {
                          return const SizeBox();
                        } else {
                          return Row(
                            children: [
                              SvgPicture.asset(ImageConstants.errorSolid),
                              const SizeBox(width: 5),
                              Text(
                                "Invalid mobile number",
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
                    if (!_isPhoneValid) {
                      return const SizeBox();
                    } else {
                      return GradientButton(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.otp,
                            arguments: OTPArgumentModel(
                              code: "123456",
                              emailOrPhone: _phoneController.text,
                              isEmail: false,
                            ).toMap(),
                          );
                        },
                        text: "Proceed",
                      );
                    }
                  }),
                  const SizeBox(height: 32),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
