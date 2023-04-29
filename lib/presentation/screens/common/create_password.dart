// ignore_for_file: public_member_api_docs, sort_constructors_first
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
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/data/models/arguments/create_account.dart';
import 'package:dialup_mobile_app/data/models/arguments/onboarding_status.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/createPassword/criteria.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/constants/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  late final TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late CreateAccountArgumentModel createAccountArgumentModel;

  bool showPassword = false;
  bool showConfirmPassword = false;

  int toggle = 0;

  // ? boolean flags for criteria
  bool hasMin8 = false;
  bool hasNumeric = false;
  bool hasUpperLower = false;
  bool hasSpecial = false;

  bool isMatch = false;

  bool isChecked = false;

  bool allTrue = false;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    controllerInitialization();
    blocInitialization();
  }

  void argumentInitialization() {
    createAccountArgumentModel =
        CreateAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  void controllerInitialization() {
    _emailController =
        TextEditingController(text: createAccountArgumentModel.email);
  }

  void blocInitialization() {
    final CriteriaBloc criteriaBloc = context.read<CriteriaBloc>();
    criteriaBloc.add(CriteriaMin8Event(hasMin8: hasMin8));
    criteriaBloc.add(CriteriaNumericEvent(hasNumeric: hasNumeric));
    criteriaBloc.add(CriteriaUpperLowerEvent(hasUpperLower: hasUpperLower));
    criteriaBloc.add(CriteriaSpecialEvent(hasSpecial: hasSpecial));

    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));

    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: false));

    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(
          onTap: promptUser,
        ),
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
                    labels[182]["labelText"],
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
                          RichText(
                            text: TextSpan(
                              text: 'User ID ',
                              style: TextStyles.primary.copyWith(
                                color: AppColors.black63,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '(Email address)',
                                  style: TextStyles.primary.copyWith(
                                    color:
                                        const Color.fromRGBO(99, 99, 99, 0.5),
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizeBox(height: 9),
                          CustomTextField(
                            controller: _emailController,
                            enabled: false,
                            onChanged: (p0) {},
                            color: AppColors.blackEE,
                            fontColor: const Color.fromRGBO(37, 37, 37, 0.5),
                          ),
                          const SizeBox(height: 15),
                          Text(
                            labels[182]["labelText"],
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.black63,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                            builder: buildShowPassword,
                          ),
                          const SizeBox(height: 15),
                          Text(
                            labels[49]["labelText"],
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.black63,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 9),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                                builder: buildShowConfirmPassword,
                              ),
                              BlocBuilder<MatchPasswordBloc,
                                  MatchPasswordState>(
                                builder: buildCheckCircle,
                              )
                            ],
                          ),
                          const SizeBox(height: 15),
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
                const SizeBox(height: 20),
                Row(
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: buildCheckBox,
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

  Widget buildShowPassword(BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
    if (showPassword) {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  HidePasswordEvent(showPassword: false, toggle: ++toggle));
              showPassword = !showPassword;
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
        obscureText: !showPassword,
      );
    } else {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
              showPassword = !showPassword;
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
        obscureText: !showPassword,
      );
    }
  }

  Widget buildShowConfirmPassword(
      BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc confirmPasswordBloc =
        context.read<ShowPasswordBloc>();
    if (showConfirmPassword) {
      return CustomTextField(
        width: 83.w,
        controller: _confirmPasswordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              confirmPasswordBloc.add(
                  HidePasswordEvent(showPassword: false, toggle: ++toggle));
              showConfirmPassword = !showConfirmPassword;
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
        obscureText: !showConfirmPassword,
      );
    } else {
      return CustomTextField(
        width: 83.w,
        controller: _confirmPasswordController,
        minLines: 1,
        maxLines: 1,
        suffix: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              confirmPasswordBloc.add(
                  DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
              showConfirmPassword = !showConfirmPassword;
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
        obscureText: !showConfirmPassword,
      );
    }
  }

  Widget buildCheckCircle(BuildContext context, MatchPasswordState state) {
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
  }

  Widget buildCriteriaSection(BuildContext context, CriteriaState state) {
    return PasswordCriteria(
      criteria1Color: hasMin8 ? AppColors.primary : AppColors.red,
      criteria2Color: hasNumeric ? AppColors.primary : AppColors.red,
      criteria3Color: hasUpperLower ? AppColors.primary : AppColors.red,
      criteria4Color: hasSpecial ? AppColors.primary : AppColors.red,
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

  Widget buildCheckBox(BuildContext context, CheckBoxState state) {
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
  }

  Widget buildSubmitButton(BuildContext context, CreatePasswordState state) {
    if (allTrue) {
      return Column(
        children: [
          const SizeBox(height: 10),
          GradientButton(
            onTap: () {
              if (createAccountArgumentModel.isRetail) {
                // Navigator.pushReplacementNamed(
                //   context,
                //   Routes.retailDashboard,
                //   arguments: RetailDashboardArgumentModel(
                //     imgUrl:
                //         "https://images.unsplash.com/photo-1619895862022-09114b41f16f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                //     name: createAccountArgumentModel.email,
                //   ).toMap(),
                // );
                Navigator.pushNamed(
                  context,
                  Routes.retailOnboardingStatus,
                  arguments: OnboardingStatusArgumentModel(
                    stepsCompleted: 1,
                    isFatca: false,
                    isPassport: false,
                    isRetail: createAccountArgumentModel.isRetail,
                  ).toMap(),
                );
              } else {
                Navigator.pushNamed(context, Routes.businessOnboardingStatus);
              }
            },
            text: labels[222]["labelText"],
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  void triggerCriteriaEvent(String p0) {
    final CriteriaBloc criteriaBloc = context.read<CriteriaBloc>();

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
  }

  void triggerPasswordMatchEvent() {
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    if (_passwordController.text == _confirmPasswordController.text) {
      isMatch = true;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    } else {
      isMatch = false;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    }
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  void triggerAllTrueEvent() {
    allTrue = hasMin8 &&
        hasNumeric &&
        hasUpperLower &&
        hasSpecial &&
        isMatch &&
        isChecked;
    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
  }
}
