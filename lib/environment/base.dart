abstract class BaseConfig {
  // ? Authentication APIs

  String get createAccount;
  String get getCustomerDetails;

  // ? Authentication APIs

  String get login;
  String get addNewDevice;
  String get validateEmailOtpForPassword;
  String get changePassword;

  // ? Configuration APIs

  String get getAllCountries;
  String get getSupportedLanguages;
  String get getCountryDetails;
  String get getAppLabels;
  String get getAppMessages;
  String get getDropdownLists;
  String get getTermsAndConditions;
  String get getPrivacyStatement;

  // ? Onboarding APIs

  String get sendEmailOtp;
  String get verifyEmailOtp;
  String get validateEmail;
  String get registerUser;
  String get ifEidExists;
  String get ifPassportExists;
  String get uploadPersonalDetails;
  String get sendMobileOtp;
  String get verifyMobileOtp;
  String get registerRetailCustomerAddress;
  String get addOrUpdateIncomeSource;
  String get uploadCustomerTaxInformation;
  String get registerRetailCustomer;
  String get uploadEid;
  String get uploadPassport;
}
