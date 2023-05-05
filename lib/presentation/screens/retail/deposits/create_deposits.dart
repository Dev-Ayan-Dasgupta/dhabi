import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_bloc.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_event.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_state.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_bloc.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_event.dart';
import 'package:dialup_mobile_app/bloc/dashboard/summary_tile_state.dart';
import 'package:dialup_mobile_app/bloc/dateSelection/date_selection_bloc.dart';
import 'package:dialup_mobile_app/bloc/dateSelection/date_selection_event.dart';
import 'package:dialup_mobile_app/bloc/dateSelection/date_selection_state.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/errorMessage/error_message_bloc.dart';
import 'package:dialup_mobile_app/bloc/errorMessage/error_message_event.dart';
import 'package:dialup_mobile_app/bloc/errorMessage/error_message_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CreateDepositsScreen extends StatefulWidget {
  const CreateDepositsScreen({Key? key}) : super(key: key);

  @override
  State<CreateDepositsScreen> createState() => _CreateDepositsScreenState();
}

class _CreateDepositsScreenState extends State<CreateDepositsScreen> {
  double _scrollOffset = 0;
  int _scrollIndex = 0;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _depositController = TextEditingController();

  final double minAmtReq = 10000;
  final double maxAmtReq = 100000;
  final double bal = 25000;

  String errorMsg = "";

  bool isShowButton = false;
  bool showPeriod = false;

  bool isAutoRenewal = true;
  bool isAutoClosure = false;

  String? selectedPayout;

  String date = "";

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

