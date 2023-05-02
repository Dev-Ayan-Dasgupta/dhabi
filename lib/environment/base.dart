abstract class BaseConfig {
  // ? Authentication APIs

  String get login;
  String get addNewDevice;

  // ? Configuration APIs

  String get getAllCountries;
  String get getSupportedLanguages;
  String get getCountryDetails;
  String get getAppLabels;
  String get getAppMessages;
  String get getDropdownLists;

  // ? Onboarding APIs

  String get sendEmailOtp;
  String get verifyEmailOtp;
  String get validateEmail;
  String get registerUser;
  String get uploadEid;
  String get uploadPassport;
  String get uploadPersonalDetails;
  String get sendMobileOtp;
  String get verifyMobileOtp;
  String get registerRetailCustomerAddress;
  String get registerRetailCustomer;
  String get uploadCustomerTaxInformation;
}
