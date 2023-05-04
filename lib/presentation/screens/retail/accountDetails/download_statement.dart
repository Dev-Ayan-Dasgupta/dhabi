import 'package:dialup_mobile_app/bloc/dateSelection/date_selection_bloc.dart';
import 'package:dialup_mobile_app/bloc/dateSelection/date_selection_event.dart';
import 'package:dialup_mobile_app/bloc/dateSelection/date_selection_state.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/cupertino.dart';
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

  int toggles = 0;

  String? selectedFormat;

  DateTime auxFromDate = DateTime.now();
  DateTime tempFromDate = DateTime.now();
  DateTime auxToDate = DateTime.now();
  DateTime tempToDate = DateTime.now();

  bool isFormatSelected = false;
  bool isFromDateSelected = false;
  bool isToDateSelected = false;
  bool isOneMonth = false;
  bool isThreeMonths = false;
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
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
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
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    builder: (context, state) {
                      return CustomDropDown(
                        title: "Select File Format",
                        items: items,
                        value: selectedFormat,
                        onChanged: onSelectFileFormat,
                      );
                    },
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Please select the date range from the below dropdown",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<DateSelectionBloc, DateSelectionState>(
                    builder: (context, state) {
                      return DateDropdown(
                        onTap: onFromDateSelected,
                        isSelected: isFromDateSelected,
                        text: fromDate,
                      );
                    },
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<DateSelectionBloc, DateSelectionState>(
                    builder: (context, state) {
                      return DateDropdown(
                        isSelected: isToDateSelected,
                        onTap: onToDateSelected,
                        text: toDate,
                      );
                    },
                  ),
                  const SizeBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Or",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.grey40,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return ActionButton(
                        onTap: onOneMonthTap,
                        text: "Download Last 1 Month Statement",
                        isSelected: isOneMonth,
                      );
                    },
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return ActionButton(
                        onTap: onThreeMonthsTap,
                        text: "Download Last 3 Months Statement",
                        isSelected: isThreeMonths,
                      );
                    },
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return ActionButton(
                        onTap: onSixMonthsTap,
                        text: "Download Last 6 Months Statement",
                        isSelected: isSixMonths,
                      );
                    },
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

  onSelectFileFormat(Object? value) {
    final DropdownSelectedBloc formatSelectionBloc =
        context.read<DropdownSelectedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    toggles++;
    isFormatSelected = true;
    selectedFormat = value as String;
    formatSelectionBloc.add(
      DropdownSelectedEvent(
        isDropdownSelected: isFormatSelected,
        toggles: toggles,
      ),
    );
    showButtonBloc.add(
      ShowButtonEvent(
        show: isFormatSelected &&
            ((isOneMonth || isThreeMonths || isSixMonths) ||
                (isFromDateSelected && isToDateSelected)),
      ),
    );
  }

  void onFromDateSelected() {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height: (300 / Dimensions.designWidth).w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular((20 / Dimensions.designWidth).w),
                topRight: Radius.circular((20 / Dimensions.designWidth).w),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return Text(
                      DateFormat('EEE, d MMM, yyyy').format(auxFromDate),
                      style: TextStyles.primaryBold.copyWith(
                        color: const Color(0xFF252525),
                        fontSize: (18 / Dimensions.designWidth).w,
                      ),
                    );
                  },
                ),
                const SizeBox(height: 20),
                SizedBox(
                  height: (170 / Dimensions.designWidth).w,
                  child: CupertinoDatePicker(
                    initialDateTime: auxFromDate,
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: onFromDateChanged,
                  ),
                ),
                const SizeBox(height: 20),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        tempFromDate = auxFromDate;
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: (50.w) - 1,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "CANCEL",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.black12,
                    ),
                    InkWell(
                      onTap: onFromDateOk,
                      child: Container(
                        width: (50.w) - 1,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "OK",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  onFromDateChanged(DateTime p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    tempFromDate = p0;
    fromDate = DateFormat('d MMMM, yyyy').format(auxFromDate);
    showButtonBloc.add(
      ShowButtonEvent(
        show: isFormatSelected &&
            ((isOneMonth || isThreeMonths || isSixMonths) ||
                (isFromDateSelected && isToDateSelected)),
      ),
    );
  }

  onFromDateOk() {
    final DateSelectionBloc fromDateSelectionBloc =
        context.read<DateSelectionBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    isFromDateSelected = true;
    if (fromDate == "To Date") {
      fromDate = DateFormat('d MMMM, yyyy').format(
        DateTime.now(),
      );
    }
    auxFromDate = tempFromDate;
    fromDate = DateFormat('d MMMM, yyyy').format(auxFromDate);
    isOneMonth = false;
    isThreeMonths = false;
    isSixMonths = false;
    fromDateSelectionBloc.add(
      DateSelectionEvent(isDateSelected: isFromDateSelected),
    );
    showButtonBloc.add(ShowButtonEvent(
        show: isFormatSelected &&
            ((isOneMonth || isThreeMonths || isSixMonths) ||
                (isFromDateSelected && isToDateSelected))));
    Navigator.pop(context);
  }

  void onToDateSelected() {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height: (300 / Dimensions.designWidth).w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular((20 / Dimensions.designWidth).w),
                topRight: Radius.circular((20 / Dimensions.designWidth).w),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return Text(
                      DateFormat('EEE, d MMM, yyyy').format(auxToDate),
                      style: TextStyles.primaryBold.copyWith(
                        color: const Color(0xFF252525),
                        fontSize: (18 / Dimensions.designWidth).w,
                      ),
                    );
                  },
                ),
                const SizeBox(height: 20),
                SizedBox(
                  height: (170 / Dimensions.designWidth).w,
                  child: CupertinoDatePicker(
                    initialDateTime: auxToDate.add(const Duration(seconds: 1)),
                    minimumDate: auxFromDate,
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: onToDateChanged,
                  ),
                ),
                const SizeBox(height: 20),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        tempToDate = auxToDate;
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: (50.w) - 1,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "CANCEL",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.black12,
                    ),
                    InkWell(
                      onTap: onToDateOk,
                      child: Container(
                        width: (50.w) - 1,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "OK",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void onToDateChanged(DateTime p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    tempToDate = p0;
    toDate = DateFormat('d MMMM, yyyy').format(auxToDate);
    showButtonBloc.add(
      ShowButtonEvent(
        show: isFormatSelected &&
            ((isOneMonth || isThreeMonths || isSixMonths) ||
                (isFromDateSelected && isToDateSelected)),
      ),
    );
  }

  void onToDateOk() {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final DateSelectionBloc toDateSelectionBloc =
        context.read<DateSelectionBloc>();
    isToDateSelected = true;
    if (toDate == "To Date") {
      toDate = DateFormat('d MMMM, yyyy').format(
        DateTime.now(),
      );
    }
    auxToDate = tempToDate;
    toDate = DateFormat('d MMMM, yyyy').format(auxToDate);
    isOneMonth = false;
    isThreeMonths = false;
    isSixMonths = false;
    toDateSelectionBloc.add(
      DateSelectionEvent(isDateSelected: isToDateSelected),
    );
    showButtonBloc.add(
      ShowButtonEvent(
        show: isFormatSelected &&
            ((isOneMonth || isThreeMonths || isSixMonths) ||
                (isFromDateSelected && isToDateSelected)),
      ),
    );
    Navigator.pop(context);
  }

  void onOneMonthTap() {
    final DateSelectionBloc fromDateSelectionBloc =
        context.read<DateSelectionBloc>();
    final DateSelectionBloc toDateSelectionBloc =
        context.read<DateSelectionBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    isFromDateSelected = false;
    fromDate = "From Date";
    isToDateSelected = false;
    toDate = "To Date";
    auxToDate = DateTime.now();
    tempToDate = DateTime.now();
    auxFromDate = DateTime.now();
    tempFromDate = DateTime.now();
    fromDateSelectionBloc
        .add(DateSelectionEvent(isDateSelected: isFromDateSelected));
    toDateSelectionBloc
        .add(DateSelectionEvent(isDateSelected: isToDateSelected));

    isOneMonth = true;
    isThreeMonths = false;
    isSixMonths = false;
    showButtonBloc.add(
      ShowButtonEvent(
        show: isFormatSelected &&
            ((isOneMonth || isThreeMonths || isSixMonths) ||
                (isFromDateSelected && isToDateSelected)),
      ),
    );
  }

  void onThreeMonthsTap() {
    final DateSelectionBloc fromDateSelectionBloc =
        context.read<DateSelectionBloc>();
    final DateSelectionBloc toDateSelectionBloc =
        context.read<DateSelectionBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    isFromDateSelected = false;
    fromDate = "From Date";
    isToDateSelected = false;
    toDate = "To Date";
    auxToDate = DateTime.now();
    tempToDate = DateTime.now();
    auxFromDate = DateTime.now();
    tempFromDate = DateTime.now();
    fromDateSelectionBloc
        .add(DateSelectionEvent(isDateSelected: isFromDateSelected));
    toDateSelectionBloc
        .add(DateSelectionEvent(isDateSelected: isToDateSelected));

    isOneMonth = false;
    isThreeMonths = true;
    isSixMonths = false;
    showButtonBloc.add(
      ShowButtonEvent(
        show: isFormatSelected &&
            ((isOneMonth || isThreeMonths || isSixMonths) ||
                (isFromDateSelected && isToDateSelected)),
      ),
    );
  }

  void onSixMonthsTap() {
    final DateSelectionBloc fromDateSelectionBloc =
        context.read<DateSelectionBloc>();
    final DateSelectionBloc toDateSelectionBloc =
        context.read<DateSelectionBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    isFromDateSelected = false;
    fromDate = "From Date";
    isToDateSelected = false;
    toDate = "To Date";
    auxToDate = DateTime.now();
    tempToDate = DateTime.now();
    auxFromDate = DateTime.now();
    tempFromDate = DateTime.now();
    fromDateSelectionBloc
        .add(DateSelectionEvent(isDateSelected: isFromDateSelected));
    toDateSelectionBloc
        .add(DateSelectionEvent(isDateSelected: isToDateSelected));

    isOneMonth = false;
    isThreeMonths = false;
    isSixMonths = true;
    showButtonBloc.add(
      ShowButtonEvent(
        show: isFormatSelected &&
            ((isOneMonth || isThreeMonths || isSixMonths) ||
                (isFromDateSelected && isToDateSelected)),
      ),
    );
  }
}