  List<DetailsTileModel> rates = [
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
    DetailsTileModel(key: "1wk (7-29 days)", value: "0.0500"),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollOffset = _scrollController.offset + 120;
      _scrollIndex = _scrollOffset ~/ 188;

      final SummaryTileBloc summaryTileBloc = context.read<SummaryTileBloc>();
      summaryTileBloc.add(SummaryTileEvent(scrollIndex: _scrollIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          InkWell(
            onTap: promptUser,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (15 / Dimensions.designWidth).w,
                vertical: (15 / Dimensions.designWidth).w,
              ),
              child: SvgPicture.asset(ImageConstants.rates),
            ),
          )
        ],
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
                  const SizeBox(height: 10),
                  Text(
                    "Create Deposits",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  SizedBox(
                    height: (146 / Dimensions.designWidth).w,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return AccountSummaryTile(
                          onTap: () {},
                          imgUrl:
                              "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
                          accountType: "Savings",
                          currency: "USD",
                          amount: 20000,
                          subText: "",
                          subImgUrl: "",
                        );
                      },
                    ),
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<SummaryTileBloc, SummaryTileState>(
                    builder: buildSummaryTile,
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                                EdgeInsets.all((10 / Dimensions.designWidth).w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular((3 / Dimensions.designWidth).w),
                              ),
                              color: const Color(0xFFEEEEEE),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Amount Limit Criteria",
                                  style: TextStyles.primaryBold.copyWith(
                                    color: AppColors.primary,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizeBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Minimum amount required",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    Text(
                                      "USD ${minAmtReq.toStringAsFixed(2)}",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizeBox(height: 7),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Maximum amount required",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    Text(
                                      "USD ${maxAmtReq.toStringAsFixed(2)}",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizeBox(height: 10),
                          Text(
                            "Deposit Amount (USD)",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.black63,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 7),
                          CustomTextField(
                            controller: _depositController,
                            hintText: "E.g., 500",
                            onChanged: onDepositChanged,
                          ),
                          const SizeBox(height: 5),
                          BlocBuilder<ErrorMessageBloc, ErrorMessageState>(
                            builder: buildErrorMessage,
                          ),
                          const SizeBox(height: 10),
                          Text(
                            "Tenure",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.black63,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 10),
                          InkWell(
                            onTap: showDatePickerWidget,
                            child: Container(
                              padding: EdgeInsets.all(
                                  (15 / Dimensions.designWidth).w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    (10 / Dimensions.designWidth).w)),
                                boxShadow: [BoxShadows.primary],
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date",
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: AppColors.black63,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      BlocBuilder<DateSelectionBloc,
                                          DateSelectionState>(
                                        builder: buildCurrentDate,
                                      ),
                                      SvgPicture.asset(
                                        ImageConstants.arrowForwardIos,
                                        width: (10 / Dimensions.designWidth).w,
                                        height: (16 / Dimensions.designWidth).w,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.primary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: buildDepositColumn,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: buildSubmitButton,
            ),
          ],
        ),
      ),
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: (22 / Dimensions.designWidth).w,
            right: (22 / Dimensions.designWidth).w,
            top: (192 / Dimensions.designWidth).w,
            bottom: (32 / Dimensions.designWidth).w,
          ),
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: (100 / Dimensions.designWidth).w,
              child: Column(
                children: [
                  Expanded(
                    child: DetailsTile(length: 10, details: rates),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSummaryTile(BuildContext context, SummaryTileState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 47.w -
              (22 / Dimensions.designWidth).w -
              ((5 - 1) * (6.5 / Dimensions.designWidth).w)),
      child: SizedBox(
        width: 90.w,
        height: (9 / Dimensions.designWidth).w,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return ScrollIndicator(
              isCurrent: (index == _scrollIndex),
            );
          },
        ),
      ),
    );
  }

  Widget buildErrorMessage(BuildContext context, ErrorMessageState state) {
    if (errorMsg.isNotEmpty) {
      return Text(
        errorMsg,
        style: TextStyles.primaryMedium.copyWith(
          color: AppColors.red100,
          fontSize: (16 / Dimensions.designWidth).w,
        ),
      );
    } else {
      return const SizeBox();
    }
  }

  void showDatePickerWidget() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
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
                Text(
                  DateFormat('EEE, d MMM, yyyy').format(DateTime.now()),
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.black25,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                SizedBox(
                  height: (170 / Dimensions.designWidth).w,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (p0) {
                      date = DateFormat('d MMMM, yyyy').format(p0);
                    },
                  ),
                ),
                const SizeBox(height: 20),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
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
                      onTap: onDateOK,
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

  void onDateOK() {
    final DateSelectionBloc dateSelectionBloc =
        context.read<DateSelectionBloc>();
    final ShowButtonBloc showPeriodSection = context.read<ShowButtonBloc>();
    if (date.isNotEmpty) {
      dateSelectionBloc.add(const DateSelectionEvent(isDateSelected: true));
      showPeriod = true;
      showPeriodSection.add(
        ShowButtonEvent(
            show: showPeriod &&
                errorMsg.isEmpty &&
                _depositController.text.isNotEmpty),
      );
    }
    Navigator.pop(context);
  }

  Widget buildCurrentDate(BuildContext context, DateSelectionState state) {
    return Text(
      "$date\t\t\t\t",
      style: TextStyles.primaryMedium.copyWith(
        color: AppColors.black63,
        fontSize: (16 / Dimensions.designWidth).w,
      ),
    );
  }

  Widget buildDepositColumn(BuildContext context, ShowButtonState state) {
    if (showPeriod && errorMsg.isEmpty && _depositController.text.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Container(
            width: 100.w,
            padding: EdgeInsets.symmetric(
                horizontal: (15 / Dimensions.designWidth).w,
                vertical: (8 / Dimensions.designWidth).w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w)),
              color: AppColors.blackEE,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      ImageConstants.warningSmall,
                      width: (20 / Dimensions.designWidth).w,
                      height: (20 / Dimensions.designWidth).w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizeBox(width: 10),
                    Text(
                      "Tenure",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: (18 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                Text(
                  "6.10%",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
          ),
          const SizeBox(height: 20),
          Row(
            children: [
              Text(
                "Interest Payout ",
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.black63,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              SvgPicture.asset(
                ImageConstants.help,
                width: (16.67 / Dimensions.designWidth).w,
                height: (16.67 / Dimensions.designWidth).w,
                colorFilter: const ColorFilter.mode(
                  Color(0XFFA1A1A1),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizeBox(height: 7),
          BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
            builder: buildInterestDropdown,
          ),
          const SizeBox(height: 20),
          Text(
            "On maturity",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.black63,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 10),
          Row(
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: buildAutoRollover,
              ),
              const SizeBox(width: 5),
              Text(
                "Auto Rollover",
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.black63,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(width: 30),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: buildAutoClosure,
              ),
              const SizeBox(width: 5),
              Text(
                "Auto Closure",
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.black63,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
            ],
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildInterestDropdown(
      BuildContext context, DropdownSelectedState state) {
    return CustomDropDown(
      title: "Select",
      items: items,
      value: selectedPayout,
      onChanged: onDropdownChanged,
    );
  }

  void onDropdownChanged(Object? value) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final DropdownSelectedBloc dropdownSelectedBloc =
        context.read<DropdownSelectedBloc>();
    selectedPayout = value as String;
    isShowButton = true;
    dropdownSelectedBloc.add(
      DropdownSelectedEvent(isDropdownSelected: true, toggles: 1),
    );
    showButtonBloc.add(
      ShowButtonEvent(
        show: isShowButton &&
            errorMsg.isEmpty &&
            _depositController.text.isNotEmpty,
      ),
    );
  }

  Widget buildAutoRollover(BuildContext context, ButtonFocussedState state) {
    final ButtonFocussedBloc maturityBloc = context.read<ButtonFocussedBloc>();
    return InkWell(
      onTap: () {
        isAutoRenewal = true;
        isAutoClosure = false;
        maturityBloc.add(
          ButtonFocussedEvent(isFocussed: isAutoRenewal, toggles: 1),
        );
      },
      child: Container(
        width: (18 / Dimensions.designWidth).w,
        height: (18 / Dimensions.designWidth).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: const Color(0XFFDDDDDD)),
        ),
        child: Ternary(
          condition: isAutoRenewal,
          truthy: Center(
            child: SvgPicture.asset(
              ImageConstants.dot,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
              colorFilter: const ColorFilter.mode(
                Color(0XFF00B894),
                BlendMode.srcIn,
              ),
            ),
          ),
          falsy: const SizeBox(),
        ),
      ),
    );
  }

  Widget buildAutoClosure(BuildContext context, ButtonFocussedState state) {
    final ButtonFocussedBloc maturityBloc = context.read<ButtonFocussedBloc>();
    return InkWell(
      onTap: () {
        isAutoRenewal = false;
        isAutoClosure = true;
        maturityBloc.add(
          ButtonFocussedEvent(isFocussed: isAutoRenewal, toggles: 1),
        );
      },
      child: Container(
        width: (18 / Dimensions.designWidth).w,
        height: (18 / Dimensions.designWidth).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: const Color(0XFFDDDDDD)),
        ),
        child: Ternary(
          condition: isAutoClosure,
          truthy: Center(
            child: SvgPicture.asset(
              ImageConstants.dot,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
              colorFilter: const ColorFilter.mode(
                Color(0XFF00B894),
                BlendMode.srcIn,
              ),
            ),
          ),
          falsy: const SizeBox(),
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isShowButton &&
        errorMsg.isEmpty &&
        _depositController.text.isNotEmpty) {
      return Column(
        children: [
          const SizeBox(height: 20),
          GradientButton(
            onTap: () {
              Navigator.pushNamed(context, Routes.depositConfirmation);
            },
            text: labels[31]["labelText"],
          ),
          const SizeBox(height: 20),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  void onDepositChanged(String p0) {
    final ErrorMessageBloc errorMessageBloc = context.read<ErrorMessageBloc>();
    final ShowButtonBloc showPeriodSection = context.read<ShowButtonBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (double.parse(p0) < minAmtReq || double.parse(p0) > maxAmtReq) {
      errorMsg = "Please check the amount limit criteria";
      errorMessageBloc.add(
        ErrorMessageEvent(hasError: errorMsg.isEmpty),
      );
    } else if (double.parse(p0) > bal) {
      errorMsg = "Insufficient fund";
      errorMessageBloc.add(
        ErrorMessageEvent(hasError: errorMsg.isEmpty),
      );
    } else {
      errorMsg = "";
      errorMessageBloc.add(
        ErrorMessageEvent(hasError: errorMsg.isEmpty),
      );
    }
    showPeriodSection.add(
      ShowButtonEvent(
        show: showPeriod &&
            errorMsg.isEmpty &&
            _depositController.text.isNotEmpty,
      ),
    );
    showButtonBloc.add(
      ShowButtonEvent(
        show: isShowButton &&
            errorMsg.isEmpty &&
            _depositController.text.isNotEmpty,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _depositController.dispose();
    super.dispose();
  }
}
