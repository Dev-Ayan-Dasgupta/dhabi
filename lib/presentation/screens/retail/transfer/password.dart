import 'package:dialup_mobile_app/bloc/createPassword/create_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/createPassword/create_password_event.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_bloc.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/data/models/arguments/error.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool showPassword = false;
  final TextEditingController _passwordController = TextEditingController();
  int toggle = 0;
  bool hasMin8 = false;
  bool hasNumeric = false;
  bool hasUpperLower = false;
  bool hasSpecial = false;
  bool allTrue = false;

  @override
  Widget build(BuildContext context) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
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
                      "Password",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Enter your login password to complete the transaction",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color.fromRGBO(0, 0, 0, 0.4),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Password",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF636363),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 10),
                    BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                      builder: (context, state) {
                        if (showPassword) {
                          return CustomTextField(
                            controller: _passwordController,
                            suffix: Padding(
                              padding: EdgeInsets.only(
                                  left: (10 / Dimensions.designWidth).w),
                              child: InkWell(
                                onTap: () {
                                  passwordBloc.add(HidePasswordEvent(
                                      showPassword: false, toggle: ++toggle));
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
                              triggerAllTrueEvent();
                            },
                            obscureText: !showPassword,
                          );
                        } else {
                          return CustomTextField(
                            controller: _passwordController,
                            suffix: Padding(
                              padding: EdgeInsets.only(
                                  left: (10 / Dimensions.designWidth).w),
                              child: InkWell(
                                onTap: () {
                                  passwordBloc.add(DisplayPasswordEvent(
                                      showPassword: true, toggle: ++toggle));
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
                              triggerAllTrueEvent();
                            },
                            obscureText: !showPassword,
                          );
                        }
                      },
                    ),
                    const SizeBox(height: 10),
                    InkWell(
                      onTap: () {
                        // TODO: Navigate to forgot password screen
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color.fromRGBO(34, 97, 105, 0.5),
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: (context, state) {
                  if (allTrue) {
                    return Column(
                      children: [
                        GradientButton(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.errorScreen,
                              arguments: ErrorArgumentModel(
                                hasSecondaryButton: true,
                                iconPath: ImageConstants.checkCircleOutlined,
                                title: "Success!",
                                message:
                                    "Your transaction has been completed\n\nTransfer reference: 254455588800",
                                buttonText: "Home",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                buttonTextSecondary: "Make another transaction",
                                onTapSecondary: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ).toMap(),
                            );
                          },
                          text: "Proceed",
                        ),
                        const SizeBox(height: 20),
                      ],
                    );
                  } else {
                    return const SizeBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
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

  void triggerAllTrueEvent() {
    allTrue = hasMin8 && hasNumeric && hasUpperLower && hasSpecial;
    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: allTrue));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}