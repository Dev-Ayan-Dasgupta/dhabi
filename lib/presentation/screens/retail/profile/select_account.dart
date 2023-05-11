// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/data/models/arguments/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SelectAccountScreen extends StatefulWidget {
  const SelectAccountScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SelectAccountScreen> createState() => _SelectAccountScreenState();
}

class _SelectAccountScreenState extends State<SelectAccountScreen> {
  late SelectAccountArgumentModel selectAccountArgument;

  @override
  void initState() {
    super.initState();
    selectAccountArgument =
        SelectAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select an entity",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Please select the entity you want to login to",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.grey40,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectAccountArgument.cifDetails.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SolidButton(
                        onTap: () {
                          cif = selectAccountArgument.cifDetails[index]["cif"];
                          if (selectAccountArgument.cifDetails[index]
                              ["isCompanyRegistered"]) {
                            Navigator.pushNamed(context, Routes.setPassword);
                          } else {
                            // TODO: show dialog box which Samit sir will share
                          }
                        },
                        text: selectAccountArgument.cifDetails[index]
                            ["companyName"],
                        color: Colors.white,
                        boxShadow: [BoxShadows.primary],
                        fontColor: AppColors.primary,
                      ),
                      const SizeBox(height: 10),
                    ],
                  );
                },
              ),
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     const SizeBox(height: 20),
            //     Text(
            //       "Please select from the personal account you wish to reset the password",
            //       style: TextStyles.primaryMedium.copyWith(
            //         color: AppColors.grey40,
            //         fontSize: (16 / Dimensions.designWidth).w,
            //       ),
            //     ),
            //     const SizeBox(height: 10),
            //     SolidButton(
            //       onTap: () {},
            //       text: "Personal Account",
            //       color: Colors.white,
            //       boxShadow: [BoxShadows.primary],
            //       fontColor: AppColors.primary,
            //     ),
            //     const SizeBox(height: 560 - (3 * 70)),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
