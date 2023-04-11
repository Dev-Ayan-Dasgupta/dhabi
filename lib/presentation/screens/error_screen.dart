// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/data/models/arguments/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  late ErrorArgumentModel errorArgumentModel;

  @override
  void initState() {
    errorArgumentModel =
        ErrorArgumentModel.fromMap(widget.argument as dynamic ?? {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    errorArgumentModel.iconPath,
                    width: (215 / Dimensions.designWidth).w,
                    height: (215 / Dimensions.designWidth).w,
                  ),
                  const SizeBox(height: 30),
                  Text(
                    errorArgumentModel.title,
                    style: TextStyles.primaryBold.copyWith(
                      color: const Color(0xFF252525),
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    errorArgumentModel.message,
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color(0xFF252525),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                errorArgumentModel.hasSecondaryButton
                    ? Column(
                        children: [
                          SolidButton(
                            onTap: errorArgumentModel.onTapSecondary!,
                            text: errorArgumentModel.buttonTextSecondary!,
                            color: const Color.fromRGBO(34, 97, 105, 0.17),
                            fontColor: AppColors.primary,
                          ),
                          const SizeBox(height: 20),
                        ],
                      )
                    : const SizeBox(),
                GradientButton(
                  onTap: errorArgumentModel.onTap,
                  text: errorArgumentModel.buttonText,
                ),
                const SizeBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }
}