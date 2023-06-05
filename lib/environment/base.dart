abstract class BaseConfig {
  // ? Authentication APIs

  String get createAccount;
  String get getCustomerDetails;
  String get hasCustomerSingleCif;
  String get getCustomerAccountDetails;
  String get getCustomerAccountStatement;
  String get getExcelCustomerAccountStatement;
  String get getPdfCustomerAccountStatement;
  String get getFdRates;
  String get createBeneficiary;
  String get getBeneficiaries;
  String get createFd;

  // ? Authentication APIs

  String get login;
  String get addNewDevice;
  String get validateEmailOtpForPassword;
  String get changePassword;
  String get isDeviceValid;
  String get renewToken;
  String get registeredMobileOTPRequest;

  // ? Configuration APIs

  String get getAllCountries;
  String get getSupportedLanguages;
  String get getCountryDetails;
  String get getAppLabels;
  String get getAppMessages;
  String get getDropdownLists;
  String get getTermsAndConditions;
  String get getPrivacyStatement;
  String get getApplicationConfigurations;
  String get getBankDetails;

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
  String get createCustomer;

  // ? Corporate Onboarding APIs

  String get checkIfTradeLicenseExists;
  String get register;
}
