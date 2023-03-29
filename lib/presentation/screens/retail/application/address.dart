import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ApplicationAddressScreen extends StatefulWidget {
  const ApplicationAddressScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationAddressScreen> createState() =>
      _ApplicationAddressScreenState();
}

class _ApplicationAddressScreenState extends State<ApplicationAddressScreen> {
  int progress = 1;

  final TextEditingController _countryController =
      TextEditingController(text: "United Arab Emirates");
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizeBox(height: 10),
              Text(
                "Application Details",
                style: TextStyles.primaryBold.copyWith(
                  color: AppColors.primary,
                  fontSize: (28 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 30),
              ApplicationProgress(progress: progress),
              const SizeBox(height: 30),
              Text(
                "Address Details",
                style: TextStyles.primary.copyWith(
                  color: AppColors.primary,
                  fontSize: (24 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Country",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0xFF636363),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 9),
                      CustomTextField(
                        controller: _countryController,
                        onChanged: (p0) {},
                        enabled: false,
                        color: const Color(0xFFF9F9F9),
                        fontColor: const Color(0xFFAAAAAA),
                      ),
                      const SizeBox(height: 20),
                      Text(
                        "Address Line 1 *",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0xFF636363),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 9),
                      CustomTextField(
                        controller: _address1Controller,
                        onChanged: (p0) {},
                        hintText: "Address",
                      ),
                      const SizeBox(height: 20),
                      Text(
                        "Address Line 2",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0xFF636363),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 9),
                      CustomTextField(
                        controller: _address2Controller,
                        onChanged: (p0) {},
                        hintText: "Address",
                      ),
                      const SizeBox(height: 20),
                      Text(
                        "City *",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0xFF636363),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 9),
                      CustomTextField(
                        controller: _cityController,
                        onChanged: (p0) {},
                        hintText: "",
                      ),
                      const SizeBox(height: 20),
                      Text(
                        "State",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0xFF636363),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 9),
                      CustomTextField(
                        controller: _stateController,
                        onChanged: (p0) {},
                        hintText: "State",
                      ),
                      const SizeBox(height: 20),
                      Text(
                        "Zip/Postal Code",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0xFF636363),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 9),
                      CustomTextField(
                        controller: _zipController,
                        onChanged: (p0) {},
                        hintText: "0000",
                      ),
                      const SizeBox(height: 20),
                      Text(
                        "Resident Since",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0xFF636363),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 9),
                      CustomTextField(
                        controller: _zipController,
                        onChanged: (p0) {},
                        hintText: "0000",
                      ),
                      const SizeBox(height: 30),
                    ],
                  ),
                ),
              ),
              const SizeBox(height: 20),
              GradientButton(onTap: () {}, text: "Continue"),
              const SizeBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countryController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }
}
