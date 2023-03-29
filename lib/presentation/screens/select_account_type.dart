// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/data/models/arguments/create_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_bloc.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_event.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SelectAccountTypeScreen extends StatefulWidget {
  const SelectAccountTypeScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SelectAccountTypeScreen> createState() =>
      _SelectAccountTypeScreenState();
}

class _SelectAccountTypeScreenState extends State<SelectAccountTypeScreen> {
  bool isPersonalFocussed = false;
  bool isBusinessFocussed = false;
  int toggles = 0;

  late CreateAccountArgumentModel createAccountArgumentModel;

  @override
  void initState() {
    super.initState();
    createAccountArgumentModel =
        CreateAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(
            // onTap: () {
            //   Navigator.pop(context);
            // },
            ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: (22 / Dimensions.designWidth).w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizeBox(height: 10),
                  Text(
                    "Select your account type",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 22),
                  Text(
                    "Please select the type of account you wish to open",
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color.fromRGBO(0, 0, 0, 0.4),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                    builder: (context, state) {
                      return SolidButton(
                        onTap: () {
                          isPersonalFocussed = true;
                          isBusinessFocussed = false;
                          toggles++;
                          buttonFocussedBloc.add(
                            ButtonFocussedEvent(
                              isFocussed: isPersonalFocussed,
                              toggles: toggles,
                            ),
                          );
                        },
                        color: Colors.white,
                        borderColor: isPersonalFocussed
                            ? const Color.fromRGBO(0, 184, 148, 0.21)
                            : Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.1),
                            offset: Offset(
                              (3 / Dimensions.designWidth).w,
                              (4 / Dimensions.designHeight).h,
                            ),
                            blurRadius: (3 / Dimensions.designWidth).w,
                            // spreadRadius: (2 / Dimensions.designWidth).w,
                          ),
                        ],
                        fontColor: AppColors.primary,
                        text: "Personal",
                      );
                    },
                  ),
                  const SizeBox(height: 30),
                  BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                    builder: (context, state) {
                      return SolidButton(
                        onTap: () {
                          isPersonalFocussed = false;
                          isBusinessFocussed = true;
                          toggles++;
                          buttonFocussedBloc.add(
                            ButtonFocussedEvent(
                              isFocussed: isBusinessFocussed,
                              toggles: toggles,
                            ),
                          );
                        },
                        color: Colors.white,
                        borderColor: isBusinessFocussed
                            ? const Color.fromRGBO(0, 184, 148, 0.21)
                            : Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.1),
                            offset: Offset(
                              (3 / Dimensions.designWidth).w,
                              (4 / Dimensions.designHeight).h,
                            ),
                            blurRadius: (3 / Dimensions.designWidth).w,
                            // spreadRadius: (2 / Dimensions.designWidth).w,
                          ),
                        ],
                        fontColor: AppColors.primary,
                        text: "Business",
                      );
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  GradientButton(
                    onTap: () {
                      if (isPersonalFocussed) {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.createPassword,
                          arguments: CreateAccountArgumentModel(
                            email: createAccountArgumentModel.email,
                            isRetail: true,
                          ).toMap(),
                        );
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.createPassword,
                          arguments: CreateAccountArgumentModel(
                            email: createAccountArgumentModel.email,
                            isRetail: false,
                          ).toMap(),
                        );
                      }
                    },
                    text: "Proceed",
                  ),
                  const SizeBox(height: 16),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routes.login);
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
            ),
          ],
        ),
      ),
    );
  }
}
