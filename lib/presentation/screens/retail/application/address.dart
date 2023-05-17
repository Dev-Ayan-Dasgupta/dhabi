import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  // bool isResidenceYearSelected = false;
  bool isAddress1Entered = false;
  bool isEmirateSelected = false;
  // bool isCityEntered = false;
  int toggles = 0;

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  String? selectedValue;

  int emirateIndex = -1;

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DropdownSelectedBloc residenceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(
          onTap: () {
            // residenceSelectedBloc.add(DropdownSelectedEvent(
            //     isDropdownSelected: false, toggles: toggles));
            // Navigator.pop(context);
          },
        ),
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
              labels[261]["labelText"],
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 30),
            ApplicationProgress(progress: progress),
            const SizeBox(height: 30),
            Text(
              labels[28]["labelText"],
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          labels[264]["labelText"],
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
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
                    Row(
                      children: [
                        Text(
                          labels[265]["labelText"],
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _address1Controller,
                      onChanged: (p0) {
                        if (_address1Controller.text.isEmpty) {
                          isAddress1Entered = false;
                        } else {
                          isAddress1Entered = true;
                        }
                        residenceSelectedBloc.add(
                          DropdownSelectedEvent(
                            isDropdownSelected:
                                // isResidenceYearSelected &&
                                (isAddress1Entered
                                // && isCityEntered
                                ),
                            toggles: toggles,
                          ),
                        );
                      },
                      hintText: "Address",
                    ),
                    const SizeBox(height: 20),
                    Text(
                      labels[266]["labelText"],
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark80,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _address2Controller,
                      onChanged: (p0) {},
                      hintText: "Address",
                    ),
                    // const SizeBox(height: 20),
                    // Text(
                    //   "${labels[331]["labelText"]} *",
                    //   style: TextStyles.primary.copyWith(
                    //     color: AppColors.black63,
                    //     fontSize: (16 / Dimensions.designWidth).w,
                    //   ),
                    // ),
                    // const SizeBox(height: 9),
                    // CustomTextField(
                    //   controller: _cityController,
                    //   onChanged: (p0) {
                    //     if (_cityController.text.isEmpty) {
                    //       isCityEntered = false;
                    //     } else {
                    //       isCityEntered = true;
                    //     }
                    //     residenceSelectedBloc.add(
                    //       DropdownSelectedEvent(
                    //         isDropdownSelected: isResidenceYearSelected &&
                    //             (isAddress1Entered && isCityEntered),
                    //         toggles: toggles,
                    //       ),
                    //     );
                    //   },
                    //   hintText: labels[331]["labelText"],
                    // ),
                    // const SizeBox(height: 20),
                    // Text(
                    //   "State",
                    //   style: TextStyles.primary.copyWith(
                    //     color: AppColors.black63,
                    //     fontSize: (16 / Dimensions.designWidth).w,
                    //   ),
                    // ),
                    // const SizeBox(height: 9),
                    // CustomTextField(
                    //   controller: _stateController,
                    //   onChanged: (p0) {},
                    //   hintText: "State",
                    // ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          labels[267]["labelText"],
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                      builder: (context, state) {
                        return CustomDropDown(
                          title: "Select from the list",
                          items: emirates,
                          value: selectedValue,
                          onChanged: (value) {
                            toggles++;
                            isEmirateSelected = true;
                            selectedValue = value as String;
                            emirateIndex = emirates.indexOf(selectedValue!);
                            residenceSelectedBloc.add(
                              DropdownSelectedEvent(
                                isDropdownSelected: isEmirateSelected &&
                                    (isAddress1Entered
                                    // && isCityEntered
                                    ),
                                toggles: toggles,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizeBox(height: 20),
                    Text(
                      labels[269]["labelText"],
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark80,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _zipController,
                      keyboardType: TextInputType.number,
                      onChanged: (p0) {},
                      hintText: "0000",
                    ),
                    // const SizeBox(height: 20),
                    // Text(
                    //   "Resident Since *",
                    //   style: TextStyles.primary.copyWith(
                    //     color: AppColors.black63,
                    //     fontSize: (16 / Dimensions.designWidth).w,
                    //   ),
                    // ),
                    // const SizeBox(height: 9),
                    // BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    //   builder: (context, state) {
                    //     return CustomDropDown(
                    //       title: "Year",
                    //       items: items,
                    //       value: selectedValue,
                    //       onChanged: (value) {
                    //         toggles++;
                    //         isResidenceYearSelected = true;
                    //         selectedValue = value as String;
                    //         residenceSelectedBloc.add(
                    //           DropdownSelectedEvent(
                    //             isDropdownSelected: isResidenceYearSelected &&
                    //                 (isAddress1Entered && isCityEntered),
                    //             toggles: toggles,
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    const SizeBox(height: 30),
                  ],
                ),
              ),
            ),
            const SizeBox(height: 20),
            BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
              builder: (context, state) {
                if (isEmirateSelected && isAddress1Entered) {
                  return Column(
                    children: [
                      GradientButton(
                        onTap: () async {
                          final DropdownSelectedBloc showButtonBloc =
                              context.read<DropdownSelectedBloc>();
                          isUploading = true;
                          showButtonBloc.add(
                            DropdownSelectedEvent(
                              isDropdownSelected: isUploading,
                              toggles: toggles,
                            ),
                          );
                          await storage.write(
                              key: "addressCountry",
                              value: _countryController.text);
                          storageAddressCountry =
                              await storage.read(key: "addressCountry");
                          await storage.write(
                              key: "addressLine1",
                              value: _address1Controller.text);
                          storageAddressLine1 =
                              await storage.read(key: "addressLine1");
                          await storage.write(
                              key: "addressLine2",
                              value: _address2Controller.text);
                          storageAddressLine2 =
                              await storage.read(key: "addressLine2");
                          await storage.write(
                              key: "addressEmirate", value: selectedValue);
                          storageAddressEmirate =
                              await storage.read(key: "addressEmirate");
                          await storage.write(
                              key: "poBox", value: _zipController.text);
                          storageAddressPoBox =
                              await storage.read(key: "poBox");
                          // var result = await MapRegisterRetailCustomerAddress
                          //     .mapRegisterRetailCustomerAddress({
                          //   "addressLine_1": _address1Controller.text,
                          //   "addressLine_2": _address2Controller.text,
                          //   "areaId": uaeDetails[emirateIndex]["areas"][0]
                          //       ["area_Id"],
                          //   "cityId": uaeDetails[emirateIndex]["city_Id"],
                          //   "stateId": 1,
                          //   "countryId": 1,
                          //   "pinCode": _zipController.text
                          // }, token ?? "");
                          // log("RegisterRetailCustomerAddress API Response -> $result");
                          if (context.mounted) {
                            Navigator.pushNamed(
                                context, Routes.applicationIncome);
                          }
                          isUploading = false;
                          showButtonBloc.add(
                            DropdownSelectedEvent(
                              isDropdownSelected: isUploading,
                              toggles: toggles,
                            ),
                          );
                          await storage.write(
                              key: "stepsCompleted", value: 5.toString());
                          storageStepsCompleted = int.parse(
                              await storage.read(key: "stepsCompleted") ?? "0");
                        },
                        text: labels[127]["labelText"],
                        auxWidget:
                            isUploading ? const LoaderRow() : const SizeBox(),
                      ),
                      const SizeBox(height: PaddingConstants.bottomPadding),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SolidButton(onTap: () {}, text: labels[127]["labelText"]),
                      const SizeBox(height: PaddingConstants.bottomPadding),
                    ],
                  );
                }
              },
            ),
          ],
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
