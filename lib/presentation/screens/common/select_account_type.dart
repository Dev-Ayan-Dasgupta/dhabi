// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
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
                          onButtonTap(true, false);
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
                          onButtonTap(false, true);
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
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      if (isPersonalFocussed || isBusinessFocussed) {
                        return GradientButton(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.createPassword,
                              arguments: CreateAccountArgumentModel(
                                email: createAccountArgumentModel.email,
                                isRetail: isPersonalFocussed ? true : false,
                              ).toMap(),
                            );
                          },
                          text: "Proceed",
                        );
                      } else {
                        return const SizeBox();
                      }
                    },
                  ),
                  const SizeBox(height: 10),
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
                  const SizeBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onButtonTap(bool isPersonal, bool isBusiness) {
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    isPersonalFocussed = isPersonal;
    isBusinessFocussed = isBusiness;
    toggles++;
    buttonFocussedBloc.add(
      ButtonFocussedEvent(
        isFocussed: isPersonal ? isPersonalFocussed : isBusinessFocussed,
        toggles: toggles,
      ),
    );
    showButtonBloc.add(
      ShowButtonEvent(
          show: isPersonal ? isPersonalFocussed : isBusinessFocussed),
    );
  }
}
