import 'package:dialup_mobile_app/bloc/createPassword/create_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/createPassword/create_password_event.dart';
import 'package:dialup_mobile_app/bloc/createPassword/create_password_state.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_bloc.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_event.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_state.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_event.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/createPassword/criteria.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  int toggle = 0;

  bool showNewPassword = false;
  bool showConfirmNewPassword = false;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  // ? boolean flags for password criteria
  bool hasMin8 = false;
  bool hasUpperLower = false;
  bool hasNumeric = false;
  bool hasSpecial = false;

  bool isMatch = false;

  // bool isCorrect = false;

  bool allTrue = false;

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
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Set Password",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 15),
                  Text(
                    "Please set a password for your chosen User ID",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "New Password",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.black63,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                            builder: buildNewPassword,
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: buildCriteriaError,
                          ),
                          const SizeBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "Confirm New Password",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.black63,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                            builder: buildConfirmNewPassword,
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              if (_confirmNewPasswordController.text.length <
                                  8) {
                                return const SizeBox();
                              } else {
                                return BlocBuilder<MatchPasswordBloc,
                                    MatchPasswordState>(
                                  builder: buildMatchMessage,
                                );
                              }
                            },
                          ),
                          const SizeBox(height: 25),
                          BlocBuilder<CriteriaBloc, CriteriaState>(
                            builder: buildCriteriaSection,
                          ),
                          const SizeBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<CreatePasswordBloc, CreatePasswordState>(
                  builder: buildSubmitButton,
                ),
                const SizeBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNewPassword(BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
    if (showNewPassword) {
      return CustomTextField(
        controller: _newPasswordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  HidePasswordEvent(showPassword: false, toggle: ++toggle));
              showNewPassword = !showNewPassword;
            },
            child: Icon(
              Icons.visibility_off_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerCriteriaEvent(p0);
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showNewPassword,
      );
    } else {
      return CustomTextField(
        controller: _newPasswordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
              showNewPassword = !showNewPassword;
            },
            child: Icon(
              Icons.visibility_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerCriteriaEvent(p0);
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showNewPassword,
      );
    }
  }

  Widget buildCriteriaError(BuildContext context, ShowButtonState state) {
    if (!(hasMin8 && hasUpperLower && hasNumeric && hasSpecial) &&
        _newPasswordController.text.isNotEmpty) {
      return Row(
        children: [
          SvgPicture.asset(
            ImageConstants.errorSolid,
            width: (13 / Dimensions.designWidth).w,
            height: (13 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "Password does not meet the criteria",
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

  Widget buildConfirmNewPassword(
      BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc confirmPasswordBloc =
        context.read<ShowPasswordBloc>();
    if (showConfirmNewPassword) {
      return CustomTextField(
        // width: 83.w,
        controller: _confirmNewPasswordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              confirmPasswordBloc.add(
                  HidePasswordEvent(showPassword: false, toggle: ++toggle));
              showConfirmNewPassword = !showConfirmNewPassword;
            },
            child: Icon(
              Icons.visibility_off_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showConfirmNewPassword,
      );
    } else {
      return CustomTextField(
        // width: 83.w,
        controller: _confirmNewPasswordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              confirmPasswordBloc.add(
                  DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
              showConfirmNewPassword = !showConfirmNewPassword;
            },
            child: Icon(
              Icons.visibility_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showConfirmNewPassword,
      );
    }
  }

  Widget buildMatchMessage(BuildContext context, MatchPasswordState state) {
    return BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
        builder: (context, state) {
      return Row(
        children: [
          Ternary(
            condition: isMatch,
            truthy: Icon(
              Icons.check_circle_rounded,
              color: AppColors.green100,
              size: (13 / Dimensions.designWidth).w,
            ),
            falsy: Icon(
              Icons.error,
              color: AppColors.orange100,
              size: (13 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(width: 5),
          Text(
            isMatch ? "Password is matching" : "Password is not matching",
            style: TextStyles.primaryMedium.copyWith(
              color: isMatch ? AppColors.green100 : AppColors.orange100,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    });
  }

  Widget buildCriteriaSection(BuildContext context, CriteriaState state) {
    return PasswordCriteria(
      criteria1Color: hasMin8 ? AppColors.primaryDark : AppColors.red100,
      criteria2Color: hasNumeric ? AppColors.primaryDark : AppColors.red100,
      criteria3Color: hasUpperLower ? AppColors.primaryDark : AppColors.red100,
      criteria4Color: hasSpecial ? AppColors.primaryDark : AppColors.red100,
      criteria1Widget: hasMin8
          ? SvgPicture.asset(ImageConstants.checkSmall)
          : const SizeBox(),
      criteria2Widget: hasNumeric
          ? SvgPicture.asset(ImageConstants.checkSmall)
          : const SizeBox(),
      criteria3Widget: hasUpperLower
          ? SvgPicture.asset(ImageConstants.checkSmall)
          : const SizeBox(),
      criteria4Widget: hasSpecial
          ? SvgPicture.asset(ImageConstants.checkSmall)
          : const SizeBox(),
    );
  }

  Widget buildSubmitButton(BuildContext context, CreatePasswordState state) {
    if (allTrue) {
      return Column(
        children: [
          const SizeBox(height: 15),
          GradientButton(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.errorSuccessScreen,
                arguments: ErrorArgumentModel(
                  hasSecondaryButton: false,
                  iconPath: ImageConstants.checkCircleOutlined,
                  title: "Password Changed!",
                  message:
                      "Your password updated successfully.\nPlease log in again with your new password.",
                  buttonText: labels[205]["labelText"],
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Routes.loginUserId);
                  },
                  buttonTextSecondary: "",
                  onTapSecondary: () {},
                ).toMap(),
              );
            },
            text: "Save",
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizeBox(height: 15),
          SolidButton(onTap: () {}, text: "Save"),
        ],
      );
    }
  }

  void triggerCriteriaEvent(String p0) {
    final CriteriaBloc criteriaBloc = context.read<CriteriaBloc>();
    final ShowButtonBloc showCriteriaMessageBloc =
        context.read<ShowButtonBloc>();

    if (p0.length >= 8) {
      criteriaBloc.add(CriteriaMin8Event(hasMin8: true));
      hasMin8 = true;
    } else {
      criteriaBloc.add(CriteriaMin8Event(hasMin8: false));
      hasMin8 = false;
    }

    if (p0.contains(RegExp(r'[0-9]'))) {
      criteriaBloc.add(CriteriaNumericEvent(hasNumeric: true));
      hasNumeric = true;
    } else {
      criteriaBloc.add(CriteriaNumericEvent(hasNumeric: false));
      hasNumeric = false;
    }

    if (p0.contains(RegExp(r'[A-Z]')) && p0.contains(RegExp(r'[a-z]'))) {
      criteriaBloc.add(CriteriaUpperLowerEvent(hasUpperLower: true));
      hasUpperLower = true;
    } else {
      criteriaBloc.add(CriteriaUpperLowerEvent(hasUpperLower: false));
      hasUpperLower = false;
    }

    if (p0.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      criteriaBloc.add(CriteriaSpecialEvent(hasSpecial: true));
      hasSpecial = true;
    } else {
      criteriaBloc.add(CriteriaSpecialEvent(hasSpecial: false));
      hasSpecial = false;
    }

    showCriteriaMessageBloc.add(
      ShowButtonEvent(
        show: hasMin8 && hasNumeric && hasUpperLower && hasSpecial,
      ),
    );
  }

  void triggerPasswordMatchEvent() {
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();

    final ShowButtonBloc matchPasswordMessageBloc =
        context.read<ShowButtonBloc>();

    if (_newPasswordController.text == _confirmNewPasswordController.text) {
      isMatch = true;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    } else {
      isMatch = false;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    }

    matchPasswordMessageBloc.add(ShowButtonEvent(show: isMatch));
  }

  void triggerAllTrueEvent() {
    allTrue = hasMin8 && hasNumeric && hasUpperLower && hasSpecial && isMatch;
    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
  }
}