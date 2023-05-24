import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/configurations/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

String? deviceId;
String deviceName = "";
String deviceType = "";
String appVersion = "";

List dhabiCountries = [];

List uaeDetails = [];
List<String> emirates = [];

class _SplashScreenState extends State<SplashScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  // String? _deviceId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getDeviceId();
      await getPackageInfo();
      await initPlatformState();
      await initConfigurations();
      await initLocalStorageData();
      if (context.mounted) {
        navigate(context);
      }
    });
  }

  Future<void> initConfigurations() async {
    log("Init conf started");
    labels = await MapAppLabels.mapAppLabels({"languageCode": "en"});
    messages = await MapAppMessages.mapAppMessages({"languageCode": "en"});
    dhabiCountries = await MapAllCountries.mapAllCountries();
    getDhabiCountryNames();
    allDDs = await MapDropdownLists.mapDropdownLists({"languageCode": "en"});
    populateDD(serviceRequestDDs, 0);
    populateDD(statementFileDDs, 1);
    populateDD(moneyTransferReasonDDs, 2);
    populateDD(typeOfAccountDDs, 3);
    populateDD(bearerDetailDDs, 4);
    populateDD(sourceOfIncomeDDs, 5);
    populateDD(noTinReasonDDs, 6);
    populateDD(statementDurationDDs, 7);
    populateEmirates();
    getPolicies();
    log("Init conf ended");
  }

  void getDhabiCountryNames() {
    dhabiCountryNames.clear();
    countryLongCodes.clear();
    for (var country in dhabiCountries) {
      dhabiCountryNames.add(country["countryName"]);
      countryLongCodes.add(country["longCode"]);
    }
    // log("dhabiCountryNames -> $dhabiCountryNames");
  }

  void populateDD(List dropdownList, int dropdownIndex) {
    dropdownList.clear();
    for (Map<String, dynamic> item in allDDs[dropdownIndex]["items"]) {
      dropdownList.add(item["value"]);
    }
    // print(dropdownList);
  }

  void populateEmirates() async {
    uaeDetails =
        await MapCountryDetails.mapCountryDetails({"countryShortCode": "AE"});
    emirates.clear();
    for (Map<String, dynamic> emirate in uaeDetails) {
      emirates.add(emirate["city_Name"]);
    }
    // log("Emirates -> $emirates");
  }

  void getPolicies() async {
    terms = await MapTermsAndConditions.mapTermsAndConditions(
        {"languageCode": "en"});
    statement =
        await MapPrivacyStatement.mapPrivacyStatement({"languageCode": "en"});
    // log("Terms -> $terms");
    // log("statement -> $statement");
  }

  Future<void> getDeviceId() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    if (!mounted) return;
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = DeviceInfoHelper.readWebBrowserInfo(
            await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData = DeviceInfoHelper.readAndroidBuildData(
              await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = DeviceInfoHelper.readIosDeviceInfo(
              await deviceInfoPlugin.iosInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    _deviceData = deviceData;
    // log("_deviceData -> $_deviceData");

    if (Platform.isAndroid) {
      deviceType = "Android";
    } else if (Platform.isIOS) {
      deviceType = "iOS";
      deviceName = _deviceData['name'];
    }

    log("deviceId -> $deviceId");
    log("deviceName -> $deviceName");
    log("deviceType -> $deviceType");
    log("appVersion -> $appVersion");
  }

  Future<void> initLocalStorageData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      await storage.deleteAll();
      prefs.setBool('first_run', false);
    }

    try {
      storageIsNotNewInstall =
          (await storage.read(key: "newInstall")) == "true";
      log("storageIsNotNewInstall -> $storageIsNotNewInstall");
      storageHasFirstLoggedIn =
          (await storage.read(key: "hasFirstLoggedIn")) == "true";
      log("storageHasFirstLoggedIn -> $storageHasFirstLoggedIn");
      storageIsFirstLogin = (await storage.read(key: "isFirstLogin")) == "true";
      log("storageIsFirstLogin -> $storageIsFirstLogin");

      storageEmail = await storage.read(key: "emailAddress");
      log("storageEmail -> $storageEmail");
      storagePassword = await storage.read(key: "password");
      log("storagePassword -> $storagePassword");
      storageUserId = int.parse(await storage.read(key: "userId") ?? "0");
      log("storageUserId -> $storageUserId");
      storageUserTypeId =
          int.parse(await storage.read(key: "userTypeId") ?? "1");
      log("storageUserTypeId -> $storageUserTypeId");
      storageCompanyId = int.parse(await storage.read(key: "companyId") ?? "0");
      log("storageCompanyId -> $storageCompanyId");

      persistBiometric = await storage.read(key: "persistBiometric") == "true";
      log("persistBiometric -> $persistBiometric");

      storageStepsCompleted =
          int.parse(await storage.read(key: "stepsCompleted") ?? "0");
      log("storageStepsCompleted -> $storageStepsCompleted");

      storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
      log("storageIsEid -> $storageIsEid");
      storageFullName = await storage.read(key: "fullName");
      log("storageFullName -> $storageFullName");
      storageEidNumber = await storage.read(key: "eiDNumber");
      log("storageEidNumber -> $storageEidNumber");
      storagePassportNumber = await storage.read(key: "passportNumber");
      log("storagePassportNumber -> $storagePassportNumber");
      storageNationality = await storage.read(key: "nationality");
      log("storageNationality -> $storageNationality");
      storageNationalityCode = await storage.read(key: "nationalityCode");
      log("storageNationalityCode -> $storageNationalityCode");
      storageIssuingStateCode = await storage.read(key: "issuingStateCode");
      log("storageIssuingStateCode -> $storageIssuingStateCode");
      storageExpiryDate = await storage.read(key: "expiryDate");
      log("storageExpiryDate -> $storageExpiryDate");
      storageDob = await storage.read(key: "dob");
      log("storageDob -> $storageDob");
      storageGender = await storage.read(key: "gender");
      log("storageGender -> $storageGender");
      storagePhoto = await storage.read(key: "photo");
      log("storagePhoto -> $storagePhoto");
      storageDocPhoto = await storage.read(key: "docPhoto");
      log("storageDocPhoto -> $storageDocPhoto");
      storageSelfiePhoto = await storage.read(key: "selfiePhoto");
      log("storageSelfiePhoto -> $storageSelfiePhoto");
      storagePhotoMatchScore =
          double.parse(await storage.read(key: "photoMatchScore") ?? "0");
      log("storagePhotoMatchScore -> $storagePhotoMatchScore");

      storageAddressCountry = await storage.read(key: "addressCountry");
      log("storageAddressCountry -> $storageAddressCountry");
      storageAddressLine1 = await storage.read(key: "addressLine1");
      log("storageAddressLine1 -> $storageAddressLine1");
      storageAddressLine2 = await storage.read(key: "addressLine2");
      log("storageAddressLine2 -> $storageAddressLine2");
      storageAddressEmirate = await storage.read(key: "addressEmirate");
      log("storageAddressEmirate -> $storageAddressEmirate");
      storageAddressPoBox = await storage.read(key: "poBox");
      log("storageAddressPoBox -> $storageAddressPoBox");

      storageIncomeSource = await storage.read(key: "incomeSource");
      log("storageIncomeSource -> $storageIncomeSource");

      storageIsUSFATCA = await storage.read(key: "incomeSource") == "true";
      log("storageIsUSFATCA -> $storageIsUSFATCA");
      storageUsTin = await storage.read(key: "usTin");
      log("storageUsTin -> $storageUsTin");

      storageTaxCountry = await storage.read(key: "taxCountry");
      log("storageTaxCountry -> $storageTaxCountry");
      storageIsTinYes = await storage.read(key: "isTinYes") == "true";
      log("storageIsTinYes -> $storageIsTinYes");
      storageCrsTin = await storage.read(key: "crsTin");
      log("storageCrsTin -> $storageCrsTin");
      storageNoTinReason = await storage.read(key: "noTinReason");
      log("storageNoTinReason -> $storageNoTinReason");

      storageAccountType =
          int.parse(await storage.read(key: "accountType") ?? "1");
      log("storageAccountType -> $storageAccountType");

      storageCif = await storage.read(key: "cif");
      log("storageCif -> $storageCif");
      storageIsCompany = await storage.read(key: "isCompany") == "true";
      log("storageIsCompany -> $storageIsCompany");
      storageisCompanyRegistered =
          await storage.read(key: "isCompanyRegistered") == "true";
      log("storageisCompanyRegistered -> $storageisCompanyRegistered");

      storageRetailLoggedIn =
          await storage.read(key: "retailLoggedIn") == "true";
      log("storageRetailLoggedIn -> $storageRetailLoggedIn");

      storageCustomerName = await storage.read(key: "customerName");
      log("storageCustomerName -> $storageCustomerName");
    } catch (_) {
      rethrow;
    }
  }

  void navigate(BuildContext context) {
    if (storageIsNotNewInstall == false) {
      Navigator.pushReplacementNamed(context, Routes.onboarding,
          arguments: OnboardingArgumentModel(isInitial: true).toMap());
    } else {
      if (storageStepsCompleted == 0) {
        if (storageUserTypeId == 2) {
          if (storageIsFirstLogin == false) {
            Navigator.pushReplacementNamed(context, Routes.onboarding,
                arguments: OnboardingArgumentModel(isInitial: true).toMap());
          } else {
            if (persistBiometric == true) {
              Navigator.pushReplacementNamed(
                context,
                Routes.loginBiometric,
                arguments: LoginPasswordArgumentModel(
                  emailId: storageEmail ?? "",
                  userId: storageUserId ?? 0,
                  userTypeId: storageUserTypeId ?? 1,
                  companyId: storageCompanyId ?? 0,
                ).toMap(),
              );
            } else {
              Navigator.pushReplacementNamed(
                context,
                Routes.loginPassword,
                arguments: LoginPasswordArgumentModel(
                  emailId: storageEmail ?? "",
                  userId: storageUserId ?? 0,
                  userTypeId: storageUserTypeId ?? 1,
                  companyId: storageCompanyId ?? 0,
                ).toMap(),
              );
            }
          }
        } else {
          if (persistBiometric == true) {
            Navigator.pushReplacementNamed(
              context,
              Routes.loginBiometric,
              arguments: LoginPasswordArgumentModel(
                emailId: storageEmail ?? "",
                userId: storageUserId ?? 0,
                userTypeId: storageUserTypeId ?? 1,
                companyId: storageCompanyId ?? 0,
              ).toMap(),
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              Routes.loginPassword,
              arguments: LoginPasswordArgumentModel(
                emailId: storageEmail ?? "",
                userId: storageUserId ?? 0,
                userTypeId: storageUserTypeId ?? 1,
                companyId: storageCompanyId ?? 0,
              ).toMap(),
            );
          }
        }
      } else {
        if (storageUserTypeId == 1) {
          if (storageStepsCompleted == 1) {
            Navigator.pushReplacementNamed(
              context,
              Routes.retailOnboardingStatus,
              arguments: OnboardingStatusArgumentModel(
                stepsCompleted: 0,
                isFatca: false,
                isPassport: false,
                isRetail: true,
              ).toMap(),
            );
          } else if (storageStepsCompleted == 2 || storageStepsCompleted == 3) {
            Navigator.pushReplacementNamed(
              context,
              Routes.retailOnboardingStatus,
              arguments: OnboardingStatusArgumentModel(
                stepsCompleted: 1,
                isFatca: false,
                isPassport: false,
                isRetail: true,
              ).toMap(),
            );
          } else if (storageStepsCompleted == 4 ||
              storageStepsCompleted == 5 ||
              storageStepsCompleted == 6 ||
              storageStepsCompleted == 7 ||
              storageStepsCompleted == 8) {
            Navigator.pushReplacementNamed(
              context,
              Routes.retailOnboardingStatus,
              arguments: OnboardingStatusArgumentModel(
                stepsCompleted: 2,
                isFatca: false,
                isPassport: false,
                isRetail: true,
              ).toMap(),
            );
          } else if (storageStepsCompleted == 9) {
            Navigator.pushReplacementNamed(
              context,
              Routes.retailOnboardingStatus,
              arguments: OnboardingStatusArgumentModel(
                stepsCompleted: 3,
                isFatca: false,
                isPassport: false,
                isRetail: true,
              ).toMap(),
            );
          } else if (storageStepsCompleted == 10) {
            Navigator.pushReplacementNamed(
              context,
              Routes.retailOnboardingStatus,
              arguments: OnboardingStatusArgumentModel(
                stepsCompleted: 4,
                isFatca: false,
                isPassport: false,
                isRetail: true,
              ).toMap(),
            );
          }
        }
        if (storageUserTypeId == 2) {
          if (storageStepsCompleted == 1) {
            Navigator.pushReplacementNamed(
              context,
              Routes.createPassword,
              arguments: CreateAccountArgumentModel(
                email: storageEmail ?? "",
                isRetail: storageUserTypeId == 1 ? true : false,
                userTypeId: storageUserTypeId ?? 1,
                companyId: storageCompanyId ?? 0,
              ).toMap(),
            );
          } else if (storageStepsCompleted == 2) {
            Navigator.pushReplacementNamed(
              context,
              Routes.businessOnboardingStatus,
              arguments: OnboardingStatusArgumentModel(
                stepsCompleted: 1,
                isFatca: false,
                isPassport: false,
                isRetail: false,
              ).toMap(),
            );
          } else if (storageStepsCompleted == 11) {
            Navigator.pushReplacementNamed(
              context,
              Routes.businessOnboardingStatus,
              arguments: OnboardingStatusArgumentModel(
                stepsCompleted: 2,
                isFatca: false,
                isPassport: false,
                isRetail: false,
              ).toMap(),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstants.splashBackGround),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(ImageConstants.splashIcon),
        ),
      ),
    );
  }
}
