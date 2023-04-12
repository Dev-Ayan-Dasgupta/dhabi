import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/date_dropdown.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/download_statement_button.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';

class DownloadStatementScreen extends StatefulWidget {
  const DownloadStatementScreen({Key? key}) : super(key: key);

  @override
  State<DownloadStatementScreen> createState() =>
      _DownloadStatementScreenState();
}

class _DownloadStatementScreenState extends State<DownloadStatementScreen> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8'
  ];

  String fromDate = "From Date";
  String toDate = "To Date";

  bool isFormatSelected = false;
  bool isFromDateSelected = false;
  bool isToDateSelected = false;
  bool isOneMonth = false;
  bool isThreeMonths = true;
  bool isSixMonths = false;

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
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Download Statement",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Please select the format in which you want to download the statement",
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color.fromRGBO(0, 0, 0, 0.4),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  CustomDropDown(
                    title: "Select File Format",
                    items: items,
                    onChanged: (value) {},
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Please select the date range from the below dropdown",
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color.fromRGBO(0, 0, 0, 0.4),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  DateDropdown(
                    onTap: () {},
                    isSelected: isFromDateSelected,
                    text: fromDate,
                  ),
                  const SizeBox(height: 10),
                  DateDropdown(
                    isSelected: isToDateSelected,
                    onTap: () {},
                    text: toDate,
                  ),
                  const SizeBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Or",
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color.fromRGBO(0, 0, 0, 0.4),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ),
                  const SizeBox(height: 10),
                  DownloadStatementButton(
                    onTap: () {},
                    text: "Download Last 1 Month Statement",
                    isSelected: isOneMonth,
                  ),
                  const SizeBox(height: 10),
                  DownloadStatementButton(
                    onTap: () {},
                    text: "Download Last 3 Months Statement",
                    isSelected: isThreeMonths,
                  ),
                  const SizeBox(height: 10),
                  DownloadStatementButton(
                    onTap: () {},
                    text: "Download Last 6 Months Statement",
                    isSelected: isSixMonths,
                  ),
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                if (isFormatSelected &&
                    ((isOneMonth || isThreeMonths || isSixMonths) ||
                        (isFromDateSelected && isToDateSelected))) {
                  return Column(
                    children: [
                      GradientButton(
                        onTap: () {},
                        text: "Download Now",
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
    );
  }
}
