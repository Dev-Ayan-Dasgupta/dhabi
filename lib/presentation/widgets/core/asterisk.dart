import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';

class Asterisk extends StatelessWidget {
  const Asterisk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      " *",
      style: TextStyles.primaryMedium.copyWith(color: AppColors.red),
    );
  }
}
