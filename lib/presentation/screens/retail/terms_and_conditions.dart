// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/scrollDirection/scroll_direction_bloc.dart';
import 'package:dialup_mobile_app/bloc/scrollDirection/scroll_direction_event.dart';
import 'package:dialup_mobile_app/bloc/scrollDirection/scroll_direction_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/constants/text.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool isChecked = false;
  final ScrollController _scrollController = ScrollController();
  bool scrollDown = true;

  late CreateAccountArgumentModel createAccountArgumentModel;

  @override
  void initState() {
    super.initState();
    createAccountArgumentModel =
        CreateAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
    final ScrollDirectionBloc scrollDirectionBloc =
        context.read<ScrollDirectionBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >
            (_scrollController.position.maxScrollExtent -
                    _scrollController.position.minScrollExtent) /
                2) {
          scrollDown = false;
          scrollDirectionBloc.add(ScrollDirectionEvent(scrollDown: scrollDown));
        } else {
          scrollDown = true;
          scrollDirectionBloc.add(ScrollDirectionEvent(scrollDown: scrollDown));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollDirectionBloc scrollDirectionBloc =
        context.read<ScrollDirectionBloc>();
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Terms & Conditions",
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.primary,
                          fontSize: (28 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: 1,
                                itemBuilder: (context, _) {
                                  return SizedBox(
                                    width: 100.w,
                                    child: Text(
                                      tAndC,
                                      style: TextStyles.primary.copyWith(
                                        color: const Color(0XFF252525),
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        BlocBuilder<CheckBoxBloc, CheckBoxState>(
                          builder: (context, state) {
                            if (isChecked) {
                              return InkWell(
                                onTap: () {
                                  isChecked = false;
                                  triggerCheckBoxEvent(isChecked);
                                },
                                child:
                                    SvgPicture.asset(ImageConstants.checkedBox),
                              );
                            } else {
                              return InkWell(
                                onTap: () {
                                  isChecked = true;
                                  triggerCheckBoxEvent(isChecked);
                                },
                                child: SvgPicture.asset(
                                    ImageConstants.uncheckedBox),
                              );
                            }
                          },
                        ),
                        const SizeBox(width: 10),
                        Text(
                          "I've read all the terms and conditions",
                          style: TextStyles.primary.copyWith(
                            color: const Color(0XFF414141),
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                    const SizeBox(height: 20),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
                        if (isChecked) {
                          return GradientButton(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, Routes.retailDashboard,
                                  arguments: RetailDashboardArgumentModel(
                                    imgUrl:
                                        "https://images.unsplash.com/photo-1619895862022-09114b41f16f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                                    name: createAccountArgumentModel.email,
                                  ).toMap());
                            },
                            text: "I Agree",
                          );
                        } else {
                          return const SizeBox();
                        }
                      },
                    ),
                    const SizeBox(height: 10),
                  ],
                ),
              ],
            ),
            BlocBuilder<ScrollDirectionBloc, ScrollDirectionState>(
              builder: (context, state) {
                return Positioned(
                  right: 0,
                  bottom: (150 / Dimensions.designWidth).w -
                      MediaQuery.of(context).viewPadding.bottom,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      if (!scrollDown
                          // _scrollController.offset >
                          //   (_scrollController.position.maxScrollExtent -
                          //           _scrollController.position.minScrollExtent) /
                          //       2
                          ) {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                          scrollDown = true;
                          scrollDirectionBloc.add(
                              ScrollDirectionEvent(scrollDown: scrollDown));
                          // setState(() {});
                        }
                      } else {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                          // setState(() {});
                          scrollDown = false;
                          scrollDirectionBloc.add(
                              ScrollDirectionEvent(scrollDown: scrollDown));
                        }
                      }
                    },
                    child: Container(
                      width: (50 / Dimensions.designWidth).w,
                      height: (50 / Dimensions.designWidth).w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadows.primary],
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          // _scrollController.hasClients
                          //     ? _scrollController.offset ==
                          //             _scrollController.position.maxScrollExtent
                          !scrollDown
                              ? ImageConstants.arrowUpward
                              : ImageConstants.arrowDownward,
                          // : ImageConstants.arrowDownward,
                          width: (16 / Dimensions.designWidth).w,
                          height: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isChecked));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
