// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/corporateAccounts/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class WorkflowDetailsScreen extends StatefulWidget {
  const WorkflowDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<WorkflowDetailsScreen> createState() => _WorkflowDetailsScreenState();
}

class _WorkflowDetailsScreenState extends State<WorkflowDetailsScreen> {
  final TextEditingController _reasonController = TextEditingController();
  bool isReasonValid = false;

  String workflowTitle = "";

  List<DetailsTileModel> workflowDetails = [];

  bool isFetchingWorkflow = false;
  bool isApprovingRejecting = false;

  late WorkflowArgumentModel workflowArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateTitle(workflowArgument.workflowType);
    getWorkflowDetails();
  }

  void argumentInitialization() {
    workflowArgument =
        WorkflowArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> getWorkflowDetails() async {
    try {
      isFetchingWorkflow = true;
      setState(() {});

      log("getWflowDetApi Request -> ${{
        "reference": workflowArgument.reference,
      }}");
      var getWflowDetApiResult = await MapWorkflowDetails.mapWorkflowDetails(
        {
          "reference": workflowArgument.reference,
        },
        token ?? "",
      );
      log("getWflowDetApiResult -> $getWflowDetApiResult");

      if (getWflowDetApiResult["success"]) {
        populateWorkflowTile(workflowArgument.workflowType,
            getWflowDetApiResult["originalRequest"]);
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Error {200}",
                message: customerDetails["message"] ??
                    "Error while getting workflow details, please try again later",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: labels[346]["labelText"],
                ),
              );
            },
          );
        }
      }

      isFetchingWorkflow = false;
      setState(() {});
    } catch (_) {
      rethrow;
    }
  }

  void populateWorkflowTile(
      int workflowType, Map<String, dynamic> originalRequest) {
    switch (workflowType) {
      case 3:
        workflowDetails.add(DetailsTileModel(
            key: "Debit Account", value: originalRequest["AccountNumber"]));
        workflowDetails.add(DetailsTileModel(
            key: "Deposit Amount",
            value:
                "${originalRequest["Currency"]} ${originalRequest["Amount"].toStringAsFixed(2)}"));
        workflowDetails.add(DetailsTileModel(
            key: "Tenure", value: originalRequest["AccountNumber"]));
        workflowDetails.add(DetailsTileModel(
            key: "Interest Rate",
            value: "${originalRequest["InterestRate"].toString()}%"));
        workflowDetails.add(DetailsTileModel(
            key: "Interest Amount",
            value:
                "${originalRequest["Currency"]} ${originalRequest["Amount"].toStringAsFixed(2)}"));
        workflowDetails.add(DetailsTileModel(
            key: "Interest Payout", value: originalRequest["InterestPayout"]));
        workflowDetails.add(DetailsTileModel(
            key: "Auto Rollover",
            value: originalRequest["AutoRollover"].toString()));
        workflowDetails.add(DetailsTileModel(
            key: "Auto Fund Transfer",
            value: originalRequest["AutoFundTransfer"].toString()));
        workflowDetails.add(DetailsTileModel(key: "Credit Account", value: ""));
        workflowDetails.add(DetailsTileModel(
            key: "Date of Maturity",
            value: DateFormat('dd MMMM yyyy')
                .format(DateTime.parse(originalRequest["MaturityDate"]))));
        break;
      case 6:
        workflowDetails.add(DetailsTileModel(
            key: "Address Line 1", value: originalRequest["AddressLine_1"]));
        workflowDetails.add(DetailsTileModel(
            key: "Address Line 2", value: originalRequest["AddressLine_2"]));
        workflowDetails
            .add(DetailsTileModel(key: "City", value: originalRequest["City"]));
        workflowDetails.add(
            DetailsTileModel(key: "State", value: originalRequest["State"]));
        workflowDetails.add(DetailsTileModel(
            key: "Country Code", value: originalRequest["CountryCode"]));
        workflowDetails.add(DetailsTileModel(
            key: "Pin Code", value: originalRequest["PinCode"]));
        break;
      case 9:
        workflowDetails
            .add(DetailsTileModel(key: "OTP", value: originalRequest["OTP"]));
        workflowDetails.add(DetailsTileModel(
            key: "Mobile Number", value: originalRequest["MobileNumber"]));
        break;
      case 12:
        workflowDetails.add(
          DetailsTileModel(
            key: "Account Type",
            value: originalRequest["AccountType"] == 1
                ? "Savings"
                : originalRequest["AccountType"] == 2
                    ? "Current"
                    : "Savings and Current",
          ),
        );
        break;
      case 15:
        workflowDetails.add(DetailsTileModel(
            key: "Debit Account", value: originalRequest["DebitAccount"]));
        workflowDetails.add(DetailsTileModel(
            key: "Credit Account", value: originalRequest["CreditAccount"]));
        workflowDetails.add(DetailsTileModel(
            key: "Debit Amount",
            value:
                "${originalRequest["Currency"]} ${originalRequest["DebitAmount"]}"));
        break;
      case 27:
        workflowDetails.add(DetailsTileModel(
            key: "Debit Account", value: originalRequest["DebitAccount"]));
        workflowDetails.add(DetailsTileModel(
            key: "Credit Account", value: originalRequest["CreditAccount"]));
        workflowDetails.add(DetailsTileModel(
            key: "Debit Amount",
            value:
                "${originalRequest["Currency"]} ${originalRequest["DebitAmount"]}"));
        break;
      default:
    }
  }

  String populateTitle(int workflowType) {
    switch (workflowType) {
      case 3:
        workflowTitle = "Deposit Details";
        break;
      case 6:
        workflowTitle = "Address Details";
        break;
      case 9:
        workflowTitle = "Mobile Number Details";
        break;
      case 12:
        workflowTitle = "Account Type Details";
        break;
      case 15:
        workflowTitle = "Internal Money Transfer Details";
        break;
      case 18:
        workflowTitle = "Foreign Money Transfer Details";
        break;
      case 21:
        workflowTitle = "Account Deactivation Details";
        break;
      case 24:
        workflowTitle = "Email Address Details";
        break;
      case 27:
        workflowTitle = "Within Dhabi Transaction Details";
        break;
      default:
    }
    return workflowTitle;
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
                    workflowTitle,
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Please review the workflow details to approve or reject it",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Ternary(
                    condition: isFetchingWorkflow,
                    truthy: const ShimmerDepositDetails(),
                    falsy: Expanded(
                      child: DetailsTile(
                        length: workflowDetails.length,
                        details: workflowDetails,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return GradientButton(
                      onTap: () async {},
                      text: "Approve",
                      auxWidget: isApprovingRejecting
                          ? const LoaderRow()
                          : const SizeBox(),
                    );
                  },
                ),
                const SizeBox(height: 15),
                SolidButton(
                  color: const Color.fromRGBO(34, 97, 105, 0.17),
                  fontColor: AppColors.primary,
                  onTap: () {
                    // showDialog(
                    //   barrierDismissible: true,
                    //   context: context,
                    //   builder: (context) {
                    //     final ShowButtonBloc showButtonBloc =
                    //         context.read<ShowButtonBloc>();
                    //     return SingleChildScrollView(
                    //       child: Column(
                    //         children: [
                    //           CustomDialog(
                    //             svgAssetPath: ImageConstants.warning,
                    //             title: labels[320]["labelText"],
                    //             message: labels[321]["labelText"],
                    //             auxWidget: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 // const SizeBox(height: 20),
                    //                 Text(
                    //                   labels[58]["labelText"],
                    //                   style: TextStyles.primaryMedium.copyWith(
                    //                     color: AppColors.dark80,
                    //                     fontSize:
                    //                         (14 / Dimensions.designWidth).w,
                    //                   ),
                    //                 ),
                    //                 const SizeBox(height: 10),
                    //                 BlocBuilder<ShowButtonBloc,
                    //                     ShowButtonState>(
                    //                   builder: (context, state) {
                    //                     return CustomTextField(
                    //                       controller: _reasonController,
                    //                       hintText: "Type Your Remarks Here",
                    //                       bottomPadding:
                    //                           (16 / Dimensions.designWidth).w,
                    //                       minLines: 3,
                    //                       maxLines: 5,
                    //                       maxLength: 200,
                    //                       onChanged: (p0) {
                    //                         if (p0.isNotEmpty) {
                    //                           isReasonValid = true;
                    //                         } else {
                    //                           isReasonValid = false;
                    //                         }
                    //                         showButtonBloc.add(
                    //                           ShowButtonEvent(
                    //                               show: isReasonValid),
                    //                         );
                    //                       },
                    //                     );
                    //                   },
                    //                 ),
                    //                 const SizeBox(height: 20),
                    //                 BlocBuilder<ShowButtonBloc,
                    //                     ShowButtonState>(
                    //                   builder: (context, state) {
                    //                     if (isReasonValid) {
                    //                       return GradientButton(
                    //                         onTap: () async {
                    //                           final ShowButtonBloc
                    //                               showButtonBloc = context
                    //                                   .read<ShowButtonBloc>();
                    //                           isApprovingRejecting = true;
                    //                           showButtonBloc.add(ShowButtonEvent(
                    //                               show: isApprovingRejecting));

                    //                           log("approveRejectApiResult -> ${{
                    //                             "reference":
                    //                                 workflowArgument.reference,
                    //                             "approve": false,
                    //                             "rejectReason":
                    //                                 _reasonController.text,
                    //                           }}");
                    //                           var approveRejectApiResult =
                    //                               await MapApproveOrDissaproveWorkflow
                    //                                   .mapApproveOrDissaproveWorkflow(
                    //                             {
                    //                               "reference": workflowArgument
                    //                                   .reference,
                    //                               "approve": false,
                    //                               "rejectReason":
                    //                                   _reasonController.text,
                    //                             },
                    //                             token ?? "",
                    //                           );
                    //                           log("approveRejectApiResult -> $approveRejectApiResult");

                    //                           if (approveRejectApiResult[
                    //                               "success"]) {
                    //                             if (context.mounted) {
                    //                               Navigator.pop(context);
                    //                               showDialog(
                    //                                 context: context,
                    //                                 builder: (context) {
                    //                                   return CustomDialog(
                    //                                     svgAssetPath: ImageConstants
                    //                                         .checkCircleOutlined,
                    //                                     title:
                    //                                         "Request Rejected",
                    //                                     message:
                    //                                         "You have successfully rejected the maker's request.",
                    //                                     actionWidget:
                    //                                         GradientButton(
                    //                                       onTap: () {
                    //                                         Navigator.pop(
                    //                                             context);
                    //                                         Navigator.pop(
                    //                                             context);
                    //                                         Navigator.pushNamed(
                    //                                             context,
                    //                                             Routes
                    //                                                 .notifications);
                    //                                       },
                    //                                       text: labels[346]
                    //                                           ["labelText"],
                    //                                     ),
                    //                                   );
                    //                                 },
                    //                               );
                    //                             }
                    //                           } else {
                    //                             if (context.mounted) {
                    //                               showDialog(
                    //                                 context: context,
                    //                                 builder: (context) {
                    //                                   return CustomDialog(
                    //                                     svgAssetPath:
                    //                                         ImageConstants
                    //                                             .warning,
                    //                                     title: "Error {200}",
                    //                                     message: approveRejectApiResult[
                    //                                             "message"] ??
                    //                                         "Error while rejecting request, please try again later",
                    //                                     actionWidget:
                    //                                         GradientButton(
                    //                                       onTap: () {
                    //                                         Navigator.pop(
                    //                                             context);
                    //                                       },
                    //                                       text: labels[346]
                    //                                           ["labelText"],
                    //                                     ),
                    //                                   );
                    //                                 },
                    //                               );
                    //                             }
                    //                           }

                    //                           isApprovingRejecting = true;
                    //                           showButtonBloc.add(ShowButtonEvent(
                    //                               show: isApprovingRejecting));
                    //                         },
                    //                         text: labels[31]["labelText"],
                    //                         auxWidget: isApprovingRejecting
                    //                             ? const LoaderRow()
                    //                             : const SizeBox(),
                    //                       );
                    //                     } else {
                    //                       return SolidButton(
                    //                           onTap: () {},
                    //                           text: labels[31]["labelText"]);
                    //                     }
                    //                   },
                    //                 ),
                    //               ],
                    //             ),
                    //             actionWidget: SolidButton(
                    //               color:
                    //                   const Color.fromRGBO(34, 97, 105, 0.17),
                    //               fontColor: AppColors.primary,
                    //               onTap: () {
                    //                 Navigator.pop(context);
                    //               },
                    //               text: labels[166]["labelText"],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // );
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) {
                        final ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    (10 / Dimensions.designWidth).w),
                                topRight: Radius.circular(
                                    (10 / Dimensions.designWidth).w),
                              ),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: (PaddingConstants.horizontalPadding /
                                      Dimensions.designWidth)
                                  .w,
                              vertical: (PaddingConstants.bottomPadding /
                                      Dimensions.designHeight)
                                  .h,
                            ),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  ImageConstants.warning,
                                  width: (111 / Dimensions.designHeight).h,
                                  height: (111 / Dimensions.designHeight).h,
                                ),
                                const SizeBox(height: 20),
                                Text(
                                  labels[320]["labelText"],
                                  style: TextStyles.primaryBold.copyWith(
                                    color: AppColors.black25,
                                    fontSize: (20 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const SizeBox(height: 10),
                                Text(
                                  labels[321]["labelText"],
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.dark50,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizeBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      labels[58]["labelText"],
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.dark80,
                                        fontSize:
                                            (14 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizeBox(height: 10),
                                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                  builder: (context, state) {
                                    return CustomTextField(
                                      controller: _reasonController,
                                      hintText: "Type Your Remarks Here",
                                      bottomPadding:
                                          (16 / Dimensions.designWidth).w,
                                      minLines: 3,
                                      maxLines: 5,
                                      maxLength: 200,
                                      onChanged: (p0) {
                                        if (p0.isNotEmpty) {
                                          isReasonValid = true;
                                        } else {
                                          isReasonValid = false;
                                        }
                                        showButtonBloc.add(
                                          ShowButtonEvent(show: isReasonValid),
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizeBox(height: 20),
                                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                  builder: (context, state) {
                                    if (isReasonValid) {
                                      return GradientButton(
                                        onTap: () async {
                                          final ShowButtonBloc showButtonBloc =
                                              context.read<ShowButtonBloc>();
                                          isApprovingRejecting = true;
                                          showButtonBloc.add(ShowButtonEvent(
                                              show: isApprovingRejecting));

                                          log("approveRejectApiResult -> ${{
                                            "reference":
                                                workflowArgument.reference,
                                            "approve": false,
                                            "rejectReason":
                                                _reasonController.text,
                                          }}");
                                          var approveRejectApiResult =
                                              await MapApproveOrDissaproveWorkflow
                                                  .mapApproveOrDissaproveWorkflow(
                                            {
                                              "reference":
                                                  workflowArgument.reference,
                                              "approve": false,
                                              "rejectReason":
                                                  _reasonController.text,
                                            },
                                            token ?? "",
                                          );
                                          log("approveRejectApiResult -> $approveRejectApiResult");

                                          if (approveRejectApiResult[
                                              "success"]) {
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomDialog(
                                                    svgAssetPath: ImageConstants
                                                        .checkCircleOutlined,
                                                    title: "Request Rejected",
                                                    message:
                                                        "You have successfully rejected the maker's request.",
                                                    actionWidget:
                                                        GradientButton(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pushNamed(
                                                            context,
                                                            Routes
                                                                .notifications);
                                                      },
                                                      text: labels[346]
                                                          ["labelText"],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          } else {
                                            if (context.mounted) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomDialog(
                                                    svgAssetPath:
                                                        ImageConstants.warning,
                                                    title: "Error {200}",
                                                    message: approveRejectApiResult[
                                                            "message"] ??
                                                        "Error while rejecting request, please try again later",
                                                    actionWidget:
                                                        GradientButton(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      text: labels[346]
                                                          ["labelText"],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          }

                                          isApprovingRejecting = true;
                                          showButtonBloc.add(ShowButtonEvent(
                                              show: isApprovingRejecting));
                                        },
                                        text: labels[31]["labelText"],
                                        auxWidget: isApprovingRejecting
                                            ? const LoaderRow()
                                            : const SizeBox(),
                                      );
                                    } else {
                                      return SolidButton(
                                          onTap: () {},
                                          text: labels[31]["labelText"]);
                                    }
                                  },
                                ),
                                const SizeBox(height: 15),
                                SolidButton(
                                  color:
                                      const Color.fromRGBO(34, 97, 105, 0.17),
                                  fontColor: AppColors.primary,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  text: labels[166]["labelText"],
                                ),
                                // const SizeBox(height: 100),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  text: "Reject",
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
