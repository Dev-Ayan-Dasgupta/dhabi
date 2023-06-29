// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class DownloadStatementScreen extends StatefulWidget {
  const DownloadStatementScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<DownloadStatementScreen> createState() =>
      _DownloadStatementScreenState();
}

class _DownloadStatementScreenState extends State<DownloadStatementScreen> {
  final List<String> items = [
    'Excel (.xls)',
    'PDF (.pdf)',
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

  bool isFolderCreated = false;
  Directory? directory;

  bool isDownloading = false;

  late DownloadStatementArgumentModel downloadStatementArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    downloadStatementArgument = DownloadStatementArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels[95]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),

                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "From Date",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
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
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "To Date",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
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
                  Row(
                    children: [
                      Text(
                        "Select a File Format to Download",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
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
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     "Or",
                  //     style: TextStyles.primaryMedium.copyWith(
                  //       color: AppColors.grey40,
                  //       fontSize: (16 / Dimensions.designWidth).w,
                  //     ),
                  //   ),
                  // ),
                  // const SizeBox(height: 10),
                  // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  //   builder: (context, state) {
                  //     return ActionButton(
                  //       onTap: onOneMonthTap,
                  //       text: "Download Last 1 Month Statement",
                  //       isSelected: isOneMonth,
                  //     );
                  //   },
                  // ),
                  // const SizeBox(height: 10),
                  // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  //   builder: (context, state) {
                  //     return ActionButton(
                  //       onTap: onThreeMonthsTap,
                  //       text: "Download Last 3 Months Statement",
                  //       isSelected: isThreeMonths,
                  //     );
                  //   },
                  // ),
                  // const SizeBox(height: 10),
                  // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  //   builder: (context, state) {
                  //     return ActionButton(
                  //       onTap: onSixMonthsTap,
                  //       text: "Download Last 6 Months Statement",
                  //       isSelected: isSixMonths,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                if (isFormatSelected &&
                    ((isOneMonth || isThreeMonths || isSixMonths) ||
                        (isFromDateSelected && isToDateSelected)) &&
                    auxFromDate.difference(auxToDate).inDays <= 0) {
                  return Column(
                    children: [
                      GradientButton(
                        onTap: () async {
                          String? base64String;

                          if (!isDownloading) {
                            final ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isDownloading = true;
                            showButtonBloc.add(
                              ShowButtonEvent(show: isDownloading),
                            );

                            if (selectedFormat == "Excel (.xls)") {
                              base64String =
                                  await MapExcelCustomerAccountStatement
                                      .mapExcelCustomerAccountStatement(
                                {
                                  "accountNumber":
                                      downloadStatementArgument.accountNumber,
                                  "startDate": DateFormat('yyyy-MM-dd')
                                      .format(auxFromDate),
                                  "endDate":
                                      DateFormat('yyyy-MM-dd').format(auxToDate)
                                },
                                token ?? "",
                              );
                              // log("base64 xls -> $base64String");
                            } else if (selectedFormat == "PDF (.pdf)") {
                              log("Pdf statement API request -> ${{
                                "accountNumber":
                                    downloadStatementArgument.accountNumber,
                                "startDate": DateFormat('yyyy-MM-dd')
                                    .format(auxFromDate),
                                "endDate":
                                    DateFormat('yyyy-MM-dd').format(auxToDate),
                              }}");
                              base64String =
                                  await MapPdfCustomerAccountStatement
                                      .mapPdfCustomerAccountStatement(
                                {
                                  "accountNumber":
                                      downloadStatementArgument.accountNumber,
                                  "startDate": DateFormat('yyyy-MM-dd')
                                      .format(auxFromDate),
                                  "endDate": DateFormat('yyyy-MM-dd')
                                      .format(auxToDate),
                                },
                                token ?? "",
                              );
                              // log("base64 pdf -> $base64String");
                            }
                            openFile(base64String, selectedFormat);

                            isDownloading = false;
                            showButtonBloc.add(
                              ShowButtonEvent(show: isDownloading),
                            );
                          }
                        },
                        text: labels[101]["labelText"],
                        auxWidget:
                            isDownloading ? const LoaderRow() : const SizeBox(),
                      ),
                      SizeBox(
                        height: PaddingConstants.bottomPadding +
                            MediaQuery.paddingOf(context).bottom,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SolidButton(onTap: () {}, text: labels[101]["labelText"]),
                      SizeBox(
                        height: PaddingConstants.bottomPadding +
                            MediaQuery.paddingOf(context).bottom,
                      ),
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

  void openFile(String? base64String, String? format) async {
    Uint8List bytes = base64.decode(base64String ?? "");
    File file;
    log("format -> ${format?.split(' ').last.substring(1, format.split(' ').last.length - 1)}");
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //! FOR Android
        : await getApplicationDocumentsDirectory(); //! FOR iOS

    file = File(
        "${directory?.path}/Dhabi_${downloadStatementArgument.accountNumber}_${DateFormat('yyyy-MM-dd').format(auxFromDate)}_${DateFormat('yyyy-MM-dd').format(auxToDate)}${format?.split(' ').last.substring(1, format.split(' ').last.length - 1)}");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    await OpenFile.open(
        "${directory?.path}/Dhabi_${downloadStatementArgument.accountNumber}_${DateFormat('yyyy-MM-dd').format(auxFromDate)}_${DateFormat('yyyy-MM-dd').format(auxToDate)}${format?.split(' ').last.substring(1, format.split(' ').last.length - 1)}");
  }

  onSelectFileFormat(Object? value) {
    final DropdownSelectedBloc formatSelectionBloc =
        context.read<DropdownSelectedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    toggles++;
    isFormatSelected = true;
    selectedFormat = value as String;
    log("selectedFormat -> $selectedFormat");
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
            height:
                (((Platform.isIOS ? 310 : 370)) / Dimensions.designHeight).h,
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
                const SizeBox(height: 20),
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
                  height:
                      ((Platform.isIOS ? 170 : 230) / Dimensions.designHeight)
                          .h,
                  child: Ternary(
                    condition: Platform.isIOS,
                    truthy: CupertinoDatePicker(
                      initialDateTime: auxFromDate,
                      maximumDate: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: onFromDateChangediOS,
                    ),
                    falsy: DatePickerWidget(
                      looping: false,
                      initialDate: auxFromDate,
                      // firstDate: auxFromDate,
                      lastDate: DateTime.now(),
                      dateFormat: "dd-MMMM-yyyy",
                      onChange: onFromDateChangedAndroid,
                      pickerTheme: DateTimePickerTheme(
                        dividerColor: AppColors.dark30,
                        itemTextStyle: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: (20 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
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

  onFromDateChangediOS(DateTime p0) {
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

  onFromDateChangedAndroid(DateTime p0, _) {
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
            height:
                (((Platform.isIOS ? 300 : 360)) / Dimensions.designHeight).h,
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
                  height:
                      (((Platform.isIOS ? 170 : 230)) / Dimensions.designHeight)
                          .h,
                  child: Ternary(
                    condition: Platform.isIOS,
                    truthy: CupertinoDatePicker(
                      initialDateTime:
                          auxToDate.add(const Duration(seconds: 1)),
                      minimumDate: auxFromDate.difference(auxToDate).inDays > 0
                          ? auxToDate
                          : auxFromDate,
                      maximumDate: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: onToDateChangediOS,
                    ),
                    falsy: DatePickerWidget(
                      looping: false,
                      initialDate: auxFromDate.difference(auxToDate).inDays > 0
                          ? auxFromDate
                          : auxToDate.add(const Duration(seconds: 1)),
                      firstDate: auxFromDate,
                      lastDate: DateTime.now(),
                      dateFormat: "dd-MMMM-yyyy",
                      onChange: onToDateChangedAndroid,
                      pickerTheme: DateTimePickerTheme(
                        dividerColor: AppColors.dark30,
                        itemTextStyle: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: (20 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
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

  void onToDateChangediOS(DateTime p0) {
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

  onToDateChangedAndroid(DateTime p0, _) {
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
    auxFromDate = DateTime.now().subtract(const Duration(days: 30));
    tempFromDate = DateTime.now().subtract(const Duration(days: 30));
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
    auxFromDate = DateTime.now().subtract(const Duration(days: 90));
    tempFromDate = DateTime.now().subtract(const Duration(days: 90));
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
    auxFromDate = DateTime.now().subtract(const Duration(days: 180));
    tempFromDate = DateTime.now().subtract(const Duration(days: 180));
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
