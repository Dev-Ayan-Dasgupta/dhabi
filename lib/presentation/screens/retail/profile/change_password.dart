import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
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
import 'package:dialup_mobile_app/data/models/arguments/error.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/createPassword/criteria.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  // ? boolean flags for password obscurity
  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmNewPassword = false;

  int toggle = 0;

  bool isCorrect = false;
  bool isMatch = false;

  // ? boolean flags for password criteria
  bool hasMin8 = false;
  bool hasUpperLower = false;
  bool hasNumeric = false;
  bool hasSpecial = false;

  bool isChecked = false;

  bool allTrue = false;

  String currentPassword = "AyanDg16@#";

  @override
  Widget build(BuildContext context) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
    final ShowPasswordBloc confirmPasswordBloc =
        context.read<ShowPasswordBloc>();
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
                    Text(
                      "Change Password",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Current Password",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: const Color(0xFF636363),
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                Text(
                                  "Forgot Password?",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color:
                                        const Color.fromRGBO(34, 97, 105, 0.5),
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                )
                              ],
                            ),
                            const SizeBox(height: 9),
                            BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                              builder: (context, state) {
                                if (showCurrentPassword) {
                                  return CustomTextField(
                                    controller: _currentPasswordController,
                                    minLines: 1,
                                    maxLines: 1,
                                    suffix: Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              (10 / Dimensions.designWidth).w),
                                      child: InkWell(
                                        onTap: () {
                                          passwordBloc.add(HidePasswordEvent(
                                              showPassword: false,
                                              toggle: ++toggle));
                                          showCurrentPassword =
                                              !showCurrentPassword;
                                        },
                                        child: Icon(
                                          Icons.visibility_off_outlined,
                                          color: const Color.fromRGBO(
                                              34, 97, 105, 0.5),
                                          size: (20 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ),
                                    onChanged: (p0) {
                                      triggerValidityEvent(p0, currentPassword);
                                      // triggerCriteriaEvent(p0);
                                      // triggerPasswordMatchEvent();
                                      triggerAllTrueEvent();
                                    },
                                    obscureText: !showCurrentPassword,
                                  );
                                } else {
                                  return CustomTextField(
                                    controller: _currentPasswordController,
                                    minLines: 1,
                                    maxLines: 1,
                                    suffix: Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              (10 / Dimensions.designWidth).w),
                                      child: InkWell(
                                        onTap: () {
                                          passwordBloc.add(DisplayPasswordEvent(
                                              showPassword: true,
                                              toggle: ++toggle));
                                          showCurrentPassword =
                                              !showCurrentPassword;
                                        },
                                        child: Icon(
                                          Icons.visibility_outlined,
                                          color: const Color.fromRGBO(
                                              34, 97, 105, 0.5),
                                          size: (20 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ),
                                    onChanged: (p0) {
                                      triggerValidityEvent(p0, currentPassword);
                                      // triggerCriteriaEvent(p0);
                                      // triggerPasswordMatchEvent();
                                      triggerAllTrueEvent();
                                    },
                                    obscureText: !showCurrentPassword,
                                  );
                                }
                              },
                            ),
                            const SizeBox(height: 9),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: (context, state) {
                                if (!isCorrect &&
                                    _currentPasswordController.text.length >=
                                        8) {
                                  return Row(
                                    children: [
                                      SvgPicture.asset(
                                        ImageConstants.errorSolid,
                                        width: (14 / Dimensions.designWidth).w,
                                        height: (14 / Dimensions.designWidth).w,
                                      ),
                                      const SizeBox(width: 5),
                                      Text(
                                        "Password incorrect",
                                        style:
                                            TextStyles.primaryMedium.copyWith(
                                          color: const Color(0xFFC94540),
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizeBox();
                                }
                              },
                            ),
                            const SizeBox(height: 15),
                            Text(
                              "New Password",
                              style: TextStyles.primaryMedium.copyWith(
                                color: const Color(0xFF636363),
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 9),
                            BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                              builder: (context, state) {
                                if (showNewPassword) {
                                  return CustomTextField(
                                    controller: _newPasswordController,
                                    minLines: 1,
                                    maxLines: 1,
                                    suffix: Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              (10 / Dimensions.designWidth).w),
                                      child: InkWell(
                                        onTap: () {
                                          passwordBloc.add(HidePasswordEvent(
                                              showPassword: false,
                                              toggle: ++toggle));
                                          showNewPassword = !showNewPassword;
                                        },
                                        child: Icon(
                                          Icons.visibility_off_outlined,
                                          color: const Color.fromRGBO(
                                              34, 97, 105, 0.5),
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
                                      padding: EdgeInsets.only(
                                          left:
                                              (10 / Dimensions.designWidth).w),
                                      child: InkWell(
                                        onTap: () {
                                          passwordBloc.add(DisplayPasswordEvent(
                                              showPassword: true,
                                              toggle: ++toggle));
                                          showNewPassword = !showNewPassword;
                                        },
                                        child: Icon(
                                          Icons.visibility_outlined,
                                          color: const Color.fromRGBO(
                                              34, 97, 105, 0.5),
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
                              },
                            ),
                            const SizeBox(height: 9),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: (context, state) {
                                if (!(hasMin8 &&
                                        hasUpperLower &&
                                        hasNumeric &&
                                        hasSpecial) &&
                                    _newPasswordController.text.isNotEmpty) {
                                  return Row(
                                    children: [
                                      SvgPicture.asset(
                                        ImageConstants.errorSolid,
                                        width: (14 / Dimensions.designWidth).w,
                                        height: (14 / Dimensions.designWidth).w,
                                      ),
                                      const SizeBox(width: 5),
                                      Text(
                                        "Password does not meet the criteria",
                                        style:
                                            TextStyles.primaryMedium.copyWith(
                                          color: const Color(0xFFC94540),
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizeBox();
                                }
                              },
                            ),
                            const SizeBox(height: 15),
                            Text(
                              "Confirm New Password",
                              style: TextStyles.primaryMedium.copyWith(
                                color: const Color(0xFF636363),
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 9),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<ShowPasswordBloc,
                                    ShowPasswordState>(
                                  builder: (context, state) {
                                    if (showConfirmNewPassword) {
                                      return CustomTextField(
                                        width: 83.w,
                                        controller:
                                            _confirmNewPasswordController,
                                        minLines: 1,
                                        maxLines: 1,
                                        suffix: Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  (10 / Dimensions.designWidth)
                                                      .w),
                                          child: InkWell(
                                            onTap: () {
                                              confirmPasswordBloc.add(
                                                  HidePasswordEvent(
                                                      showPassword: false,
                                                      toggle: ++toggle));
                                              showConfirmNewPassword =
                                                  !showConfirmNewPassword;
                                            },
                                            child: Icon(
                                              Icons.visibility_off_outlined,
                                              color: const Color.fromRGBO(
                                                  34, 97, 105, 0.5),
                                              size:
                                                  (20 / Dimensions.designWidth)
                                                      .w,
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
                                        width: 83.w,
                                        controller:
                                            _confirmNewPasswordController,
                                        minLines: 1,
                                        maxLines: 1,
                                        suffix: Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  (10 / Dimensions.designWidth)
                                                      .w),
                                          child: InkWell(
                                            onTap: () {
                                              confirmPasswordBloc.add(
                                                  DisplayPasswordEvent(
                                                      showPassword: true,
                                                      toggle: ++toggle));
                                              showConfirmNewPassword =
                                                  !showConfirmNewPassword;
                                            },
                                            child: Icon(
                                              Icons.visibility_outlined,
                                              color: const Color.fromRGBO(
                                                  34, 97, 105, 0.5),
                                              size:
                                                  (20 / Dimensions.designWidth)
                                                      .w,
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
                                  },
                                ),
                                BlocBuilder<MatchPasswordBloc,
                                    MatchPasswordState>(
                                  builder: (context, state) {
                                    if (isMatch) {
                                      return SvgPicture.asset(
                                        ImageConstants.checkCircle,
                                        width: (20 / Dimensions.designWidth).w,
                                        height: (20 / Dimensions.designWidth).w,
                                      );
                                    } else {
                                      return SvgPicture.asset(
                                        ImageConstants.warningSmall,
                                        width: (20 / Dimensions.designWidth).w,
                                        height: (20 / Dimensions.designWidth).w,
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                            const SizeBox(height: 9),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: (context, state) {
                                if (!isMatch &&
                                    _confirmNewPasswordController
                                        .text.isNotEmpty) {
                                  return Row(
                                    children: [
                                      SvgPicture.asset(
                                        ImageConstants.warningSmall,
                                        width: (14 / Dimensions.designWidth).w,
                                        height: (14 / Dimensions.designWidth).w,
                                      ),
                                      const SizeBox(width: 5),
                                      Text(
                                        "New passwords do not match",
                                        style:
                                            TextStyles.primaryMedium.copyWith(
                                          color: const Color(0xFFF39C12),
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizeBox();
                                }
                              },
                            ),
                            const SizeBox(height: 15),
                            BlocBuilder<CriteriaBloc, CriteriaState>(
                              builder: (context, state) {
                                return PasswordCriteria(
                                  criteria1Color: hasMin8
                                      ? AppColors.primary
                                      : const Color(0xFFC94540),
                                  criteria2Color: hasNumeric
                                      ? AppColors.primary
                                      : const Color(0xFFC94540),
                                  criteria3Color: hasUpperLower
                                      ? AppColors.primary
                                      : const Color(0xFFC94540),
                                  criteria4Color: hasSpecial
                                      ? AppColors.primary
                                      : const Color(0xFFC94540),
                                  criteria1Widget: hasMin8
                                      ? SvgPicture.asset(
                                          ImageConstants.checkSmall)
                                      : const SizeBox(),
                                  criteria2Widget: hasNumeric
                                      ? SvgPicture.asset(
                                          ImageConstants.checkSmall)
                                      : const SizeBox(),
                                  criteria3Widget: hasUpperLower
                                      ? SvgPicture.asset(
                                          ImageConstants.checkSmall)
                                      : const SizeBox(),
                                  criteria4Widget: hasSpecial
                                      ? SvgPicture.asset(
                                          ImageConstants.checkSmall)
                                      : const SizeBox(),
                                );
                              },
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
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      BlocBuilder<CheckBoxBloc, CheckBoxState>(
                        builder: (context, state) {
                          if (isChecked) {
                            return InkWell(
                              onTap: () {
                                isChecked = false;
                                triggerCheckBoxEvent(isChecked);
                                triggerAllTrueEvent();
                              },
                              child: SvgPicture.asset(
                                ImageConstants.checkedBox,
                                width: (14 / Dimensions.designWidth).w,
                                height: (14 / Dimensions.designWidth).w,
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () {
                                isChecked = true;
                                triggerCheckBoxEvent(isChecked);
                                triggerAllTrueEvent();
                              },
                              child: SvgPicture.asset(
                                ImageConstants.uncheckedBox,
                                width: (14 / Dimensions.designWidth).w,
                                height: (14 / Dimensions.designWidth).w,
                              ),
                            );
                          }
                        },
                      ),
                      const SizeBox(width: 10),
                      RichText(
                        text: TextSpan(
                          text: 'I agree to the ',
                          style: TextStyles.primary.copyWith(
                            color: const Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyles.primary.copyWith(
                                color: AppColors.primary,
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: TextStyles.primary.copyWith(
                                color: const Color.fromRGBO(0, 0, 0, 0.5),
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyles.primary.copyWith(
                                color: AppColors.primary,
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<CreatePasswordBloc, CreatePasswordState>(
                    builder: (context, state) {
                      if (allTrue) {
                        return Column(
                          children: [
                            const SizeBox(height: 10),
                            GradientButton(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.errorSuccessScreen,
                                  arguments: ErrorArgumentModel(
                                    hasSecondaryButton: false,
                                    iconPath:
                                        ImageConstants.checkCircleOutlined,
                                    title: "Password Changed!",
                                    message:
                                        "Your password updated successfully.\nPlease log in again with your new password.",
                                    buttonText: "Login",
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, Routes.login);
                                    },
                                  ).toMap(),
                                );
                              },
                              text: "Update",
                            ),
                          ],
                        );
                      } else {
                        return const SizeBox();
                      }
                    },
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

  void triggerValidityEvent(String p0, String matcher) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    if (p0.length >= 8) {
      if (p0 == matcher) {
        isCorrect = true;
        showButtonBloc.add(ShowButtonEvent(show: isCorrect));
      } else {
        isCorrect = false;
        showButtonBloc.add(ShowButtonEvent(show: isCorrect));
      }
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

    showCriteriaMessageBloc.add(ShowButtonEvent(
        show: hasMin8 && hasNumeric && hasUpperLower && hasSpecial));
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

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  void triggerAllTrueEvent() {
    allTrue = isCorrect &&
        hasMin8 &&
        hasNumeric &&
        hasUpperLower &&
        hasSpecial &&
        isMatch &&
        isChecked;
    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
