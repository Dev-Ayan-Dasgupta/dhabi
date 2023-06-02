// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AcceptTermsAndConditionsScreen extends StatefulWidget {
  const AcceptTermsAndConditionsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<AcceptTermsAndConditionsScreen> createState() =>
      _AcceptTermsAndConditionsScreenState();
}

class _AcceptTermsAndConditionsScreenState
    extends State<AcceptTermsAndConditionsScreen> {
  bool isChecked = false;
  final ScrollController _scrollController = ScrollController();
  bool scrollDown = true;

  bool isUploading = false;

  late CreateAccountArgumentModel createAccountArgumentModel;

  @override
  void initState() {
    super.initState();
    createAccountArgumentModel =
        CreateAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
    final ScrollDirectionBloc scrollDirectionBloc =
        context.read<ScrollDirectionBloc>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_scrollController.hasClients) {
          if (_scrollController.offset >
              (_scrollController.position.maxScrollExtent -
                      _scrollController.position.minScrollExtent) /
                  2) {
            scrollDown = false;
            scrollDirectionBloc
                .add(ScrollDirectionEvent(scrollDown: scrollDown));
          } else {
            scrollDown = true;
            scrollDirectionBloc
                .add(ScrollDirectionEvent(scrollDown: scrollDown));
          }
        }
      },
    );
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
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
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
                                    child: HtmlWidget(terms),
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
                            onTap: () async {
                              if (!isUploading) {
                                log("storageNationalityCode -> $storageNationalityCode");
                                final ShowButtonBloc showButtonBloc =
                                    context.read<ShowButtonBloc>();
                                isUploading = true;
                                showButtonBloc
                                    .add(ShowButtonEvent(show: isUploading));

                                // if (storageIsEid == true) {
                                //   var response =
                                //       await MapUploadEid.mapUploadEid(
                                //     {
                                //       "eidDocumentImage": storageDocPhoto,
                                //       "eidUserPhoto": storagePhoto,
                                //       "selfiePhoto": storageSelfiePhoto,
                                //       "photoMatchScore": storagePhotoMatchScore,
                                //       "eidNumber": storageEidNumber,
                                //       "fullName": storageFullName,
                                //       "dateOfBirth": DateFormat('yyyy-MM-dd')
                                //           .format(DateFormat('dd MMMM yyyy')
                                //               .parse(storageDob ??
                                //                   "1 January 1900")),
                                //       "nationalityCountryCode":
                                //           storageNationalityCode,
                                //       "genderId": storageGender == 'M' ? 1 : 2,
                                //       "expiresOn": DateFormat('yyyy-MM-dd')
                                //           .format(DateFormat('dd MMMM yyyy')
                                //               .parse(storageExpiryDate ??
                                //                   "1 January 1900")),
                                //       "isReKYC": false
                                //     },
                                //     token ?? "",
                                //   );

                                //   log("UploadEid API response -> $response");
                                // } else {
                                //   var response =
                                //       await MapUploadPassport.mapUploadPassport(
                                //     {
                                //       "passportDocumentImage": storageDocPhoto,
                                //       "passportUserPhoto": storagePhoto,
                                //       "selfiePhoto": storageSelfiePhoto,
                                //       "photoMatchScore": storagePhotoMatchScore,
                                //       "passportNumber": storagePassportNumber,
                                //       "passportIssuingCountryCode":
                                //           storageIssuingStateCode,
                                //       "fullName": storageFullName,
                                //       "dateOfBirth": DateFormat('yyyy-MM-dd')
                                //           .format(DateFormat('dd/MM/yyyy')
                                //               .parse(
                                //                   storageDob ?? "00/00/0000")),
                                //       "nationalityCountryCode":
                                //           storageNationalityCode,
                                //       "genderId": storageGender == 'M' ? 1 : 2,
                                //       "expiresOn": DateFormat('yyyy-MM-dd')
                                //           .format(DateFormat('dd/MM/yyyy')
                                //               .parse(storageExpiryDate ??
                                //                   "00/00/0000")),
                                //       "isReKYC": false
                                //     },
                                //     token ?? "",
                                //   );
                                //   log("UploadPassport API response -> $response");
                                // }
                                var createCustomerResult =
                                    await MapCreateCustomer.mapCreateCustomer(
                                        token ?? "");

                                if (createCustomerResult["success"]) {
                                  var responseAccount =
                                      await MapCreateAccount.mapCreateAccount(
                                          {"accountType": storageAccountType},
                                          token ?? "");
                                  log("Create Account API response -> $responseAccount");

                                  log("Email ID -> $storageEmail");
                                  log("Password -> $storagePassword");

                                  if (responseAccount["success"]) {
                                    var result = await MapLogin.mapLogin({
                                      "emailId": storageEmail,
                                      "userTypeId": storageUserTypeId,
                                      "userId": storageUserId,
                                      "companyId": storageCompanyId,
                                      "password": storagePassword,
                                      "deviceId": deviceId,
                                      "registerDevice": false,
                                      "deviceName": deviceName,
                                      "deviceType": deviceType,
                                      "appVersion": appVersion
                                    });
                                    log("Login API Response -> $result");
                                    token = result["token"];
                                    log("token -> $token");

                                    if (result["success"]) {
                                      customerName = result["customerName"];
                                      await storage.write(
                                          key: "customerName",
                                          value: customerName);
                                      storageCustomerName = await storage.read(
                                          key: "customerName");
                                      await storage.write(
                                          key: "retailLoggedIn",
                                          value: true.toString());
                                      storageRetailLoggedIn = await storage
                                              .read(key: "retailLoggedIn") ==
                                          "true";
                                      if (context.mounted) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.retailDashboard,
                                          (route) => false,
                                          arguments:
                                              RetailDashboardArgumentModel(
                                            imgUrl: "",
                                            name: storageFullName ?? "",
                                            isFirst: false,
                                          ).toMap(),
                                        );
                                      }

                                      await storage.write(
                                          key: "cif", value: cif.toString());
                                      storageCif =
                                          await storage.read(key: "cif");
                                      log("storageCif -> $storageCif");

                                      await storage.write(
                                          key: "isCompany",
                                          value: isCompany.toString());
                                      storageIsCompany = await storage.read(
                                              key: "isCompany") ==
                                          "true";
                                      log("storageIsCompany -> $storageIsCompany");

                                      await storage.write(
                                          key: "isCompanyRegistered",
                                          value:
                                              isCompanyRegistered.toString());
                                      storageisCompanyRegistered =
                                          await storage.read(
                                                  key: "isCompanyRegistered") ==
                                              "true";
                                      log("storageisCompanyRegistered -> $storageisCompanyRegistered");
                                    }
                                  }
                                } else {
                                  log("Create Customer API failed -> ${createCustomerResult["message"]}");
                                }

                                isUploading = false;
                                showButtonBloc
                                    .add(ShowButtonEvent(show: isUploading));

                                await storage.write(
                                    key: "stepsCompleted", value: 0.toString());
                                storageStepsCompleted = int.parse(
                                    await storage.read(key: "stepsCompleted") ??
                                        "0");

                                await storage.write(
                                    key: "hasFirstLoggedIn",
                                    value: true.toString());
                                storageHasFirstLoggedIn = (await storage.read(
                                        key: "hasFirstLoggedIn")) ==
                                    "true";
                              }
                            },
                            text: "I Agree",
                            auxWidget: isUploading
                                ? const LoaderRow()
                                : const SizeBox(),
                          );
                        } else {
                          return SolidButton(onTap: () {}, text: "I Agree");
                        }
                      },
                    ),
                    SizeBox(
                      height: PaddingConstants.bottomPadding +
                          MediaQuery.of(context).padding.bottom,
                    ),
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
                      if (!scrollDown) {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                          scrollDown = true;
                          scrollDirectionBloc.add(
                              ScrollDirectionEvent(scrollDown: scrollDown));
                        }
                      } else {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );

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
