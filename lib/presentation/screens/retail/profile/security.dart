import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool isEnabled = true;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Security",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Device Preference",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: const Color(0XFFF8F8F8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Biometric",
                    style: TextStyles.primary.copyWith(
                      color: const Color(0XFF979797),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildBiometricSwitch,
                  ),
                ],
              ),
            ),
            const SizeBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Change Password",
                  style: TextStyles.primary.copyWith(
                    color: const Color(0XFF1A3C40),
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.changePassword);
                  },
                  child: SvgPicture.asset(
                    ImageConstants.arrowForwardIos,
                    width: (6.7 / Dimensions.designWidth).w,
                    height: (11.3 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBiometricSwitch(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc isEnabledBloc = context.read<ShowButtonBloc>();
    return FlutterSwitch(
      width: (45 / Dimensions.designWidth).w,
      height: (25 / Dimensions.designWidth).w,
      activeColor: AppColors.green100,
      inactiveColor: const Color(0XFFD7D9D8),
      toggleSize: (15 / Dimensions.designWidth).w,
      value: isEnabled,
      onToggle: (val) {
        isEnabled = val;
        isEnabledBloc.add(ShowButtonEvent(show: isEnabled));
      },
    );
  }
}
